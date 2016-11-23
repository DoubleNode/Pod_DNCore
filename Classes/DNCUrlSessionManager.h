//
//  DNCUrlSessionManager.h
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface DNCUrlSessionManager : AFURLSessionManager

+ (_Nonnull instancetype)manager;

+ (_Nonnull instancetype)managerWithSessionConfiguration:(NSURLSessionConfiguration* _Nonnull)configuration;

- (_Nonnull instancetype)init;

- (_Nonnull instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration* _Nullable)configuration;

- (NSURLSessionDataTask* _Nonnull)sendTaskWithRequest:(NSURLRequest* _Nonnull)request
                                   serverErrorHandler:(void(^ _Nullable)(NSHTTPURLResponse* _Nullable httpResponse))serverErrorHandler
                                     dataErrorHandler:(void(^ _Nullable)(NSData* _Nullable errorData, NSString* _Nullable errorMessage))dataErrorHandler
                                  unknownErrorHandler:(void(^ _Nullable)(NSError* _Nullable dataError))unknownErrorHandler
                                noResponseBodyHandler:(void(^ _Nullable)())noResponseBodyHandler
                                    completionHandler:(void(^ _Nullable)(NSURLResponse* _Nonnull response, id _Nullable responseObject))completionHandler;

- (NSURLSessionDataTask* _Nonnull)dataTaskWithRequest:(NSURLRequest* _Nonnull)request
                                             withData:(NSData* _Nonnull)data
                                   serverErrorHandler:(void(^ _Nullable)(NSHTTPURLResponse* _Nullable httpResponse))serverErrorHandler
                                     dataErrorHandler:(void(^ _Nullable)(NSData* _Nullable errorData, NSString* _Nullable errorMessage))dataErrorHandler
                                  unknownErrorHandler:(void(^ _Nullable)(NSError* _Nullable dataError))unknownErrorHandler
                                noResponseBodyHandler:(void(^ _Nullable)())noResponseBodyHandler
                                    completionHandler:(void(^ _Nullable)(NSURLResponse* _Nonnull response, id _Nullable responseObject))completionHandler;

@end
