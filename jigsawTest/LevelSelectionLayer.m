//
//  CategorySelectionLayer.m
//  jigsawTest
//
//  Created by admin on 7/2/14.
//  Copyright (c) 2014 BITLANTIC. All rights reserved.
//

#import "LevelSelectionLayer.h"
#import "GameConstants.h"
#import "GameManager.h"
#import "GameHelper.h"
#import "ImageHelper.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "HomeScreenLayer.h"

#import "BlockAlertView.h"
#import "BlockBackground.h"
#import "BlockUI.h"

@implementation LevelSelectionLayer

+(CCScene *)sceneParameter:(NSString *)imageStr
{
	CCScene *scene = [CCScene node];
	LevelSelectionLayer *layer = [LevelSelectionLayer node];
    [layer initWithSelectedImage:imageStr];
	[scene addChild: layer];
    
    return scene;
}

- (void)initWithSelectedImage:(NSString *)imageSelected
{
    if(imageSelected.length == 0)
    {
        selImage = [[NSUserDefaults standardUserDefaults] valueForKey:@"TEMPIMAGE"];
    }
    else
    {
        selImage = imageSelected;
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:selImage forKey:@"TEMPIMAGE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void) onEnter
{
	[super onEnter];
        
    screenSize = [[CCDirector sharedDirector] winSize];
    [CCSpriteFrameCache sharedSpriteFrameCache];
    
    [self initBackground];
}


-(void) initBackground{
    
	CCSprite *background;
    background = [CCSprite spriteWithFile:@"newhomebg.jpg"];
    
    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        background = [CCSprite spriteWithFile:@"homebgiphone5.jpg"];
    }

    [background setPosition:ccp(screenSize.width/2, screenSize.height/2)];
    
    [self addChild:background];
}


-(void)onEnterTransitionDidFinish{
    
    bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(330/2, 286/2, 695, 482);
    bgView.layer.cornerRadius = 2.0f;
    bgView.layer.borderWidth = 2.0f;
    bgView.layer.masksToBounds = YES;
    bgView.layer.borderColor = [UIColor whiteColor].CGColor;
    [[[CCDirector sharedDirector] view] addSubview:bgView];
    bgView.hidden = YES;
    
    
    level1 = [UIButton buttonWithType:UIButtonTypeCustom];
    level1.frame = CGRectMake(330/2, 646, 155, 44);
    level1.tag = 1;
    [level1 setBackgroundImage:[UIImage imageNamed:@"level1.png"] forState:UIControlStateNormal];
    [level1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [level1 setBackgroundColor:[UIColor clearColor]];
    [level1 addTarget:self action:@selector(level1Selected:) forControlEvents:UIControlEventTouchUpInside];
    [[[CCDirector sharedDirector] view] addSubview:level1];
    [[[CCDirector sharedDirector] view] bringSubviewToFront:level1];
    
    level2 = [UIButton buttonWithType:UIButtonTypeCustom];
    level2.frame = CGRectMake(330/2+156+115, 646, 155, 44);
    level2.tag = 2;
    [level2 setBackgroundImage:[UIImage imageNamed:@"level2.png"] forState:UIControlStateNormal];
    [level2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [level2 setBackgroundColor:[UIColor clearColor]];
    [level2 addTarget:self action:@selector(level2Selected:) forControlEvents:UIControlEventTouchUpInside];
    [[[CCDirector sharedDirector] view] addSubview:level2];
    [[[CCDirector sharedDirector] view] bringSubviewToFront:level2];
    
    level3 = [UIButton buttonWithType:UIButtonTypeCustom];
    level3.frame = CGRectMake(330/2+(2*156)+115+115, 646, 155, 44);
    level3.tag = 3;
    [level3 setBackgroundImage:[UIImage imageNamed:@"level3.png"] forState:UIControlStateNormal];
    [level3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [level3 setBackgroundColor:[UIColor clearColor]];
    [level3 addTarget:self action:@selector(level3Selected:) forControlEvents:UIControlEventTouchUpInside];
    [[[CCDirector sharedDirector] view] addSubview:level3];
    [[[CCDirector sharedDirector] view] bringSubviewToFront:level3];
    
    if(IS_IPHONE_5)
    {
        bgView.layer.borderWidth = 1.5f;
        bgView.frame = CGRectMake(244/2, 55/2, 324, 226);

        [level1 setBackgroundImage:[UIImage imageNamed:@"level1_iphone.png"] forState:UIControlStateNormal];
        level1.frame = CGRectMake(244/2, 258, 80, 25);

        [level2 setBackgroundImage:[UIImage imageNamed:@"level2_iphone.png"] forState:UIControlStateNormal];
        level2.frame = CGRectMake(244/2+81+42, 258, 80, 25);

        [level3 setBackgroundImage:[UIImage imageNamed:@"level3_iphone.png"] forState:UIControlStateNormal];
        level3.frame = CGRectMake(244/2+(2*81)+42+42, 258, 80, 25);
    }
    
    if(IS_IPHONE_4)
    {
        bgView.layer.borderWidth = 1.5f;
        bgView.frame = CGRectMake(156/2, 55/2, 324, 226);
        
        [level1 setBackgroundImage:[UIImage imageNamed:@"level1_iphone.png"] forState:UIControlStateNormal];
        level1.frame = CGRectMake(156/2, 258, 80, 25);
        
        [level2 setBackgroundImage:[UIImage imageNamed:@"level2_iphone.png"] forState:UIControlStateNormal];
        level2.frame = CGRectMake(156/2+80+42, 258, 80, 25);
        
        [level3 setBackgroundImage:[UIImage imageNamed:@"level3_iphone.png"] forState:UIControlStateNormal];
        level3.frame = CGRectMake(156/2+(2*80)+42+42, 258, 80, 25);
    }
    
    CCSprite *itemSprite;
    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        itemSprite = [[CCSprite alloc] initWithFile:@"backbutton_iphone.png"];
    }
    else
    {
        itemSprite = [[CCSprite alloc] initWithFile:@"backbutton.png"];
    }
    
    CCMenuItemSprite *backButton = [CCMenuItemSprite itemWithNormalSprite:itemSprite selectedSprite:nil
                                                                   target:self
                                                                 selector:@selector(onClickBack)];
    
    CCMenu *backMenu = [CCMenu menuWithItems:backButton,nil];
    [backMenu setPosition:ccp(backButton.contentSize.width/2+10, (screenSize.height - (backButton.contentSize.height/2)) - 10)];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [backMenu setPosition:ccp(backButton.contentSize.width/2 + 5, screenSize.height - backButton.contentSize.height/2 - 5)];
    }
    
    [self addChild:backMenu z:80 tag:70];

    
    
    NSLog(@"IMAGE NAME 11:: %@", selImage);
    
//    camera image size is 670*465
//    our image size is 648*448
    
    [[CCTextureCache sharedTextureCache] removeTextureForKey:selImage];
        
    imageSprite = [CCSprite spriteWithFile:selImage];
    [imageSprite setPosition:ccp(screenSize.width/2, screenSize.height/2)];
//    imageSprite.anchorPoint = ccp(0, 0);
    imageSprite.scale = 0.4f;
    
    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        [imageSprite setPosition:ccp(screenSize.width/2, (screenSize.height/2)+20)];
    }
    
    [imageSprite runAction:[CCRotateBy actionWithDuration:1.0f angle:360]];

    [imageSprite runAction:[CCScaleTo actionWithDuration:1.0f scale:1.0f]];
    
    [self scheduleOnce:@selector(showBgView:) delay:1.0];
    
    [self addChild:imageSprite];
    
    
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
    
    [self scheduleOnce:@selector(addBanerViewAds:) delay:1.0];
    
    soundEngine = [SimpleAudioEngine sharedEngine];
    
}

- (void)addBanerViewAds:(ccTime)dt
{
//    [[GameManager sharedGameManager] init];
    [[[GameManager sharedGameManager] bannerView] setHidden:NO];
    //    if([[GameManager sharedGameManager] isInterstitialAdReady])
    //    {
    //        [[[GameManager sharedGameManager] interstitial] presentInView :[[CCDirector sharedDirector] view]];
    //    }
}

- (void)showBgView:(ccTime)dt
{
    bgView.hidden = NO;
}

- (void)onClickBack
{
    selectedImageName = nil;
    [soundEngine playEffect:@"Back.mp3"];
    
    [bgView removeFromSuperview];
    [level1 removeFromSuperview];
    [level2 removeFromSuperview];
    [level3 removeFromSuperview];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeBL transitionWithDuration:1.5 scene:[HomeScreenLayer scene]]];
}


- (void)level1Selected:(UIButton *)sender
{
    NSLog(@"TAG VALUE:: %d", sender.tag);
    [soundEngine playEffect:@"select.mp3"];
    
    [CCAnimationCache purgeSharedAnimationCache];
    [[CCDirector sharedDirector] purgeCachedData];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];

    [bgView removeFromSuperview];
    [level1 removeFromSuperview];
    [level2 removeFromSuperview];
    [level3 removeFromSuperview];
    

//    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"" message:@"Rate us on the app store if you had fun playing the Jigsaw puzzle."];
//    [alert addButtonWithTitle:@"Rate Jigsaw Puzzles Fun" imageIdentifier:@"green" block:^{
//        
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/jigsaw-puzzles-fun/id898825186?ls=1&mt=8"]];
//        
//        }];
//    
//    [alert addButtonWithTitle:@"Rate it Later" imageIdentifier:@"yellow" block:^{
//        }];
//    [alert show];
    


     [[CCDirector sharedDirector] runWithScene:[CCTransitionMoveInL transitionWithDuration:0.5 scene:[PlayArea sceneWithParameter:selImage withLevel:1]]];
}

- (void)level2Selected:(UIButton *)sender
{
    NSLog(@"TAG VALUE:: %d", sender.tag);
    [soundEngine playEffect:@"select.mp3"];
    
    [CCAnimationCache purgeSharedAnimationCache];
    [[CCDirector sharedDirector] purgeCachedData];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    [bgView removeFromSuperview];
    [level1 removeFromSuperview];
    [level2 removeFromSuperview];
    [level3 removeFromSuperview];
    
     [[CCDirector sharedDirector] runWithScene:[CCTransitionMoveInL transitionWithDuration:0.5 scene:[PlayArea sceneWithParameter:selImage withLevel:2]]];
    
}

- (void)level3Selected:(UIButton *)sender
{
    NSLog(@"TAG VALUE:: %d", sender.tag);
    [soundEngine playEffect:@"select.mp3"];
    
    [CCAnimationCache purgeSharedAnimationCache];
    [[CCDirector sharedDirector] purgeCachedData];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];

    [bgView removeFromSuperview];
    [level1 removeFromSuperview];
    [level2 removeFromSuperview];
    [level3 removeFromSuperview];
    
     [[CCDirector sharedDirector] runWithScene:[CCTransitionMoveInL transitionWithDuration:0.5 scene:[PlayArea sceneWithParameter:selImage withLevel:3]]];
    
}


#pragma mark - OnTouchExplosion
-(void) createExplosionAtPosition:(CGPoint)point
{
    [soundEngine playEffect:@"shine_sound_1.mp3"];
    
    if(explosion != nil){
        [explosion resetSystem];
        [self removeChild:explosion cleanup:NO];
        explosion = nil;
    }
    explosion = [[CCParticleSun alloc] initWithTotalParticles:50];
    if(IS_IPHONE_4)
    {
        explosion.texture = [[CCTextureCache sharedTextureCache] addImage:@"particle-stars_iphone.png"];
    }
    else
    {
        explosion.texture = [[CCTextureCache sharedTextureCache] addImage:@"particle-stars.png"];
    }
        
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


- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - onexit

-(void) onExit{
    [super onExit];
    
    [self removeChild:imageSprite cleanup:YES];
    
    [[[GameManager sharedGameManager] bannerView] setHidden:YES];
    
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    
    [self removeAllChildrenWithCleanup:YES];
    [self removeFromParentAndCleanup:YES];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}



@end
