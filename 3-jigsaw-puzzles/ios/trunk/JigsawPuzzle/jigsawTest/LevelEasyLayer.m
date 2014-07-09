//
//  LevelEasyLayer.m
//  jigsawTest
//
//  Created by admin on 6/27/14.
//  Copyright (c) 2014 BITLANTIC. All rights reserved.
//

#import "LevelEasyLayer.h"
#import "GameManager.h"
#import "GameConstants.h"
#import "HomeScreenLayer.h"
#import "GameHelper.h"
#import "ImageHelper.h"
#import "AudioHelper.h"

@implementation LevelEasyLayer
@synthesize selectedLevel;

+(CCScene *)sceneWithParameter:(NSString *)imageStr withLevel:(int)levelNo
{
    CCScene *scene = [CCScene node];
    LevelEasyLayer *layer = [LevelEasyLayer node];
    
    [layer initWithSelectedImage:imageStr andLevel:levelNo];
    [scene addChild:layer];
    
    return scene;
}

- (void)initWithSelectedImage:(NSString *)imageSelected andLevel:(int)levelNo
{
    NSLog(@"Selected Image 22 :: %@", imageSelected);
    NSLog(@"Selected Level 22 :: %d", levelNo);

    newImage = imageSelected;
    selectedLevel = levelNo;
}

- (void)onEnter
{
    [super onEnter];
    [super resetScreen];
    CCDirector * director_ = [CCDirector sharedDirector];
    screenSize = [director_ winSize];
    zIndex = 1100;
    
    [[director_ touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];

    [self initBackground];
    
    if(newImage != (id)[NSNull null])
    {
        [self loadPuzzleImage:newImage];
    }
}

- (void)initBackground
{
    CCSprite *background;
    background = [CCSprite spriteWithFile:@"background-gameplay-easy.png"];
    if(IS_IPHONE_5)
    {
        background = [CCSprite spriteWithFile:@"background-gameplay-easy_5.png"];
    }
    if(IS_IPHONE_4)
    {
        background = [CCSprite spriteWithFile:@"background-gameplay-easy_4.png"];
    }

    
	background.position = ccp(screenSize.width/2, screenSize.height/2);
    [self addChild:background];
}


- (void)onClickBack
{
    [hintLabel removeFromSuperview];
    [switchControl removeFromSuperview];
    
    [self removeFromParentAndCleanup:YES];
    [self removeAllChildrenWithCleanup:YES];
    [self removeChild:puzzleImage cleanup:YES];
    
    [AudioHelper playBack];

    if([[NSUserDefaults standardUserDefaults] boolForKey:@"HOMEPAGE"] == YES)
    {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeBL transitionWithDuration:0.5 scene:[HomeScreenLayer scene]]];
    }
    else
    {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeBL transitionWithDuration:0.5 scene:[CategorySelectionLayer sceneParameter:@""]]];
    }
    
}


-(void)onEnterTransitionDidFinish
{
    CCSprite *itemSprite;
    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        itemSprite = [[CCSprite alloc] initWithFile:@"back-button_iPhone.png"];
    }
    else
    {
        itemSprite = [[CCSprite alloc] initWithFile:@"back-button.png"];
    }
    
    CCMenuItemSprite *backButton = [CCMenuItemSprite itemWithNormalSprite:itemSprite selectedSprite:nil
                                                                   target:self
                                                                 selector:@selector(onClickBack)];
    
    CCMenu *backMenu = [CCMenu menuWithItems:backButton,nil];
    [backMenu setPosition:ccp(backButton.contentSize.width/2,
                              screenSize.height - (backButton.contentSize.height/2))];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        [backMenu setPosition:ccp(backButton.contentSize.width/2,
                                  screenSize.height - backButton.contentSize.height/2 )];
    }
    [self addChild:backMenu z:80 tag:70];

    
    if(selectedLevel == 1 || selectedLevel == 5)
    {
        int cols = 4;
        int rows = 3;
        pieces = [[NSMutableArray alloc] initWithCapacity:cols*rows];
        [self loadLevelSprites:@"4x3"];
        [self loadPieces:@"levelEasy" withCols:cols andRols:rows];
        [self scheduleOnce:@selector(enableTouch:) delay:0.5];
    }
    
    
    if(selectedLevel == 2)
    {
        int cols = 6;
        int rows = 4;
        pieces = [[NSMutableArray alloc] initWithCapacity:cols*rows];
        [self loadLevelSprites:@"6x4"];
        [self loadPieces:@"levelNormal" withCols:cols andRols:rows];
        [self scheduleOnce:@selector(enableTouch:) delay:0.5];
    }
    
    
    if(selectedLevel == 3)
    {
        int cols = 8;
        int rows = 6;
        pieces = [[NSMutableArray alloc] initWithCapacity:cols*rows];
        [self loadLevelSprites:@"8x6"];
        [self loadPieces:@"levelHard" withCols:cols andRols:rows];
        [self scheduleOnce:@selector(enableTouch:) delay:0.5];
    }

}


-(void)onExit{
    [super onExit];
    [CCAnimationCache purgeSharedAnimationCache];
    [[CCDirector sharedDirector] purgeCachedData];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    [[CCTextureCache sharedTextureCache] dumpCachedTextureInfo];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"pieces_4x3.plist"];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"pieces_4x3.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"pieces_4x3_bevel.plist"];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"pieces_4x3_bevel.png"];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"pieces_6x4.plist"];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"pieces_6x4.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"pieces_6x4_bevel.plist"];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"pieces_6x4_bevel.png"];

    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"pieces_8x6.plist"];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"pieces_8x6.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"pieces_8x6_bevel.plist"];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"pieces_8x6_bevel.png"];

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft
        || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        return YES;
    }
    return NO;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

@end
