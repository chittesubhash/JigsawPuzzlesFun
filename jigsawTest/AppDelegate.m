//
//  AppDelegate.m
//  jigsawTest
//
//  Created by admin on 6/27/14.
//  Copyright (c) 2014 BITLANTIC. All rights reserved.
//

#import "AppDelegate.h"
#import "GameManager.h"
#import "IntroLayer.h"

// Register our helper sub-class as a transaction observer
#import "CategoryIAPHelper.h"

@implementation AppDelegate
@synthesize director = director_, navController = navController_, window = window_;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //TODO: call the sharedInstance method of Singleton CategoryIAPHelper
    [CategoryIAPHelper sharedInstance];
    
    CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGB565	//kEAGLColorFormatRGBA8
								   depthFormat:0	//GL_DEPTH_COMPONENT24_OES
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];
    
	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];
//	director_.wantsFullScreenLayout = YES;
    director_.extendedLayoutIncludesOpaqueBars = YES;
	// Display FSP and SPF
	[director_ setDisplayStats:NO];
	// set FPS at 60
	[director_ setAnimationInterval:1.0/60];
	// attach the openglView to the director
	[director_ setView:glView];
    
	// for rotation and other messages
	[director_ setDelegate:self];
    
	[director_ setProjection:kCCDirectorProjection2D];
    
	if( ! [director_ enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
    
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
	// If the 1st suffix is not found and if fallback is enabled then fallback suffixes are going to searched. If none is found, it will try with the name without suffix.
	// On iPad HD  : "-ipadhd", "-ipad",  "-hd"
	// On iPad     : "-ipad", "-hd"
	// On iPhone HD: "-hd"
	CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setEnableFallbackSuffixes:NO];				// Default: NO. No fallback suffixes are going to be used
	[sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
	[sharedFileUtils setiPadSuffix:@"-ipad"];					// Default on iPad is "ipad"
	[sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"
    
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
    [[GameManager sharedGameManager] setupAudioEngine];
    
    
    [director_ pushScene:[IntroLayer scene]];
    director_.view.multipleTouchEnabled = NO;
    //[[CCDirector sharedDirector] runWithScene:[CCTransitionScene transitionWithDuration:1.0 scene:[IntroLayer scene]]];
    
	// Create a Navigation Controller with the Director
	navController_ = [[UINavigationController alloc] initWithRootViewController:director_];
	navController_.navigationBarHidden = YES;

    //PUSHWOOSH PART
    
    // set custom delegate for push handling, in our case - view controller
    [PushNotificationManager pushManager].delegate = navController_;
	
	// handling push on app start
	[[PushNotificationManager pushManager] handlePushReceived:launchOptions];
	
	// make sure we count app open in Pushwoosh stats
	[[PushNotificationManager pushManager] sendAppOpen];
	
	// register for push notifications!
	[[PushNotificationManager pushManager] registerForPushNotifications];
    
    [window_ setRootViewController:navController_];
	[window_ makeKeyAndVisible];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    CC_DIRECTOR_END();
}

// Supported orientations: Landscape. Customize it for your own needs
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}



#pragma mark - PUSHWOOSH

// system push notification registration success callback, delegate to pushManager
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	[[PushNotificationManager pushManager] handlePushRegistration:deviceToken];
}

// system push notification registration error callback, delegate to pushManager
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	[[PushNotificationManager pushManager] handlePushRegistrationFailure:error];
}

// system push notifications callback, delegate to pushManager
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	[[PushNotificationManager pushManager] handlePushReceived:userInfo];
}

// silent push handling for applications with the "remote-notification" background mode
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSDictionary *pushDict = [userInfo objectForKey:@"aps"];
    BOOL isSilentPush = [[pushDict objectForKey:@"content-available"] boolValue];
    
    if (isSilentPush) {
        NSLog(@"Silent push notification:%@", userInfo);
        
        //load content here
        
		// must call completionHandler
        completionHandler(UIBackgroundFetchResultNewData);
    }
    else {
        [[PushNotificationManager pushManager] handlePushReceived:userInfo];
        
		// must call completionHandler
        completionHandler(UIBackgroundFetchResultNoData);
    }
}

+ (AppDelegate *) sharedDelegate
{
    return (AppDelegate *) [UIApplication sharedApplication].delegate;
}

@end
