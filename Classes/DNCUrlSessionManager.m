//
//  DNCUrlSessionManager.m
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

#import "DNCUrlSessionManager.h"

#import "DNCUtilities.h"

@implementation DNCUrlSessionManager

+ (_Nonnull instancetype)manager
{
    return [[DNCUrlSessionManager alloc] init];
}

+ (_Nonnull instancetype)managerWithSessionConfiguration:(NSURLSessionConfiguration* _Nonnull)configuration
{
    return [[DNCUrlSessionManager alloc] initWithSessionConfiguration:configuration];
}

- (_Nonnull instancetype)init
{
    return [super initWithSessionConfiguration:nil];
}

- (_Nonnull instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration* _Nullable)configuration
{
    if (!configuration)
    {
        configuration   = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    
    return [super initWithSessionConfiguration:configuration];
}

- (NSURLSessionDataTask*)sendTaskWithRequest:(NSURLRequest*)request
                          serverErrorHandler:(void(^ _Nullable)(NSHTTPURLResponse* _Nullable httpResponse))serverErrorHandler
                            dataErrorHandler:(void(^ _Nullable)(NSData* _Nullable errorData, NSString* _Nullable errorMessage))dataErrorHandler
                         unknownErrorHandler:(void(^ _Nullable)(NSError* _Nullable dataError))unknownErrorHandler
                       noResponseBodyHandler:(void(^ _Nullable)(void))noResponseBodyHandler
                           completionHandler:(void(^ _Nullable)(NSURLResponse* _Nonnull response, id _Nullable responseObject))completionHandler
{
    return [super dataTaskWithRequest:request
                    completionHandler:
            ^(NSURLResponse* _Nonnull response, id _Nullable responseObject, NSError* _Nullable dataError)
            {
                if (dataError)
                {
                    DNCLog(DNCLL_Info, DNCLD_Networking, @"DATAERROR - %@", response.URL);
                    
                    if (dataError.code == NSURLErrorTimedOut)
                    {
                        NSHTTPURLResponse*  httpResponse;
                        if ([response isKindOfClass:[NSHTTPURLResponse class]])
                        {
                            httpResponse    = (NSHTTPURLResponse*)response;
                        }
                        
                        DNCLog(DNCLL_Info, DNCLD_Networking, @"WILLRETRY - %@", response.URL);
                        [DNCThread afterDelay:1.0f
                                          run:
                         ^()
                         {
                             serverErrorHandler ? serverErrorHandler(httpResponse) : nil;
                         }];
                        return;
                    }
                    
                    NSData*    errorData   = dataError.userInfo[@"com.alamofire.serialization.response.error.data"];
                    if (errorData.length)
                    {
                        NSString*  errorString = [[NSString alloc] initWithData:errorData
                                                                       encoding:NSASCIIStringEncoding];
                        DNCLog(DNCLL_Debug, DNCLD_General, @"data=%@", errorString);
                    }
                    
                    if ([response isKindOfClass:[NSHTTPURLResponse class]])
                    {
                        NSHTTPURLResponse*    httpResponse    = (NSHTTPURLResponse*)response;
                        if (httpResponse.statusCode == 500)
                        {
                            DNCLog(DNCLL_Info, DNCLD_Networking, @"WILLRETRY - %@", response.URL);
                            [DNCThread afterDelay:1.0f
                                              run:
                             ^()
                             {
                                 serverErrorHandler ? serverErrorHandler(httpResponse) : nil;
                             }];
                            return;
                        }
                    }
                    
                    if (errorData)
                    {
                        id jsonData = [NSJSONSerialization JSONObjectWithData:errorData
                                                                      options:0
                                                                        error:nil];
                        if (jsonData)
                        {
                            NSString*  errorMessage    = jsonData[@"error"];
                            if (!errorMessage)
                            {
                                errorMessage    = jsonData[@"data"][@"error"];
                            }
                            if (!errorMessage)
                            {
                                errorMessage    = jsonData[@"data"][@"message"];
                            }
                            if (!errorMessage)
                            {
                                errorMessage    = jsonData[@"message"];
                            }
                            
                            dataErrorHandler ? dataErrorHandler(errorData, errorMessage) : nil;
                            return;
                        }
                    }
                    
                    unknownErrorHandler ? unknownErrorHandler(dataError) : nil;
                    return;
                }
                
                if (!responseObject)
                {
                    noResponseBodyHandler ? noResponseBodyHandler() : nil;
                    return;
                }
                
                completionHandler ? completionHandler(response, responseObject) : nil;
            }];
}

- (NSURLSessionDataTask*)dataTaskWithRequest:(NSURLRequest*)request
                                    withData:(NSData* _Nonnull)data
                          serverErrorHandler:(void(^ _Nullable)(NSHTTPURLResponse* _Nullable httpResponse))serverErrorHandler
                            dataErrorHandler:(void(^ _Nullable)(NSData* _Nullable errorData, NSString* _Nullable errorMessage))dataErrorHandler
                         unknownErrorHandler:(void(^ _Nullable)(NSError* _Nullable dataError))unknownErrorHandler
                       noResponseBodyHandler:(void(^ _Nullable)(void))noResponseBodyHandler
                           completionHandler:(void(^ _Nullable)(NSURLResponse* _Nonnull response, id _Nullable responseObject))completionHandler
{
    return [super uploadTaskWithRequest:request
                               fromData:data
                               progress:
            ^(NSProgress* _Nonnull uploadProgress)
            {
            }
                      completionHandler:
            ^(NSURLResponse* _Nonnull response, id _Nullable responseObject, NSError* _Nullable dataError)
            {
                if (dataError)
                {
                    DNCLog(DNCLL_Info, DNCLD_Networking, @"DATAERROR - %@", response.URL);
                    
                    if (dataError.code == NSURLErrorTimedOut)
                    {
                        NSHTTPURLResponse*  httpResponse;
                        if ([response isKindOfClass:[NSHTTPURLResponse class]])
                        {
                            httpResponse    = (NSHTTPURLResponse*)response;
                        }
                        
                        DNCLog(DNCLL_Info, DNCLD_Networking, @"WILLRETRY - %@", response.URL);
                        [DNCThread afterDelay:1.0f
                                          run:
                         ^()
                         {
                             serverErrorHandler ? serverErrorHandler(httpResponse) : nil;
                         }];
                        return;
                    }
                    
                    if ([response isKindOfClass:[NSHTTPURLResponse class]])
                    {
                        NSHTTPURLResponse*    httpResponse    = (NSHTTPURLResponse*)response;
                        if (httpResponse.statusCode == 500)
                        {
                            DNCLog(DNCLL_Info, DNCLD_Networking, @"WILLRETRY - %@", response.URL);
                            [DNCThread afterDelay:1.0f
                                              run:
                             ^()
                             {
                                 serverErrorHandler ? serverErrorHandler(httpResponse) : nil;
                             }];
                            return;
                        }
                    }
                    
                    NSData*    errorData   = dataError.userInfo[@"com.alamofire.serialization.response.error.data"];
                    NSString*  errorString = [[NSString alloc] initWithData:errorData
                                                                   encoding:NSASCIIStringEncoding];
                    DNCLog(DNCLL_Debug, DNCLD_General, @"data=%@", errorString);
                    
                    if (errorData)
                    {
                        id jsonData = [NSJSONSerialization JSONObjectWithData:errorData
                                                                      options:0
                                                                        error:nil];
                        if (jsonData)
                        {
                            NSString*  errorMessage    = jsonData[@"error"];
                            
                            dataErrorHandler ? dataErrorHandler(errorData, errorMessage) : nil;
                        }
                    }
                    
                    unknownErrorHandler ? unknownErrorHandler(dataError) : nil;
                    return;
                }
                
                if (!responseObject)
                {
                    noResponseBodyHandler ? noResponseBodyHandler() : nil;
                    return;
                }
                
                completionHandler ? completionHandler(response, responseObject) : nil;
            }];
}

@end
