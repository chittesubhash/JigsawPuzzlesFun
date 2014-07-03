//
//  CategorySelectionLayer.h
//  jigsawTest
//
//  Created by admin on 7/2/14.
//  Copyright (c) 2014 BITLANTIC. All rights reserved.
//

#import "CCLayer.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "cocos2d.h"
#import "PuzzleGrid.h"
#import "InfiniteScrollPicker.h"
#import "LevelEasyLayer.h"

@interface CategorySelectionLayer : CCLayer <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, UITableViewDelegate, UITableViewDataSource>{
    CGSize screenSize;
    PuzzleGrid* puzzleGrid;
    UIImagePickerController *_picker;
    UIPopoverController *_popover;
    UIWindow *window;
    
    CCParticleSystem *explosion;
    CCMenu *navArrowMenu;
    CCMenu *levelMenu;
    
    CCMenuItemSprite *cameraButton;
    CCMenuItemSprite *albumButton;
    
    
    NSArray *categoryItems;
    UITableView *categoryTable;
    UILabel *selectcategoryLabel;
    
    LevelEasyLayer *levelEasy;
    UIView *scrollView;
    InfiniteScrollPicker *infiniteScrollPicker;
    
    BOOL cameraSelected;
    int selectedLevel;

}

+(CCScene *)sceneWithParameter:(int)levelNo;


@end
