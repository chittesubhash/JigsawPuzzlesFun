/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Luiz Adolpho <luiz.adolpho@gmail.com>
 * Created 08/2012
 * All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "cocos2d.h"
#import "PuzzleGrid.h"
#import "FGScrollLayer.h"
#import "SlidingMenuColors.h"
#import "InfiniteScrollPicker.h"
#import "LevelEasyLayer.h"

@interface PuzzleSelectionLayer : CCLayer <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, UITableViewDelegate, UITableViewDataSource>{
    CGSize screenSize;    
    PuzzleGrid* puzzleGrid;
    UIImagePickerController *_picker;
    UIPopoverController *_popover;
    UIWindow *window;
	UIImage *newImage;

    CCParticleSystem *explosion;
    CCMenu *navArrowMenu;
    CCMenu *levelMenu;
    
    CCMenuItemSprite *cameraButton;
    
    NSArray *categoryItems;
    UITableView *categoryTable;
    UILabel *selectcategoryLabel;
    
    LevelEasyLayer *levelEasy;
    UIView *scrollView;
    InfiniteScrollPicker *isp3;
}

+(CCScene *) scene;


@end
