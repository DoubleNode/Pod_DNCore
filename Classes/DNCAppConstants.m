//
//  DNCAppConstants.m
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC.
//
//  DNCore is released under the MIT license. See LICENSE for details.
//

@import ColorUtils;

#import "DNCAppConstants.h"

#import "DNCUtilities.h"
#import "DNCRootViewController.h"

@implementation DNCAppConstants

+ (DNCAppConstantsBuildType)appBuildType
{
    return DNCAppConstantsBuildTypeUnknown;
}

// App Request Review Constants
+ (BOOL)requestReviews                          {   return [self intConstant:@"requestReviews"];                    }
+ (NSUInteger)requestReviewFirstMinimumLaunches {   return [self intConstant:@"requestReviewFirstMinimumLaunches"]; }
+ (NSUInteger)requestReviewFirstMaximumLaunches {   return [self intConstant:@"requestReviewFirstMaximumLaunches"]; }
+ (NSUInteger)requestReviewFrequency            {   return [self intConstant:@"requestReviewFrequency"];            }
+ (NSUInteger)requestReviewDaysSinceFirstLaunch {   return [self intConstant:@"requestReviewDaysSinceFirstLaunch"]; }
+ (NSUInteger)requestReviewHoursSinceLastLaunch {   return [self intConstant:@"requestReviewHoursSinceLastLaunch"]; }
+ (NSUInteger)requestReviewDaysSinceLastReview  {   return [self intConstant:@"requestReviewDaysSinceLastReview"];  }

+ (NSURL*)urlConstant:(NSString*)key
{
    return [self urlConstant:key filter:nil];
}

+ (NSURL*)urlConstant:(NSString*)key
               filter:(NSString*)filter
{
    NSString*   str = [self constantValue:key filter:filter] ?: @"";
    
    return [NSURL URLWithString:str];
}

+ (NSDate*)dateConstant:(NSString*)key
{
    return [self dateConstant:key filter:nil];
}

+ (NSDate*)dateConstant:(NSString*)key
                 filter:(NSString*)filter
{
    NSString*   str = [self constantValue:key filter:filter];
    
    NSDateFormatter*    formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM/dd/yyyy HH:mm z"];
    
    return [formatter dateFromString:str];
}

+ (UIColor*)colorConstant:(NSString*)key
{
    return [self colorConstant:key filter:nil];
}

+ (UIColor*)colorConstant:(NSString*)key
                   filter:(NSString*)filter
{
    return [UIColor colorWithString:[self constantValue:key filter:filter]];
}

+ (BOOL)boolConstant:(NSString*)key
{
    return [self boolConstant:key filter:nil];
}

+ (BOOL)boolConstant:(NSString*)key
              filter:(NSString*)filter
{
    return [[self constantValue:key filter:filter] boolValue];
}

+ (double)doubleConstant:(NSString*)key
{
    return [self doubleConstant:key filter:nil];
}

+ (double)doubleConstant:(NSString*)key
                  filter:(NSString*)filter
{
    return [[self constantValue:key filter:filter] doubleValue];
}

+ (int)intConstant:(NSString*)key
{
    return [self intConstant:key filter:nil];
}

+ (int)intConstant:(NSString*)key
            filter:(NSString*)filter
{
    return [[self constantValue:key filter:filter] intValue];
}

+ (UIFont*)fontConstant:(NSString*)key
{
    return [self fontConstant:key filter:nil];
}

+ (UIFont*)fontConstant:(NSString*)key
                 filter:(NSString*)filter
{
    NSString*   fontName    = [self constantValue:[NSString stringWithFormat:@"%@Name", key] filter:filter];
    NSString*   fontSize    = [self constantValue:[NSString stringWithFormat:@"%@Size", key] filter:filter];
    
    UIFont* retFont  = [UIFont fontWithName:fontName size:([fontSize doubleValue] / 2)];
    
    return [retFont fontWithSize:([fontSize doubleValue] / 2)];
}

+ (CGSize)sizeConstant:(NSString*)key
{
    return [self sizeConstant:key filter:nil];
}

+ (CGSize)sizeConstant:(NSString*)key
                filter:(NSString*)filter
{
    NSString*   sizeWidth   = [self constantValue:[NSString stringWithFormat:@"%@Width", key] filter:filter];
    NSString*   sizeHeight  = [self constantValue:[NSString stringWithFormat:@"%@Height", key] filter:filter];
    
    return CGSizeMake([sizeWidth floatValue], [sizeHeight floatValue]);
}

+ (NSArray*)arrayConstant:(NSString*)key
{
    id  value = [self plistConfig:key];
    
    if (![value isKindOfClass:NSArray.class])
    {
        return @[
                 value
                 ];
    }
    
    NSArray*   arrayValue = value;
    
    return arrayValue;
}

+ (NSDictionary*)dictionaryConstant:(NSString*)key
{
    id  value = [self plistConfig:key];
    
    if (![value isKindOfClass:NSDictionary.class])
    {
        return @{
                 @""    : value,
                 };
    }
    
    NSDictionary*   dictionaryValue = value;
    
    return dictionaryValue;
}

+ (id)constantValue:(NSString*)key
{
    return [self constantValue:key filter:nil];
}

+ (NSDictionary*)dictionaryOptionsLookupUI:(NSString*)key
                                 withValue:(NSDictionary*)value
{
    NSString*   noUIString  = [NSUserDefaults.standardUserDefaults stringForKey:@"AppConstantsNoUI"];
    BOOL        noUI        = noUIString.boolValue;
    
    if ([NSThread isMainThread])
    {
        noUI    = YES;
    }
    
    NSString*   noUIValue   = value[@"noUI"] ?: @"NO";
    if (noUIValue.boolValue)
    {
        noUI    = YES;
    }
    
    if (noUI)
    {
        return [self dictionaryOptionsWithoutUI:key
                                      withValue:value];
    }
    
    __block id  selectedOption;
    
    DNCSemaphoreGate*   semaphore = DNCSemaphoreGate.semaphore;
    
    [DNCUIThread run:
     ^()
     {
         NSString*   title      = value[@"title"]   ?: [NSString stringWithFormat:@"%@_TITLE_NOT_SPECIFIED", key];
         NSString*   message    = value[@"message"] ?: [NSString stringWithFormat:@"%@_MESSAGE_NOT_SPECIFIED", key];
         NSArray*    options    = value[@"options"];
         
         UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title
                                                                                  message:message
                                                                           preferredStyle:UIAlertControllerStyleAlert];
         
         for (NSDictionary* option in options)
         {
             NSString*   label   = option[@"label"] ?: [NSString stringWithFormat:@"%@_OPTION_LABEL_NOT_SPECIFIED", key];
             
             UIAlertAction* action = [UIAlertAction actionWithTitle:label
                                                              style:UIAlertActionStyleDefault
                                                            handler:
                                      ^(UIAlertAction* _Nonnull action)
                                      {
                                          selectedOption = option;
                                          
                                          [semaphore done];
                                      }];
             [alertController addAction:action];
         }
         
         [DNCUtilities.appDelegate.rootViewController presentViewController:alertController
                                                                   animated:YES
                                                                 completion:nil];
     }];
    
    [semaphore wait];
    
    [self plistConfigReplace:key
                   withValue:selectedOption];
    
    return selectedOption;
}

+ (NSDictionary*)dictionaryOptionsWithoutUI:(NSString*)key
                                  withValue:(NSDictionary*)value
{
    NSString*   defaultKey  = value[@"default"] ?: @"";
    NSArray*    options     = value[@"options"];
    
    __block id  selectedOption;
    
    for (NSDictionary* option in options)
    {
        NSString*   optionKey = option[@"key"] ?: [NSString stringWithFormat:@"%@_OPTION_LABEL_NOT_SPECIFIED", key];
        
        if ([optionKey isEqualToString:defaultKey])
        {
            selectedOption = option;
        }
    }
    
    [self plistConfigReplace:key
                   withValue:selectedOption];
    
    return selectedOption;
}

+ (NSDictionary*)dictionaryTogglesLookupUI:(NSString*)key
                                 withValue:(NSDictionary*)value
{
    NSString*   noUIString  = [NSUserDefaults.standardUserDefaults stringForKey:@"AppConstantsNoUI"];
    BOOL        noUI        = noUIString.boolValue;
    
    if ([NSThread isMainThread])
    {
        noUI    = YES;
    }
    
    NSString*   noUIValue   = value[@"noUI"] ?: @"NO";
    if (noUIValue.boolValue)
    {
        noUI    = YES;
    }
    
    if (noUI)
    {
        return [self dictionaryTogglesWithoutUI:key
                                      withValue:value];
    }
    
    __block NSMutableDictionary*    selectedToggles = NSMutableDictionary.dictionary;
    
    DNCSemaphoreGate*   semaphore = DNCSemaphoreGate.semaphore;
    
    [DNCUIThread run:
     ^()
     {
         id rootViewController  = DNCUtilities.appDelegate.rootViewController;
         DNCAssert([rootViewController isKindOfClass:DNCRootViewController.class], DNCLD_API, @"RootViewController is not a DNCRootViewController class");
         
         DNCRootViewController* targetController    = (DNCRootViewController*)rootViewController;
         
         NSString*   title      = value[@"title"]   ?: [NSString stringWithFormat:@"%@_TITLE_NOT_SPECIFIED", key];
         NSString*   message    = value[@"message"] ?: [NSString stringWithFormat:@"%@_MESSAGE_NOT_SPECIFIED", key];
         NSArray*    toggles    = value[@"toggles"];
         
         UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title
                                                                                  message:message
                                                                           preferredStyle:UIAlertControllerStyleAlert];
         
         for (NSDictionary* toggle in toggles)
         {
             NSString*   toggleKey      = toggle[@"key"]   ?: [NSString stringWithFormat:@"%@_TOGGLE_KEY_NOT_SPECIFIED", key];
             NSString*   toggleLabel    = toggle[@"label"] ?: [NSString stringWithFormat:@"%@_TOGGLE_LABEL_NOT_SPECIFIED", key];
             
             BOOL  toggleState = [toggle[@"default"] boolValue];
             
             NSMutableDictionary*  stateToggle = toggle.mutableCopy;
             stateToggle[@"state"]      = (toggleState ? @"1" : @"0");
             selectedToggles[toggleKey] = stateToggle;
             
             [alertController addTextFieldWithConfigurationHandler:
              ^(UITextField* _Nonnull textField)
              {
                  // Create button
                  UIButton*  checkbox = [UIButton buttonWithType:UIButtonTypeCustom];
                  [checkbox setFrame:CGRectMake(2 , 2, 18, 18)];  // Not sure about size
                  [checkbox setTag:1];
                  [checkbox addTarget:targetController
                               action:@selector(checkBoxPressedWithSender:)
                     forControlEvents:UIControlEventTouchUpInside];
                  
                  checkbox.selected = toggleState;
                  
                  // Setup image for button
                  [checkbox.imageView setContentMode:UIViewContentModeScaleAspectFit];
                  [checkbox setImage:[UIImage imageNamed:@"iconCheckmarkOff"]
                            forState:UIControlStateNormal];
                  [checkbox setImage:[UIImage imageNamed:@"iconCheckmarkOn"]
                            forState:UIControlStateSelected];
                  [checkbox setImage:[UIImage imageNamed:@"iconCheckmarkOn"]
                            forState:UIControlStateHighlighted];
                  [checkbox setAdjustsImageWhenHighlighted:TRUE];
                  
                  stateToggle[@"button"]    = checkbox;
                  
                  // Setup the right view in the text field
                  [textField setClearButtonMode:UITextFieldViewModeAlways];
                  [textField setRightViewMode:UITextFieldViewModeAlways];
                  [textField setRightView:checkbox];
                  
                  // Setup Tag so the textfield can be identified
                  [textField setTag:-1];
                  [textField setDelegate:(id<UITextFieldDelegate>)targetController];
                  
                  // Setup textfield
                  [textField setText:toggleLabel];
              }];
         }
         
         UIAlertAction* action = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK")
                                                          style:UIAlertActionStyleDefault
                                                        handler:
                                  ^(UIAlertAction* _Nonnull action)
                                  {
                                      [semaphore done];
                                  }];
         [alertController addAction:action];
         
         [targetController presentViewController:alertController
                                        animated:YES
                                      completion:nil];
     }];
    
    [semaphore wait];
    
    [DNCUIThread run:
     ^()
     {
         [selectedToggles enumerateKeysAndObjectsUsingBlock:
          ^(NSString* _Nonnull key, NSMutableDictionary* _Nonnull obj, BOOL* _Nonnull stop)
          {
              UIButton*   checkbox    = obj[@"button"];
              BOOL        toggleState = checkbox.selected;
              
              obj[@"state"] = (toggleState ? @"1" : @"0");
          }];
     }];
    
    [self plistConfigReplace:key
                   withValue:selectedToggles];
    
    return selectedToggles;
}

+ (NSDictionary*)dictionaryTogglesWithoutUI:(NSString*)key
                                  withValue:(NSDictionary*)value
{
    __block NSMutableDictionary*    selectedToggles = NSMutableDictionary.dictionary;
    
    NSArray*    toggles    = value[@"toggles"];
    
    for (NSDictionary* toggle in toggles)
    {
        NSString*   toggleKey   = toggle[@"key"]   ?: [NSString stringWithFormat:@"%@_TOGGLE_KEY_NOT_SPECIFIED", key];
        
        BOOL  toggleState = [toggle[@"default"] boolValue];
        
        NSMutableDictionary*  stateToggle = toggle.mutableCopy;
        stateToggle[@"state"]      = (toggleState ? @"1" : @"0");
        selectedToggles[toggleKey] = stateToggle;
    }
    
    [self plistConfigReplace:key
                   withValue:selectedToggles];
    
    return selectedToggles;
}

+ (NSDictionary*)dictionarySelection:(NSString*)key
                           withValue:(NSDictionary*)value
{
    NSDictionary*   selectedOption = value;
    
    if (value[@"options"])
    {
        selectedOption = [self dictionaryOptionsLookupUI:key
                                               withValue:value];
        
        return selectedOption[@"key"] ?: (selectedOption[@"label"] ?: [NSString stringWithFormat:@"%@_OPTION_KEY_NOT_SPECIFIED", key]);
    }
    else if (value[@"toggles"])
    {
        selectedOption = [self dictionaryTogglesLookupUI:key
                                               withValue:value];
        
        return selectedOption[@"key"] ?: (selectedOption[@"label"] ?: [NSString stringWithFormat:@"%@_TOGGLE_KEY_NOT_SPECIFIED", key]);
    }
    
    return (value[@"key"] ?: value);
}

+ (id)dictionaryLookupConstant:(NSString*)key
                     forSubkey:(NSString*)subkey
{
    NSDictionary*   selectedOption = [self plistConfig:key];
    
    if (selectedOption[@"options"])
    {
        selectedOption = [self dictionaryOptionsLookupUI:key
                                               withValue:selectedOption];
        return selectedOption[subkey] ?: nil;
    }
    else if (selectedOption[@"toggles"])
    {
        selectedOption = [self dictionaryTogglesLookupUI:key
                                               withValue:selectedOption];
        return selectedOption[subkey][@"state"];
    }
    else
    {
        NSDictionary*   subKeyDictionary = selectedOption[subkey];
        if (subKeyDictionary &&
            [subKeyDictionary isKindOfClass:NSDictionary.class])
        {
            return subKeyDictionary[@"state"] ?: nil;
        }
    }
    
    return selectedOption[subkey] ?: nil;
}

+ (id)constantValue:(NSString*)key
             filter:(NSString*)filter
{
    id  value   = [self plistConfig:key];
    
    if ([value isKindOfClass:NSDictionary.class])
    {
        if (filter)
        {
            NSDictionary*   values  = (NSDictionary*)value;
            
            value   = values[filter];
            if (!value)
            {
                value   = values[@"default"];
            }
        }
        else
        {
            value = [self dictionarySelection:key
                                    withValue:value];
        }
    }
    else if (value)
    {
        value   = [NSString stringWithFormat:@"%@", value];
    }
    
    if ([value isKindOfClass:NSString.class])
    {
        NSString*   stringValue = value;
        
        while ([stringValue containsString:@"{{"])
        {
            NSArray*    stringValues = [stringValue componentsSeparatedByString:@"{{"];
            if (stringValues.count <= 1)
            {
                // Should never occur!!
                break;
            }
            
            NSString*   tokenFragment   = stringValues[1];
            NSString*   token           = [tokenFragment componentsSeparatedByString:@"}}"].firstObject;
            NSString*   tokenString     = [NSString stringWithFormat:@"{{%@}}", token];
            
            NSString*   tokenValue;
            
            if ([token containsString:@":"])
            {
                NSArray*    selectionValues = [token componentsSeparatedByString:@":"];
                NSString*   selectionToken  = selectionValues[0];
                NSString*   selectionKey    = selectionValues[1];
                
                tokenValue = [self dictionaryLookupConstant:selectionToken
                                                  forSubkey:selectionKey];
            }
            
            if (!tokenValue)
            {
                tokenValue  = [self constantValue:token
                                           filter:filter];
            }
            if (!tokenValue)
            {
                tokenValue  = tokenString;
            }
            
            stringValue = [stringValue stringByReplacingOccurrencesOfString:tokenString
                                                                 withString:tokenValue];
        }
        
        value = stringValue;
    }
    
    return value;
}

static NSMutableDictionary* plistConfigDict = nil;
static NSString*            plistServerCode = nil;

+ (NSMutableDictionary*)plistDict
{
    NSString*   serverCode  = [DNCUtilities settingsItem:@"ServerCode"];
    //DLog(LL_Debug, LD_General, @"ServerCode=%@", serverCode);
    if (![serverCode isEqualToString:plistServerCode])
    {
        plistConfigDict = nil;
        plistServerCode = serverCode;
    }
    
    @synchronized( self )
    {
        if (plistConfigDict == nil)
        {
            NSString*   constantsPlist  = [NSUserDefaults.standardUserDefaults stringForKey:@"AppConstantsFilenameOverride"];
            if (!constantsPlist)
            {
                constantsPlist = @"Constants";
            }
            
            NSString*   constantsPath   = [[NSBundle mainBundle] pathForResource:constantsPlist ofType:@"plist"];
            if (!constantsPath)
            {
                NSException*    exception = [NSException exceptionWithName:@"DNAppConstants Exception"
                                                                    reason:[NSString stringWithFormat:@"Constants plist not found: %@", constantsPlist]
                                                                  userInfo:nil];
                @throw exception;
            }
            
            plistConfigDict = [NSMutableDictionary.alloc initWithContentsOfFile:constantsPath];
            if (!plistConfigDict)
            {
                NSException*    exception = [NSException exceptionWithName:@"DNAppConstants Exception"
                                                                    reason:[NSString stringWithFormat:@"Unable to initialize Constants Config Dictionary: %@", constantsPath]
                                                                  userInfo:nil];
                @throw exception;
            }
            
            NSString*   constantsPlist2 = [NSString stringWithFormat:@"%@%@%@", constantsPlist, ((serverCode.length > 0) ? @"_" : @""), serverCode];
            NSString*   constantsPath2  = [[NSBundle mainBundle] pathForResource:constantsPlist2 ofType:@"plist"];
            if (constantsPath2)
            {
                NSMutableDictionary*    newDict = [NSMutableDictionary dictionaryWithDictionary:plistConfigDict];
                
                NSDictionary*   overrideItems   = [[NSDictionary alloc] initWithContentsOfFile:constantsPath2];
                [overrideItems enumerateKeysAndObjectsUsingBlock:
                 ^(NSString* key, id obj, BOOL* stop)
                 {
                     id originalObj = newDict[key];
                     
                     if ([obj isKindOfClass:NSDictionary.class])
                     {
                         NSMutableDictionary*   objMD  = [obj mutableCopy];
                         if ([originalObj isKindOfClass:NSDictionary.class])
                         {
                             [objMD addEntriesFromDictionary:originalObj];
                         }
                         else
                         {
                             objMD[@"default"]  = originalObj;
                         }
                         
                         newDict[key]   = objMD;
                     }
                     else
                     {
                         newDict[key]   = obj;
                     }
                 }];
                
                plistConfigDict = newDict;
            }
        }
    }
    
    return plistConfigDict;
}

+ (id)plistConfig:(NSString*)key
{
    NSMutableDictionary*    dict = [self plistDict];
    
    id  value = dict[key];
    if ((value == nil) || (value == [NSNull null]))
    {
        DNCLog(DNCLL_Warning, DNCLD_Framework, @"***** MISSING CONSTANT KEY: %@", key);
    }
    
    return value;
}

+ (void)plistConfigReplace:(NSString*)key
                 withValue:(id)value
{
    NSAssert(value, @"value is nil.");
    
    NSMutableDictionary*    dict = [self plistDict];
    
    dict[key]   = value;
}

@end
