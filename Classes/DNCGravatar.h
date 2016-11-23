//
//  DNCGravatar.h
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//
//  Derived from work originally created by Rudd Fawcett
//  Portions Copyright (c) 2013 Rudd Fawcett.
//  All rights reserved.
//  https://www.cocoacontrols.com/controls/uiimageview-gravatar
//

#import <UIKit/UIKit.h>

// Rating of Gravatar
typedef NS_ENUM(NSUInteger, DNCGravatarRating)
{
    DNCGravatarRatingG = 1,
    DNCGravatarRatingPG,
    DNCGravatarRatingR,
    DNCGravatarRatingX,
    
    DNCGravatarRating_Count
};

// Default Gravatar types: http://bit.ly/1cCmtdb
typedef NS_ENUM(NSUInteger, DNCGravatarDefault)
{
    DNCGravatarDefault404 = 1,
    DNCGravatarDefaultMysteryMan,
    DNCGravatarDefaultIdenticon,
    DNCGravatarDefaultMonsterID,
    DNCGravatarDefaultWavatar,
    DNCGravatarDefaultRetro,
    DNCGravatarDefaultBlank,
    
    DNCGravatarDefault_Count
};

@interface DNCGravatar : NSObject

// User email - you must set this!
@property (readwrite, strong, nonatomic)    NSString*           email;

// The size of the gravatar up to 2048. All gravatars are squares, so you will get 2048x2048.
@property (readwrite, nonatomic)            NSUInteger          size;

// Rating (G, PG, R, X) of gravatar to allow, helpful for kid-friendly apps.
@property (readwrite, nonatomic)            DNCGravatarRating   rating;

// If email doesn't have a gravatar, use one of these... http://bit.ly/1cCmtdb
@property (readwrite, nonatomic)            DNCGravatarDefault  defaultGravatar;

// Force a default gravatar, whether or not email has gravatar. Remember to set defaultGravatar too!
@property (readwrite, nonatomic)            BOOL                forceDefault;

- (NSString*)gravtarURL:(NSString*)email;

@end
