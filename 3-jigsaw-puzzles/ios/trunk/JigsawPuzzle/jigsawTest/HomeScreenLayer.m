//
//  HomeScreenLayer.m
//  jigsawTest
//
//  Created by admin on 6/27/14.
//  Copyright (c) 2014 BITLANTIC. All rights reserved.
//

#import "HomeScreenLayer.h"
#import "CategorySelectionLayer.h"
#import "GameConstants.h"
#import "GameManager.h"
#import "GameHelper.h"
#import "ImageHelper.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "AudioHelper.h"

#import "SimpleAudioEngine.h"

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
    
    cameraSelected = NO;

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
//    [self scheduleOnce:@selector(megacloudAnimation:) delay:0.3];
    [self scheduleOnce:@selector(initParticles:) delay:0.5];
    [self scheduleOnce:@selector(selectLevelButton:) delay:0.5];
    
    [self scheduleOnce:@selector(initAlbumButton:) delay:0.5];
    [self scheduleOnce:@selector(initCameraButton:) delay:0.5];
    
    [self scheduleOnce:@selector(addBanerViewAds:) delay:0.5];

}

-(void) initAlbumButton:(ccTime)dt
{
    [CCAnimationCache purgeSharedAnimationCache];
    [[CCDirector sharedDirector] purgeCachedData];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    [[CCTextureCache sharedTextureCache] dumpCachedTextureInfo];
    
    CCSprite *normal = [CCSprite spriteWithFile:@"albumBtn.jpeg"];
    CCSprite *selected = [CCSprite spriteWithFile:@"albumBtn.jpeg"];
    
    albumButton = [CCMenuItemSprite itemWithNormalSprite:normal selectedSprite:selected target:self selector:@selector(showPhotoLibrary)];
    albumButton.position = ccp(screenSize.height-50, screenSize.height-50);
    albumButton.isEnabled = YES;
    
    
    CCMenu *menu = [CCMenu menuWithItems:albumButton, nil];
    [menu alignItemsHorizontallyWithPadding:40];
    [menu setPosition: ccp(140, 640)];
    
    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        [menu setPosition: ccp(60, 260)];
    }
    
    [self addChild:menu z:7 tag:7];
}


-(void) initCameraButton:(ccTime)dt
{
    
    CCSprite *normal = [CCSprite spriteWithFile:@"camera.png"];
    CCSprite *selected = [CCSprite spriteWithFile:@"camera.png"];
    
    cameraButton = [CCMenuItemSprite itemWithNormalSprite:normal selectedSprite:selected target:self selector:@selector(startCamera)];
    cameraButton.position = ccp(screenSize.width-60, screenSize.height-50);
    cameraButton.isEnabled = YES;
    
    CCMenu *menu = [CCMenu menuWithItems:cameraButton, nil];
    [menu alignItemsHorizontallyWithPadding:40];
    [menu setPosition: ccp(screenSize.width - 140, 640)];
    
    
    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        [menu setPosition: ccp(screenSize.width - 70, 260)];
    }
    
    [self addChild:menu z:7 tag:7];

}

-(void) startCamera
{
    [CCAnimationCache purgeSharedAnimationCache];
    [[CCDirector sharedDirector] purgeCachedData];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    [[CCTextureCache sharedTextureCache] dumpCachedTextureInfo];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [paths stringByAppendingPathComponent:@"image.png"];
    [fileManager removeItemAtPath:filePath error:NULL];
    
	if (_picker) {
		[_picker dismissViewControllerAnimated:YES completion:nil];
		[_picker.view removeFromSuperview];
	}
	if (_popover) {
		[_popover dismissPopoverAnimated:NO];
	}
    CCDirector * director =[CCDirector sharedDirector];
	[director stopAnimation];
	_picker = [[UIImagePickerController alloc] init];
	_picker.delegate = self;
    _picker.allowsEditing = NO;
    
    
    if( [UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceFront ])
    {
        // do something
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [director presentViewController:_picker animated:YES completion:nil];
    }
    else
    {
        CGRect r = CGRectMake(screenSize.width/2, 0, 10, 10);
        _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            _popover = [[UIPopoverController alloc] initWithContentViewController:_picker];
            _popover.delegate = self;
            r.origin = [director convertToGL:r.origin];
            [_popover presentPopoverFromRect:r inView:[director view]
                    permittedArrowDirections:0 animated:YES];
            _popover.popoverContentSize = CGSizeMake(320, screenSize.width);
            
        }else{
            
            [director presentViewController:_picker animated:YES completion:nil];
        }
    }
    
    cameraSelected = YES;
}


-(void) showPhotoLibrary
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [paths stringByAppendingPathComponent:@"image.png"];
    [fileManager removeItemAtPath:filePath error:NULL];
    
	if (_picker) {
		[_picker dismissViewControllerAnimated:YES completion:nil];
		[_picker.view removeFromSuperview];
	}
	if (_popover) {
		[_popover dismissPopoverAnimated:NO];
	}
    CCDirector * director =[CCDirector sharedDirector];
	[director stopAnimation];
	_picker = [[UIImagePickerController alloc] init];
	_picker.delegate = self;
	_picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _picker.allowsEditing = NO;
    CGRect r = CGRectMake(screenSize.width/2, 0, 10, 10);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        _popover = [[UIPopoverController alloc] initWithContentViewController:_picker];
        _popover.delegate = self;
        r.origin = [director convertToGL:r.origin];
        [_popover presentPopoverFromRect:r inView:[director view]
                permittedArrowDirections:0 animated:YES];
        _popover.popoverContentSize = CGSizeMake(320, screenSize.width);
        
    }else{
        
        [director presentViewController:_picker animated:YES completion:nil];
    }
}

#pragma mark - ImagePickerDelegateMethods
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_picker dismissViewControllerAnimated:YES completion:nil];
	[_picker.view removeFromSuperview];
    _picker = nil;
    
	[_popover dismissPopoverAnimated:NO];
    _popover = nil;
    
	[[CCDirector sharedDirector] startAnimation];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self imagePickerControllerDidCancel:nil];
}

- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info
{
    [selectcategoryLabel removeFromSuperview];
    
    CGSize imageSize = CGSizeMake(693, 480);
    
    if([GameHelper isRetinaIpad]){
        imageSize.width = imageSize.width * 2;
        imageSize.height = imageSize.height * 2;
    }
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if(IS_IPHONE_5)
        {
            imageSize.width = 670;
            imageSize.height = 464;
        }
        else if ([[CCDirector sharedDirector] enableRetinaDisplay:YES])
        {
            imageSize.width = 648;
            imageSize.height = 448;
        }
        else
        {
            imageSize.width = 324;
            imageSize.height = 224;
        }
        
        if(IS_IPHONE_4)
        {
            imageSize.width = 670;
            imageSize.height = 464;
        }
    }
    
    
    UIImage *originalImage = nil;
    originalImage = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];
    originalImage = [ImageHelper cropImage:originalImage toSize:imageSize];
    [_picker dismissViewControllerAnimated:YES completion:nil];

    [_popover dismissPopoverAnimated:YES];
	[[CCDirector sharedDirector] startAnimation];
    
    if(cameraSelected == YES)
    {
        UIImageWriteToSavedPhotosAlbum(originalImage,
                                       self, // send the message to 'self' when calling the callback
                                       @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), // the selector to tell the method to call on completion,
                                       NULL);
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"image.png"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])	//Does directory exist?
	{
        [self removeImage:filePath];
	}
    
    
    NSData *pngData = nil;
    pngData = UIImagePNGRepresentation(originalImage);
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath1 = [paths1 objectAtIndex:0]; //Get the docs directory
    NSString *filePath1 = [documentsPath1 stringByAppendingPathComponent:@"image.png"]; //Add the file name
    [pngData writeToFile:filePath1 atomically:YES]; //Write the file
    
    NSLog(@"IMAGES filePath:: %@", filePath1);
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HOMEPAGE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    for (UIView *view in [[[CCDirector sharedDirector] view] subviews]) {
        UIButton *btnObj = (UIButton *)view;
        if([btnObj isKindOfClass:[UIButton class]])
        {
            [btnObj removeFromSuperview];
        }
    }
    
    [[CCDirector sharedDirector] runWithScene:[CCTransitionFadeTR transitionWithDuration:1.0 scene:[LevelEasyLayer sceneWithParameter:filePath withLevel:5]]];
}

- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo
{
    if (error) {
        // Do anything needed to handle the error or display it to the user
    } else {
        // .... do anything you want here to handle
        // .... when the image has been saved in the photo album
    }
}

-(void)removeImage:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [paths stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", fileName]];
    [fileManager removeItemAtPath:filePath error:NULL];
}

- (void)addBanerViewAds:(ccTime)dt
{
    [[[GameManager sharedGameManager] bannerView] setHidden:NO];
//    if([[GameManager sharedGameManager] isInterstitialAdReady])
//    {
//        [[[GameManager sharedGameManager] interstitial] presentInView :[[CCDirector sharedDirector] view]];
//    }
}


- (void)megacloudAnimation:(ccTime)dt
{
    CCSprite *megacloud = [CCSprite spriteWithFile:@"mega-cloud-ipad.png"];
    if(IS_IPHONE_5 || IS_IPHONE_4)
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
    categoryItems = [[NSArray alloc] initWithObjects:@"Animals", @"Buildings", @"Cars", nil];
    
    selectcategoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(372, 10, 300, 54)];
    selectcategoryLabel.backgroundColor = [UIColor clearColor];
    selectcategoryLabel.text = @"SELECT CATEGORY";
    selectcategoryLabel.textAlignment = NSTextAlignmentCenter;
    selectcategoryLabel.textColor = [UIColor orangeColor];
    selectcategoryLabel.font = [UIFont boldSystemFontOfSize:30.0];
    [[[CCDirector sharedDirector] view] addSubview:selectcategoryLabel];
    
    
    UIButton *animalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    animalButton.frame = CGRectMake(screenSize.width/2-125/2, 85, 125, 125);
    [animalButton setBackgroundImage:[UIImage imageNamed:@"animal.jpeg"] forState:UIControlStateNormal];
    [animalButton addTarget:self action:@selector(animalCategorySelected:) forControlEvents:UIControlEventTouchUpInside];
    [[[CCDirector sharedDirector] view] addSubview:animalButton];
    
    UIButton *buildingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    buildingButton.frame = CGRectMake(200, 275, 125, 125);
    [buildingButton setBackgroundImage:[UIImage imageNamed:@"building.jpg"] forState:UIControlStateNormal];
    [buildingButton addTarget:self action:@selector(buildingCategorySelected:) forControlEvents:UIControlEventTouchUpInside];
    [[[CCDirector sharedDirector] view] addSubview:buildingButton];
    
    UIButton *carButton = [UIButton buttonWithType:UIButtonTypeCustom];
    carButton.frame = CGRectMake(700, 275, 125, 125);
    [carButton setBackgroundImage:[UIImage imageNamed:@"car.jpeg"] forState:UIControlStateNormal];
    [carButton addTarget:self action:@selector(carCategorySelected:) forControlEvents:UIControlEventTouchUpInside];
    [[[CCDirector sharedDirector] view] addSubview:carButton];
    
    UIButton *sportsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sportsButton.frame = CGRectMake(200, 450, 125, 125);
    [sportsButton setBackgroundImage:[UIImage imageNamed:@"car.jpeg"] forState:UIControlStateNormal];
    [sportsButton addTarget:self action:@selector(sportsCategorySelected:) forControlEvents:UIControlEventTouchUpInside];
    [[[CCDirector sharedDirector] view] addSubview:sportsButton];
    
    UIButton *fruitsButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    fruitsButton1.frame = CGRectMake(700, 450, 125, 125);
    [fruitsButton1 setBackgroundImage:[UIImage imageNamed:@"building.jpg"] forState:UIControlStateNormal];
    [fruitsButton1 addTarget:self action:@selector(personalitiesCategorySelected:) forControlEvents:UIControlEventTouchUpInside];
    [[[CCDirector sharedDirector] view] addSubview:fruitsButton1];

    if(IS_IPHONE_4 || IS_IPHONE_5)
    {
        selectcategoryLabel.frame = CGRectMake(140, 48, 200, 44);
        selectcategoryLabel.font = [UIFont boldSystemFontOfSize:16.0];
    }
    
    
    
//    CCSprite *audioBtn = [CCSprite spriteWithFile:@"audio.jpeg"];
//    CCMenuItemSprite *audio = [CCMenuItemSprite itemWithNormalSprite:audioBtn selectedSprite:nil target:self selector:@selector(audioBtnSelected)];
//    CCMenu *audioMenu = [CCMenu menuWithItems:audio, nil];
//    [audioMenu setPosition:ccp(900, 100 )];
//    [self addChild:audioMenu];
    
}

- (void)audioBtnSelected
{
    
}


- (void)animalCategorySelected:(UIButton *)sender
{
    infiniteScrollPicker = [[InfiniteScrollPicker alloc] initWithFrame:CGRectMake(0, -200, screenSize.width, screenSize.height) WithDelegate:self];
    [infiniteScrollPicker setUserInteractionEnabled:YES];
    infiniteScrollPicker.backgroundColor = [UIColor clearColor];
    
    if(IS_IPHONE_4 || IS_IPHONE_5)
    {
        infiniteScrollPicker.frame = CGRectMake(0, -50, screenSize.width, screenSize.height);
    }
    
    [infiniteScrollPicker setAnimalsImagesArray];
    [infiniteScrollPicker setHeightOffset:20];
    [infiniteScrollPicker setPositionRatio:2];
    [infiniteScrollPicker setAlphaOfobjs:0.7];
    [[[CCDirector sharedDirector] view] addSubview:infiniteScrollPicker];
    
    closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, 0, 64, 64);
    [closeButton setImage:[UIImage imageNamed:@"close_iPhone.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeScrollView) forControlEvents:UIControlEventTouchUpInside];
    [[[CCDirector sharedDirector] view] addSubview:closeButton];

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}


- (void)buildingCategorySelected:(UIButton *)sender
{
    infiniteScrollPicker = [[InfiniteScrollPicker alloc] initWithFrame:CGRectMake(0, -200, screenSize.width, screenSize.height) WithDelegate:self];
    [infiniteScrollPicker setUserInteractionEnabled:YES];
    
    if(IS_IPHONE_4 || IS_IPHONE_5)
    {
        infiniteScrollPicker.frame = CGRectMake(0, -50, screenSize.width, screenSize.height);
    }
    
    [infiniteScrollPicker setBuildingsImagesArray];
    [infiniteScrollPicker setHeightOffset:20];
    [infiniteScrollPicker setPositionRatio:2];
    [infiniteScrollPicker setAlphaOfobjs:0.7];
    [[[CCDirector sharedDirector] view] addSubview:infiniteScrollPicker];

    closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, 0, 64, 64);
    [closeButton setImage:[UIImage imageNamed:@"close_iPhone.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeScrollView) forControlEvents:UIControlEventTouchUpInside];
    [[[CCDirector sharedDirector] view] addSubview:closeButton];
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}

- (void)carCategorySelected:(UIButton *)sender
{
    infiniteScrollPicker = [[InfiniteScrollPicker alloc] initWithFrame:CGRectMake(0, -200, screenSize.width, screenSize.height) WithDelegate:self];
    [infiniteScrollPicker setUserInteractionEnabled:YES];
    
    if(IS_IPHONE_4 || IS_IPHONE_5)
    {
        infiniteScrollPicker.frame = CGRectMake(0, -50, screenSize.width, screenSize.height);
    }
    
    [infiniteScrollPicker setCarsImagesArray];
    [infiniteScrollPicker setHeightOffset:20];
    [infiniteScrollPicker setPositionRatio:2];
    [infiniteScrollPicker setAlphaOfobjs:0.7];
    [[[CCDirector sharedDirector] view] addSubview:infiniteScrollPicker];

    closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, 0, 64, 64);
    [closeButton setImage:[UIImage imageNamed:@"close_iPhone.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeScrollView) forControlEvents:UIControlEventTouchUpInside];
    [[[CCDirector sharedDirector] view] addSubview:closeButton];
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
}

- (void)sportsCategorySelected:(UIButton *)sender
{
    infiniteScrollPicker = [[InfiniteScrollPicker alloc] initWithFrame:CGRectMake(0, -200, screenSize.width, screenSize.height) WithDelegate:self];
    [infiniteScrollPicker setUserInteractionEnabled:YES];
    
    if(IS_IPHONE_4 || IS_IPHONE_5)
    {
        infiniteScrollPicker.frame = CGRectMake(0, -50, screenSize.width, screenSize.height);
    }
    
    [infiniteScrollPicker setSportsImagesArray];
    [infiniteScrollPicker setHeightOffset:20];
    [infiniteScrollPicker setPositionRatio:2];
    [infiniteScrollPicker setAlphaOfobjs:0.7];
    [[[CCDirector sharedDirector] view] addSubview:infiniteScrollPicker];
    
    closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, 0, 64, 64);
    [closeButton setImage:[UIImage imageNamed:@"close_iPhone.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeScrollView) forControlEvents:UIControlEventTouchUpInside];
    [[[CCDirector sharedDirector] view] addSubview:closeButton];
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
}

- (void)personalitiesCategorySelected:(UIButton *)sender
{
    infiniteScrollPicker = [[InfiniteScrollPicker alloc] initWithFrame:CGRectMake(0, -200, screenSize.width, screenSize.height) WithDelegate:self];
    [infiniteScrollPicker setUserInteractionEnabled:YES];
    
    if(IS_IPHONE_4 || IS_IPHONE_5)
    {
        infiniteScrollPicker.frame = CGRectMake(0, -50, screenSize.width, screenSize.height);
    }
    
    [infiniteScrollPicker setPersonalitiesImagesArray];
    [infiniteScrollPicker setHeightOffset:20];
    [infiniteScrollPicker setPositionRatio:2];
    [infiniteScrollPicker setAlphaOfobjs:0.7];
    
    [[[CCDirector sharedDirector] view] addSubview:infiniteScrollPicker];
    
    closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, 0, 64, 64);
    [closeButton setImage:[UIImage imageNamed:@"close_iPhone.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeScrollView) forControlEvents:UIControlEventTouchUpInside];
    [[[CCDirector sharedDirector] view] addSubview:closeButton];
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}

- (void)closeScrollView
{
    infiniteScrollPicker.hidden = YES;
    closeButton.hidden = YES;
}


- (void)btnClicked:(UIButton *)sender {
    
    [AudioHelper playStart];

    NSLog(@"**CustomScrollViewBtnClicked = %d", sender.tag);
    
    for (UIView *view in [[[CCDirector sharedDirector] view] subviews]) {
        UIButton *btnObj = (UIButton *)view;
        if([btnObj isKindOfClass:[UIButton class]])
        {
            [btnObj removeFromSuperview];
        }
    }
    
    [infiniteScrollPicker removeFromSuperview];
    
    
    int pos = sender.tag % 6;
    NSLog(@"**Pos = %d", pos);
    
//    NSString *buttonStatus = (__bridge NSString *)sender.observationInfo;
//    NSLog(@"****ButtonStatus = %@", buttonStatus);
    
    NSString *imageName = @"";
    if(IS_IPHONE_4 || IS_IPHONE_5)
    {
        imageName =  [NSString stringWithFormat:@"Letter%d_iPhone.png", pos + 1];
    }
    else
    {
        imageName =  [NSString stringWithFormat:@"Letter%d.png", pos + 1];
    }
    NSLog(@"**imageName = %@", imageName);
    
    [[GameManager sharedGameManager] runSceneWithID:kCategorySelection withParameter:imageName];
    
    
    //    if ([buttonStatus isEqualToString:@"UNLOCKED"]) {
    //        [[GameManager sharedGameManager] runSceneWithID:kLevelEasy withParameter:imageName];
    //    }
    //    else {
    //        [self startViewAnimation:NO];
    //    }
}


- (void)onExitTransitionDidStart
{
    
}

- (void)onExit
{
    [[[GameManager sharedGameManager] bannerView] removeFromSuperview];
    
    [selectcategoryLabel removeFromSuperview];
    
    [emitter resetSystem];
    [self removeAllChildrenWithCleanup:YES];
}

@end
