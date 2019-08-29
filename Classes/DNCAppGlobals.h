//
//  DNCAppGlobals.h
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC.
//
//  DNCore is released under the MIT license. See LICENSE for details.
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

// App Request Review Constants
- (BOOL)appConstantRequestReviews;
- (NSUInteger)appConstantRequestReviewFirstMinimumLaunches;
- (NSUInteger)appConstantRequestReviewFirstMaximumLaunches;
- (NSUInteger)appConstantRequestReviewFrequency;
- (NSUInteger)appConstantRequestReviewDaysSinceFirstLaunch;
- (NSUInteger)appConstantRequestReviewHoursSinceLastLaunch;
- (NSUInteger)appConstantRequestReviewDaysSinceLastReview;

- (BOOL)checkAndAskForReview;

- (void)applicationDidBecomeActive;
- (void)applicationWillResignActive;

@end
