//
//  HomeScreenLayer.m
//  jigsawTest
//
//  Created by admin on 6/27/14.
//  Copyright (c) 2014 BITLANTIC. All rights reserved.
//

#import "HomeScreenLayer.h"
#import "LevelSelectionLayer.h"
#import "GameConstants.h"
#import "GameManager.h"
#import "GameHelper.h"
#import "ImageHelper.h"
#import <MobileCoreServices/UTCoreTypes.h>

#import "AVCamViewController.h"

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
    NSLog(@"**HomeScreenLayer**");
    
    cameraSelected = NO;

    screenSize = [[CCDirector sharedDirector] winSize];
    [self initBackground];
}

- (void)initBackground
{
    [self scheduleOnce:@selector(rotateGlobe:) delay:0.0];

    CCSprite *background;
    background = [CCSprite spriteWithFile:@"newhomebg_ipad.png"];
    
    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        background = [CCSprite spriteWithFile:@"newhomebg_iphone.jpg"];
    }
    
//    background.anchorPoint = ccp(0, 0);
    [background setPosition:ccp(screenSize.width/2, screenSize.height/2)];
    [self addChild:background];
    
}

- (void)rotateGlobe:(ccTime)dt
{
    CCSprite *globe;
    
    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        globe = [CCSprite spriteWithFile:@"globe_iphone.png"];
        [globe setPosition:ccp(screenSize.width/2, screenSize.height/2+10)];
    }
    else
    {
        globe = [CCSprite spriteWithFile:@"globe_ipad.png"];
        [globe setPosition:ccp(screenSize.width/2+12, screenSize.height/2+25)];
    }
    
//    globe.anchorPoint = ccp(0, 0);
    [self addChild:globe];
    
//    CCRotateBy *rot = [CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:2 angle: 720]];
    CCRotateBy *rot = [CCRotateBy actionWithDuration: 1 angle: 720];
    [globe runAction:rot];

}

- (void)orientationChanged:(NSNotification *)notification
{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation) && !isShowingLandscapeView)
    {
        isShowingLandscapeView = YES;
    }
    else if (UIDeviceOrientationIsPortrait(deviceOrientation) && isShowingLandscapeView)
    {
        isShowingLandscapeView = NO;
    }
}

- (void)onEnterTransitionDidFinish
{
    isShowingLandscapeView = NO;
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    NSLog(@"CURRENT ORIENTATION:: %d", orientation);
    
    sendTag = 0;
    
    soundEngine = [SimpleAudioEngine sharedEngine];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"CAMERAALBUM"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self scheduleOnce:@selector(initParticles:) delay:1.0];
    [self placeCategoryButtons];    
    [self scheduleOnce:@selector(initAlbumButton:) delay:3.0];
    [self scheduleOnce:@selector(initCameraButton:) delay:3.0];
    [self scheduleOnce:@selector(addBanerViewAds:) delay:2.0];
    
    
    
    buyCategories = [UIButton buttonWithType:UIButtonTypeCustom];
    buyCategories.frame = CGRectMake(screenSize.width-125, 550, 116, 112);
    [buyCategories setBackgroundImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
    [buyCategories setTitle:@"More Items" forState:UIControlStateNormal];
    buyCategories.backgroundColor = [UIColor clearColor];
    [buyCategories addTarget:self action:@selector(showNewCategories) forControlEvents:UIControlEventTouchUpInside];
    [[[CCDirector sharedDirector] view] addSubview:buyCategories];
    
    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        buyCategories.frame = CGRectMake(screenSize.width-55, 235, 50, 48);
        [buyCategories setBackgroundImage:[UIImage imageNamed:@"camera_iphone.png"] forState:UIControlStateNormal];
    }
   
//    itemNotPurchased = [[UILabel alloc] init];
//    itemNotPurchased.frame = CGRectMake(20, 200, 200, 34);
//    itemNotPurchased.text = @"Item Not Purchased";
//    itemNotPurchased.textColor = [UIColor orangeColor];
//    itemNotPurchased.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    [[[CCDirector sharedDirector] view] addSubview:itemNotPurchased];
}


/////////////////////////////////////////////////////////////////////////////////
- (void)showNewCategories
{
//    animalLabel.hidden = YES;
//    buildingLabel.hidden = YES;
//    carLabel.hidden = YES;
//    sportsLabel.hidden = YES;
//    fruitsLabel.hidden = YES;
//    personalitiesLabel.hidden = YES;
//    
//    
//    buyCategories.hidden = YES;
//    itemNotPurchased.hidden = YES;
    
//    bitla@test.com
//    Bitlantic1
    
    [emitter resetSystem];

    PurchaseViewController *purchaseView = [[PurchaseViewController alloc] init];
    purchaseView.mainPuzzle = @"My Puzzles";
    [[[CCDirector sharedDirector] self].navigationController pushViewController:purchaseView animated:YES];
    
}


/////////////////////////////////////////////////////////////////////////////////


-(void) initCameraButton:(ccTime)dt
{
    [CCAnimationCache purgeSharedAnimationCache];
    [[CCDirector sharedDirector] purgeCachedData];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    CCSprite *normal;
    normal = [CCSprite spriteWithFile:@"camera.png"];
    CCSprite *selected;
    selected = [CCSprite spriteWithFile:@"camera.png"];
    
    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        normal = [CCSprite spriteWithFile:@"camera_iphone.png"];
        selected = [CCSprite spriteWithFile:@"camera_iphone.png"];
    }
    
    albumButton = [CCMenuItemSprite itemWithNormalSprite:normal selectedSprite:selected target:self selector:@selector(startCamera)];
    albumButton.position = ccp(screenSize.height-50, screenSize.height-50);
    albumButton.isEnabled = YES;
    
    
    CCMenu *menu = [CCMenu menuWithItems:albumButton, nil];
    [menu alignItemsHorizontallyWithPadding:40];
    [menu setPosition: ccp(70, 700)];
    
    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        [menu setPosition: ccp(30, 290)];
    }
    
    [self addChild:menu z:7 tag:7];
}


-(void) initAlbumButton:(ccTime)dt
{
    cameraSelected = NO;
    
    [CCAnimationCache purgeSharedAnimationCache];
    [[CCDirector sharedDirector] purgeCachedData];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    CCSprite *normal;
     normal = [CCSprite spriteWithFile:@"photogallery.png"];
    CCSprite *selected;
    selected = [CCSprite spriteWithFile:@"photogallery.png"];
    
    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        normal = [CCSprite spriteWithFile:@"photogallery_iphone.png"];
        selected = [CCSprite spriteWithFile:@"photogallery_iphone.png"];
    }
    
    
    cameraButtonSprite = [CCMenuItemSprite itemWithNormalSprite:normal selectedSprite:selected target:self selector:@selector(showPhotoLibrary)];
    cameraButtonSprite.position = ccp(screenSize.width-60, screenSize.height-50);
    cameraButtonSprite.isEnabled = YES;

    
    CCMenu *menu = [CCMenu menuWithItems:cameraButtonSprite, nil];
    [menu alignItemsHorizontallyWithPadding:40];
    [menu setPosition: ccp(screenSize.width - 70, 700)];
    
    
    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        [menu setPosition: ccp(screenSize.width - 30, 290)];
    }
    
    [self addChild:menu z:7 tag:7];

}

- (void)openCamera
{
    animalLabel.hidden = YES;
    buildingLabel.hidden = YES;
    carLabel.hidden = YES;
    sportsLabel.hidden = YES;
    fruitsLabel.hidden = YES;
    personalitiesLabel.hidden = YES;
    
    AVCamViewController *camView = [[AVCamViewController alloc] init];
//    [[[CCDirector sharedDirector] navigationController] pushViewController:camView animated:YES];
    
    [[CCDirector sharedDirector] presentViewController:camView animated:YES completion:NULL];

}


-(void) startCamera
{
    [soundEngine playEffect:@"pop.mp3"];

    [CCAnimationCache purgeSharedAnimationCache];
    [[CCDirector sharedDirector] purgeCachedData];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
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
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            cameraSelected = YES;

            [director presentViewController:_picker animated:YES completion:nil];
        }
        else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            [self openCamera];
        }
    }
    else
    {
        CGRect r = CGRectMake(screenSize.width/2, 0, 10, 10);
        _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
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
}


-(void) showPhotoLibrary
{
    [soundEngine playEffect:@"pop.mp3"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [paths stringByAppendingPathComponent:@"image.png"];
    [fileManager removeItemAtPath:filePath error:NULL];
    

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        self.specialLibrary = library;

        NSMutableArray *groups = [NSMutableArray array];
        [_specialLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group) {
                [groups addObject:group];
            } else {
                // this is the end
                [self displayPickerForGroup:[groups objectAtIndex:0]];
            }
        } failureBlock:^(NSError *error) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            
            NSLog(@"A problem occured %@", [error description]);
            // an error here means that the asset groups were inaccessable.
            // Maybe the user or system preferences refused access.
        }];
    }
    else
    {
        if (_picker) {
            [_picker dismissViewControllerAnimated:YES completion:nil];
            [_picker.view removeFromSuperview];
        }
        if (_popover) {
            [_popover dismissPopoverAnimated:NO];
        }
        CCDirector * director = [CCDirector sharedDirector];
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
            
        }
    }
}

- (void)displayPickerForGroup:(ALAssetsGroup *)group
{
	ELCAssetTablePicker *tablePicker = [[ELCAssetTablePicker alloc] initWithNibName: nil bundle: nil];
    tablePicker.singleSelection = YES;
    tablePicker.immediateReturn = YES;
    
	ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:tablePicker];
    elcPicker.delegate = self;
	tablePicker.parent = elcPicker;
    
    // Move me
    tablePicker.assetGroup = group;
    [tablePicker.assetGroup setAssetsFilter:[ALAssetsFilter allAssets]];
    
    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)])
    {
//        [self presentViewController:elcPicker animated:YES completion:nil];
        
        [[CCDirector sharedDirector] presentViewController:elcPicker animated:YES completion:nil];
    }
    else
    {
//        [self presentModalViewController:elcPicker animated:YES];
        
        [[CCDirector sharedDirector] presentViewController:elcPicker animated:YES completion:nil];
    }
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    }
}

#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
    {
        [[CCDirector sharedDirector] dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [[CCDirector sharedDirector] dismissViewControllerAnimated:YES completion:nil];
    }
    
    
    CGSize imageSize = CGSizeMake(693, 480);

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if(IS_IPHONE_5 || IS_IPHONE_4)
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
    }

    
    UIImage *originalImage = nil;
    for(NSDictionary *dict in info)
    {
        originalImage = [dict objectForKey:UIImagePickerControllerOriginalImage];
        originalImage = [ImageHelper cropImage:originalImage toSize:imageSize];

        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            originalImage = [self imageResize:originalImage andResizeTo:CGSizeMake(324, 224)];

	}

    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    {
        NSLog(@"SCALE:: %f", [UIScreen mainScreen].scale);
    }
    
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
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *pngData = nil;
    pngData = UIImagePNGRepresentation(originalImage);
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath1 = [paths1 objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath1 stringByAppendingPathComponent:@"image.png"]; //Add the file name
    [fileManager removeItemAtPath:filePath error:NULL];
    [pngData writeToFile:filePath atomically:YES]; //Write the file
    
    NSLog(@"IMAGES filePath:: %@", filePath);
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HOMEPAGE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    for (UIView *view in [[[CCDirector sharedDirector] view] subviews]) {
        UIButton *btnObj = (UIButton *)view;
        if([btnObj isKindOfClass:[UIButton class]])
        {
            [btnObj removeFromSuperview];
        }
    }
    
    animalLabel.hidden = YES;
    buildingLabel.hidden = YES;
    carLabel.hidden = YES;
    sportsLabel.hidden = YES;
    fruitsLabel.hidden = YES;
    personalitiesLabel.hidden = YES;
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"CAMERAALBUM"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[CCDirector sharedDirector] runWithScene:[CCTransitionFadeTR transitionWithDuration:1.0 scene:[LevelSelectionLayer sceneParameter:filePath]]];
    
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
    {
        [[CCDirector sharedDirector] dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [[CCDirector sharedDirector] dismissViewControllerAnimated:YES completion:nil];
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
    CGSize imageSize = CGSizeMake(693, 480);
    
    if([GameHelper isRetinaIpad])
    {
        imageSize.width = imageSize.width * 2;
        imageSize.height = imageSize.height * 2;
    }
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if(IS_IPHONE_5 || IS_IPHONE_4)
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
    }
    
    
    UIImage *originalImage = nil;
    originalImage = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];
    originalImage = [ImageHelper cropImage:originalImage toSize:imageSize];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        originalImage = [self imageResize:originalImage andResizeTo:CGSizeMake(324, 224)];
    
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
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSData *pngData = nil;
    pngData = UIImagePNGRepresentation(originalImage);
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath1 = [paths1 objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath1 stringByAppendingPathComponent:@"image.png"]; //Add the file name
    [fileManager removeItemAtPath:filePath error:NULL];
    [pngData writeToFile:filePath atomically:YES]; //Write the file
    
    NSLog(@"IMAGES filePath:: %@", filePath);
    
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HOMEPAGE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    for (UIView *view in [[[CCDirector sharedDirector] view] subviews]) {
        UIButton *btnObj = (UIButton *)view;
        if([btnObj isKindOfClass:[UIButton class]])
        {
            [btnObj removeFromSuperview];
        }
    }
    
    animalLabel.hidden = YES;
    buildingLabel.hidden = YES;
    carLabel.hidden = YES;
    sportsLabel.hidden = YES;
    fruitsLabel.hidden = YES;
    personalitiesLabel.hidden = YES;
    
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"CAMERAALBUM"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[CCDirector sharedDirector] runWithScene:[CCTransitionFadeTR transitionWithDuration:1.0 scene:[LevelSelectionLayer sceneParameter:filePath]]];
}


- (UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize
{
    CGFloat scale = [[UIScreen mainScreen]scale];
    /*You can remove the below comment if you dont want to scale the image in retina   device .Dont forget to comment UIGraphicsBeginImageContextWithOptions*/
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo: (void *) contextInfo;
{
    
}

- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
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
    if(IS_IPHONE_4)
    {
        emitter.texture = [[CCTextureCache sharedTextureCache] addImage: @"snow_iphone.png"];
    }
    else
    {
        emitter.texture = [[CCTextureCache sharedTextureCache] addImage: @"snow.png"];
    }
    [self addChild: emitter];
}


#pragma mark Place Category Buttons
- (void)buildingBtn:(ccTime)delay
{

    [soundEngine playEffect:@"shine_sound_2.mp3"];
    
    CCSprite *selectedSpriteBuilding = [[CCSprite alloc] initWithFile:@"buildingselected.png"];
    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        selectedSpriteBuilding = [[CCSprite alloc] initWithFile:@"buildingselected_iphone.png"];
    }
    buildingButton = [CCMenuItemSprite itemWithNormalSprite:selectedSpriteBuilding selectedSprite:nil target:self selector:@selector(buildingCategorySelected:)];
    buildingButton.scale = 0.1f;
    buildingButton.isEnabled = NO;
    
    buildingButton.tag = 2;


    CCMenu *menu2 = [CCMenu menuWithItems:buildingButton, nil];
    [menu2 setPosition:ccp(448-64-64-64, 510)];
    
    if(IS_IPHONE_5)
    {
        [menu2 setPosition:ccp(257-27-27-27, 210)];
    }
    
    if(IS_IPHONE_4)
    {
        [menu2 setPosition:ccp(213-27-27-27, 210)];
    }
    
    [buildingButton runAction:[CCSequence actions:
                             [CCScaleTo actionWithDuration:0.5f scale:1.3f],
                             [CCScaleTo actionWithDuration:0.5f scale:1.0f], nil]];
    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        [buildingButton runAction:[CCSequence actions:
                                 [CCScaleTo actionWithDuration:0.5f scale:1.2f],
                                 [CCScaleTo actionWithDuration:0.5f scale:1.0f], nil]];
    }

    [self addChild:menu2 z:80 tag:70];

}

- (void)sportsBtn:(ccTime)delay
{

    [soundEngine playEffect:@"shine_sound_2.mp3"];

    CCSprite *selectedSpriteSport = [[CCSprite alloc] initWithFile:@"sportselected.png"];
    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        selectedSpriteSport = [[CCSprite alloc] initWithFile:@"sportselected_iphone.png"];
    }
    sportsButton = [CCMenuItemSprite itemWithNormalSprite:selectedSpriteSport selectedSprite:nil target:self selector:@selector(sportsCategorySelected:)];
    sportsButton.scale = 0.1f;
    sportsButton.isEnabled = NO;
    
    sportsButton.tag = 4;

    CCMenu *menu4 = [CCMenu menuWithItems:sportsButton, nil];
    [menu4 setPosition:ccp(448-64-64-64, 320)];
    
    if(IS_IPHONE_5)
    {
        [menu4 setPosition:ccp(257-27-27-27, 130)];
    }
    
    if(IS_IPHONE_4)
    {
        [menu4 setPosition:ccp(213-27-27-27, 130)];
    }
    
    [sportsButton runAction:[CCSequence actions:
                             [CCScaleTo actionWithDuration:0.5f scale:1.3f],
                             [CCScaleTo actionWithDuration:0.5f scale:1.0f], nil]];
    
    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        [sportsButton runAction:[CCSequence actions:
                                 [CCScaleTo actionWithDuration:0.5f scale:1.2f],
                                 [CCScaleTo actionWithDuration:0.5f scale:1.0f], nil]];
    }

    [self addChild:menu4 z:80 tag:70];
}

- (void)personalitiesBtn:(ccTime)delay
{

    [soundEngine playEffect:@"shine_sound_2.mp3"];

    CCSprite *selectedSpritePersonality = [[CCSprite alloc] initWithFile:@"personalityselected.png"];
    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        selectedSpritePersonality = [[CCSprite alloc] initWithFile:@"personalityselected_iphone.png"];
    }
    personalitiesButton = [CCMenuItemSprite itemWithNormalSprite:selectedSpritePersonality selectedSprite:nil target:self selector:@selector(personalitiesCategorySelected:)];
    personalitiesButton.scale = 0.1f;
    personalitiesButton.isEnabled = NO;
    
    personalitiesButton.tag = 6;

    CCMenu *menu6 = [CCMenu menuWithItems:personalitiesButton, nil];
    [menu6 setPosition:ccp(448+64, 185)];
    if(IS_IPHONE_5)
    {
        [menu6 setPosition:ccp(257+27, 84)];
    }
    
    if(IS_IPHONE_4)
    {
        [menu6 setPosition:ccp(213+27, 84)];
    }
    
    [personalitiesButton runAction:[CCSequence actions:
                             [CCScaleTo actionWithDuration:0.5f scale:1.3f],
                             [CCScaleTo actionWithDuration:0.5f scale:1.0f], nil]];
    
    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        [personalitiesButton runAction:[CCSequence actions:
                                 [CCScaleTo actionWithDuration:0.5f scale:1.2f],
                                 [CCScaleTo actionWithDuration:0.5f scale:1.0f], nil]];
    }

    [self addChild:menu6 z:80 tag:70];

}

- (void)fruitsBtn:(ccTime)delay
{
    [soundEngine playEffect:@"shine_sound_2.mp3"];

    CCSprite *selectedSpriteFruit = [[CCSprite alloc] initWithFile:@"fruitsselected.png"];
    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        selectedSpriteFruit = [[CCSprite alloc] initWithFile:@"fruitsselected_iphone.png"];
    }
    fruitsButton1 = [CCMenuItemSprite itemWithNormalSprite:selectedSpriteFruit selectedSprite:nil target:self selector:@selector(fruitsCategorySelected:)];
    fruitsButton1.scale = 0.1f;
    fruitsButton1.isEnabled = NO;
    
    fruitsButton1.tag = 5;
    
    CCMenu *menu5 = [CCMenu menuWithItems:fruitsButton1, nil];
    [menu5 setPosition:ccp(448+128+128+64, 320)];
    
    if(IS_IPHONE_5)
    {
        [menu5 setPosition:ccp(257+54+54+27, 130)];
    }
    
    if(IS_IPHONE_4)
    {
        [menu5 setPosition:ccp(213+54+54+27, 130)];
    }
    
    [fruitsButton1 runAction:[CCSequence actions:
                             [CCScaleTo actionWithDuration:0.5f scale:1.3f],
                             [CCScaleTo actionWithDuration:0.5f scale:1.0f], nil]];
    
    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        [fruitsButton1 runAction:[CCSequence actions:
                                 [CCScaleTo actionWithDuration:0.5f scale:1.2f],
                                 [CCScaleTo actionWithDuration:0.5f scale:1.0f], nil]];
    }

    [self addChild:menu5 z:80 tag:70];
}

- (void)carsBtn:(ccTime)delay
{
    [soundEngine playEffect:@"shine_sound_2.mp3"];


    CCSprite *selectedSpriteCar = [[CCSprite alloc] initWithFile:@"carselected.png"];
    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        selectedSpriteCar = [[CCSprite alloc] initWithFile:@"carselected_iphone.png"];
    }
    carButton = [CCMenuItemSprite itemWithNormalSprite:selectedSpriteCar selectedSprite:nil target:self selector:@selector(carCategorySelected:)];
    carButton.scale = 0.1f;
    carButton.isEnabled = NO;
    
    carButton.tag = 3;

    CCMenu *menu3 = [CCMenu menuWithItems:carButton, nil];
    [menu3 setPosition:ccp(448+128+128+64, 510)];
    
    if(IS_IPHONE_5)
    {
        [menu3 setPosition:ccp(257+54+54+27, 210)];
    }
    
    if(IS_IPHONE_4)
    {
        [menu3 setPosition:ccp(213+54+54+27, 210)];
    }
    
    [carButton runAction:[CCSequence actions:
                             [CCScaleTo actionWithDuration:0.5f scale:1.3f],
                             [CCScaleTo actionWithDuration:0.5f scale:1.0f], nil]];
    
    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        [carButton runAction:[CCSequence actions:
                                 [CCScaleTo actionWithDuration:0.5f scale:1.2f],
                                 [CCScaleTo actionWithDuration:0.5f scale:1.0f], nil]];
    }

    [self addChild:menu3 z:80 tag:70];
    
    animalButton.isEnabled = YES;
    buildingButton.isEnabled = YES;
    sportsButton.isEnabled = YES;
    personalitiesButton.isEnabled = YES;
    fruitsButton1.isEnabled = YES;
    carButton.isEnabled = YES;
    
    
    cameraButtonSprite.isEnabled = YES;
    albumButton.isEnabled = YES;
}


- (void)placeCategoryButtons
{
    [[CCDirector sharedDirector] view].multipleTouchEnabled = NO;
    [[CCDirector sharedDirector] view].exclusiveTouch = YES;

    CCSprite *selectedSpriteAnimal = [[CCSprite alloc] initWithFile:@"animalselected.png"];
    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        selectedSpriteAnimal = [[CCSprite alloc] initWithFile:@"animalselected_iphone.png"];
    }
    animalButton = [CCMenuItemSprite itemWithNormalSprite:selectedSpriteAnimal selectedSprite:nil target:self selector:@selector(animalCategorySelected:)];
    animalButton.scale = 0.1f;
    animalButton.isEnabled = NO;
    animalButton.tag = 1;
    
    cameraButtonSprite.isEnabled = NO;
    albumButton.isEnabled = NO;
    
    CCMenu *menu1 = [CCMenu menuWithItems:animalButton, nil];
    [menu1 setPosition:ccp(448+64, 660)];
    if(IS_IPHONE_5)
    {
        [menu1 setPosition:ccp(257+27, 275)];
    }
    
    if(IS_IPHONE_4)
    {
        [menu1 setPosition:ccp(213+27, 275)];
    }
    
    [animalButton runAction:[CCSequence actions:
                         [CCScaleTo actionWithDuration:0.5f scale:1.3f],
                         [CCScaleTo actionWithDuration:0.5f scale:1.0f], nil]];
    
    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        [animalButton runAction:[CCSequence actions:
                                 [CCScaleTo actionWithDuration:0.5f scale:1.2f],
                                 [CCScaleTo actionWithDuration:0.5f scale:1.0f], nil]];
    }
    [self addChild:menu1 z:80 tag:70];

    ;
    [soundEngine playEffect:@"shine_sound_2.mp3"];
    
    [self scheduleOnce:@selector(buildingBtn:) delay:0.5f];
    [self scheduleOnce:@selector(sportsBtn:) delay:1.0f];
    [self scheduleOnce:@selector(personalitiesBtn:) delay:1.5f];
    [self scheduleOnce:@selector(fruitsBtn:) delay:2.0f];
    [self scheduleOnce:@selector(carsBtn:) delay:2.5f];

    
    animalLabel = [[UILabel alloc] init];
    animalLabel.backgroundColor = [UIColor clearColor];
    animalLabel.text = @"ANIMALS";
    animalLabel.textAlignment = NSTextAlignmentCenter;
    animalLabel.textColor = [UIColor yellowColor];
    [[[CCDirector sharedDirector] view] addSubview:animalLabel];

    
    buildingLabel = [[UILabel alloc] init];
    buildingLabel.backgroundColor = [UIColor clearColor];
    buildingLabel.text = @"BUILDINGS";
    buildingLabel.textAlignment = NSTextAlignmentCenter;
    buildingLabel.textColor = [UIColor yellowColor];
    [[[CCDirector sharedDirector] view] addSubview:buildingLabel];
    
    
    carLabel = [[UILabel alloc] init];
    carLabel.backgroundColor = [UIColor clearColor];
    carLabel.text = @"CARS";
    carLabel.textAlignment = NSTextAlignmentCenter;
    carLabel.textColor = [UIColor yellowColor];
    [[[CCDirector sharedDirector] view] addSubview:carLabel];
    
    
    sportsLabel = [[UILabel alloc] init];
    sportsLabel.backgroundColor = [UIColor clearColor];
    sportsLabel.text = @"SPORTS";
    sportsLabel.textAlignment = NSTextAlignmentCenter;
    sportsLabel.textColor = [UIColor yellowColor];
    [[[CCDirector sharedDirector] view] addSubview:sportsLabel];

    
    fruitsLabel = [[UILabel alloc] init];
    fruitsLabel.backgroundColor = [UIColor clearColor];
    fruitsLabel.text = @"FRUITS";
    fruitsLabel.textAlignment = NSTextAlignmentCenter;
    fruitsLabel.textColor = [UIColor yellowColor];
    [[[CCDirector sharedDirector] view] addSubview:fruitsLabel];
    
    
    personalitiesLabel = [[UILabel alloc] init];
    personalitiesLabel.backgroundColor = [UIColor clearColor];
    personalitiesLabel.numberOfLines = 2;
    personalitiesLabel.text = @"FAMOUS PERSONALITIES";
    personalitiesLabel.textAlignment = NSTextAlignmentCenter;
    personalitiesLabel.textColor = [UIColor yellowColor];
    [[[CCDirector sharedDirector] view] addSubview:personalitiesLabel];
    
    if(IS_IPHONE_5)
    {
        animalLabel.frame = CGRectMake(244, 72, 80, 16);
        animalLabel.font = [UIFont fontWithName:@"Marker Felt" size:11.0];

        buildingLabel.frame = CGRectMake(244-27-27-27-27, 138, 80, 16);
        buildingLabel.font = [UIFont fontWithName:@"Marker Felt" size:11.0];

        carLabel.frame = CGRectMake(244+27+27+27+27, 138, 80, 16);
        carLabel.font = [UIFont fontWithName:@"Marker Felt" size:11.0];

        sportsLabel.frame = CGRectMake(244-27-27-27-27, 218, 80, 16);
        sportsLabel.font = [UIFont fontWithName:@"Marker Felt" size:11.0];

        fruitsLabel.frame = CGRectMake(244+27+27+27+27, 218, 80, 16);
        fruitsLabel.font = [UIFont fontWithName:@"Marker Felt" size:11.0];

        personalitiesLabel.frame = CGRectMake(244-10, 264, 80+20, 26);
        personalitiesLabel.font = [UIFont fontWithName:@"Marker Felt" size:11.0];

    }
    else if (IS_IPHONE_4)
    {
        animalLabel.frame = CGRectMake(200, 72, 80, 16);
        animalLabel.font = [UIFont fontWithName:@"Marker Felt" size:11.0];
        
        buildingLabel.frame = CGRectMake(200-27-27-27-27, 138, 80, 16);
        buildingLabel.font = [UIFont fontWithName:@"Marker Felt" size:11.0];
        
        carLabel.frame = CGRectMake(200+27+27+27+27, 138, 80, 16);
        carLabel.font = [UIFont fontWithName:@"Marker Felt" size:11.0];
        
        sportsLabel.frame = CGRectMake(200-27-27-27-27, 218, 80, 16);
        sportsLabel.font = [UIFont fontWithName:@"Marker Felt" size:11.0];
        
        fruitsLabel.frame = CGRectMake(200+27+27+27+27, 218, 80, 16);
        fruitsLabel.font = [UIFont fontWithName:@"Marker Felt" size:11.0];
        
        personalitiesLabel.frame = CGRectMake(200-10, 264, 80+20, 26);
        personalitiesLabel.font = [UIFont fontWithName:@"Marker Felt" size:11.0];
    }
    else
    {
        animalLabel.frame = CGRectMake(448, 128+40, 128, 44);
        animalLabel.font = [UIFont fontWithName:@"Marker Felt" size:24.0];
        
        buildingLabel.frame = CGRectMake(448-128-64-64, 325, 128, 44);
        buildingLabel.font = [UIFont fontWithName:@"Marker Felt" size:24.0];
        
        carLabel.frame = CGRectMake(448+128+64+64, 325, 128, 44);
        carLabel.font = [UIFont fontWithName:@"Marker Felt" size:24.0];
        
        sportsLabel.frame = CGRectMake(448-128-64-64, 510, 128, 44);
        sportsLabel.font = [UIFont fontWithName:@"Marker Felt" size:24.0];
        
        fruitsLabel.frame = CGRectMake(448+128+64+64, 510, 128, 44);
        fruitsLabel.font = [UIFont fontWithName:@"Marker Felt" size:24.0];
        
        personalitiesLabel.frame = CGRectMake(448-10, 650, 128+20, 60);
        personalitiesLabel.font = [UIFont fontWithName:@"Marker Felt" size:24.0];
    }
    
    
//    [UIView animateWithDuration:1.75
//                          delay:0.1
//                        options:UIViewAnimationOptionCurveLinear
//                     animations:^{
//                         [UIView setAnimationDelegate:self];
//                         
////                         [UIView setAnimationDidStopSelector:@selector(moveToLeft:finished:context:)];
//                         
////                         animalButton.frame = CGRectMake(screenSize.width/2-128/2, 40, 128, 128);
////                         animalLabel.frame = CGRectMake(animalButton.frame.origin.x, animalButton.frame.origin.y+animalButton.frame.size.height, 128, 34);
////
////                         buildingButton.frame = CGRectMake(200, 200, 128, 128);
////                         buildingLabel.frame = CGRectMake(buildingButton.frame.origin.x, buildingButton.frame.origin.y+buildingButton.frame.size.height, 128, 34);
////                         
////                         carButton.frame = CGRectMake(700, 200, 128, 128);
////                         carLabel.frame = CGRectMake(carButton.frame.origin.x, carButton.frame.origin.y+carButton.frame.size.height, 128, 34);
////                         
////                         sportsButton.frame = CGRectMake(200, 405, 128, 128);
////                         sportsLabel.frame = CGRectMake(sportsButton.frame.origin.x, sportsButton.frame.origin.y+sportsButton.frame.size.height, 128, 34);
////                         
////                         fruitsButton1.frame = CGRectMake(700, 405, 128, 128);
////                         fruitsLabel.frame = CGRectMake(fruitsButton1.frame.origin.x, fruitsButton1.frame.origin.y+fruitsButton1.frame.size.height, 128, 34);
////                         
////                         personalitiesButton.frame = CGRectMake(screenSize.width/2-125/2, 520, 128, 128);
////                         personalitiesLabel.frame = CGRectMake(personalitiesButton.frame.origin.x-10, personalitiesButton.frame.origin.y+personalitiesButton.frame.size.height, 128+20, 60);
//                         
//                         cameraButton.isEnabled = YES;
//                         albumButton.isEnabled = YES;
//
//                         
//                     }
//                     completion:^(BOOL finished)
//                    {
//                         NSLog(@"Face left done");
//                         
//                     }];

    
//    CCSprite *audioBtn = [CCSprite spriteWithFile:@"audio.jpeg"];
//    CCMenuItemSprite *audio = [CCMenuItemSprite itemWithNormalSprite:audioBtn selectedSprite:nil target:self selector:@selector(audioBtnSelected)];
//    CCMenu *audioMenu = [CCMenu menuWithItems:audio, nil];
//    [audioMenu setPosition:ccp(900, 100 )];
//    [self addChild:audioMenu];
    
}

#pragma mark - CategoryButtons Selection

- (void)hidingViews
{
    animalButton.visible = NO;
    buildingButton.visible = NO;
    carButton.visible = NO;
    sportsButton.visible = NO;
    fruitsButton1.visible = NO;
    personalitiesButton.visible = NO;
    
    animalLabel.hidden = YES;
    buildingLabel.hidden = YES;
    carLabel.hidden = YES;
    sportsLabel.hidden = YES;
    fruitsLabel.hidden = YES;
    personalitiesLabel.hidden = YES;
    
    cameraButtonSprite.visible = NO;
    albumButton.visible = NO;
}

- (void)animalCategorySelected:(UIButton *)sender
{
    NSLog(@"SELECTED CATEGORY TAG:: %d", sender.tag);
    
    sendTag = sender.tag;
    
    ;
    [soundEngine playEffect:@"categorySelected.mp3"];

    [self hidingViews];
    
    infiniteScrollPicker = [[InfiniteScrollPicker alloc] initWithFrame:CGRectMake(0, -200, screenSize.width, screenSize.height) WithDelegate:self];
    [infiniteScrollPicker setUserInteractionEnabled:YES];
    
    if(IS_IPHONE_4 || IS_IPHONE_5)
    {
        infiniteScrollPicker.frame = CGRectMake(0, -35, screenSize.width, screenSize.height);
    }
    
    [infiniteScrollPicker setAnimalsImagesArray];
    [infiniteScrollPicker setHeightOffset:20];
    [infiniteScrollPicker setPositionRatio:2];
    [infiniteScrollPicker setAlphaOfobjs:0.7];
    [[[CCDirector sharedDirector] view] addSubview:infiniteScrollPicker];
    
    closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(10, 10, 115, 116);
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close_ipad.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeScrollView) forControlEvents:UIControlEventTouchUpInside];
    [[[CCDirector sharedDirector] view] addSubview:closeButton];

    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        closeButton.frame = CGRectMake(2, 2, 58, 58);
        [closeButton setBackgroundImage:[UIImage imageNamed:@"close_iphone.png"] forState:UIControlStateNormal];
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}


- (void)buildingCategorySelected:(UIButton *)sender
{
    NSLog(@"SELECTED CATEGORY TAG:: %d", sender.tag);
    
    sendTag = sender.tag;

    ;
    [soundEngine playEffect:@"categorySelected.mp3"];
    

    [self hidingViews];

    infiniteScrollPicker = [[InfiniteScrollPicker alloc] initWithFrame:CGRectMake(0, -200, screenSize.width, screenSize.height) WithDelegate:self];
    [infiniteScrollPicker setUserInteractionEnabled:YES];
    
    if(IS_IPHONE_4 || IS_IPHONE_5)
    {
        infiniteScrollPicker.frame = CGRectMake(0, -35, screenSize.width, screenSize.height);
    }
    
    [infiniteScrollPicker setBuildingsImagesArray];
    [infiniteScrollPicker setHeightOffset:20];
    [infiniteScrollPicker setPositionRatio:2];
    [infiniteScrollPicker setAlphaOfobjs:0.7];
    [[[CCDirector sharedDirector] view] addSubview:infiniteScrollPicker];

    closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(10, 10, 115, 116);
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close_ipad.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeScrollView) forControlEvents:UIControlEventTouchUpInside];
    [[[CCDirector sharedDirector] view] addSubview:closeButton];
    
    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        closeButton.frame = CGRectMake(2, 2, 58, 58);
        [closeButton setBackgroundImage:[UIImage imageNamed:@"close_iphone.png"] forState:UIControlStateNormal];
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}

- (void)carCategorySelected:(UIButton *)sender
{
    NSLog(@"SELECTED CATEGORY TAG:: %d", sender.tag);
    
    sendTag = sender.tag;

    ;
    [soundEngine playEffect:@"categorySelected.mp3"];

    [self hidingViews];

    infiniteScrollPicker = [[InfiniteScrollPicker alloc] initWithFrame:CGRectMake(0, -200, screenSize.width, screenSize.height) WithDelegate:self];
    [infiniteScrollPicker setUserInteractionEnabled:YES];
    
    if(IS_IPHONE_4 || IS_IPHONE_5)
    {
        infiniteScrollPicker.frame = CGRectMake(0, -35, screenSize.width, screenSize.height);
    }
    
    [infiniteScrollPicker setCarsImagesArray];
    [infiniteScrollPicker setHeightOffset:20];
    [infiniteScrollPicker setPositionRatio:2];
    [infiniteScrollPicker setAlphaOfobjs:0.7];
    [[[CCDirector sharedDirector] view] addSubview:infiniteScrollPicker];

    closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(10, 10, 115, 116);
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close_ipad.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeScrollView) forControlEvents:UIControlEventTouchUpInside];
    [[[CCDirector sharedDirector] view] addSubview:closeButton];
    
    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        closeButton.frame = CGRectMake(2, 2, 58, 58);
        [closeButton setBackgroundImage:[UIImage imageNamed:@"close_iphone.png"] forState:UIControlStateNormal];
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
}

- (void)sportsCategorySelected:(UIButton *)sender
{
    NSLog(@"SELECTED CATEGORY TAG:: %d", sender.tag);
    
    sendTag = sender.tag;

    ;
    [soundEngine playEffect:@"categorySelected.mp3"];

    [self hidingViews];

    infiniteScrollPicker = [[InfiniteScrollPicker alloc] initWithFrame:CGRectMake(0, -200, screenSize.width, screenSize.height) WithDelegate:self];
    [infiniteScrollPicker setUserInteractionEnabled:YES];
    
    if(IS_IPHONE_4 || IS_IPHONE_5)
    {
        infiniteScrollPicker.frame = CGRectMake(0, -35, screenSize.width, screenSize.height);
    }
    
    [infiniteScrollPicker setSportsImagesArray];
    [infiniteScrollPicker setHeightOffset:20];
    [infiniteScrollPicker setPositionRatio:2];
    [infiniteScrollPicker setAlphaOfobjs:0.7];
    [[[CCDirector sharedDirector] view] addSubview:infiniteScrollPicker];
    
    closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(10, 10, 115, 116);
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close_ipad.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeScrollView) forControlEvents:UIControlEventTouchUpInside];
    [[[CCDirector sharedDirector] view] addSubview:closeButton];
    
    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        closeButton.frame = CGRectMake(2, 2, 58, 58);
        [closeButton setBackgroundImage:[UIImage imageNamed:@"close_iphone.png"] forState:UIControlStateNormal];
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
}

- (void)fruitsCategorySelected:(UIButton *)sender
{
    NSLog(@"SELECTED CATEGORY TAG:: %d", sender.tag);
    
    sendTag = sender.tag;

    ;
    [soundEngine playEffect:@"categorySelected.mp3"];

    [self hidingViews];

    infiniteScrollPicker = [[InfiniteScrollPicker alloc] initWithFrame:CGRectMake(0, -200, screenSize.width, screenSize.height) WithDelegate:self];
    [infiniteScrollPicker setUserInteractionEnabled:YES];
    
    if(IS_IPHONE_4 || IS_IPHONE_5)
    {
        infiniteScrollPicker.frame = CGRectMake(0, -35, screenSize.width, screenSize.height);
    }
    
    [infiniteScrollPicker setFruitsImagesArray];
    [infiniteScrollPicker setHeightOffset:20];
    [infiniteScrollPicker setPositionRatio:2];
    [infiniteScrollPicker setAlphaOfobjs:0.7];
    
    [[[CCDirector sharedDirector] view] addSubview:infiniteScrollPicker];
    
    closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(10, 10, 115, 116);
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close_ipad.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeScrollView) forControlEvents:UIControlEventTouchUpInside];
    [[[CCDirector sharedDirector] view] addSubview:closeButton];
    
    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        closeButton.frame = CGRectMake(2, 2, 58, 58);
        [closeButton setBackgroundImage:[UIImage imageNamed:@"close_iphone.png"] forState:UIControlStateNormal];
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
}

- (void)personalitiesCategorySelected:(UIButton *)sender
{
    NSLog(@"SELECTED CATEGORY TAG:: %d", sender.tag);
    
    sendTag = sender.tag;

    ;
    [soundEngine playEffect:@"categorySelected.mp3"];

    [self hidingViews];

    infiniteScrollPicker = [[InfiniteScrollPicker alloc] initWithFrame:CGRectMake(0, -200, screenSize.width, screenSize.height) WithDelegate:self];
    [infiniteScrollPicker setUserInteractionEnabled:YES];
    
    if(IS_IPHONE_4 || IS_IPHONE_5)
    {
        infiniteScrollPicker.frame = CGRectMake(0, -35, screenSize.width, screenSize.height);
    }
    
    [infiniteScrollPicker setPersonalitiesImagesArray];
    [infiniteScrollPicker setHeightOffset:20];
    [infiniteScrollPicker setPositionRatio:2];
    [infiniteScrollPicker setAlphaOfobjs:0.7];
    
    [[[CCDirector sharedDirector] view] addSubview:infiniteScrollPicker];
    
    closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(10, 10, 115, 116);
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close_ipad.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeScrollView) forControlEvents:UIControlEventTouchUpInside];
    [[[CCDirector sharedDirector] view] addSubview:closeButton];
    
    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        closeButton.frame = CGRectMake(2, 2, 58, 58);
        [closeButton setBackgroundImage:[UIImage imageNamed:@"close_iphone.png"] forState:UIControlStateNormal];
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}

- (void)closeScrollView
{
    //Showing views
    animalButton.visible = YES;
    buildingButton.visible = YES;
    carButton.visible = YES;
    sportsButton.visible = YES;
    fruitsButton1.visible = YES;
    personalitiesButton.visible = YES;
    
    cameraButtonSprite.visible = YES;
    albumButton.visible = YES;
    
    animalLabel.hidden = NO;
    buildingLabel.hidden = NO;
    carLabel.hidden = NO;
    sportsLabel.hidden = NO;
    fruitsLabel.hidden = NO;
    personalitiesLabel.hidden = NO;
    
    [infiniteScrollPicker removeFromSuperview];
    [closeButton removeFromSuperview];
}


- (void)btnClicked:(UIButton *)sender {
    
    [CCAnimationCache purgeSharedAnimationCache];
    [[CCDirector sharedDirector] purgeCachedData];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    [soundEngine playEffect:@"select.mp3"];
    
    for (UIView *view in [[[CCDirector sharedDirector] view] subviews]) {
        UIButton *btnObj = (UIButton *)view;
        if([btnObj isKindOfClass:[UIButton class]])
        {
            [btnObj removeFromSuperview];
        }
        
        UILabel *labelObj = (UILabel *)view;
        if([labelObj isKindOfClass:[UILabel class]])
        {
            [labelObj removeFromSuperview];
        }
    }
    
    [infiniteScrollPicker removeFromSuperview];
    
    int pos = sender.tag % 6;
    NSLog(@"**Pos = %d", pos);
    
//    NSString *buttonStatus = (__bridge NSString *)sender.observationInfo;
//    NSLog(@"****ButtonStatus = %@", buttonStatus);
    
    NSString *sendStr = @"";
    
    if(sendTag == 1)
    {
        sendStr = @"animal";
    }
    if(sendTag == 2)
    {
        sendStr = @"building";
    }
    if(sendTag == 3)
    {
        sendStr = @"car";
    }
    if(sendTag == 4)
    {
        sendStr = @"sports";
    }
    if(sendTag == 5)
    {
        sendStr = @"fruits";
    }
    if(sendTag == 6)
    {
        sendStr = @"personalities";
    }
    
    imageName = @"";
    if(IS_IPHONE_4 || IS_IPHONE_5)
    {
        imageName =  [NSString stringWithFormat:@"%@%d_iphone.jpg", sendStr, pos + 1];
    }
    else
    {
        imageName =  [NSString stringWithFormat:@"%@%d.jpg", sendStr, pos + 1];
    }
    NSLog(@"**imageName = %@", imageName);
    
    [self scheduleOnce:@selector(gotoNextScene:) delay:0.0];
}

- (void)gotoNextScene:(ccTime)delay
{
    [emitter resetSystem];

    [[CCDirector sharedDirector] runWithScene:[CCTransitionFadeTR transitionWithDuration:1.0 scene:[LevelSelectionLayer sceneParameter:imageName]]];
}

- (void)onExitTransitionDidStart
{
    
}

- (void)onExit
{
    [[[GameManager sharedGameManager] bannerView] removeFromSuperview];
    
//    [emitter resetSystem];
    [self removeAllChildrenWithCleanup:YES];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

@end
