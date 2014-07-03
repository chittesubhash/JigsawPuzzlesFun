//
//  HomeScreenLayer.h
//  jigsawTest
//
//  Created by admin on 6/27/14.
//  Copyright (c) 2014 BITLANTIC. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"

@interface HomeScreenLayer : CCLayer <UITableViewDelegate, UITableViewDataSource>
{
    CGSize screenSize;
    CCParticleSystem* emitter;
    NSArray* startLabels;
    CCLabelBMFont* startLabel;
    CCMenu *optMenu;

    NSArray *levels;
    UILabel *selectLevel;
    UITableView *levelSelectionTable;
}

+(CCScene *)scene;
@end
