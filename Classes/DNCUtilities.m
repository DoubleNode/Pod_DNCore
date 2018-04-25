//
//  DNCUtilities.m
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

@import SDVersion;

#define DEBUGLOGGING
#import "DNCUtilities.h"

#import <UIKit/UIKit.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVFoundation.h>

#include <CommonCrypto/CommonHMAC.h>
#import <mach/mach_time.h> // for mach_absolute_time() and friends

#include <sys/types.h>
#include <sys/socket.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <objc/message.h>

#import "DNCDate.h"

#import "NSString+DNCHTML.h"
#import "NSDate+DNCUtils.h"
#import "GGMutableDictionary.h"

@interface DNCUtilities()
{
    DNCLogLevel             _logDebugLevel;
    GGMutableDictionary*    _logDebugDomains;
}

@property (strong, nonatomic) NSString* xcodeColorsEscape;
@property (strong, nonatomic) NSString* xcodeColorsReset;

@end

#define ERROR_DOMAIN_CLASS      [NSString stringWithFormat:@"com.doublenode.dncore.%@", NSStringFromClass([self class])]
#define ERROR_UNKNOWN           1001
#define ERROR_TIMEOUT           1002

@implementation DNCUtilities

+ (id<DNCApplicationProtocol>)appDelegate
{
    return (id<DNCApplicationProtocol>)[[UIApplication sharedApplication] delegate];
}

+ (DNCUtilities*)sharedInstance
{
    static dispatch_once_t  once;
    static DNCUtilities*    instance = nil;
    
    dispatch_once(&once, ^{
        instance = [[DNCUtilities alloc] init];
    });
    
    return instance;
}

+ (NSString*)osVersion
{
    return [UIDevice currentDevice].systemVersion;
}

+ (NSString*)deviceNameString
{
    return SDVersion.deviceNameString;
}

+ (NSString*)deviceVersionName
{
    return [SDVersion deviceNameForVersion:SDVersion.deviceVersion];
}

+ (NSString*)buildString
{
    return self.appDelegate.buildString;
}

+ (NSString*)versionString
{
    return self.appDelegate.versionString;
}

+ (NSString*)bundleName
{
    return self.appDelegate.bundleName;
}

+ (NSDateFormatter*)dictionaryDateDateFormatter
{
    static dispatch_once_t  once;
    static NSDateFormatter* instance = nil;
    
    dispatch_once(&once, ^{
        instance = [[NSDateFormatter alloc] init];
        [instance setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    });
    
    return instance;
}

+ (NSNumberFormatter*)dictionaryDateNumberFormatter
{
    static dispatch_once_t      once;
    static NSNumberFormatter*   instance = nil;
    
    dispatch_once(&once, ^{
        instance = [[NSNumberFormatter alloc] init];
        [instance setAllowsFloats:NO];
    });
    
    return instance;
}

+ (CGSize)screenSizeUnits
{
    return (CGSize){ [self screenWidthUnits], [self screenHeightUnits] };
}

+ (CGFloat)screenHeightUnits
{
    CGRect  bounds  = [[UIScreen mainScreen] bounds];
    CGFloat height  = bounds.size.height;
    
    return height;
}

+ (CGFloat)screenWidthUnits
{
    CGRect  bounds  = [[UIScreen mainScreen] bounds];
    CGFloat width   = bounds.size.width;
    
    return width;
}

+ (CGSize)screenSize
{
    return (CGSize){ [self screenWidth], [self screenHeight] };
}

+ (CGFloat)screenHeight
{
    CGRect  bounds  = [[UIScreen mainScreen] bounds];
    CGFloat height  = bounds.size.height;
    CGFloat scale   = [[UIScreen mainScreen] scale];
    
    return (height * scale);
}

+ (CGFloat)screenWidth
{
    CGRect  bounds  = [[UIScreen mainScreen] bounds];
    CGFloat width   = bounds.size.width;
    CGFloat scale   = [[UIScreen mainScreen] scale];
    
    return (width * scale);
}

+ (BOOL)isTall
{
    static dispatch_once_t  once;
    static BOOL             result = NO;
    
    dispatch_once(&once, ^{
        CGRect bounds = [[UIScreen mainScreen] bounds];
        CGFloat height = bounds.size.height;
        CGFloat scale = [[UIScreen mainScreen] scale];
        
        result = (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) && ((height * scale) >= 1136));
    });
    
    return result;
}

+ (BOOL)isDeviceIPad
{
    static dispatch_once_t  once;
    static BOOL             result = NO;
    
    dispatch_once(&once, ^{
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            result = YES;
        }
    });
    
    return result;
}

+ (NSString*)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString*)appendNibSuffix:(NSString*)nibNameOrNil withDefaultNib:(NSString*)defaultNib
{
    if ([nibNameOrNil length] == 0)
    {
        nibNameOrNil    = defaultNib;
    }
    
    return [DNCUtilities appendNibSuffix:nibNameOrNil];
}

+ (NSString*)appendNibSuffix:(NSString*)nibNameOrNil
{
    NSString*   retval  = nibNameOrNil;
    
    //NSString*   bundlePath      = [[NSBundle mainBundle] pathForResource:[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] ofType:@"lproj"];
    NSString*   bundlePath      = [[NSBundle mainBundle] pathForResource:@"Base" ofType:@"lproj"];
    NSBundle*   languageBundle  = [NSBundle bundleWithPath:bundlePath];
    
    if ([DNCUtilities isDeviceIPad])
    {
        NSString*   tempNibName = [NSString stringWithFormat:@"%@~ipad", retval];
        if([languageBundle pathForResource:tempNibName ofType:@"nib"] != nil)
        {
            //file found
            retval = tempNibName;
        }
    }
    else
    {
        NSString*   tempNibName = [NSString stringWithFormat:@"%@~iphone", retval];
        if([languageBundle pathForResource:tempNibName ofType:@"nib"] != nil)
        {
            //file found
            retval = tempNibName;
        }
        
        if ([DNCUtilities isTall])
        {
            NSString*   tempNibName = [NSString stringWithFormat:@"%@-568h", retval];
            if([languageBundle pathForResource:tempNibName ofType:@"nib"] != nil)
            {
                //file found
                retval = tempNibName;
            }
            
        }
    }
    
    return retval;
}

+ (void)registerCellNib:(NSString*)nibName
     withCollectionView:(UICollectionView*)collectionView
{
    [self registerCellNib:nibName
               withBundle:nil
       withCollectionView:collectionView];
}

+ (void)registerCellNib:(NSString*)nibName
             withBundle:(NSBundle*)bundle
     withCollectionView:(UICollectionView*)collectionView
{
    [self registerCellNib:nibName
               withBundle:bundle
       withCollectionView:collectionView
           withSizingCell:NO];
}

+ (UICollectionViewCell*)registerCellNib:(NSString*)nibName
                      withCollectionView:(UICollectionView*)collectionView
                          withSizingCell:(BOOL)sizingCellFlag
{
    return [self registerCellNib:nibName
                      withBundle:nil
              withCollectionView:collectionView
                  withSizingCell:sizingCellFlag];
}

+ (UICollectionViewCell*)registerCellNib:(NSString*)nibName
                              withBundle:(NSBundle*)bundle
                      withCollectionView:(UICollectionView*)collectionView
                          withSizingCell:(BOOL)sizingCellFlag
{
    NSString*   cellNibName = [self appendNibSuffix:nibName];
    UINib*      cellNib     = [UINib nibWithNibName:cellNibName
                                             bundle:bundle];
    [collectionView registerNib:cellNib
     forCellWithReuseIdentifier:nibName];
    
    UICollectionViewCell*   retval  = nil;
    
    if (sizingCellFlag)
    {
        retval = [cellNib instantiateWithOwner:nil options:nil].firstObject;
    }
    
    return retval;
}

+ (void)registerCellNib:(NSString*)nibName
forSupplementaryViewOfKind:(NSString*)kind
     withCollectionView:(UICollectionView*)collectionView
{
    [self registerCellNib:nibName withBundle:nil forSupplementaryViewOfKind:kind withCollectionView:collectionView];
}

+ (void)registerCellNib:(NSString*)nibName
             withBundle:(NSBundle*)bundle
forSupplementaryViewOfKind:(NSString*)kind
     withCollectionView:(UICollectionView*)collectionView
{
    [self registerCellNib:nibName withBundle:bundle forSupplementaryViewOfKind:kind withCollectionView:collectionView withSizingCell:NO];
}

+ (UICollectionViewCell*)registerCellNib:(NSString*)nibName
              forSupplementaryViewOfKind:(NSString*)kind
                      withCollectionView:(UICollectionView*)collectionView
                          withSizingCell:(BOOL)sizingCellFlag
{
    return [self registerCellNib:nibName
                      withBundle:nil
      forSupplementaryViewOfKind:kind
              withCollectionView:collectionView
                  withSizingCell:sizingCellFlag];
}

+ (UICollectionViewCell*)registerCellNib:(NSString*)nibName
                              withBundle:(NSBundle*)bundle
              forSupplementaryViewOfKind:(NSString*)kind
                      withCollectionView:(UICollectionView*)collectionView
                          withSizingCell:(BOOL)sizingCellFlag
{
    NSString*   cellNibName = [self appendNibSuffix:nibName];
    UINib*      cellNib     = [UINib nibWithNibName:cellNibName bundle:bundle];
    [collectionView registerNib:cellNib
     forSupplementaryViewOfKind:kind
            withReuseIdentifier:nibName];
    
    UICollectionViewCell*   retval  = nil;
    
    if (sizingCellFlag)
    {
        retval = [cellNib instantiateWithOwner:nil options:nil].firstObject;
    }
    
    return retval;
}

+ (void)registerCellNib:(NSString*)nibName
          withTableView:(UITableView*)tableView
{
    [self registerCellNib:nibName withBundle:nil withTableView:tableView];
}

+ (void)registerCellNib:(NSString*)nibName
             withBundle:(NSBundle*)bundle
          withTableView:(UITableView*)tableView
{
    NSString*   cellNibName = [self appendNibSuffix:nibName];
    UINib*      cellNib     = [UINib nibWithNibName:cellNibName bundle:bundle];
    
    [tableView registerNib:cellNib forCellReuseIdentifier:nibName];
}

+ (void)registerCellClass:(NSString*)className
            withTableView:(UITableView*)tableView
{
    Class   cellClass   = NSClassFromString(className);
    
    [tableView registerClass:cellClass forCellReuseIdentifier:className];
}

+ (void)registerCellNib:(NSString*)nibName
forHeaderFooterViewReuseIdentifier:(NSString*)kind
          withTableView:(UITableView*)tableView
{
    [self registerCellNib:nibName withBundle:nil forHeaderFooterViewReuseIdentifier:kind withTableView:tableView];
}

+ (void)registerCellNib:(NSString*)nibName
             withBundle:(NSBundle*)bundle
forHeaderFooterViewReuseIdentifier:(NSString*)kind
          withTableView:(UITableView*)tableView
{
    NSString*   cellNibName = [self appendNibSuffix:nibName];
    UINib*      cellNib     = [UINib nibWithNibName:cellNibName bundle:bundle];
    
    [tableView registerNib:cellNib forHeaderFooterViewReuseIdentifier:nibName];
}

+ (void)registerCellClass:(NSString*)className
forHeaderFooterViewReuseIdentifier:(NSString*)kind
            withTableView:(UITableView*)tableView
{
    Class   cellClass   = NSClassFromString(className);
    
    [tableView registerClass:cellClass forHeaderFooterViewReuseIdentifier:className];
}

+ (NSString*)deviceImageName:(NSString*)name
{
    NSString*   fileName        = [[[NSFileManager defaultManager] displayNameAtPath:name] stringByDeletingPathExtension];
    NSString*   extension       = [name pathExtension];
    
    NSString*   orientationStr  = @"";
    NSString*   orientation2Str = @"";
    NSString*   deviceStr       = @"";
    
    UIInterfaceOrientation  orientation = [UIApplication sharedApplication].statusBarOrientation;
    switch (orientation)
    {
        case UIInterfaceOrientationUnknown:
        case UIInterfaceOrientationPortrait:
        {
            orientationStr  = @"-Portrait";
            orientation2Str = @"-Portrait";
            break;
        }
            
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            orientationStr  = @"-Portrait";
            orientation2Str = @"-PortraitUpsideDown";
            break;
        }
            
        case UIInterfaceOrientationLandscapeLeft:
        {
            orientationStr  = @"-Landscape";
            orientation2Str = @"-LandscapeLeft";
            break;
        }
            
        case UIInterfaceOrientationLandscapeRight:
        {
            orientationStr  = @"-Landscape";
            orientation2Str = @"-LandscapeRight";
            break;
        }
    }
    
    if ([DNCUtilities isDeviceIPad])
    {
        deviceStr   = @"~ipad";
    }
    else
    {
        if ([DNCUtilities isTall])
        {
            deviceStr   = @"-568h@2x";
        }
        else
        {
            deviceStr   = @"~iphone";
        }
    }
    
    NSString*   tempName;
    
    tempName = [fileName stringByAppendingFormat:@"%@%@", deviceStr, orientation2Str];
    if ([[NSBundle mainBundle] pathForResource:tempName ofType:extension] != nil)
    {
        return [tempName stringByAppendingFormat:@".%@", extension];
    }
    
    tempName = [fileName stringByAppendingFormat:@"%@", orientation2Str];
    if ([[NSBundle mainBundle] pathForResource:tempName ofType:extension] != nil)
    {
        return [tempName stringByAppendingFormat:@".%@", extension];
    }
    
    tempName = [fileName stringByAppendingFormat:@"%@%@", deviceStr, orientationStr];
    if ([[NSBundle mainBundle] pathForResource:tempName ofType:extension] != nil)
    {
        return [tempName stringByAppendingFormat:@".%@", extension];
    }
    
    tempName = [fileName stringByAppendingFormat:@"%@", orientationStr];
    if ([[NSBundle mainBundle] pathForResource:tempName ofType:extension] != nil)
    {
        return [tempName stringByAppendingFormat:@".%@", extension];
    }
    
    tempName = [fileName stringByAppendingFormat:@"%@", deviceStr];
    if ([[NSBundle mainBundle] pathForResource:tempName ofType:extension] != nil)
    {
        return [tempName stringByAppendingFormat:@".%@", extension];
    }
    
    return [fileName stringByAppendingFormat:@".%@", extension];
}

+ (bool)canDevicePlaceAPhoneCall
{
    /*
     Returns YES if the device can place a phone call
     */
    
    // Check if the device can place a phone call
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]])
    {
        // Device supports phone calls, lets confirm it can place one right now
        CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = [netInfo subscriberCellularProvider];
        NSString *mnc = [carrier mobileNetworkCode];
        
        if (([mnc length] > 0) && (![mnc isEqualToString:@"65535"]))
        {
            // Device can place a phone call
            return YES;
        }
    }
    
    // Device does not support phone calls
    return  NO;
}

+(AVAudioPlayer*)createSound:(NSString*)fName ofType:(NSString*)ext
{
    AVAudioPlayer*  avSound = nil;
    
    NSString*   path  = [[NSBundle mainBundle] pathForResource:fName ofType:ext];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSURL*  pathURL = [NSURL fileURLWithPath:path];
        
        @try
        {
            avSound = [[AVAudioPlayer alloc] initWithContentsOfURL:pathURL error:nil];
        }
        @catch (NSException *exception)
        {
        }
        
        [avSound prepareToPlay];
    }
    else
    {
        DNCLog(DNCLL_Debug, DNCLD_General, @"error, file not found: %@", path);
    }
    
    return avSound;
}

+ (void)playSound:(NSString*)name
{
    static AVAudioPlayer*  avSound_buzz = nil;
    static AVAudioPlayer*  avSound_ding = nil;
    static AVAudioPlayer*  avSound_tada = nil;
    static AVAudioPlayer*  avSound_beep = nil;
    
    static dispatch_once_t  once;
    
    dispatch_once(&once, ^{
        avSound_buzz    = [DNCUtilities createSound:@"buzz_Error" ofType:@"mp3"];
        avSound_ding    = [DNCUtilities createSound:@"ding_Capture" ofType:@"mp3"];
        avSound_tada    = [DNCUtilities createSound:@"tada_Reward" ofType:@"mp3"];
        avSound_beep    = [DNCUtilities createSound:@"beep_Scanner" ofType:@"mp3"];
    });
    
    if ([name isEqualToString:@"buzz"] == YES)
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [avSound_buzz play];
    }
    else if ([name isEqualToString:@"ding"] == YES)
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [avSound_ding play];
    }
    else if ([name isEqualToString:@"tada"] == YES)
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [avSound_tada play];
    }
    else if ([name isEqualToString:@"beep"] == YES)
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [avSound_beep play];
    }
    
    [DNCThread afterDelay:3.0f
                      run:
     ^()
     {
         //NSError*    error;
         [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:NULL];
     }];
}

+ (NSString*)encodeWithHMAC_SHA1:(NSString*)data withKey:(NSString*)key
{
    const char* cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];    // NSASCIIStringEncoding];
    const char* cData = [data cStringUsingEncoding:NSUTF8StringEncoding];   // NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSString*   hexStr = [NSString  stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          cHMAC[0], cHMAC[1], cHMAC[2], cHMAC[3], cHMAC[4],
                          cHMAC[5], cHMAC[6], cHMAC[7],
                          cHMAC[8], cHMAC[9], cHMAC[10], cHMAC[11], cHMAC[12],
                          cHMAC[13], cHMAC[14], cHMAC[15],
                          cHMAC[16], cHMAC[17], cHMAC[18], cHMAC[19]
                          ];
    
    return hexStr;
}

+ (UIImage*)imageScaledForRetina:(UIImage*)image
{
    // [UIImage imageWithCGImage:[newImage CGImage] scale:2.0 orientation:UIImageOrientationUp];
    // [newImage scaleProportionalToSize:CGSizeMake(32, 32)];
    
    double  scale   = [[UIScreen mainScreen] scale];
    //NSLog(@"scale=%.2f", scale);
    
    return [UIImage imageWithCGImage:[image CGImage] scale:scale orientation:UIImageOrientationUp];
}

#pragma mark - Global Settings functions

+ (NSUserDefaults*)groupDefaults
{
    if (self.sharedInstance.userDefaultsSuiteName.length)
    {
        return [NSUserDefaults.alloc initWithSuiteName:self.sharedInstance.userDefaultsSuiteName];
    }
    
    return NSUserDefaults.standardUserDefaults;
}

+ (id)settingsItem:(NSString*)item
{
    return [self settingsItem:item
                      default:@""];
}

+ (id)settingsItem:(NSString*)item
           default:(id)defaultValue
{
    __block id  retval;
    
    NSString*   key = [NSString stringWithFormat:@"Setting_%@", item];
    
    NSUserDefaults* groupDefaults = self.groupDefaults;
    
    if ([groupDefaults objectForKey:key] == nil)
    {
        [groupDefaults setObject:defaultValue
                          forKey:key];
    }
    
    retval = [groupDefaults objectForKey:key];
    
    return retval;
}

+ (BOOL)settingsItem:(NSString*)item
         boolDefault:(BOOL)defaultValue
{
    return [[self settingsItem:item
                       default:(defaultValue ? @"1" : @"0")] boolValue];
}

+ (void)setSettingsItem:(NSString*)item
                  value:(id)value
{
    NSString*   key = [NSString stringWithFormat:@"Setting_%@", item];
    
    NSUserDefaults* groupDefaults = self.groupDefaults;
    
    if (value != nil)
    {
        [groupDefaults setObject:value
                          forKey:key];
    }
    else
    {
        [groupDefaults removeObjectForKey:key];
    }
    
    [groupDefaults synchronize];
}

+ (void)setSettingsItem:(NSString*)item
              boolValue:(BOOL)value
{
    [self setSettingsItem:item
                    value:(value ? @"1" : @"0")];
}

+ (NSString *)getIPAddress
{
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    NSString *wifiAddress = nil;
    NSString *cellAddress = nil;
    
    // retrieve the current interfaces - returns 0 on success
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            sa_family_t sa_type = temp_addr->ifa_addr->sa_family;
            if(sa_type == AF_INET || sa_type == AF_INET6) {
                NSString*   name    = @(temp_addr->ifa_name);
                NSString*   addr    = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]; // pdp_ip0
                                                                                                                                        //NSLog(@"NAME: \"%@\" addr: %@", name, addr); // see for yourself
                
                if([name isEqualToString:@"en0"]) {
                    // Interface is the wifi connection on the iPhone
                    wifiAddress = addr;
                } else
                    if([name isEqualToString:@"pdp_ip0"]) {
                        // Interface is the cell connection on the iPhone
                        cellAddress = addr;
                    }
            }
            temp_addr = temp_addr->ifa_next;
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    NSString*   addr = wifiAddress ?: cellAddress;
    return addr ? addr : @"0.0.0.0";
}

+ (void)updateImage:(UIImageView*)imageView
           newImage:(UIImage*)newImage
{
    [UIView animateWithDuration:0.2f
                     animations:^
     {
         imageView.alpha = 0.0f;
     }
                     completion:^(BOOL finished)
     {
         imageView.image = newImage;
         
         [UIView animateWithDuration:0.2f
                          animations:^
          {
              imageView.alpha = 1.0f;
          }];
     }];
}

#pragma mark - Dictionary Translation functions

+ (NSNumber*)dictionaryBoolean:(NSDictionary*)dictionary withItem:(NSString*)key andDefault:(NSNumber*)defaultValue
{
    return [[self class] dictionaryBoolean:dictionary dirty:nil withItem:key andDefault:defaultValue];
}

+ (NSNumber*)dictionaryBoolean:(NSDictionary*)dictionary dirty:(BOOL*)dirtyFlag withItem:(NSString*)key andDefault:(NSNumber*)defaultValue
{
    NSNumber*   retval  = defaultValue;
    
    id  object = dictionary[key];
    if (object != nil)
    {
        if (object != (NSNumber*)[NSNull null])
        {
            NSNumber*   newval  = [NSNumber numberWithInt:[object boolValue]];
            
            if ((retval == nil) || ([newval isEqualToNumber:retval] == NO))
            {
                if (dirtyFlag != nil)   {   *dirtyFlag = YES;   }
                retval = newval;
            }
        }
    }
    else if (retval)
    {
        if (dirtyFlag != nil)   {   *dirtyFlag = YES;   }
    }
    
    return retval;
}

+ (NSNumber*)dictionaryNumber:(NSDictionary*)dictionary withItem:(NSString*)key andDefault:(NSNumber*)defaultValue
{
    return [[self class] dictionaryNumber:dictionary dirty:nil withItem:key andDefault:defaultValue];
}

+ (NSNumber*)dictionaryNumber:(NSDictionary*)dictionary dirty:(BOOL*)dirtyFlag withItem:(NSString*)key andDefault:(NSNumber*)defaultValue
{
    NSNumber*   retval  = defaultValue;
    
    id  object = dictionary[key];
    if (object != nil)
    {
        if (object != (NSNumber*)[NSNull null])
        {
            NSNumber*   newval  = [NSNumber numberWithInt:[object intValue]];
            
            if ((retval == nil) || ([newval isEqualToNumber:retval] == NO))
            {
                if (dirtyFlag != nil)   {   *dirtyFlag = YES;   }
                retval = newval;
            }
        }
    }
    else if (retval)
    {
        if (dirtyFlag != nil)   {   *dirtyFlag = YES;   }
    }
    
    return retval;
}

+ (NSDecimalNumber*)dictionaryDecimalNumber:(NSDictionary*)dictionary withItem:(NSString*)key andDefault:(NSDecimalNumber*)defaultValue
{
    return [[self class] dictionaryDecimalNumber:dictionary dirty:nil withItem:key andDefault:defaultValue];
}

+ (NSDecimalNumber*)dictionaryDecimalNumber:(NSDictionary*)dictionary dirty:(BOOL*)dirtyFlag withItem:(NSString*)key andDefault:(NSDecimalNumber*)defaultValue
{
    NSDecimalNumber*   retval  = defaultValue;
    
    id  object = [dictionary objectForKey:key];
    if (object != nil)
    {
        if (object != (NSDecimalNumber*)[NSNull null])
        {
            NSDecimalNumber*   newval  = [NSDecimalNumber decimalNumberWithDecimal:[object decimalValue]];
            
            if ((retval == nil) || ([newval compare:retval] != NSOrderedSame))
            {
                if (dirtyFlag != nil)   {   *dirtyFlag = YES;   }
                retval = newval;
            }
        }
    }
    else if (retval)
    {
        if (dirtyFlag != nil)   {   *dirtyFlag = YES;   }
    }
    
    return retval;
}

+ (NSNumber*)dictionaryDouble:(NSDictionary*)dictionary withItem:(NSString*)key andDefault:(NSNumber*)defaultValue
{
    return [[self class] dictionaryDouble:dictionary dirty:nil withItem:key andDefault:defaultValue];
}

+ (NSNumber*)dictionaryDouble:(NSDictionary*)dictionary dirty:(BOOL*)dirtyFlag withItem:(NSString*)key andDefault:(NSNumber*)defaultValue
{
    NSNumber*   retval  = defaultValue;
    
    id  object = [dictionary objectForKey:key];
    if (object != nil)
    {
        if (object != (NSString*)[NSNull null])
        {
            NSNumber*   newval  = @([object doubleValue]);
            
            if ((retval == nil) || ([newval isEqualToNumber:retval] == NO))
            {
                if (dirtyFlag != nil)   {   *dirtyFlag = YES;   }
                retval = newval;
            }
        }
    }
    else if (retval)
    {
        if (dirtyFlag != nil)   {   *dirtyFlag = YES;   }
    }
    
    return retval;
}

+ (NSString*)dictionaryString:(NSDictionary*)dictionary withItem:(NSString*)key andDefault:(NSString*)defaultValue
{
    return [[self class] dictionaryString:dictionary dirty:nil withItem:key andDefault:defaultValue];
}

+ (NSString*)dictionaryString:(NSDictionary*)dictionary dirty:(BOOL*)dirtyFlag withItem:(NSString*)key andDefault:(NSString*)defaultValue
{
    NSString*   retval  = defaultValue;
    
    id  object = [dictionary objectForKey:key];
    if (object != nil)
    {
        if ([object isKindOfClass:[NSArray class]] == YES)
        {
            if (object != (NSArray*)[NSNull null])
            {
                if ([object count] > 0)
                {
                    NSString*   newval  = object[0];
                    
                    if ((retval == nil) || ([newval isEqualToString:retval] == NO))
                    {
                        if (dirtyFlag != nil)   {   *dirtyFlag = YES;   }
                        retval = newval;
                    }
                }
            }
        }
        else
        {
            if ([object isKindOfClass:[NSString class]] == YES)
            {
                if ([object isEqualToString:@"<null>"] == YES)
                {
                    object  = @"";
                }
            }
            else if ([object isKindOfClass:[NSNull class]] == YES)
            {
                object = @"";
            }
            else
            {
                object = [object stringValue];
            }
            if (object != (NSString*)[NSNull null])
            {
                NSString*   newval  = object;
                
                if ((retval == nil) || ([newval isEqualToString:retval] == NO))
                {
                    if (dirtyFlag != nil)   {   *dirtyFlag = YES;   }
                    retval = newval;
                }
            }
        }
    }
    else if (retval)
    {
        if (dirtyFlag != nil)   {   *dirtyFlag = YES;   }
    }
    
    return [retval dncStringByDecodingXMLEntities];
}

+ (NSArray*)dictionaryArray:(NSDictionary*)dictionary withItem:(NSString*)key andDefault:(NSArray*)defaultValue
{
    return [[self class] dictionaryArray:dictionary dirty:nil withItem:key andDefault:defaultValue];
}

+ (NSArray*)dictionaryArray:(NSDictionary*)dictionary dirty:(BOOL*)dirtyFlag withItem:(NSString*)key andDefault:(NSArray*)defaultValue
{
    NSArray*    retval  = defaultValue;
    
    id  object = [dictionary objectForKey:key];
    if (object != nil)
    {
        if (object != (NSArray*)[NSNull null])
        {
            if ([object isKindOfClass:[NSArray class]] == YES)
            {
                NSArray*   newval  = object;
                
                if ((retval == nil) || ([newval isEqualToArray:retval] == NO))
                {
                    if (dirtyFlag != nil)   {   *dirtyFlag = YES;   }
                    retval = newval;
                }
            }
        }
    }
    else if (retval)
    {
        if (dirtyFlag != nil)   {   *dirtyFlag = YES;   }
    }
    
    return retval;
}

+ (NSDictionary*)dictionaryDictionary:(NSDictionary*)dictionary withItem:(NSString*)key andDefault:(NSDictionary*)defaultValue
{
    return [[self class] dictionaryDictionary:dictionary dirty:nil withItem:key andDefault:defaultValue];
}

+ (NSDictionary*)dictionaryDictionary:(NSDictionary*)dictionary dirty:(BOOL*)dirtyFlag withItem:(NSString*)key andDefault:(NSDictionary*)defaultValue
{
    NSDictionary*    retval  = defaultValue;
    
    id  object = dictionary[key];
    if (object != nil)
    {
        if (object != (NSDictionary*)[NSNull null])
        {
            if ([object isKindOfClass:[NSDictionary class]] == YES)
            {
                NSDictionary*   newval  = object;
                
                if ((retval == nil) || ([newval isEqualToDictionary:retval] == NO))
                {
                    if (dirtyFlag != nil)   {   *dirtyFlag = YES;   }
                    retval = newval;
                }
            }
        }
    }
    else if (retval)
    {
        if (dirtyFlag != nil)   {   *dirtyFlag = YES;   }
    }
    
    return retval;
}

+ (NSDate*)dictionaryDate:(NSDictionary*)dictionary withItem:(NSString*)key andDefault:(NSDate*)defaultValue
{
    return [[self class] dictionaryDate:dictionary dirty:nil withItem:key andDefault:defaultValue];
}

+ (NSDate*)dictionaryDate:(NSDictionary*)dictionary dirty:(BOOL*)dirtyFlag withItem:(NSString*)key andDefault:(NSDate*)defaultValue
{
    NSDate*   retval  = defaultValue;
    if ((id)retval == (id)@0)
    {
        retval = nil;
    }
    
    id  object = [dictionary objectForKey:key];
    if (object != nil)
    {
        if ([object isKindOfClass:[NSNumber class]])
        {
            if (object != (NSNumber*)[NSNull null])
            {
                NSDate*   newval  = [NSDate dateWithTimeIntervalSince1970:[object intValue]];
                
                if ((retval == nil) || ([newval isEqualToDate:retval] == NO))
                {
                    if (dirtyFlag != nil)   {   *dirtyFlag = YES;   }
                    retval = newval;
                }
            }
        }
        else if ([object isKindOfClass:[NSString class]])
        {
            if (object != (NSString*)[NSNull null])
            {
                NSDate*   newval  = [[[self class] dictionaryDateDateFormatter] dateFromString:object];
                if (newval == nil)
                {
                    NSNumber*   timestamp = [[[self class] dictionaryDateNumberFormatter] numberFromString:object];
                    if (timestamp != nil)
                    {
                        if ([timestamp integerValue] != 0)
                        {
                            newval = [NSDate dateWithTimeIntervalSince1970:[timestamp integerValue]];
                        }
                    }
                }
                if (newval)
                {
                    if ((retval == nil) || ([newval isEqualToDate:retval] == NO))
                    {
                        if (dirtyFlag != nil)   {   *dirtyFlag = YES;   }
                        retval = newval;
                    }
                }
            }
        }
        else if ([object isKindOfClass:[NSDate class]])
        {
            if (object != (NSDate*)[NSNull null])
            {
                NSDate*   newval  = object;
                
                if ((retval == nil) || ([newval isEqualToDate:retval] == NO))
                {
                    if (dirtyFlag != nil)   {   *dirtyFlag = YES;   }
                    retval = newval;
                }
            }
        }
    }
    else if (retval)
    {
        if (dirtyFlag != nil)   {   *dirtyFlag = YES;   }
    }
    
    return retval;
}

+ (DNCDate*)dictionaryDNCDate:(NSDictionary*)dictionary withItem:(NSString*)key andDefault:(DNCDate*)defaultValue
{
    return [[self class] dictionaryDNCDate:dictionary dirty:nil withItem:key andDefault:defaultValue];
}

+ (DNCDate*)dictionaryDNCDate:(NSDictionary*)dictionary dirty:(BOOL*)dirtyFlag withItem:(NSString*)key andDefault:(DNCDate*)defaultValue
{
    unsigned    dateFlags   = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute;
    
    DNCDate*    retval  = defaultValue;
    if ((id)retval == (id)@0)
    {
        retval = nil;
    }
    
    id  object = [dictionary objectForKey:key];
    if (object != nil)
    {
        if ([object isKindOfClass:[NSNumber class]])
        {
            if (object != (NSNumber*)[NSNull null])
            {
                NSDate*     gmtTime     = [NSDate dateWithTimeIntervalSince1970:[object intValue]];
                NSDate*     localTime   = [gmtTime dncToGlobalTime];
                
                DNCDate*    newval = [DNCDate dateWithComponentFlags:dateFlags fromDate:localTime];
                
                if ((retval == nil) || ([newval isEqualToDNDate:retval] == NO))
                {
                    if (dirtyFlag != nil)   {   *dirtyFlag = YES;   }
                    retval = newval;
                }
            }
        }
        else if ([object isKindOfClass:[NSString class]])
        {
            if (object != (NSString*)[NSNull null])
            {
                NSDate*     gmtTime     = [NSDate dateWithTimeIntervalSince1970:[object intValue]];
                NSDate*     localTime   = [gmtTime dncToGlobalTime];
                
                DNCDate*    newval = [DNCDate dateWithComponentFlags:dateFlags fromDate:localTime];
                if (newval == nil)
                {
                    NSNumber*   timestamp = [[[self class] dictionaryDateNumberFormatter] numberFromString:object];
                    if (timestamp != nil)
                    {
                        if ([timestamp integerValue] != 0)
                        {
                            NSDate*     gmtTime     = [NSDate dateWithTimeIntervalSince1970:[timestamp intValue]];
                            NSDate*     localTime   = [gmtTime dncToGlobalTime];
                            
                            newval = [DNCDate dateWithComponentFlags:dateFlags fromDate:localTime];
                        }
                    }
                }
                if (newval)
                {
                    if ((retval == nil) || ([newval isEqualToDNDate:retval] == NO))
                    {
                        if (dirtyFlag != nil)   {   *dirtyFlag = YES;   }
                        retval = newval;
                    }
                }
            }
        }
        else if ([object isKindOfClass:[DNCDate class]])
        {
            if (object != (DNCDate*)[NSNull null])
            {
                DNCDate*   newval  = object;
                
                if ((retval == nil) || ([newval isEqualToDNDate:retval] == NO))
                {
                    if (dirtyFlag != nil)   {   *dirtyFlag = YES;   }
                    retval = newval;
                }
            }
        }
    }
    else if (retval)
    {
        if (dirtyFlag != nil)   {   *dirtyFlag = YES;   }
    }
    
    return retval;
}

+ (id)dictionaryObject:(NSDictionary*)dictionary withItem:(NSString*)key andDefault:(id)defaultValue
{
    return [[self class] dictionaryObject:dictionary dirty:nil withItem:key andDefault:defaultValue];
}

+ (id)dictionaryObject:(NSDictionary*)dictionary dirty:(BOOL*)dirtyFlag withItem:(NSString*)key andDefault:(id)defaultValue
{
    id  retval  = defaultValue;
    
    if (dictionary[key] != nil)
    {
        if (dictionary[key] != (id)[NSNull null])
        {
            id  newval  = dictionary[key];
            
            if ((retval == nil) || ([newval isEqual:retval] == NO))
            {
                if (dirtyFlag != nil)   {   *dirtyFlag = YES;   }
                retval = newval;
            }
        }
    }
    else if (retval)
    {
        if (dirtyFlag != nil)   {   *dirtyFlag = YES;   }
    }
    
    return retval;
}

// How to apply color formatting to your log statements:
//
// To set the foreground color:
// Insert the ESCAPE_SEQ into your string, followed by "fg124,12,255;" where r=124, g=12, b=255.
//
// To set the background color:
// Insert the ESCAPE_SEQ into your string, followed by "bg12,24,36;" where r=12, g=24, b=36.
//
// To reset the foreground color (to default value):
// Insert the ESCAPE_SEQ into your string, followed by "fg;"
//
// To reset the background color (to default value):
// Insert the ESCAPE_SEQ into your string, followed by "bg;"
//
// To reset the foreground and background color (to default values) in one operation:
// Insert the ESCAPE_SEQ into your string, followed by ";"

#define XCODE_COLORS_ESCAPE @"\033["

#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color

- (id)init
{
    self = [super init];
    if (self)
    {
        self.xcodeColorsEscape  = @"";
        self.xcodeColorsReset   = @"";
        
        // Force XcodeColors on for now.  Env Variable isn't working right
        //setenv("XcodeColors", "YES", 0); // Enables XcodeColors (you obviously have to install it too)
        
        char*   xcode_colors = getenv("XcodeColors");
        if (xcode_colors && (strcmp(xcode_colors, "YES") == 0))
        {
            // XcodeColors is installed and enabled!
            self.xcodeColorsEscape  = XCODE_COLORS_ESCAPE;
            self.xcodeColorsReset   = XCODE_COLORS_ESCAPE @"fg;" XCODE_COLORS_ESCAPE @"bg;";
        }
        
        _logDebugLevel   = DNCLL_Everything;
        _logDebugDomains = GGMutableDictionary.dictionary;
        
        [DNCThread run:
         ^()
         {
             [self logResetLogState];
         }];
    }
    
    return self;
}

+ (NSString*)xcodeColorsEscape
{
    return [DNCUtilities sharedInstance].xcodeColorsEscape;
}

+ (NSString*)xcodeColorsReset
{
    return [DNCUtilities sharedInstance].xcodeColorsReset;
}

+ (NSString*)xcodeColorsLevelColor:(DNCLogLevel)level
{
    if ([DNCUtilities sharedInstance].xcodeColorsEscape.length == 0)
    {
        return @"";
    }
    
    NSString*   color   = @"fg;bg;";
    
    switch (level)
    {
        case DNCLL_Critical:       {   color   = XCODE_COLORS_ESCAPE @"fg255,255,255;" XCODE_COLORS_ESCAPE @"bg255,0,0;";  break;  }
        case DNCLL_Error:          {   color   = XCODE_COLORS_ESCAPE @"fg255,0,0;" XCODE_COLORS_ESCAPE @"bg;";             break;  }
        case DNCLL_Warning:        {   color   = XCODE_COLORS_ESCAPE @"fg255,127,0;" XCODE_COLORS_ESCAPE @"bg;";           break;  }
        case DNCLL_Debug:          {   color   = XCODE_COLORS_ESCAPE @"fg0,0,255;" XCODE_COLORS_ESCAPE @"bg;";             break;  }
        case DNCLL_Info:           {   color   = XCODE_COLORS_ESCAPE @"fg100,100,133;" XCODE_COLORS_ESCAPE @"bg;";         break;  }
        case DNCLL_Everything:     {   color   = XCODE_COLORS_ESCAPE @"fg64,64,64;" XCODE_COLORS_ESCAPE @"bg;";            break;  }
    }
    
    return color;
}

+ (NSString*)xcodeColorsDomainColor:(NSString*)domain
{
    if ([DNCUtilities sharedInstance].xcodeColorsEscape.length == 0)
    {
        return @"";
    }
    
    NSString*   color   = @"fg;bg;";
    
    if ([domain isEqualToString:DNCLD_UnitTests])          {   color   = XCODE_COLORS_ESCAPE @"fg255,255,255;" XCODE_COLORS_ESCAPE @"bg255,0,0;"; }
    else if ([domain isEqualToString:DNCLD_General])       {   color   = XCODE_COLORS_ESCAPE @"fg80,80,80;" XCODE_COLORS_ESCAPE @"bg;"; }
    else if ([domain isEqualToString:DNCLD_Framework])     {   color   = XCODE_COLORS_ESCAPE @"fg255,0,0;" XCODE_COLORS_ESCAPE @"bg;"; }
    else if ([domain isEqualToString:DNCLD_CoreData])      {   color   = XCODE_COLORS_ESCAPE @"fg255,255,255;" XCODE_COLORS_ESCAPE @"bg0,0,255;"; }
    else if ([domain isEqualToString:DNCLD_CoreDataIS])    {   color   = XCODE_COLORS_ESCAPE @"fg255,252,229;" XCODE_COLORS_ESCAPE @"bg0,0,255;"; }
    else if ([domain isEqualToString:DNCLD_Realm])         {   color   = XCODE_COLORS_ESCAPE @"fg0,127,0;" XCODE_COLORS_ESCAPE @"bg;"; }
    else if ([domain isEqualToString:DNCLD_ViewState])     {   color   = XCODE_COLORS_ESCAPE @"fg255,252,229;" XCODE_COLORS_ESCAPE@"bg0,127,0;"; }
    else if ([domain isEqualToString:DNCLD_Theming])       {   color   = XCODE_COLORS_ESCAPE @"fg255,255,255;" XCODE_COLORS_ESCAPE @"bg0,127,0;"; }
    else if ([domain isEqualToString:DNCLD_Location])      {   color   = XCODE_COLORS_ESCAPE @"fg255,127,0;" XCODE_COLORS_ESCAPE @"bg;"; }
    else if ([domain isEqualToString:DNCLD_Networking])    {   color   = XCODE_COLORS_ESCAPE @"fg0,0,255;" XCODE_COLORS_ESCAPE @"bg;"; }
    else if ([domain isEqualToString:DNCLD_API])           {   color   = XCODE_COLORS_ESCAPE @"fg0,255,127;" XCODE_COLORS_ESCAPE @"bg;"; }
    else if ([domain isEqualToString:DNCLD_DAO])           {   color   = XCODE_COLORS_ESCAPE @"fg0,255,127;" XCODE_COLORS_ESCAPE @"bg;"; }
    
    return color;
}

+ (NSString*)xcodeColorsOtherColor
{
    if ([DNCUtilities sharedInstance].xcodeColorsEscape.length == 0)
    {
        return @"";
    }
    
    NSString*   color   = XCODE_COLORS_ESCAPE @"fg192,192,192;" XCODE_COLORS_ESCAPE @"bg;";
    
    return color;
}

- (void)logResetLogState
{
    if ([[[self class] appDelegate] respondsToSelector:@selector(resetLogState)] == YES)
    {
        [[[self class] appDelegate] resetLogState];
    };
}

- (void)logSetLevel:(DNCLogLevel)level
{
    _logDebugLevel   = level;
}

- (void)logEnableDomain:(NSString*)domain
{
    [self logEnableDomain:domain forLevel:DNCLL_Everything];
}

- (void)logEnableDomain:(NSString*)domain forLevel:(DNCLogLevel)level
{
    @synchronized(_logDebugDomains)
    {
        _logDebugDomains[domain] = @(level);
    }
}

- (void)logDisableDomain:(NSString*)domain
{
    [self logDisableDomain:domain forLevel:DNCLL_Everything];
}

- (void)logDisableDomain:(NSString*)domain forLevel:(DNCLogLevel)level
{
    @synchronized(_logDebugDomains)
    {
        _logDebugDomains[domain] = @(level - 1);
    }
}

- (BOOL)isLogEnabledDomain:(NSString*)domain
                  andLevel:(int)level
{
    if (level > _logDebugLevel)
    {
        return NO;
    }
    
    __block BOOL    retval = YES;
    
    @synchronized(_logDebugDomains)
    {
        [_logDebugDomains enumerateKeysAndObjectsUsingBlock:^(NSString* key, NSNumber* obj, BOOL* stop)
         {
             if ([key isEqualToString:domain])
             {
                 retval = (level <= [[self->_logDebugDomains objectForKey:domain] intValue]);
                 *stop = YES;
             }
         }];
    }
    
    return retval;
}

@end

//
// Function provided by BigNerdRanch
// https://gist.github.com/bignerdranch/2006587
//
CGFloat DNCTimeBlock (void (^block)(void))
{
    mach_timebase_info_data_t   info;
    if (mach_timebase_info(&info) != KERN_SUCCESS)
    {
        return -1.0;
    }
    
    uint64_t    start   = mach_absolute_time ();
    block ();
    uint64_t    end     = mach_absolute_time ();
    uint64_t    elapsed = end - start;
    
    uint64_t    nanos   = (elapsed * info.numer) / info.denom;
    return (CGFloat)nanos / NSEC_PER_SEC;
}

NSString*
levelString(int level)
{
    switch (level)
    {
        case DNCLL_Critical:    {   return @"🆘🆘🆘";   }
        case DNCLL_Error:       {   return @"❤️❤️❤️";   }
        case DNCLL_Warning:     {   return @"⚠️⚠️⚠️";   }
        case DNCLL_Debug:       {   return @"🍺🍺🍺";   }
        case DNCLL_Info:        {   return @"✳️✳️✳️";   }
        case DNCLL_Everything:  {   return @"🚻🚻🚻";   }
    }
    
    return @"";
}

void DNCLogMessageF(const char *filename, int lineNumber, const char *functionName, NSString *domain, int level, NSString *format, ...)
{
    if ([[DNCUtilities sharedInstance] isLogEnabledDomain:domain andLevel:level] != YES)
    {
        return;
    }
    
    NSString*   domainColor = [DNCUtilities xcodeColorsDomainColor:domain];
    NSString*   mainColor   = [DNCUtilities xcodeColorsLevelColor:level];
    NSString*   otherColor  = [DNCUtilities xcodeColorsOtherColor];
    
    va_list args;
    va_start(args, format);
    
    NSString*   formattedStr = [[NSString alloc] initWithFormat:format arguments:args];
    
    va_end(args);
    
    NSLog(@"%@ %@[%@] %@{%@} %@[%@:%d] %@%@%@", levelString(level), otherColor, ([NSThread isMainThread] ? @"MT" : @"BT"), domainColor, domain, otherColor, [NSString stringWithUTF8String:filename].lastPathComponent, lineNumber, mainColor, formattedStr, DNCUtilities.xcodeColorsReset);
}

@interface DNCThreadingHelper : NSObject
{
    GGMutableDictionary*    _dispatchQueues;
}

+ (DNCThreadingHelper*)sharedInstance;

+ (void)runOnUIThread:(DNCUtilitiesBlock)block;
+ (NSTimer*)afterDelay:(double)delay
         runOnUIThread:(DNCUtilitiesBlock)block;
+ (void)repeatedlyAfterDelay:(double)delay
               runOnUIThread:(DNCUtilitiesStopBlock)block;

+ (void)runInBackground:(DNCUtilitiesBlock)block;
+ (void)runInHighBackground:(DNCUtilitiesBlock)block;
+ (void)runInLowBackground:(DNCUtilitiesBlock)block;
+ (NSTimer*)afterDelay:(double)delay
       runInBackground:(DNCUtilitiesBlock)block;
+ (NSTimer*)afterDelay:(double)delay
   runInHighBackground:(DNCUtilitiesBlock)block;
+ (NSTimer*)afterDelay:(double)delay
    runInLowBackground:(DNCUtilitiesBlock)block;
+ (void)repeatedlyAfterDelay:(double)delay
             runInBackground:(DNCUtilitiesStopBlock)block;
+ (void)repeatedlyAfterDelay:(double)delay
         runInHighBackground:(DNCUtilitiesStopBlock)block;
+ (void)repeatedlyAfterDelay:(double)delay
          runInLowBackground:(DNCUtilitiesStopBlock)block;

+ (void)runGroup:(DNCUtilitiesGroupBlock)block
            then:(DNCUtilitiesCompletionBlock)completionBlock;
+ (void)withTimeout:(dispatch_time_t)timeout
           runGroup:(DNCUtilitiesGroupBlock)block
               then:(DNCUtilitiesCompletionBlock)completionBlock;

+ (void)enterGroup:(dispatch_group_t)group;
+ (void)leaveGroup:(dispatch_group_t)group;

+ (dispatch_queue_t)queueForLabel:(NSString*)queueLabel;
+ (dispatch_queue_t)queueForLabel:(NSString*)queueLabel
                    withAttribute:(dispatch_queue_attr_t _Nullable)attribute;

+ (void)onQueueForLabel:(NSString*)queueLabel
                    run:(DNCUtilitiesBlock)block;
+ (void)onQueueForLabel:(NSString*)queueLabel
         runSynchronous:(DNCUtilitiesBlock)block;

- (id)init;

@end

@implementation DNCThreadingHelper

const double    DNCThreadingHelperPriority_Low      = 0.2f;
const double    DNCThreadingHelperPriority_Default  = 0.5f;
const double    DNCThreadingHelperPriority_High     = 0.9f;

+ (DNCThreadingHelper*)sharedInstance
{
    static dispatch_once_t      once;
    static DNCThreadingHelper*  instance = nil;
    
    dispatch_once(&once, ^{
        instance = [[DNCThreadingHelper alloc] init];
    });
    
    return instance;
}

+ (void)runBlock:(DNCUtilitiesBlock)block
{
    [self atPriority:DNCThreadingHelperPriority_Default
            runBlock:block];
}

+ (void)runBlockAtHighPriority:(DNCUtilitiesBlock)block
{
    [self atPriority:DNCThreadingHelperPriority_High
            runBlock:block];
}

+ (void)runBlockAtLowPriority:(DNCUtilitiesBlock)block
{
    [self atPriority:DNCThreadingHelperPriority_Low
            runBlock:block];
}

+ (void)atPriority:(double)priority
          runBlock:(DNCUtilitiesBlock)block
{
    NSThread.currentThread.threadPriority   = priority;
    
    block ? block() : (void)nil;
}

+ (void)runOnUIThread:(DNCUtilitiesBlock)block
{
    if (NSThread.isMainThread)
    {
        [self runBlock:block];
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

+ (void)timerRunInBackground:(NSTimer*)timer
{
    DNCUtilitiesBlock block = timer.userInfo;
    
    [self runBlock:block];
}

+ (void)timerRunInHighBackground:(NSTimer*)timer
{
    DNCUtilitiesBlock block = timer.userInfo;
    
    [self runBlockAtHighPriority:block];
}

+ (void)timerRunInLowBackground:(NSTimer*)timer
{
    DNCUtilitiesBlock block = timer.userInfo;
    
    [self runBlockAtLowPriority:block];
}

+ (void)timerRunOnUIThread:(NSTimer*)timer
{
    DNCUtilitiesBlock block = timer.userInfo;
    
    [self runOnUIThread:block];
}

+ (NSTimer*)afterDelay:(double)delay
         runOnUIThread:(DNCUtilitiesBlock)block
{
    DNCUtilitiesBlock block_ = [block copy];
    
    return [NSTimer scheduledTimerWithTimeInterval:delay
                                            target:self
                                          selector:@selector(timerRunOnUIThread:)
                                          userInfo:block_
                                           repeats:NO];
}

+ (void)repeatedlyAfterDelay:(double)delay
               runOnUIThread:(DNCUtilitiesStopBlock)block
{
    [self.class afterDelay:delay
             runOnUIThread:^
     {
         BOOL   stop = NO;
         block ? block(&stop) : (void)nil;
         if (stop == NO)
         {
             [self.class repeatedlyAfterDelay:delay
                                runOnUIThread:block];
         }
     }];
}

+ (void)runInBackground:(DNCUtilitiesBlock)block
{
    [NSThread detachNewThreadSelector:@selector(runBlock:)
                             toTarget:self
                           withObject:block];
}

+ (void)runInHighBackground:(DNCUtilitiesBlock)block
{
    [NSThread detachNewThreadSelector:@selector(runBlockAtHighPriority:)
                             toTarget:self
                           withObject:block];
}

+ (void)runInLowBackground:(DNCUtilitiesBlock)block
{
    [NSThread detachNewThreadSelector:@selector(runBlockAtLowPriority:)
                             toTarget:self
                           withObject:block];
}

+ (NSTimer*)afterDelay:(double)delay
       runInBackground:(DNCUtilitiesBlock)block
{
    DNCUtilitiesBlock block_ = [block copy];
    
    return [NSTimer scheduledTimerWithTimeInterval:delay
                                            target:self
                                          selector:@selector(timerRunInBackground:)
                                          userInfo:block_
                                           repeats:NO];
}

+ (NSTimer*)afterDelay:(double)delay
   runInHighBackground:(DNCUtilitiesBlock)block
{
    DNCUtilitiesBlock block_ = [block copy];
    
    return [NSTimer scheduledTimerWithTimeInterval:delay
                                            target:self
                                          selector:@selector(timerRunInHighBackground:)
                                          userInfo:block_
                                           repeats:NO];
}

+ (NSTimer*)afterDelay:(double)delay
    runInLowBackground:(DNCUtilitiesBlock)block
{
    DNCUtilitiesBlock block_ = [block copy];
    
    return [NSTimer scheduledTimerWithTimeInterval:delay
                                            target:self
                                          selector:@selector(timerRunInLowBackground:)
                                          userInfo:block_
                                           repeats:NO];
}

+ (void)repeatedlyAfterDelay:(double)delay
             runInBackground:(DNCUtilitiesStopBlock)block
{
    [self.class afterDelay:delay
           runInBackground:^
     {
         BOOL   stop = NO;
         block ? block(&stop) : (void)nil;
         if (stop == NO)
         {
             [self.class repeatedlyAfterDelay:delay
                              runInBackground:block];
         }
     }];
}

+ (void)repeatedlyAfterDelay:(double)delay
         runInHighBackground:(DNCUtilitiesStopBlock)block
{
    [self.class afterDelay:delay
       runInHighBackground:^
     {
         BOOL   stop = NO;
         block ? block(&stop) : (void)nil;
         if (stop == NO)
         {
             [self.class repeatedlyAfterDelay:delay
                          runInHighBackground:block];
         }
     }];
}

+ (void)repeatedlyAfterDelay:(double)delay
          runInLowBackground:(DNCUtilitiesStopBlock)block
{
    [self.class afterDelay:delay
        runInLowBackground:^
     {
         BOOL   stop = NO;
         block ? block(&stop) : (void)nil;
         if (stop == NO)
         {
             [self.class repeatedlyAfterDelay:delay
                           runInLowBackground:block];
         }
     }];
}

+ (void)runGroup:(DNCUtilitiesGroupBlock)block
            then:(DNCUtilitiesCompletionBlock)completionBlock
{
    [self withTimeout:DISPATCH_TIME_FOREVER
             runGroup:block
                 then:completionBlock];
}

+ (void)withTimeout:(dispatch_time_t)timeout
           runGroup:(DNCUtilitiesGroupBlock)block
               then:(DNCUtilitiesCompletionBlock)completionBlock
{
    [self runInBackground:
     ^()
     {
         dispatch_group_t group = dispatch_group_create();
         
         block ? block(group) : (void)nil;
         
         dispatch_time_t    timeoutTime = dispatch_time(DISPATCH_TIME_NOW, timeout * NSEC_PER_SEC);
         if (timeout == DISPATCH_TIME_FOREVER)
         {
             timeoutTime = DISPATCH_TIME_FOREVER;
         }
         
         long   result = dispatch_group_wait(group, timeoutTime);
         
         NSError*   error = nil;
         if (result != 0)
         {
             error = [NSError errorWithDomain:ERROR_DOMAIN_CLASS
                                         code:ERROR_TIMEOUT
                                     userInfo:@{
                                                NSLocalizedDescriptionKey : NSLocalizedString(@"Group Timeout has occurred.", nil),
                                                }];
         }
         
         completionBlock ? completionBlock(error) : (void)nil;
     }];
}

+ (void)enterGroup:(dispatch_group_t)group
{
    dispatch_group_enter(group);
}

+ (void)leaveGroup:(dispatch_group_t)group
{
    dispatch_group_leave(group);
}

+ (dispatch_queue_t)queueForLabel:(NSString*)queueLabel
{
    return [self queueForLabel:queueLabel
                 withAttribute:DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL];
}

+ (dispatch_queue_t)queueForLabel:(NSString*)queueLabel
                    withAttribute:(dispatch_queue_attr_t _Nullable)attribute
{
    dispatch_queue_t    queue = self.sharedInstance->_dispatchQueues[queueLabel];
    if (!queue || [queue isKindOfClass:NSNull.class])
    {
        queue = dispatch_queue_create(queueLabel.UTF8String, attribute);
        
        self.sharedInstance->_dispatchQueues[queueLabel] = queue;
    }
    
    return queue;
}

+ (void)onQueueForLabel:(NSString*)queueLabel
                    run:(DNCUtilitiesBlock)block
{
    dispatch_queue_t    queue = [self queueForLabel:queueLabel];
    
    dispatch_async(queue, block);
}

+ (void)onQueueForLabel:(NSString*)queueLabel
         runSynchronous:(DNCUtilitiesBlock)block
{
    dispatch_queue_t    queue = [self queueForLabel:queueLabel];
    
    dispatch_sync(queue, block);
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _dispatchQueues = GGMutableDictionary.alloc.init;
    }
    
    return self;
}

@end

@implementation DNCThread
{
    DNCUtilitiesThreadBlock _block;
    DNCThreadingGroup*      _threadingGroup;
}

+ (id)create:(DNCUtilitiesThreadBlock)block
{
    return [self.alloc initWithBlock:block];
}

+ (void)run:(DNCUtilitiesBlock)block
{
    [DNCThreadingHelper runInBackground:block];
}

+ (NSTimer*)afterDelay:(double)delay
                   run:(DNCUtilitiesBlock)block
{
    return [DNCThreadingHelper afterDelay:delay
                          runInBackground:block];
}

+ (void)repeatedlyAfterDelay:(double)delay
                         run:(DNCUtilitiesStopBlock)block
{
    [DNCThreadingHelper repeatedlyAfterDelay:delay
                             runInBackground:block];
}

- (id)initWithBlock:(DNCUtilitiesThreadBlock)block
{
    self = [super init];
    if (self)
    {
        _block = block;
    }
    
    return self;
}

- (void)run
{
    [self.class run:
     ^()
     {
         self->_block ? self->_block(self) : (void)nil;
     }];
}

- (void)runAfterDelay:(double)delay
{
    [self.class afterDelay:delay
                       run:
     ^()
     {
         self->_block ? self->_block(self) : (void)nil;
     }];
}

- (void)runInGroup:(DNCThreadingGroup*)threadingGroup;
{
    _threadingGroup = threadingGroup;
    
    [self run];
}

- (void)done
{
    [_threadingGroup completeThread];
}

@end

@implementation DNCUIThread
{
    DNCUtilitiesUIThreadBlock   _uiBlock;
}

+ (id)create:(DNCUtilitiesUIThreadBlock)block
{
    return [self.alloc initWithBlock:block];
}

+ (void)run:(DNCUtilitiesBlock)block
{
    [DNCThreadingHelper runOnUIThread:block];
}

+ (NSTimer*)afterDelay:(double)delay
                   run:(DNCUtilitiesBlock)block
{
    return [DNCThreadingHelper afterDelay:delay
                            runOnUIThread:block];
}

+ (void)repeatedlyAfterDelay:(double)delay
                         run:(DNCUtilitiesStopBlock)block
{
    [DNCThreadingHelper repeatedlyAfterDelay:delay
                               runOnUIThread:block];
}

- (id)initWithBlock:(DNCUtilitiesUIThreadBlock)block
{
    self = [super initWithBlock:
            ^(DNCThread* thread)
            {
                block ? block(self) : (void)nil;
            }];
    if (self)
    {
        _uiBlock = block;
    }
    
    return self;
}

@end

@implementation DNCHighThread

+ (void)run:(DNCUtilitiesBlock)block
{
    [DNCThreadingHelper runInHighBackground:block];
}

+ (NSTimer*)afterDelay:(double)delay
                   run:(DNCUtilitiesBlock)block
{
    return [DNCThreadingHelper afterDelay:delay
                      runInHighBackground:block];
}

+ (void)repeatedlyAfterDelay:(double)delay
                         run:(DNCUtilitiesStopBlock)block
{
    [DNCThreadingHelper repeatedlyAfterDelay:delay
                         runInHighBackground:block];
}

@end

@implementation DNCLowThread

+ (void)run:(DNCUtilitiesBlock)block
{
    [DNCThreadingHelper runInLowBackground:block];
}

+ (NSTimer*)afterDelay:(double)delay
                   run:(DNCUtilitiesBlock)block
{
    return [DNCThreadingHelper afterDelay:delay
                       runInLowBackground:block];
}

+ (void)repeatedlyAfterDelay:(double)delay
                         run:(DNCUtilitiesStopBlock)block
{
    [DNCThreadingHelper repeatedlyAfterDelay:delay
                          runInLowBackground:block];
}

@end

@implementation DNCThreadingGroup
{
    dispatch_group_t    _group;
    
    NSMutableArray<id<DNCThreadingGroupProtocol>>*  _threads;
}

+ (DNCThreadingGroup*)run:(DNCUtilitiesThreadingGroupBlock)block
                     then:(DNCUtilitiesCompletionBlock)completionBlock
{
    DNCThreadingGroup* newObject = [self.alloc init];
    
    [newObject run:
     ^()
     {
         block ? block(newObject) : (void)nil;
     }
              then:completionBlock];
    
    return newObject;
}

+ (DNCThreadingGroup*)withTimeout:(dispatch_time_t)timeout
                              run:(DNCUtilitiesThreadingGroupBlock)block
                             then:(DNCUtilitiesCompletionBlock)completionBlock
{
    DNCThreadingGroup* newObject = [self.alloc init];
    
    [newObject withTimeout:timeout
                       run:
     ^()
     {
         block ? block(newObject) : (void)nil;
     }
                      then:completionBlock];
    
    return newObject;
}

- (void)run:(DNCUtilitiesBlock)block
       then:(DNCUtilitiesCompletionBlock)completionBlock
{
    [self withTimeout:DISPATCH_TIME_FOREVER
                  run:block
                 then:completionBlock];
}

- (void)withTimeout:(dispatch_time_t)timeout
                run:(DNCUtilitiesBlock)block
               then:(DNCUtilitiesCompletionBlock)completionBlock
{
    [DNCThreadingHelper withTimeout:timeout
                           runGroup:
     ^(dispatch_group_t group)
     {
         self->_threads = NSMutableArray.array;
         self->_group   = group;
         
         block ? block() : (void)nil;
         
         for (id<DNCThreadingGroupProtocol> thread in self->_threads)
         {
             [thread runInGroup:self];
         }
     }
                               then:completionBlock];
}

- (void)runThread:(id<DNCThreadingGroupProtocol>)thread
{
    [self startThread];
    
    [_threads addObject:thread];
}

- (void)startThread
{
    [DNCThreadingHelper enterGroup:_group];
}

- (void)completeThread
{
    [DNCThreadingHelper leaveGroup:_group];
}

@end

@implementation DNCThreadingQueue
{
    NSString*               _label;
    dispatch_queue_t        _queue;
    dispatch_queue_attr_t   _attribute;
}

+ (DNCThreadingQueue*)queueForLabel:(NSString*)queueLabel
{
    return [self.alloc initWithLabel:queueLabel
                       withAttribute:DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL];
}

+ (DNCThreadingQueue*)queueForLabel:(NSString*)queueLabel
                      withAttribute:(dispatch_queue_attr_t)attribute
{
    return [self.alloc initWithLabel:queueLabel
                       withAttribute:attribute];
}

+ (DNCThreadingQueue*)queueForLabel:(NSString*)queueLabel
                                run:(DNCUtilitiesThreadingQueueBlock)block
{
    DNCThreadingQueue*  queue = [self.alloc initWithLabel:queueLabel
                                            withAttribute:DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL];
    [queue run:block];
    
    return queue;
}

+ (DNCThreadingQueue*)queueForLabel:(NSString*)queueLabel
                      withAttribute:(dispatch_queue_attr_t)attribute
                                run:(DNCUtilitiesThreadingQueueBlock)block
{
    DNCThreadingQueue*  queue = [self.alloc initWithLabel:queueLabel
                                            withAttribute:attribute];
    [queue run:block];
    
    return queue;
}

- (id)initWithLabel:(NSString*)queueLabel
      withAttribute:(dispatch_queue_attr_t)attribute
{
    self = [self init];
    if (self)
    {
        _label      = queueLabel;
        _attribute  = attribute;
        _queue      = [DNCThreadingHelper queueForLabel:_label
                                          withAttribute:_attribute];
    }
    
    return self;
}

- (void)run:(DNCUtilitiesThreadingQueueBlock)block
{
    [DNCThreadingHelper onQueueForLabel:_label
                                    run:
     ^()
     {
         block ? block(self) : (void)nil;
     }];
}

- (void)runSynchronously:(DNCUtilitiesThreadingQueueBlock)block
{
    [DNCThreadingHelper onQueueForLabel:_label
                         runSynchronous:
     ^()
     {
         block ? block(self) : (void)nil;
     }];
}

@end

@implementation DNCSynchronousThreadingQueue

+ (DNCSynchronousThreadingQueue*)queueForLabel:(NSString*)queueLabel
{
    return [self.alloc initWithLabel:queueLabel
                       withAttribute:DISPATCH_QUEUE_SERIAL_WITH_AUTORELEASE_POOL];
}

+ (DNCSynchronousThreadingQueue*)queueForLabel:(NSString*)queueLabel
                                           run:(DNCUtilitiesThreadingQueueBlock)block
{
    DNCSynchronousThreadingQueue*   queue = [self.alloc initWithLabel:queueLabel
                                                        withAttribute:DISPATCH_QUEUE_SERIAL_WITH_AUTORELEASE_POOL];
    [queue run:block];
    
    return queue;
}

- (void)run:(DNCUtilitiesThreadingQueueBlock)block
{
    [super runSynchronously:block];
}

@end

