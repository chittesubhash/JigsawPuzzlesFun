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
#import "PlayArea.h"

#import "SimpleAudioEngine.h"
#import "ELCImagePickerController.h"
#import "AppDelegate.h"
#import "ELCImagePickerController.h"
#import "ELCAlbumPickerController.h"
#import "ELCAssetTablePicker.h"

#import "PurchaseViewController.h"
#import <StoreKit/StoreKit.h>

@interface HomeScreenLayer : CCLayer <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, ELCImagePickerControllerDelegate>
{
    CGSize screenSize;
    CCParticleSystem* emitter;
    NSArray* startLabels;
    CCLabelBMFont* startLabel;
    CCMenu *optMenu;

    BOOL cameraSelected;
    CCMenuItemSprite *cameraButtonSprite;
    CCMenuItemSprite *albumButton;
    UIImagePickerController *_picker;
    UIPopoverController *_popover;
    
    UILabel *selectcategoryLabel;
    
    InfiniteScrollPicker *infiniteScrollPicker;
    
    int selectedLevel;
    
    UIButton *closeButton;
    
    CCMenuItemSprite *animalButton;
    CCMenuItemSprite *buildingButton;
    CCMenuItemSprite *carButton;
    CCMenuItemSprite *sportsButton;
    CCMenuItemSprite *fruitsButton1;
    CCMenuItemSprite *personalitiesButton;
    
    UILabel *animalLabel;
    UILabel *buildingLabel;
    UILabel *carLabel;
    UILabel *sportsLabel;
    UILabel *fruitsLabel;
    UILabel *personalitiesLabel;
    
    NSString *imageName;
    
    SimpleAudioEngine *soundEngine;
    
    int sendTag;
    BOOL isShowingLandscapeView;
    
    UIButton *buyCategories;
    UILabel *itemNotPurchased;
}

+(CCScene *)scene;
@property (nonatomic, retain) ALAssetsLibrary *specialLibrary;

@end





















