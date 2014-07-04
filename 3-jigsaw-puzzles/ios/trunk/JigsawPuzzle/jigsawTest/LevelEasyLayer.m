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

#import "GameHelper.h"
#import "ImageHelper.h"

@implementation LevelEasyLayer

+(CCScene *)sceneWithParameter:(NSString *)imageStr
{
    CCScene *scene = [CCScene node];
    LevelEasyLayer *layer = [LevelEasyLayer node];
    
    [layer initWithSelectedImage:imageStr];
    [scene addChild:layer];
    
    return scene;
}

- (void)initWithSelectedImage:(NSString *)imageSelected
{
    newImage = imageSelected;
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
        
//    CCSprite *fgfg = [CCSprite spriteWithFile:@"back-button.png"];
//    CCMenuItemSprite *backButton1 = [CCMenuItemSprite itemWithNormalSprite:fgfg selectedSprite:fgfg target:self selector:@selector(onClickBack)];
//    
//    CCMenu *backMenu1 = [CCMenu menuWithItems:backButton1,nil];
//    [backMenu1 setPosition:ccp(backButton1.contentSize.width-15,
//                               screenSize.height - (backButton1.contentSize.height-15))];
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
//        [backMenu1 setPosition:ccp(backButton1.contentSize.width-15,
//                                   screenSize.height - (backButton1.contentSize.height+20))];
//        
//    }
//    [self addChild:backMenu1 z:2000 tag:700];

}


- (void)onClickBack
{
    [self removeFromParentAndCleanup:YES];
    [self removeAllChildrenWithCleanup:YES];
    [self removeChild:puzzleImage cleanup:YES];
    [[GameManager sharedGameManager] runSceneWithID:kCategorySelection withParameter:nil];
}


-(void)onEnterTransitionDidFinish{
    int cols = 4;
    int rows = 3;
    pieces = [[NSMutableArray alloc] initWithCapacity:cols*rows];
    [self loadLevelSprites:@"4x3"];
    [self loadPieces:@"levelEasy" withCols:cols andRols:rows];
    [self scheduleOnce:@selector(enableTouch:) delay:0.5];
    
    
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
}


@end
