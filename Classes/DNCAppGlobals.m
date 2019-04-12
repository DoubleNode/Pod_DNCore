//
//  DNCAppGlobals.m
//  DoubleNode.com
//
//  Derived from work originally created by Darren Ehlers
//  Portions Copyright (c) 2012 DoubleNode.com and Darren Ehlers.
//  All rights reserved.
//

@import AFNetworking;
@import Foundation;
@import StoreKit;
@import SystemConfiguration.CaptiveNetwork;

#import "DNCAppGlobals.h"

#import "DNCAppConstants.h"
#import "DNCUtilities.h"

NSString* const kDNCAppGlobalsParameterAppLaunchFirstTime       = @"appLaunchFirstTime";
NSString* const kDNCAppGlobalsParameterAppLaunchLastTime        = @"appLaunchLastTime";
NSString* const kDNCAppGlobalsParameterAppLaunchCount           = @"appLaunchCount";
NSString* const kDNCAppGlobalsParameterAppReviewRequestLastTime = @"appReviewRequestLastTime";
NSString* const kDNCAppGlobalsParameterSelectedAccountNumber    = @"selectedAccountNumber";
NSString* const kDNCAppGlobalsParameterSelectedAccountType      = @"selectedAccountType";
NSString* const kDNCAppGlobalsParameterSelectedPhoneNumber      = @"selectedPhoneNumber";

@interface DNCAppGlobals()

@property (strong, nonatomic)   AFNetworkReachabilityManager*   reachabilityManager;

@end

@implementation DNCAppGlobals

@synthesize reachabilityStatus              = _reachabilityStatus;
@synthesize askedDeviceForPushNotifications = _askedDeviceForPushNotifications;

+ (instancetype)sharedInstance
{
    static dispatch_once_t predicate;
    static DNCAppGlobals*   instance = nil;
    dispatch_once(&predicate, ^
                  {
                      instance = [self.alloc init];
                  });
    return instance;
}

+ (BOOL)checkAndAskForReview
{
    DNCAppGlobals*  instance = self.sharedInstance;
    return [instance checkAndAskForReview];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.reachabilityManager = [AFNetworkReachabilityManager managerForDomain:@"apple.com"];
        
        __block typeof(self)    bSelf = self;
        
        [self.reachabilityManager setReachabilityStatusChangeBlock:
         ^(AFNetworkReachabilityStatus status)
         {
             [bSelf utilityReachabilityStatusChanged:status];
         }];
        
        [self.reachabilityManager startMonitoring];
        
        self.appLaunchFirstTime         = [DNCUtilities settingsItem:kDNCAppGlobalsParameterAppLaunchFirstTime
                                                             default:NSDate.date];
        self.appLaunchLastTime          = [DNCUtilities settingsItem:kDNCAppGlobalsParameterAppLaunchLastTime
                                                             default:nil];
        self.appReviewRequestLastTime   = [DNCUtilities settingsItem:kDNCAppGlobalsParameterAppReviewRequestLastTime
                                                             default:nil];
        self.appLaunchCount             = 1 + [[DNCUtilities settingsItem:kDNCAppGlobalsParameterAppLaunchCount
                                                                  default:0] unsignedIntegerValue];
        
        DNCLog(DNCLL_Info, DNCLD_General, @"appLaunchFirstTime=%@", self.appLaunchFirstTime);
        DNCLog(DNCLL_Info, DNCLD_General, @"appLaunchLastTime=%@", self.appLaunchLastTime);
        DNCLog(DNCLL_Info, DNCLD_General, @"appLaunchCount=%d", self.appLaunchCount);
        
        [DNCUtilities setSettingsItem:kDNCAppGlobalsParameterAppLaunchFirstTime
                                value:self.appLaunchFirstTime];
        [DNCUtilities setSettingsItem:kDNCAppGlobalsParameterAppLaunchLastTime
                                value:NSDate.date];
        [DNCUtilities setSettingsItem:kDNCAppGlobalsParameterAppLaunchCount
                                value:@(self.appLaunchCount)];
    }
    
    return self;
}

- (BOOL)checkAndAskForReview
{
    if (!self.shouldAskForReview)
    {
        return NO;
    }
    
    [SKStoreReviewController requestReview];
    
    [DNCUtilities setSettingsItem:kDNCAppGlobalsParameterAppReviewRequestLastTime
                            value:NSDate.date];
    return YES;
}

- (BOOL)shouldAskForReview
{
    // If disabled
    if (!DNCAppConstants.requestReviews)
    {
        return NO;
    }
    
    // If crashed last run...
    if (self.appLaunchDidCrashLastTime)
    {
        return NO;
    }
    
    // If launched less than 10 times...
    if (self.appLaunchCount < DNCAppConstants.requestReviewFirstMinimumLaunches)
    {
        return NO;
    }
    
    // If first launch less than 60 days...
    if ([NSDate.date timeIntervalSinceDate:self.appLaunchFirstTime] < (86400.0f * DNCAppConstants.requestReviewDaysSinceFirstLaunch))
    {
        return NO;
    }
    
    // If last launch less than 1 hour...
    if ([NSDate.date timeIntervalSinceDate:self.appLaunchLastTime] < (3600.0f * DNCAppConstants.requestReviewHoursSinceLastLaunch))
    {
        return NO;
    }
    
    // If launched greater than 50 times...
    if (self.appLaunchCount > DNCAppConstants.requestReviewFirstMaximumLaunches)
    {
        // ...and not once every 100 times...
        if (self.appLaunchCount % DNCAppConstants.requestReviewFrequency)
        {
            return NO;
        }
    }
    
    // If previously reviewed less than 60 days...
    if (self.appReviewRequestLastTime &&
        ([NSDate.date timeIntervalSinceDate:self.appReviewRequestLastTime] < (86400.0f * DNCAppConstants.requestReviewDaysSinceLastReview)))
    {
        return NO;
    }
    
    return YES;
}

- (void)applicationDidBecomeActive
{
    [self.reachabilityManager startMonitoring];
}

- (void)applicationWillResignActive
{
    [self.reachabilityManager stopMonitoring];
}

- (NSString*)currentSSID
{
    NSString*   retval;
    
    NSArray*    interfaceNames = (__bridge_transfer id)CNCopySupportedInterfaces();
    
    for (NSString* name in interfaceNames)
    {
        NSDictionary*   info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)name);
        retval  = info[@"SSID"];
    }
    
    return retval;
}

- (void)setReachabilityStatus:(DNCAppGlobalsReachabilityStatus)reachabilityStatus
{
    if (reachabilityStatus == _reachabilityStatus)
    {
        return;
    }
    
    _reachabilityStatus = reachabilityStatus;
    
    [NSNotificationCenter.defaultCenter postNotificationName:@"reachabilityStatus"
                                                      object:self];
    
    [self utilityCheckConnectivity];
}

- (BOOL)askedDeviceForPushNotifications
{
    return _askedDeviceForPushNotifications;
}

- (void)setAskedDeviceForPushNotifications:(BOOL)askedDeviceForPushNotifications
{
    if (askedDeviceForPushNotifications == _askedDeviceForPushNotifications)
    {
        return;
    }
    
    _askedDeviceForPushNotifications = askedDeviceForPushNotifications;
}

#pragma mark - Utility methods

- (void)utilityCheckConnectivity
{
    switch (self.reachabilityStatus)
    {
        case DNCAppGlobalsReachabilityStatusNotReachable:
        {
            DNCLog(DNCLL_Info, DNCLD_General, @"NETWORK - DNCAppGlobalsReachabilityStatusNotReachable");
            break;
        }
            
        case DNCAppGlobalsReachabilityStatusReachableViaWWAN:
        {
            DNCLog(DNCLL_Info, DNCLD_General, @"NETWORK - DNCAppGlobalsReachabilityStatusReachableViaWWAN");
            break;
        }
            
        case DNCAppGlobalsReachabilityStatusReachableViaWWANWithoutInternet:
        {
            DNCLog(DNCLL_Info, DNCLD_General, @"NETWORK - DNCAppGlobalsReachabilityStatusReachableViaWWANWithoutInternet");
            break;
        }
            
        case DNCAppGlobalsReachabilityStatusReachableViaWiFi:
        {
            DNCLog(DNCLL_Info, DNCLD_General, @"NETWORK - DNCAppGlobalsReachabilityStatusReachableViaWiFi");
            break;
        }
            
        case DNCAppGlobalsReachabilityStatusReachableViaWiFiWithoutInternet:
        {
            DNCLog(DNCLL_Info, DNCLD_General, @"NETWORK - DNCAppGlobalsReachabilityStatusReachableViaWiFiWithoutInternet");
            break;
        }
            
        case DNCAppGlobalsReachabilityStatusUnknown:
        default:
        {
            DNCLog(DNCLL_Info, DNCLD_General, @"NETWORK - DNCAppGlobalsReachabilityStatusUnknown");
            break;
        }
    }
    
    if (self.currentSSID.length)
    {
        DNCLog(DNCLL_Info, DNCLD_General, @"SSID = %@", self.currentSSID);
    }
}

- (void)utilityReachabilityStatusChanged:(AFNetworkReachabilityStatus)status
{
    switch (status)
    {
        case AFNetworkReachabilityStatusNotReachable:
        {
            self.reachabilityStatus = DNCAppGlobalsReachabilityStatusNotReachable;
            break;
        }
            
        case AFNetworkReachabilityStatusReachableViaWWAN:
        case AFNetworkReachabilityStatusReachableViaWiFi:
        {
            __block NSUInteger    successCount    = 0;
            
            NSArray<NSString*>*   connectivityCheckDomains    = @[
                                                                  @"www.apple.com",
                                                                  @"apple.com",
                                                                  @"www.appleiphonecell.com",
                                                                  @"www.itools.info",
                                                                  @"www.ibook.info",
                                                                  @"www.airport.us",
                                                                  @"www.thinkdifferent.us",
                                                                  ];
            
            [DNCThreadingGroup run:
             ^(DNCThreadingGroup* threadingGroup)
             {
                 for (NSString* domain in connectivityCheckDomains)
                 {
                     DNCThread*   thread =
                     [DNCThread create:
                      ^(DNCThread* thread)
                      {
                          NSURLSessionConfiguration*  configuration   = NSURLSessionConfiguration.defaultSessionConfiguration;
                          AFURLSessionManager*        manager         = [AFURLSessionManager.alloc initWithSessionConfiguration:configuration];
                          
                          manager.responseSerializer    = AFHTTPResponseSerializer.serializer;;
                          
                          NSString*       urlString = [NSString stringWithFormat:@"http://%@/library/test/success.html", domain];
                          NSURL*          URL       = [NSURL URLWithString:urlString];
                          NSURLRequest*   request   = [NSURLRequest requestWithURL:URL];
                          
                          [[manager dataTaskWithRequest:request
                                         uploadProgress:nil
                                       downloadProgress:nil
                                      completionHandler:
                            ^(NSURLResponse* _Nonnull response, id _Nullable responseObject, NSError* _Nullable error)
                            {
                                if (error)
                                {
                                    [thread done];
                                    return;
                                }
                                
                                successCount++;
                                [thread done];
                            }] resume];
                      }];
                     
                     [threadingGroup runThread:thread];
                 }
             }
                              then:
             ^(NSError* error)
             {
                 BOOL  withoutInternet = NO;
                 
                 CGFloat  successPercent  = (successCount / connectivityCheckDomains.count) * 100;
                 if (successPercent < 75)
                 {
                     withoutInternet = YES;
                 }
                 
                 if (status == AFNetworkReachabilityStatusReachableViaWWAN)
                 {
                     if (withoutInternet)
                     {
                         self.reachabilityStatus    = DNCAppGlobalsReachabilityStatusReachableViaWWANWithoutInternet;
                     }
                     else
                     {
                         self.reachabilityStatus    = DNCAppGlobalsReachabilityStatusReachableViaWWAN;
                     }
                 }
                 else if (status == AFNetworkReachabilityStatusReachableViaWiFi)
                 {
                     if (withoutInternet)
                     {
                         self.reachabilityStatus    = DNCAppGlobalsReachabilityStatusReachableViaWiFiWithoutInternet;
                     }
                     else
                     {
                         self.reachabilityStatus    = DNCAppGlobalsReachabilityStatusReachableViaWiFi;
                     }
                 }
             }];
            
            break;
        }
            
        case AFNetworkReachabilityStatusUnknown:
        default:
        {
            self.reachabilityStatus = DNCAppGlobalsReachabilityStatusUnknown;
            break;
        }
    }
}

@end
