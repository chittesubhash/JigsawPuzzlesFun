/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Luiz Adolpho <luiz.adolpho@gmail.com>
 * Created 08/2012
 * All rights reserved.
 */

#import "PuzzleSelectionLayer.h"
#import "GameConstants.h"
#import "GameManager.h"
#import "GameHelper.h"
#import "ImageHelper.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "AudioHelper.h"

@implementation PuzzleSelectionLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	PuzzleSelectionLayer *layer = [PuzzleSelectionLayer node];
	[scene addChild: layer];
	return scene;
}


-(void) onClickPhotoSelection {
    [AudioHelper playSelectPicture];
    [self showPhotoLibrary];
}

-(void) initPhotoButton{
    
    CCSprite *normal = [CCSprite spriteWithFile:@"camera.png"];
    CCSprite *selected = [CCSprite spriteWithFile:@"camera.png"];
    
    cameraButton = [CCMenuItemSprite itemWithNormalSprite:normal selectedSprite:selected target:self selector:@selector(showPhotoLibrary)];
    cameraButton.position = ccp(screenSize.width-50, screenSize.height-50);
    cameraButton.isEnabled = YES;
    
    CCMenu *menu = [CCMenu menuWithItems:cameraButton, nil];
    [menu alignItemsHorizontallyWithPadding:40];
    [menu setPosition: ccp(screenSize.height + 140, 640)];
    
    if(IS_IPHONE_5)
    {
        [menu setPosition: ccp(screenSize.height + 140, 40)];
    }
    if(IS_IPHONE_4)
    {
        [menu setPosition: ccp(screenSize.height + 140, 40)];
    }

    [self addChild:menu z:7 tag:7];
}

-(void) initBackground {
	CCSprite *background;
    background = [CCSprite spriteWithFile:@"categorySelectionBg.png"];
    
    if(IS_IPHONE_5)
    {
        background = [CCSprite spriteWithFile:@"background-puzzle-selection_5.png"];
    }
    if(IS_IPHONE_4)
    {
        background = [CCSprite spriteWithFile:@"background-puzzle-selection_5.png"];
    }

    background.anchorPoint = ccp(0, 0);

    [self addChild:background];
}


-(void)onClickPhoto{
    CCLOG(@"CLICK OVER IMAGE");
}

-(void)showEmptyBox{
    CCSprite *itemSprite = [[CCSprite alloc] initWithFile:@"empty.png"];
    if(IS_IPHONE_5)
    {
        itemSprite = [[CCSprite alloc] initWithFile:@"empty_5.png"];
    }
    if(IS_IPHONE_4)
    {
        itemSprite = [[CCSprite alloc] initWithFile:@"empty_4.png"];
    }

    CCMenuItemSprite *itemMenu = [CCMenuItemSprite itemWithNormalSprite:itemSprite selectedSprite:nil
                                                                 target:self
                                                               selector:@selector(onClickPhotoSelection)];
    CCMenu *emptyMenu = [CCMenu menuWithItems:itemMenu, nil];
    emptyMenu.anchorPoint = ccp(0,0);
    emptyMenu.position = ccp(screenSize.width/2 , screenSize.height/2 );
    [self addChild:emptyMenu z:40 tag:40];
}


-(void) onClickBack {
    [AudioHelper playBack];
    [[GameManager sharedGameManager] runSceneWithID:kHomeScreen withParameter:nil];

}

-(void) showPhotoLibrary
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
		[_picker release];
	}
	if (_popover) {
		[_popover dismissPopoverAnimated:NO];
		[_popover release];
	}
    CCDirector * director =[CCDirector sharedDirector];
	[director stopAnimation];
	_picker = [[[UIImagePickerController alloc] init] retain];
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
            _popover = [[[UIPopoverController alloc] initWithContentViewController:_picker] retain];
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


//+ (BOOL)isCameraDeviceAvailable:(UIImagePickerControllerCameraDevice)cameraDevice
//{
//    return UIImagePickerControllerSourceTypeCamera;
//}

//-(void) showPhotoLibrary
//{
//    [CCAnimationCache purgeSharedAnimationCache];
//    [[CCDirector sharedDirector] purgeCachedData];
//    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
//    [[CCTextureCache sharedTextureCache] dumpCachedTextureInfo];
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *filePath = [paths stringByAppendingPathComponent:@"image.png"];
//    [fileManager removeItemAtPath:filePath error:NULL];
//    
//	if (_picker) {
//		[_picker dismissViewControllerAnimated:YES completion:nil];
//		[_picker.view removeFromSuperview];
//		[_picker release];
//	}
//	if (_popover) {
//		[_popover dismissPopoverAnimated:NO];
//		[_popover release];
//	}
//    CCDirector * director =[CCDirector sharedDirector];
//	[director stopAnimation];
//	_picker = [[[UIImagePickerController alloc] init] retain];
//	_picker.delegate = self;
//	_picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    _picker.allowsEditing = NO;
//    CGRect r = CGRectMake(screenSize.width/2, 0, 10, 10);
//
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
//        _popover = [[[UIPopoverController alloc] initWithContentViewController:_picker] retain];
//        _popover.delegate = self;
//        r.origin = [director convertToGL:r.origin];
//        [_popover presentPopoverFromRect:r inView:[director view]
//            permittedArrowDirections:0 animated:YES];
//        _popover.popoverContentSize = CGSizeMake(320, screenSize.width);
//        
//    }else{
//            
//        [director presentViewController:_picker animated:YES completion:nil];
//    }
//}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [_picker dismissViewControllerAnimated:YES completion:nil];
	[_picker.view removeFromSuperview];
	[_picker release];
	_picker = nil;
	[_popover dismissPopoverAnimated:NO];
	[_popover release];
    _popover = nil;
	[[CCDirector sharedDirector] startAnimation];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    [self imagePickerControllerDidCancel:nil];
}

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    [selectcategoryLabel removeFromSuperview];
    [categoryTable removeFromSuperview];
    
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
    [picker release];
    [_popover dismissPopoverAnimated:YES];
	[[CCDirector sharedDirector] startAnimation];
    
    
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
    [[GameManager sharedGameManager] runSceneWithID:kLevelEasy withParameter:filePath1];

}

-(void)removeImage:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [paths stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", fileName]];
    [fileManager removeItemAtPath:filePath error:NULL];
}


-(void) createExplosionAtPosition:(CGPoint)point{
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

-(void) onEnter{
	[super onEnter];

    screenSize = [[CCDirector sharedDirector] winSize];
    [CCSpriteFrameCache sharedSpriteFrameCache];
    
    [self initBackground];

}


-(void)onEnterTransitionDidFinish{
    
    categoryItems = [[NSArray alloc] initWithObjects:@"Animals", @"Cars", @"Flowers", @"Buildings", nil];

    selectcategoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(372, 208, 300, 54)];
    selectcategoryLabel.backgroundColor = [UIColor clearColor];
    selectcategoryLabel.text = @"SELECT CATEGORY";
    selectcategoryLabel.textAlignment = NSTextAlignmentCenter;
    selectcategoryLabel.textColor = [UIColor orangeColor];
    selectcategoryLabel.font = [UIFont boldSystemFontOfSize:30.0];
    [[[CCDirector sharedDirector] view] addSubview:selectcategoryLabel];
    
    
    categoryTable = [[UITableView alloc] initWithFrame:CGRectMake(372, 262, 300, 432) style:UITableViewStylePlain];
    categoryTable.backgroundColor = [UIColor clearColor];
    categoryTable.delegate = self;
    categoryTable.dataSource = self;
    categoryTable.opaque = YES;
    [[[CCDirector sharedDirector] view] addSubview:categoryTable];
    
    cameraButton.opacity = 100.0f;

    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];

    [self initPhotoButton];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self createExplosionAtPosition:touchLocation];
    return YES;
}


#pragma mark - Table View
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return categoryItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    NSDate *object = categoryItems[indexPath.row];
    cell.textLabel.text = [object description];
    cell.textLabel.textColor = [UIColor cyanColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:24.0];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [selectcategoryLabel removeFromSuperview];
    [categoryTable removeFromSuperview];
    [scrollView removeFromSuperview];
    
    if(indexPath.row == 0)
        [self animalPuzzles];
    
    if(indexPath.row == 1)
        [self carPuzzles];
    
    if(indexPath.row == 2)
        [self flowerPuzzles];
    
    if(indexPath.row == 3)
        [self buildingPuzzles];

}

- (void)animalPuzzles {
    float height = 500;
    
    scrollView = [[UIView alloc] initWithFrame:CGRectMake(0, screenSize.height/2 - height/2 - 100, screenSize.width, height)];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    scrollView.hidden = NO;
    [[[CCDirector sharedDirector]view] addSubview:scrollView];
    
    isp3 = [[InfiniteScrollPicker alloc] initWithFrame:CGRectMake(0, 50, 1025,500) WithDelegate:self];
    [isp3 setUserInteractionEnabled:YES];
    
    [isp3 setImageAry];
    [isp3 setHeightOffset:20];
    [isp3 setPositionRatio:2];
    [isp3 setAlphaOfobjs:0.7];
    [scrollView addSubview:isp3];
    
    //    [self initHomeButton];
}


- (void)carPuzzles {
    float height = 500;
    
    scrollView = [[UIView alloc]initWithFrame:CGRectMake(0, screenSize.height/2 - height/2 - 100, screenSize.width, height)];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    scrollView.hidden = NO;
    [[[CCDirector sharedDirector]view] addSubview:scrollView];
    
    isp3 = [[InfiniteScrollPicker alloc] initWithFrame:CGRectMake(0, 50, 1025,500) WithDelegate:self];
    [isp3 setUserInteractionEnabled:YES];
    
    [isp3 setImageAry];
    [isp3 setHeightOffset:20];
    [isp3 setPositionRatio:2];
    [isp3 setAlphaOfobjs:0.7];
    [scrollView addSubview:isp3];
    
    //    [self initHomeButton];
}


- (void)flowerPuzzles {
    float height = 500;
    
    scrollView = [[UIView alloc]initWithFrame:CGRectMake(0, screenSize.height/2 - height/2 - 100, screenSize.width, height)];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    scrollView.hidden = NO;
    [[[CCDirector sharedDirector]view] addSubview:scrollView];
    
    isp3 = [[InfiniteScrollPicker alloc] initWithFrame:CGRectMake(0, 50, 1025,500) WithDelegate:self];
    [isp3 setUserInteractionEnabled:YES];
    
    [isp3 setImageAry];
    [isp3 setHeightOffset:20];
    [isp3 setPositionRatio:2];
    [isp3 setAlphaOfobjs:0.7];
    [scrollView addSubview:isp3];
    
    //    [self initHomeButton];
}


- (void)buildingPuzzles {
    float height = 768;
    
    scrollView = [[UIView alloc]initWithFrame:CGRectMake(0,  0, 1024, height)];
    [scrollView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
    scrollView.hidden = NO;
    [[[CCDirector sharedDirector]view] addSubview:scrollView];
    
    NSLog(@"asfasf:: %f", screenSize.height/2);
    
    isp3 = [[InfiniteScrollPicker alloc] initWithFrame:CGRectMake(0, -200, 1024, height) WithDelegate:self];
    isp3.backgroundColor = [UIColor clearColor];
    [isp3 setUserInteractionEnabled:YES];
    
    [isp3 setImageAry];
    [isp3 setHeightOffset:20];
    [isp3 setPositionRatio:2];
    [isp3 setAlphaOfobjs:0.7];
    [scrollView addSubview:isp3];
    
}

- (void)btnClicked:(UIButton *)sender {
    NSLog(@"**CustomScrollViewBtnClicked = %d", sender.tag);
    
    [scrollView removeFromSuperview];

    int pos = sender.tag % 6;
    NSLog(@"**Pos = %d", pos);
    
    NSString *buttonStatus = (__bridge NSString *)sender.observationInfo;
    NSLog(@"****ButtonStatus = %@", buttonStatus);
    
//    NSString *letter = [objectNames objectAtIndex:pos];
    
    NSString *imageName =  [NSString stringWithFormat:@"Letter%d.png", pos + 1];
    NSLog(@"**imageName = %@", imageName);
    
    [[GameManager sharedGameManager] runSceneWithID:kLevelEasy withParameter:imageName];

    
//    if ([buttonStatus isEqualToString:@"UNLOCKED"]) {
//        [[GameManager sharedGameManager] runSceneWithID:kLevelEasy withParameter:imageName];
//    }
//    else {
//        [self startViewAnimation:NO];
//    }
}

- (BOOL) shouldAutorotate {
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

-(void) onExit{
    [super onExit];
    [categoryTable removeFromSuperview];
    
    [levelMenu setEnabled:NO];
    [navArrowMenu setEnabled:NO];
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [self removeChild:levelMenu cleanup:YES];
    [self removeChild:navArrowMenu cleanup:YES];
    
    [self removeAllChildrenWithCleanup:YES];
    [self removeFromParentAndCleanup:YES];
}


-(void)dealloc {
    [super dealloc];
    
    [CCAnimationCache purgeSharedAnimationCache];
    [[CCDirector sharedDirector] purgeCachedData];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    [[CCTextureCache sharedTextureCache] dumpCachedTextureInfo];
}

@end
