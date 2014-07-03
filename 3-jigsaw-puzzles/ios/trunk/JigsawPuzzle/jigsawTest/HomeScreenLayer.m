//
//  HomeScreenLayer.m
//  jigsawTest
//
//  Created by admin on 6/27/14.
//  Copyright (c) 2014 BITLANTIC. All rights reserved.
//

#import "HomeScreenLayer.h"
#import "GameHelper.h"
#import "GameManager.h"
#import "CategorySelectionLayer.h"

@implementation HomeScreenLayer
+(CCScene*)scene
{
    CCScene *scene = [CCScene node];
    HomeScreenLayer *layer = [HomeScreenLayer node];
    [scene addChild:layer];
    return scene;
}

- (void)onEnter
{
    [super onEnter];
    screenSize = [[CCDirector sharedDirector] winSize];
    [self initBackground];
}

- (void)initBackground
{
    CCSprite *background = [CCSprite spriteWithFile:@"jigsaw_playing_bg.png"];
    
    if(IS_IPHONE_5)
    {
        background = [CCSprite spriteWithFile:@"jigsaw_playing_bg_5.png"];
    }
    
    if(IS_IPHONE_4)
    {
        background = [CCSprite spriteWithFile:@"jigsaw_playing_bg_5.png"];
    }

    background.anchorPoint = ccp(0, 0);
    [self addChild:background];
}

- (void)onEnterTransitionDidFinish
{
    [self scheduleOnce:@selector(megacloudAnimation:) delay:0.3];
    [self scheduleOnce:@selector(initParticles:) delay:0.9];
    [self scheduleOnce:@selector(selectLevelButton:) delay:1.2];
    
    [[[GameManager sharedGameManager] bannerView] setHidden:YES];
    if([[GameManager sharedGameManager] isInterstitialAdReady])
    {
//        [[[GameManager sharedGameManager]interstitial] presentFromViewController:[[CCDirector sharedDirector]navigationController]];
        
        
        [[[GameManager sharedGameManager]interstitial] presentInView :[[CCDirector sharedDirector] view]];
    }
}

- (void)megacloudAnimation:(ccTime)dt
{
    CCSprite *megacloud = [CCSprite spriteWithFile:@"mega-cloud-ipad.png"];
    if(IS_IPHONE_5)
    {
        megacloud = [CCSprite spriteWithFile:@"mega-cloud_5.png"];
    }
    if(IS_IPHONE_4)
    {
        megacloud = [CCSprite spriteWithFile:@"mega-cloud_5.png"];
    }

    
    megacloud.anchorPoint = ccp(0, 0);
    [megacloud setScale:0.1];
    [self addChild:megacloud z:1 tag:1];
    
    id action = [CCScaleTo actionWithDuration:0.6 scale:1.0];
    [megacloud runAction:[CCEaseOut actionWithAction:action rate:0.5]];

}

-(void) initParticles:(ccTime)dt {
    emitter = [[CCParticleFlower alloc] initWithTotalParticles:200];
    CGPoint p = emitter.position;
    emitter.position = ccp( p.x-110, p.y-110);
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        emitter.position = ccp( p.x, p.y);
    }
    emitter.life = 30;
    emitter.lifeVar = 20;
    // gravity
    emitter.gravity = ccp(20,10);
    // speed of particles
    emitter.speed = 150;
    emitter.speedVar = 120;
    ccColor4F startColor = emitter.startColor;
    startColor.r = 1.0f;
    startColor.g = 1.0f;
    startColor.b = 1.0f;
    emitter.startColor = startColor;
    ccColor4F startColorVar = emitter.startColorVar;
    startColorVar.b = 0.1f;
    emitter.startColorVar = startColorVar;
    emitter.emissionRate = emitter.totalParticles/emitter.life;
    emitter.texture = [[CCTextureCache sharedTextureCache] addImage: @"snow.png"];
    [self addChild: emitter];
}


#pragma mark Select Level Option

- (void)selectLevelButton:(ccTime)dt
{
    levels = [[NSArray alloc] initWithObjects:@"Level 1", @"Level 2", @"Level 3", @"Level 4", @"Level 5", nil];
    
    selectLevel = [[UILabel alloc] initWithFrame:CGRectMake(372, 208, 300, 54)];
    selectLevel.backgroundColor = [UIColor clearColor];
    selectLevel.text = @"SELECT LEVEL";
    selectLevel.textAlignment = NSTextAlignmentCenter;
    selectLevel.textColor = [UIColor orangeColor];
    selectLevel.font = [UIFont boldSystemFontOfSize:30.0];
    [[[CCDirector sharedDirector] view] addSubview:selectLevel];
    
    
    levelSelectionTable = [[UITableView alloc] initWithFrame:CGRectMake(372, 262, 300, 432) style:UITableViewStylePlain];
    levelSelectionTable.backgroundColor = [UIColor clearColor];
    levelSelectionTable.delegate = self;
    levelSelectionTable.dataSource = self;
    levelSelectionTable.opaque = YES;
    [[[CCDirector sharedDirector] view] addSubview:levelSelectionTable];

}


#pragma mark - Table View
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    UIView *view = [[UIView alloc] init];
    tableView.tableFooterView = view;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return levels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    NSDate *object = levels[indexPath.row];
    cell.textLabel.text = [object description];
    cell.textLabel.textColor = [UIColor cyanColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:24.0];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [selectLevel removeFromSuperview];
    [levelSelectionTable removeFromSuperview];
    
    
    if(indexPath.row == 0)
        [[CCDirector sharedDirector] runWithScene:[CCTransitionMoveInL transitionWithDuration:0.5 scene:[CategorySelectionLayer sceneWithParameter:0]]];
    
    if(indexPath.row == 1)
        [[CCDirector sharedDirector] runWithScene:[CCTransitionMoveInL transitionWithDuration:0.5 scene:[CategorySelectionLayer sceneWithParameter:1]]];

    if(indexPath.row == 2)
        [[CCDirector sharedDirector] runWithScene:[CCTransitionMoveInL transitionWithDuration:0.5 scene:[CategorySelectionLayer sceneWithParameter:2]]];
    
    if(indexPath.row == 3)
        [[CCDirector sharedDirector] runWithScene:[CCTransitionMoveInL transitionWithDuration:0.5 scene:[CategorySelectionLayer sceneWithParameter:3]]];
    
    if(indexPath.row == 4)
        [[CCDirector sharedDirector] runWithScene:[CCTransitionMoveInL transitionWithDuration:0.5 scene:[CategorySelectionLayer sceneWithParameter:4]]];

}


- (void)onExitTransitionDidStart
{
    
}

- (void)onExit
{
    [emitter resetSystem];
    [self removeAllChildrenWithCleanup:YES];
}

@end
