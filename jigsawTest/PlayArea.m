//
//  LevelEasyLayer.m
//  jigsawTest
//
//  Created by admin on 6/27/14.
//  Copyright (c) 2014 BITLANTIC. All rights reserved.
//

#import "PlayArea.h"
#import "GameManager.h"
#import "GameConstants.h"
#import "HomeScreenLayer.h"
#import "GameHelper.h"
#import "ImageHelper.h"

@implementation PlayArea
@synthesize selectedLevel;

+(CCScene *)sceneWithParameter:(NSString *)imageStr withLevel:(int)levelNo
{
    CCScene *scene = [CCScene node];
    PlayArea *layer = [PlayArea node];
    
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

    bgSoundEngine = [SimpleAudioEngine sharedEngine];

    [self initBackground];
    
    if(newImage != (id)[NSNull null])
    {
        [self loadPuzzleImage:newImage];
    }
}

- (void)initBackground
{
    CCSprite *background;
    background = [CCSprite spriteWithFile:@"background-gameplay-easy.jpg"];
    if(IS_IPHONE_5)
    {
        background = [CCSprite spriteWithFile:@"playscreenbg_iphone.jpg"];
    }
    
    if(IS_IPHONE_4)
    {
        background = [CCSprite spriteWithFile:@"playscreenbg_iphone4.jpg"];
    }
    
	background.position = ccp(screenSize.width/2, screenSize.height/2);
    [self addChild:background];
}


- (void)onClickBack
{
    [CCAnimationCache purgeSharedAnimationCache];
    [[CCDirector sharedDirector] purgeCachedData];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];

    [bgSoundEngine playEffect:@"Back.mp3"];
    
    [topView removeFromSuperview];

    [hintLabel removeFromSuperview];
    [switchControl removeFromSuperview];
    
    [self removeFromParentAndCleanup:YES];
    [self removeAllChildrenWithCleanup:YES];
    [self removeChild:puzzleImage cleanup:YES];

    [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeBL transitionWithDuration:1.0 scene:[LevelSelectionLayer sceneParameter:@""]]];
    
}


- (void)hintOnOff:(UISwitch *)paramSender
{
    if(paramSender.on)
    {
        puzzleImage.opacity = 40.0f;
    }
    else
    {
        puzzleImage.opacity = 0.0f;
    }
}

-(void)onEnterTransitionDidFinish
{
    
    [[[GameManager sharedGameManager] bannerView] removeFromSuperview];

    //to start
    [bgSoundEngine playBackgroundMusic:@"background_music.mp3" loop:YES];

    CCSprite *itemSprite;
    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        itemSprite = [[CCSprite alloc] initWithFile:@"backbutton_iphone.png"];
    }
    else
    {
        itemSprite = [[CCSprite alloc] initWithFile:@"backbutton.png"];
    }
    
    backButton = [CCMenuItemSprite itemWithNormalSprite:itemSprite selectedSprite:nil
                                                                   target:self
                                                                 selector:@selector(onClickBack)];
    
    CCMenu *backMenu = [CCMenu menuWithItems:backButton,nil];
    [backMenu setPosition:ccp(backButton.contentSize.width/2+10, (screenSize.height - (backButton.contentSize.height/2)) - 10)];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [backMenu setPosition:ccp(backButton.contentSize.width/2 + 5, screenSize.height - backButton.contentSize.height/2 - 5)];
    }
    [self addChild:backMenu z:80 tag:70];
    
    hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 125, 160, 48)];
    hintLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"active-ipad1.png"]];
    [[[CCDirector sharedDirector] view] addSubview:hintLabel];
    
    switchControl = [[UISwitch alloc] initWithFrame:CGRectMake(201, 131, 51, 31)];
    [switchControl setOn:YES animated:NO];
    switchControl.transform = CGAffineTransformMakeScale(1.4, 1.4);
    [switchControl addTarget:self action:@selector(hintOnOff:) forControlEvents:UIControlEventTouchUpInside];
    [[[CCDirector sharedDirector] view] addSubview:switchControl];

    
    if(IS_IPHONE_5)
    {
        hintLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"active-iphone1.png"]];
        hintLabel.frame = CGRectMake(70, 33, 75, 22);
        
        switchControl.transform = CGAffineTransformMakeScale(0.75, 0.75);
        switchControl.frame = CGRectMake(145, 30, 31, 16);
    }
    
    if(IS_IPHONE_4)
    {
        hintLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"active-iphone1.png"]];
        hintLabel.frame = CGRectMake(10, 72, 75, 22);
        
        switchControl.transform = CGAffineTransformMakeScale(0.75, 0.75);
        switchControl.frame = CGRectMake(85, 70, 31, 16);
    }

    
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
    
    currentTime = 0;
    isGameOver = FALSE;
    playTime = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(Update) userInfo:nil repeats:YES];

}

- (void)Update
{    
    if(isGameOver==TRUE)
    {
        [playTime invalidate];
        playTime = nil;
                
        CCSprite *puzzleSolvedSprite;
        
        NSString *narrativeText = [NSString stringWithFormat:@"%ds", currentTime];
        CCLabelBMFont *narrativeTextLabel = [CCLabelBMFont labelWithString:narrativeText fntFile:@"markerFelt.fnt"
                                                                     width:600 alignment:kCCTextAlignmentCenter];
        

        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            if(IS_IPHONE_5)
            {
                puzzleSolvedSprite = [CCSprite spriteWithFile:@"puzzleSolvedText_iphone.png"];
                puzzleSolvedSprite.position = ccp(20, 125);
                puzzleSolvedSprite.anchorPoint = ccp(0, 0);
                narrativeTextLabel.position =  ccp(80,105);
            }
            else
            {
                puzzleSolvedSprite = [CCSprite spriteWithFile:@"puzzleSolvedText_iphone.png"];
                puzzleSolvedSprite.position = ccp(0, 125);
                puzzleSolvedSprite.anchorPoint = ccp(0, 0);
                narrativeTextLabel.position =  ccp(60,105);
            }
        }
        else
        {
             puzzleSolvedSprite = [CCSprite spriteWithFile:@"puzzleSolvedText.png"];
            puzzleSolvedSprite.position = ccp(10, 370);
            puzzleSolvedSprite.anchorPoint = ccp(0, 0);
            narrativeTextLabel.position =  ccp(110,345);
        }
        
        
        //you can save this [NSString stringWithFormat:@"Your Rount Time is %.2d", currentTime] in nsuserdefoult or database like bellow
        
//        NSString *myGameLastTime =[NSString stringWithFormat:@"Puzzle Solved in %.2d", currentTime] ;
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setObject:myGameLastTime forKey:@"gameoverTime"];
//        [defaults synchronize];
        
        [self addChild:puzzleSolvedSprite z:200 tag:20];
        [self addChild:narrativeTextLabel z:2000 tag:200];

        
        //now you can get this time anyplace in your project like [[NSUserDefaults standardUserDefaults] valueForKey:@"gameoverTime"]
        
    }
    
    currentTime++;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}


-(void)onExit{
    [super onExit];
    
    [bgSoundEngine stopBackgroundMusic];

    [[CCTextureCache sharedTextureCache] removeAllTextures];

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

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}


@end
