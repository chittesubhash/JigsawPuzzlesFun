//
//  LevelEasyLayer.h
//  jigsawTest
//
//  Created by admin on 6/27/14.
//  Copyright (c) 2014 BITLANTIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LevelBaseLayer.h"
#import "cocos2d.h"
#import "Piece.h"

@interface LevelEasyLayer : LevelBaseLayer  <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>
{
    UIImagePickerController *_picker;
    UIPopoverController *_popover;
    
    UIWindow *window;
	NSString *newImage;
}
+(CCScene *)sceneWithParameter:(NSString *)imageStr;
- (void)initWithSelectedImage:(NSString *)imageSelected;
@property(nonatomic, strong) NSString *selectedImageName;
@end
