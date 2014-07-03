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
    [self scheduleOnce:@selector(initStartGameButton:) delay:1.2];
    [self scheduleOnce:@selector(initParticles:) delay:0.9];
}

- (void)onExitTransitionDidStart
{
    
}

- (void)onExit
{
    [emitter resetSystem];
    [self removeAllChildrenWithCleanup:YES];
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

- (void)initStartGameButton:(ccTime)dt
{
    CCSprite *normal = [CCSprite spriteWithFile:@"imag.png"];
    CCSprite *selected = [CCSprite spriteWithFile:@"imag.png"];

    CCMenuItemSprite *easyButton = [CCMenuItemSprite itemWithNormalSprite:normal selectedSprite:selected target:self selector:@selector(playButtonClicked)];
    easyButton.position = ccp(screenSize.width/2-50, screenSize.height/2-50);
    
    CCMenu *menu = [CCMenu menuWithItems:easyButton, nil];
    [menu alignItemsHorizontallyWithPadding:40];
    [menu setPosition: ccp(screenSize.height/2.0f + 140,300)];
    
    if(IS_IPHONE_5)
    {
        [menu setPosition: ccp(screenSize.height/2.0f + 40, 150)];
    }
    if(IS_IPHONE_4)
    {
        [menu setPosition: ccp(screenSize.height/2.0f + 40, 150)];
    }

    
    [self addChild:menu z:2 tag:2];
}


- (void)playButtonClicked
{
    [[GameManager sharedGameManager] runSceneWithID:kPuzzleSelection withParameter:nil];
}

@end
