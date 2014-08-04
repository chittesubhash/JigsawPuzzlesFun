//
//  IntroLayer.m
//  Jigsaw Puzzle
//
//  Created by admin on 7/9/14.
//  Copyright (c) 2014 BITLANTIC. All rights reserved.
//

#import "IntroLayer.h"
#import "GameManager.h"
#import "HomeScreenLayer.h"

@implementation IntroLayer

+(CCScene *) scene
{
	CCScene *scene=[CCScene node];
	IntroLayer *layer = [IntroLayer node];
	[scene addChild: layer];
	return scene;
}

-(void)onEnter
{
	[super onEnter];
	size = [[CCDirector sharedDirector] winSize];
    
    [self initBackground];
}

- (void)onEnterTransitionDidFinish
{
    [self startTracking];

}

- (void)initBackground
{
    CCSprite *background;
    background = [CCSprite spriteWithFile:@"newSplash.jpg"];
    //	background.position = ccp(size.width/2, size.height/2);
//    background.anchorPoint = ccp(0, 0);
    
    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        background = [CCSprite spriteWithFile:@"splash_iphone.jpg"];
    }
    
    background.position = ccp(size.width/2, size.height/2);
	[self addChild:background];
    
	[self scheduleOnce:@selector(makeTransition:) delay:1.5];
}

-(void)onExit{
    [super onExit];

    [CCAnimationCache purgeSharedAnimationCache];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    [self removeAllChildrenWithCleanup:YES];
//    [self removeFromParentAndCleanup:YES];
}

-(void) makeTransition:(ccTime)dt
{
    [[CCDirector sharedDirector] replaceScene: [CCTransitionCrossFade transitionWithDuration:1.0 scene:[HomeScreenLayer scene]]];

}


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}


- (void) startTracking {
	NSLog(@"Start tracking");
	PushNotificationManager * pushManager = [PushNotificationManager pushManager];
	[pushManager startLocationTracking];
}

- (void) stopTracking {
	NSLog(@"Stop tracking");
	PushNotificationManager * pushManager = [PushNotificationManager pushManager];
	[pushManager stopLocationTracking];
}


#pragma mark - PushNotificationDelegate

//succesfully registered for push notifications
- (void) onDidRegisterForRemoteNotificationsWithDeviceToken:(NSString *)token {
//	_statusLabel.text = [NSString stringWithFormat:@"Registered with push token: %@", token];
    NSLog(@"TOKEN:: %@", token);
}

//failed to register for push notifications
- (void) onDidFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//	_statusLabel.text = [NSString stringWithFormat:@"Failed to register: %@", [error description]];
    NSLog(@"ERROR:: %@", [error description]);

}

//user pressed OK on the push notification
- (void) onPushAccepted:(PushNotificationManager *)pushManager withNotification:(NSDictionary *)pushNotification {
	[PushNotificationManager clearNotificationCenter];
	
//	_statusLabel.text = [NSString stringWithFormat:@"Received push notification: %@", pushNotification];
    
    NSLog(@"Received push notification: %@", pushNotification);

	
	// Parse custom JSON data string.
	// You can set background color with custom JSON data in the following format: { "r" : "10", "g" : "200", "b" : "100" }
	// Or open specific screen of the app with custom page ID (set ID in the { "id" : "2" } format)
	NSString *customDataString = [pushManager getCustomPushData:pushNotification];
    
    NSDictionary *jsonData = nil;
    
    if (customDataString) {
        jsonData = [NSJSONSerialization JSONObjectWithData:[customDataString dataUsingEncoding:NSUTF8StringEncoding]
                                                   options:NSJSONReadingMutableContainers
                                                     error:nil];
    }
    
	NSString *redStr = [jsonData objectForKey:@"r"];
	NSString *greenStr = [jsonData objectForKey:@"g"];
	NSString *blueStr = [jsonData objectForKey:@"b"];
    
	if (redStr || greenStr || blueStr) {
		[self setViewBackgroundColorWithRed:redStr green:greenStr blue:blueStr];
	}
	
	NSString *pageId = [jsonData objectForKey:@"id"];
    
	if (pageId) {
		[self showPageWithId:pageId];
	}
}

//received tags from the server
- (void) onTagsReceived:(NSDictionary *)tags {
	NSLog(@"getTags: %@", tags);
}

//error receiving tags from the server
- (void) onTagsFailedToReceive:(NSError *)error {
	NSLog(@"getTags error: %@", error);
}


- (void)setViewBackgroundColorWithRed:(NSString *)redString green:(NSString *)greenString blue:(NSString *)blueString {
//	CGFloat red = [redString floatValue] / 255.0f;
//	CGFloat green = [greenString floatValue] / 255.0f;
//	CGFloat blue = [blueString floatValue] / 255.0f;
    
//	UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
	[UIView animateWithDuration:0.3 animations:^{
//		self.view.backgroundColor = color;
//		self.presentedViewController.view.backgroundColor = color;
	}];
}


- (void)showPageWithId:(NSString *)pageId {
//	CustomPageViewController *vc = [[CustomPageViewController alloc] init];
//	vc.bgColor = self.view.backgroundColor;
//	vc.pageId = [pageId integerValue];
//	vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//	
//	if (self.presentedViewController) {
//		[self dismissViewControllerAnimated:YES completion:^{
//			[self presentViewController:vc animated:YES completion:nil];
//		}];
//	} else {
//		[self presentViewController:vc animated:YES completion:nil];
//	}
}

@end
