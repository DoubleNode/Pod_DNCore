//
//  DNCApplicationProtocol.h
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

@import Foundation;
@import UIKit;

/**
 *  Provides functions expected to be in the applications AppDelegate class.
 */
@protocol DNCApplicationProtocol<NSObject>

#pragma mark - Base DNCApplicationProtocol functions

@optional

/**
 *  Hook to setup initial debug logging state
 *
 *  @discussion The primary use-case for this function is for debugging, diagnostics and unit testing.
 *
 */
- (void)resetLogState;

@required

- (NSString*)buildString;
- (NSString*)versionString;
- (NSString*)bundleName;

/**
 *  Returns the rootViewController.
 *
 *  @return The main window's rootViewController.
 *
 */
- (UIViewController*)rootViewController;

/**
 *  Displays/hides the status bar networkActivityIndicator in a thread-safe, nested manner.
 *
 */
- (void)setNetworkActivityIndicatorVisible:(BOOL)setVisible;

/**
 *  Returns the current state of reachability.
 *
 */
- (BOOL)isReachable;

#pragma mark - CoreData DNCApplicationProtocol functions

/**
 *  Disables the App URL Cache (if applicable).
 *
 *  @discussion The primary use-case for this function is for debugging, diagnostics and unit testing.
 *
 */
- (void)disableURLCache;

@end

