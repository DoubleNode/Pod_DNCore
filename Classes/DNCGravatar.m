//
//  DNCGravatar.h
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC.
//
//  DNCore is released under the MIT license. See LICENSE for details.
//
//  Derived from work originally created by Rudd Fawcett
//  Portions Copyright (c) 2013 Rudd Fawcett.
//  All rights reserved.
//  https://www.cocoacontrols.com/controls/uiimageview-gravatar
//

@import CommonCrypto;

#import "DNCGravatar.h"

@implementation DNCGravatar

- (NSString*)gravtarURL:(NSString*)email
{
    NSMutableString*    gravatarPath = [NSMutableString stringWithFormat:@"https://gravatar.com/avatar/%@?", [self createMD5:email]];

    return [self buildLink:gravatarPath];
}

- (NSMutableString*)buildLink:(NSMutableString*)baseLink
{
    if (_size)
    {
        [baseLink appendString:[NSString stringWithFormat:@"&size=%lu", (unsigned long)_size]];
    }

    if (_rating)
    {
        switch (_rating)
        {
            case DNCGravatarRatingG:    {   [baseLink appendString:@"&rating=g"];   break;  }
            case DNCGravatarRatingPG:   {   [baseLink appendString:@"&rating=pg"];  break;  }
            case DNCGravatarRatingR:    {   [baseLink appendString:@"&rating=r"];   break;  }
            case DNCGravatarRatingX:    {   [baseLink appendString:@"&rating=x"];   break;  }

            default:    {   break;  }
        }
    }

    if (_defaultGravatar)
    {
        switch (_defaultGravatar)
        {
            case DNCGravatarDefault404:         {   [baseLink appendString:@"&default=404"];        break;  }
            case DNCGravatarDefaultMysteryMan:  {   [baseLink appendString:@"&default=mm"];         break;  }
            case DNCGravatarDefaultIdenticon:   {   [baseLink appendString:@"&default=identicon"];  break;  }
            case DNCGravatarDefaultMonsterID:   {   [baseLink appendString:@"&default=monsterid"];  break;  }
            case DNCGravatarDefaultWavatar:     {   [baseLink appendString:@"&default=wavatar"];    break;  }
            case DNCGravatarDefaultRetro:       {   [baseLink appendString:@"&default=retro"];      break;  }
            case DNCGravatarDefaultBlank:       {   [baseLink appendString:@"&default=blank"];      break;  }

            default:    {   break;  }
        }
    }

    if (_forceDefault)
    {
        [baseLink appendString:@"&forcedefault=y"];
    }

    return baseLink;
}

- (NSString*)createMD5:(NSString*)email
{
    const char*     cStr = [email UTF8String];
    unsigned char   digest[16];

    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);

    NSMutableString*    emailMD5 = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [emailMD5 appendFormat:@"%02x", digest[i]];
    }

    return emailMD5;
}

@end
