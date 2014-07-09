//
//  CategorySelectionLayer.m
//  jigsawTest
//
//  Created by admin on 7/2/14.
//  Copyright (c) 2014 BITLANTIC. All rights reserved.
//

#import "CategorySelectionLayer.h"
#import "GameConstants.h"
#import "GameManager.h"
#import "GameHelper.h"
#import "ImageHelper.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "AudioHelper.h"
#import "HomeScreenLayer.h"

@implementation CategorySelectionLayer
@synthesize selectedImageName;

+(CCScene *)sceneParameter:(NSString *)imageStr
{
	CCScene *scene = [CCScene node];
	CategorySelectionLayer *layer = [CategorySelectionLayer node];
    [layer initWithSelectedImage:imageStr];
	[scene addChild: layer];
    
    return scene;
}

- (void)initWithSelectedImage:(NSString *)imageSelected
{
    NSLog(@"IMAGE NAME 11:: %@", imageSelected);
    if(imageSelected.length != 0)
        [[NSUserDefaults standardUserDefaults] setValue:imageSelected forKey:@"TEMPIMAGE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.selectedImageName = [NSString stringWithFormat:@"%@", imageSelected];
}


-(void) onEnter{
	[super onEnter];
        
    screenSize = [[CCDirector sharedDirector] winSize];
    [CCSpriteFrameCache sharedSpriteFrameCache];
    
    [self initBackground];
}


-(void) initBackground{
    
	CCSprite *background;
    background = [CCSprite spriteWithFile:@"jigsaw_playing_bg.png"];
    
//    if(IS_IPHONE_5)
//    {
//        background = [CCSprite spriteWithFile:@"background-puzzle-selection_5.png"];
//    }
//    if(IS_IPHONE_4)
//    {
//        background = [CCSprite spriteWithFile:@"background-puzzle-selection_5.png"];
//    }
    
    background.anchorPoint = ccp(0, 0);
    
    [self addChild:background];
}


-(void)onEnterTransitionDidFinish{    
    
    level1 = [UIButton buttonWithType:UIButtonTypeCustom];
    level1.frame = CGRectMake(648/2, 620, 125, 44);
    level1.tag = 1;
    level1.layer.cornerRadius = 2.0f;
    level1.layer.borderWidth = 2.0f;
    level1.layer.masksToBounds = YES;
    level1.titleLabel.font = [UIFont fontWithName:@"Marker Felt" size:22.0];
    [level1 setTitle:@"12 pieces" forState:UIControlStateNormal];
    [level1 setBackgroundColor:[UIColor clearColor]];
    [level1 addTarget:self action:@selector(level1Selected:) forControlEvents:UIControlEventTouchUpInside];
    [[[CCDirector sharedDirector] view] addSubview:level1];
    [[[CCDirector sharedDirector] view] bringSubviewToFront:level1];
    
    level2 = [UIButton buttonWithType:UIButtonTypeCustom];
    level2.frame = CGRectMake(648/2+125, 620, 125, 44);
    level2.tag = 2;
    level2.layer.cornerRadius = 2.0f;
    level2.layer.borderWidth = 2.0f;
    level2.layer.masksToBounds = YES;
    level2.titleLabel.font = [UIFont fontWithName:@"Marker Felt" size:22.0];
    [level2 setTitle:@"24 pieces" forState:UIControlStateNormal];
    [level2 setBackgroundColor:[UIColor clearColor]];
    [level2 addTarget:self action:@selector(level2Selected:) forControlEvents:UIControlEventTouchUpInside];
    [[[CCDirector sharedDirector] view] addSubview:level2];
    [[[CCDirector sharedDirector] view] bringSubviewToFront:level2];
    
    level3 = [UIButton buttonWithType:UIButtonTypeCustom];
    level3.frame = CGRectMake(648/2+(2*125), 620, 125, 44);
    level3.tag = 3;
    level3.layer.cornerRadius = 2.0f;
    level3.layer.borderWidth = 2.0f;
    level3.layer.masksToBounds = YES;
    level3.titleLabel.font = [UIFont fontWithName:@"Marker Felt" size:22.0];
    [level3 setTitle:@"48 pieces" forState:UIControlStateNormal];
    [level3 setBackgroundColor:[UIColor clearColor]];
    [level3 addTarget:self action:@selector(level3Selected:) forControlEvents:UIControlEventTouchUpInside];
    [[[CCDirector sharedDirector] view] addSubview:level3];
    [[[CCDirector sharedDirector] view] bringSubviewToFront:level3];
    
    
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

    
    NSString *tempImage = self.selectedImageName;
    
    if(self.selectedImageName.length == 0)
    {
        tempImage = [[NSUserDefaults standardUserDefaults] valueForKey:@"TEMPIMAGE"];
    }
    
    NSLog(@"tempImage:: %@", tempImage);

    
    CCSprite *imageSprite = [CCSprite spriteWithFile:tempImage];
    [imageSprite setPosition:ccp(165.5, 180)];
    imageSprite.anchorPoint = ccp(0, 0);
    [self addChild:imageSprite];
    
    
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
    
    [[[GameManager sharedGameManager] bannerView] setHidden:NO];

}

- (void)onClickBack
{
    [AudioHelper playBack];

    [level1 removeFromSuperview];
    [level2 removeFromSuperview];
    [level3 removeFromSuperview];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeBL transitionWithDuration:0.5 scene:[HomeScreenLayer scene]]];
}


- (void)level1Selected:(UIButton *)sender
{
    NSLog(@"TAG VALUE:: %d", sender.tag);
    
    NSString *tempImage = self.selectedImageName;
    
    if(self.selectedImageName.length == 0)
    {
        tempImage = [[NSUserDefaults standardUserDefaults] valueForKey:@"TEMPIMAGE"];
    }
    
    NSLog(@"tempImage:: %@", tempImage);

    [level1 removeFromSuperview];
    [level2 removeFromSuperview];
    [level3 removeFromSuperview];
    
     [[CCDirector sharedDirector] runWithScene:[CCTransitionMoveInL transitionWithDuration:0.5 scene:[LevelEasyLayer sceneWithParameter:tempImage withLevel:1]]];
    
}

- (void)level2Selected:(UIButton *)sender
{
    NSLog(@"TAG VALUE:: %d", sender.tag);
    

    NSString *tempImage = self.selectedImageName;
    
    if(self.selectedImageName.length == 0)
    {
        tempImage = [[NSUserDefaults standardUserDefaults] valueForKey:@"TEMPIMAGE"];
    }
    
    NSLog(@"tempImage:: %@", tempImage);

    [level1 removeFromSuperview];
    [level2 removeFromSuperview];
    [level3 removeFromSuperview];
    
     [[CCDirector sharedDirector] runWithScene:[CCTransitionMoveInL transitionWithDuration:0.5 scene:[LevelEasyLayer sceneWithParameter:tempImage withLevel:2]]];
    
}

- (void)level3Selected:(UIButton *)sender
{
    NSLog(@"TAG VALUE:: %d", sender.tag);
    

    NSString *tempImage = self.selectedImageName;
    
    if(self.selectedImageName.length == 0)
    {
        tempImage = [[NSUserDefaults standardUserDefaults] valueForKey:@"TEMPIMAGE"];
    }
    
    NSLog(@"tempImage:: %@", tempImage);

    [level1 removeFromSuperview];
    [level2 removeFromSuperview];
    [level3 removeFromSuperview];
    
     [[CCDirector sharedDirector] runWithScene:[CCTransitionMoveInL transitionWithDuration:0.5 scene:[LevelEasyLayer sceneWithParameter:tempImage withLevel:3]]];
    
}


#pragma mark - OnTouchExplosion
-(void) createExplosionAtPosition:(CGPoint)point
{
    if(explosion != nil){
        [explosion resetSystem];
        [self removeChild:explosion cleanup:NO];
        explosion = nil;
    }
    explosion = [[CCParticleSun alloc] initWithTotalParticles:50];
    explosion.texture = [[CCTextureCache sharedTextureCache] addImage:@"snow.png"];
    explosion.autoRemoveOnFinish = YES;
    explosion.speed = 30.0f;
    explosion.duration = 0.5f;
    explosion.emitterMode = 1;
    explosion.startSize = 20;
    explosion.endSize = 80;
    explosion.life = 0.6;
    explosion.endRadius = 120;
    explosion.position = point;
    [self addChild:explosion z:1000 tag:1000];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self createExplosionAtPosition:touchLocation];
    return YES;
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
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - onexit

-(void) onExit{
    [super onExit];
    
    [[[GameManager sharedGameManager] bannerView] removeFromSuperview];
    
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    
    [self removeAllChildrenWithCleanup:YES];
    [self removeFromParentAndCleanup:YES];
}


-(void)dealloc {
    [super dealloc];
}


@end
