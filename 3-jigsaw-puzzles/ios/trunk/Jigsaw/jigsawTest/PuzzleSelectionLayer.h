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
    
    CCMenuItemSprite *easyButton1;
    
    NSArray *categoryItems;
    UIButton* categoryButton;
    UITableView *categoryTable;
}

+(CCScene *) scene;


@end
