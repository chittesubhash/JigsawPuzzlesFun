//
//  AppDelegate.h
//  jigsawTest
//
//  Created by admin on 6/27/14.
//  Copyright (c) 2014 BITLANTIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CCDirectorDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (readonly) UINavigationController *navController;

@property (readonly) CCDirector *director;
@end
