//
//  DNCAppConstants.m
//  DoubleNode.com
//
//  Derived from work originally created by Darren Ehlers
//  Portions Copyright (c) 2012 DoubleNode.com and Darren Ehlers.
//  All rights reserved.
//

@import ColorUtils;

#import "DNCUtilities.h"

#import "DNCAppConstants.h"

@implementation DNCAppConstants

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

+ (NSDictionary*)dictionaryLookupUI:(NSString*)key
                          withValue:(NSDictionary*)value
{
    DNCAssertIsNotMainThread;
    
    __block id  selectedOption;
    
    DNCSemaphoreGate*   semaphore = DNCSemaphoreGate.semaphore;
    
    [DNCUIThread run:
     ^()
     {
         NSString*   title   = value[@"title"]   ?: [NSString stringWithFormat:@"%@_TITLE_NOT_SPECIFIED", key];
         NSString*   message = value[@"message"] ?: [NSString stringWithFormat:@"%@_MESSAGE_NOT_SPECIFIED", key];
         NSArray*    options = value[@"options"];
         
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

+ (NSDictionary*)dictionarySelection:(NSString*)key
                           withValue:(NSDictionary*)value
{
    NSDictionary*   selectedOption = value;
    
    if (value[@"options"])
    {
        selectedOption = [self dictionaryLookupUI:key
                                        withValue:value];
    }
    
    return selectedOption[@"key"] ?: (selectedOption[@"label"] ?: [NSString stringWithFormat:@"%@_OPTION_KEY_NOT_SPECIFIED", key]);
}

+ (id)dictionaryLookupConstant:(NSString*)key
                     forSubkey:(NSString*)subkey
{
    NSDictionary*   selectedOption = [self plistConfig:key];
    
    if (selectedOption[@"options"])
    {
        selectedOption = [self dictionaryLookupUI:key
                                        withValue:selectedOption];
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
            NSString*   constantsPlist  = @"Constants";
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
            
            NSString*   constantsPlist2 = [NSString stringWithFormat:@"Constants%@%@", ((serverCode.length > 0) ? @"_" : @""), serverCode];
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
