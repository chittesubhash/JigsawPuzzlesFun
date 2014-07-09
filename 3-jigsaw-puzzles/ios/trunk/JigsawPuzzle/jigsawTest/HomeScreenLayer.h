//
//  HomeScreenLayer.h
//  jigsawTest
//
//  Created by admin on 6/27/14.
//  Copyright (c) 2014 BITLANTIC. All rights reserved.
//

#import "CCLayer.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "cocos2d.h"
#import "InfiniteScrollPicker.h"
#import "LevelEasyLayer.h"

@interface HomeScreenLayer : CCLayer <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>
{
    CGSize screenSize;
    CCParticleSystem* emitter;
    NSArray* startLabels;
    CCLabelBMFont* startLabel;
    CCMenu *optMenu;

    BOOL cameraSelected;
    CCMenuItemSprite *cameraButton;
    CCMenuItemSprite *albumButton;
    UIImagePickerController *_picker;
    UIPopoverController *_popover;
    
    NSArray *categoryItems;
    UILabel *selectcategoryLabel;
    
    LevelEasyLayer *levelEasy;
    InfiniteScrollPicker *infiniteScrollPicker;
    
    int selectedLevel;
    
    UIButton *closeButton;
}

+(CCScene *)scene;
@end
