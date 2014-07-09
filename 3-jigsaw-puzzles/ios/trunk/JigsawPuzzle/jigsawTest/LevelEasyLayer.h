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
#import "CategorySelectionLayer.h"

@interface LevelEasyLayer : LevelBaseLayer
{
    UIWindow *window;
	NSString *newImage;
    
    int selectedLevel;
}
+(CCScene *)sceneWithParameter:(NSString *)imageStr withLevel:(int)levelNo;
- (void)initWithSelectedImage:(NSString *)imageSelected andLevel:(int)levelNo;
@property(nonatomic, assign) int selectedLevel;

@end
