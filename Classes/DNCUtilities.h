//
//  DNCUtilities.h
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NSLogger/LoggerClient.h>

#import "DNCApplicationProtocol.h"

/**
 *  System Versioning Preprocessor Macros
 */
#define DNC_SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define DNC_SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define DNC_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define DNC_SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define DNC_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

/**
 *  DLog Logging Items and Macros
 */
#ifndef __DNC_LOGLEVEL__
#define __DNC_LOGLEVEL__    1

typedef NS_ENUM(NSInteger, DNCLogLevel)
{
    DNCLL_Critical = 0,
    DNCLL_Error,
    DNCLL_Warning,
    DNCLL_Debug,
    DNCLL_Info,
    DNCLL_Everything
};

#define DNCLD_UnitTests     @"UNITTESTS"
#define DNCLD_General       @"GENERAL"
#define DNCLD_Framework     @"FRAMEWORK"
#define DNCLD_CoreData      @"COREDATA"
#define DNCLD_CoreDataIS    @"COREDATAIS"
#define DNCLD_Realm         @"REALM"
#define DNCLD_ViewState     @"VIEWSTATE"
#define DNCLD_Theming       @"THEMING"
#define DNCLD_Location      @"LOCATION"
#define DNCLD_Networking    @"NETWORKING"
#define DNCLD_API           @"API"
#define DNCLD_DAO           @"DAO"

#if !defined(DEBUG)
#define DNCAssert(condition,domain,...)           NSAssert(condition, __VA_ARGS__);
#define DNCLogMarker(marker)                      NSLog(@"%@", marker)
#define DNCLog(level,domain,...)                  NSLog(__VA_ARGS__)
#define DNCLogData(level,domain,data)             ;
#define DNCLogImage(...)                          ;
#define DNCLogTimeBlock(level,domain,title,block) block()
#define DNCAssertIsMainThread                     ;
#else
#define DNCAssert(condition,domain,...)           if (!(condition)) { DNCLogMessageF(__FILE__,__LINE__,__PRETTY_FUNCTION__,domain,DNCLL_Critical,__VA_ARGS__); } NSAssert(condition, __VA_ARGS__);
#define DNCLogMarker(marker)                      NSLog(@"%@", marker); LogMessageF(__FILE__,__LINE__,__PRETTY_FUNCTION__,domain,level,@"%@", marker)
#define DNCLog(level,domain,...)                  DNCLogMessageF(__FILE__,__LINE__,__PRETTY_FUNCTION__,domain,level,__VA_ARGS__); //LogMessageF(__FILE__,__LINE__,__PRETTY_FUNCTION__,domain,level,__VA_ARGS__)
#define DNCLogData(level,domain,data)             LogDataF(__FILE__,__LINE__,__PRETTY_FUNCTION__,domain,level,data)
#define DNCLogImage(level,domain,image)           LogImageDataF(__FILE__,__LINE__,__PRETTY_FUNCTION__,domain,level,image.size.width,image.size.height,UIImagePNGRepresentation(image))
#define DNCLogTimeBlock(level,domain,title,block) DNCLogMessageF(__FILE__,__LINE__,__PRETTY_FUNCTION__,domain,level,@"%@: blockTime: %f",title,DNCTimeBlock(block)); LogMessageF(__FILE__,__LINE__,__PRETTY_FUNCTION__,domain,level,@"%@: blockTime: %f",title,DNCTimeBlock(block))
#define DNCAssertIsMainThread                     if (![NSThread isMainThread])                                                                         \
{                                                                                                                                                       \
NSException* exception = [NSException exceptionWithName:@"DNCUtilities Exception"                                                                   \
reason:[NSString stringWithFormat:@"Not in Main Thread"]                                           \
userInfo:@{ @"FILE" : @(__FILE__), @"LINE" : @(__LINE__), @"FUNCTION" : @(__PRETTY_FUNCTION__) }];   \
@throw exception;                                                                                                                                   \
}

extern void LogImageDataF(const char *filename, int lineNumber, const char *functionName, NSString *domain, int level, int width, int height, NSData *data);

#undef assert
#if __DARWIN_UNIX03
#define assert(e)   (__builtin_expect(!(e), 0) ? (CFShow(CFSTR("assert going to fail, connect NSLogger NOW\n")), LoggerFlush(NULL,YES), __assert_rtn(__func__, __FILE__, __LINE__, #e)) : (void)0)
#else
#define assert(e)   (__builtin_expect(!(e), 0) ? (CFShow(CFSTR("assert going to fail, connect NSLogger NOW\n")), LoggerFlush(NULL,YES), __assert(#e, __FILE__, __LINE__)) : (void)0)
#endif  // __DARWIN_UNIX03
#endif  // !defined(DEBUG)

#endif  // __DNC_LOGLEVEL__

#define DNC_OBJ_OR_NULL(x)  (x ? x : [NSNull null])

@class DNCDate;

@interface DNCUtilities : NSObject

+ (id<DNCApplicationProtocol>)appDelegate;
+ (DNCUtilities*)sharedInstance;

+ (NSString*)osVersion;
+ (NSString*)deviceNameString;
+ (NSString*)deviceVersionName;
+ (NSString*)buildString;
+ (NSString*)versionString;
+ (NSString*)bundleName;

+ (CGSize)screenSizeUnits;
+ (CGFloat)screenHeightUnits;
+ (CGFloat)screenWidthUnits;
+ (CGSize)screenSize;
+ (CGFloat)screenHeight;
+ (CGFloat)screenWidth;
+ (BOOL)isTall;
+ (BOOL)isDeviceIPad;

+ (NSString*)applicationDocumentsDirectory;

+ (NSString*)appendNibSuffix:(NSString*)nibNameOrNil;
+ (NSString*)appendNibSuffix:(NSString*)nibNameOrNil withDefaultNib:(NSString*)defaultNib;
+ (NSString*)deviceImageName:(NSString*)name;

+ (void)registerCellNib:(NSString*)nibName withCollectionView:(UICollectionView*)collectionView;
+ (void)registerCellNib:(NSString*)nibName withBundle:(NSBundle*)bundle withCollectionView:(UICollectionView*)collectionView;
+ (void)registerCellNib:(NSString*)nibName forSupplementaryViewOfKind:(NSString*)kind withCollectionView:(UICollectionView*)collectionView;
+ (void)registerCellNib:(NSString*)nibName withBundle:(NSBundle*)bundle forSupplementaryViewOfKind:(NSString*)kind withCollectionView:(UICollectionView*)collectionView;

+ (UICollectionViewCell*)registerCellNib:(NSString*)nibName
                      withCollectionView:(UICollectionView*)collectionView
                          withSizingCell:(BOOL)sizingCellFlag;
+ (UICollectionViewCell*)registerCellNib:(NSString*)nibName
                              withBundle:(NSBundle*)bundle
                      withCollectionView:(UICollectionView*)collectionView
                          withSizingCell:(BOOL)sizingCellFlag;
+ (UICollectionViewCell*)registerCellNib:(NSString*)nibName
              forSupplementaryViewOfKind:(NSString*)kind
                      withCollectionView:(UICollectionView*)collectionView
                          withSizingCell:(BOOL)sizingCellFlag;
+ (UICollectionViewCell*)registerCellNib:(NSString*)nibName
                              withBundle:(NSBundle*)bundle
              forSupplementaryViewOfKind:(NSString*)kind
                      withCollectionView:(UICollectionView*)collectionView
                          withSizingCell:(BOOL)sizingCellFlag;

+ (void)registerCellNib:(NSString*)nibName withTableView:(UITableView*)tableView;
+ (void)registerCellNib:(NSString*)nibName withBundle:(NSBundle*)bundle withTableView:(UITableView*)tableView;
+ (void)registerCellClass:(NSString*)className withTableView:(UITableView*)tableView;

+ (void)registerCellNib:(NSString*)nibName forHeaderFooterViewReuseIdentifier:(NSString*)kind withTableView:(UITableView*)tableView;
+ (void)registerCellNib:(NSString*)nibName withBundle:(NSBundle*)bundle forHeaderFooterViewReuseIdentifier:(NSString*)kind withTableView:(UITableView*)tableView;
+ (void)registerCellClass:(NSString*)className forHeaderFooterViewReuseIdentifier:(NSString*)kind withTableView:(UITableView*)tableView;

+ (void)runOnBackgroundThreadAfterDelay:(CGFloat)delay
                                  block:(void (^)())block;

+ (void)runOnMainThreadAsynchronouslyWithoutDeadlocking:(void (^)())block;
+ (void)runOnMainThreadWithoutDeadlocking:(void (^)())block;
+ (void)runOnBackgroundThread:(void (^)())block;
+ (void)runBlock:(void (^)())block;

+ (void)runAfterDelay:(CGFloat)delay block:(void (^)())block;
+ (void)runOnMainThreadAfterDelay:(CGFloat)delay block:(void (^)())block;

+ (void)runRepeatedlyAfterDelay:(CGFloat)delay block:(void (^)(BOOL* stop))block;
+ (void)runOnMainThreadRepeatedlyAfterDelay:(CGFloat)delay block:(void (^)(BOOL* stop))block;

+ (NSTimer*)repeatRunAfterDelay:(CGFloat)delay block:(void (^)())block;
+ (NSTimer*)runTimerAfterDelay:(CGFloat)delay block:(void (^)())block;

+ (void)runGroupOnBackgroundThread:(void (^)(dispatch_group_t group))block
                    withCompletion:(void (^)())completionBlock;

+ (void)runGroupWithTimeout:(dispatch_time_t)timeout
         onBackgroundThread:(void (^)(dispatch_group_t group))block
             withCompletion:(void (^)())completionBlock;

+ (void)enterGroup:(dispatch_group_t)group
onBackgroundThread:(void (^)(dispatch_group_t group))block;

+ (void)enterGroup:(dispatch_group_t)group;
+ (void)leaveGroup:(dispatch_group_t)group;

+ (bool)canDevicePlaceAPhoneCall;

+ (void)playSound:(NSString*)name;
+ (NSString*)encodeWithHMAC_SHA1:(NSString*)data withKey:(NSString*)key;

+ (UIImage*)imageScaledForRetina:(UIImage*)image;

+ (id)settingsItem:(NSString*)item;
+ (id)settingsItem:(NSString*)item default:(id)defaultValue;
+ (BOOL)settingsItem:(NSString*)item boolDefault:(BOOL)defaultValue;
+ (void)setSettingsItem:(NSString*)item value:(id)value;
+ (void)setSettingsItem:(NSString*)item boolValue:(BOOL)value;

+ (NSString *)getIPAddress;

+ (void)updateImage:(UIImageView*)imageView
           newImage:(UIImage*)newImage;

#pragma mark - Dictionary Translation functions

+ (NSNumber*)dictionaryBoolean:(NSDictionary*)dictionary withItem:(NSString*)key andDefault:(NSNumber*)defaultValue;
+ (NSNumber*)dictionaryBoolean:(NSDictionary*)dictionary dirty:(BOOL*)dirtyFlag withItem:(NSString*)key andDefault:(NSNumber*)defaultValue;

+ (NSNumber*)dictionaryNumber:(NSDictionary*)dictionary withItem:(NSString*)key andDefault:(NSNumber*)defaultValue;
+ (NSNumber*)dictionaryNumber:(NSDictionary*)dictionary dirty:(BOOL*)dirtyFlag withItem:(NSString*)key andDefault:(NSNumber*)defaultValue;

+ (NSDecimalNumber*)dictionaryDecimalNumber:(NSDictionary*)dictionary withItem:(NSString*)key andDefault:(NSDecimalNumber*)defaultValue;
+ (NSDecimalNumber*)dictionaryDecimalNumber:(NSDictionary*)dictionary dirty:(BOOL*)dirtyFlag withItem:(NSString*)key andDefault:(NSDecimalNumber*)defaultValue;

+ (NSNumber*)dictionaryDouble:(NSDictionary*)dictionary withItem:(NSString*)key andDefault:(NSNumber*)defaultValue;
+ (NSNumber*)dictionaryDouble:(NSDictionary*)dictionary dirty:(BOOL*)dirtyFlag withItem:(NSString*)key andDefault:(NSNumber*)defaultValue;

+ (NSString*)dictionaryString:(NSDictionary*)dictionary withItem:(NSString*)key andDefault:(NSString*)defaultValue;
+ (NSString*)dictionaryString:(NSDictionary*)dictionary dirty:(BOOL*)dirtyFlag withItem:(NSString*)key andDefault:(NSString*)defaultValue;

+ (NSArray*)dictionaryArray:(NSDictionary*)dictionary withItem:(NSString*)key andDefault:(NSArray*)defaultValue;
+ (NSArray*)dictionaryArray:(NSDictionary*)dictionary dirty:(BOOL*)dirtyFlag withItem:(NSString*)key andDefault:(NSArray*)defaultValue;

+ (NSDictionary*)dictionaryDictionary:(NSDictionary*)dictionary withItem:(NSString*)key andDefault:(NSDictionary*)defaultValue;
+ (NSDictionary*)dictionaryDictionary:(NSDictionary*)dictionary dirty:(BOOL*)dirtyFlag withItem:(NSString*)key andDefault:(NSDictionary*)defaultValue;

+ (NSDate*)dictionaryDate:(NSDictionary*)dictionary withItem:(NSString*)key andDefault:(NSDate*)defaultValue;
+ (NSDate*)dictionaryDate:(NSDictionary*)dictionary dirty:(BOOL*)dirtyFlag withItem:(NSString*)key andDefault:(NSDate*)defaultValue;

+ (DNCDate*)dictionaryDNCDate:(NSDictionary*)dictionary withItem:(NSString*)key andDefault:(DNCDate*)defaultValue;
+ (DNCDate*)dictionaryDNCDate:(NSDictionary*)dictionary dirty:(BOOL*)dirtyFlag withItem:(NSString*)key andDefault:(DNCDate*)defaultValue;

+ (id)dictionaryObject:(NSDictionary*)dictionary withItem:(NSString*)key andDefault:(id)defaultValue;
+ (id)dictionaryObject:(NSDictionary*)dictionary dirty:(BOOL*)dirtyFlag withItem:(NSString*)key andDefault:(id)defaultValue;

- (void)logSetLevel:(DNCLogLevel)level;
- (void)logEnableDomain:(NSString*)domain;
- (void)logEnableDomain:(NSString*)domain forLevel:(DNCLogLevel)level;
- (void)logDisableDomain:(NSString*)domain;
- (void)logDisableDomain:(NSString*)domain forLevel:(DNCLogLevel)level;

@end

CGFloat DNCTimeBlock (void (^block)(void));

void DNCLogMessageF(const char *filename, int lineNumber, const char *functionName, NSString *domain, int level, NSString *format, ...);
