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

#import "SimpleAudioEngine.h"


@interface LevelSelectionLayer : CCLayer {
    CGSize screenSize;

    UIWindow *window;
    
    CCParticleSystem *explosion;
    CCMenu *levelMenu;
    
    UIButton *level1;
    UIButton *level2;
    UIButton *level3;
    
    SimpleAudioEngine *soundEngine;

    UIView *bgView;
    
    NSFileManager *fileManager;
    NSString *filePath;
    
    CCSprite *imageSprite;
    
    NSString *selImage;
    NSString *temp;
    NSString *selectedImageName;
}

+(CCScene *)sceneParameter:(NSString *)imageStr;
//@property(nonatomic, retain) NSString *selectedImageName;

@end
