//
//  IntroLayer.h
//  Jigsaw Puzzle
//
//  Created by admin on 7/9/14.
//  Copyright (c) 2014 BITLANTIC. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import <Pushwoosh/PushNotificationManager.h>


@interface IntroLayer : CCLayer <PushNotificationDelegate>
{
    CGSize size;
}

+(CCScene *) scene;

@end
