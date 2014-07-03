//
//  HomeScreenLayer.h
//  jigsawTest
//
//  Created by admin on 6/27/14.
//  Copyright (c) 2014 BITLANTIC. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"

@interface HomeScreenLayer : CCLayer
{
    CGSize screenSize;
    CCParticleSystem* emitter;
    NSArray* startLabels;
    CCLabelBMFont* startLabel;
    CCMenu *optMenu;

}

+(CCScene *)scene;
@end
