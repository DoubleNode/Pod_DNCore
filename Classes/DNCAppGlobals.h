//
//  DNCAppGlobals.h
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2019 - 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSInteger, DNCAppGlobalsReachabilityStatus)
{
    DNCAppGlobalsReachabilityStatusUnknown          = 0,
    DNCAppGlobalsReachabilityStatusNotReachable,
    DNCAppGlobalsReachabilityStatusReachableViaWWAN,
    DNCAppGlobalsReachabilityStatusReachableViaWWANWithoutInternet,
    DNCAppGlobalsReachabilityStatusReachableViaWiFi,
    DNCAppGlobalsReachabilityStatusReachableViaWiFiWithoutInternet,
    
    DNCAppGlobalsReachabilityStatus_Count,
};

@interface DNCAppGlobals : NSObject

@property (assign, nonatomic)   DNCAppGlobalsReachabilityStatus   reachabilityStatus;

@property (strong, nonatomic)   NSString*   currentSSID;

@property (assign, nonatomic)   NSUInteger  appLaunchCount;
@property (strong, nonatomic)   NSDate*     appLaunchFirstTime;
@property (strong, nonatomic)   NSDate*     appLaunchLastTime;
@property (strong, nonatomic)   NSDate*     appReviewRequestLastTime;
@property (assign, nonatomic)   BOOL        appLaunchDidCrashLastTime;

@property (assign, nonatomic)   BOOL        askedDeviceForPushNotifications;

+ (instancetype)sharedInstance;

+ (BOOL)checkAndAskForReview;

- (BOOL)checkAndAskForReview;

- (void)applicationDidBecomeActive;
- (void)applicationWillResignActive;

@end
