/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Luiz Adolpho <luiz.adolpho@gmail.com>
 * Created 08/2012
 * All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "GameConstants.h"
#import "SimpleAudioEngine.h"

#import <iAd/iAd.h>
#include <sys/xattr.h>


@interface GameManager : NSObject <ADBannerViewDelegate, ADInterstitialAdDelegate>{
    BOOL isMusicON;
    SceneTypes currentScene;
    int currentPage;
    int language;
    NSString* currentPuzzle;
    BOOL audioInitialized;
    GameManagerSoundState managerSoundState;
    SimpleAudioEngine *soundEngine;
    NSMutableDictionary *listOfSoundEffectFiles;
    NSMutableDictionary *soundEffectsState;

}

@property (readwrite) BOOL isMusicON;
@property (readwrite) int currentPage;
@property (readwrite) int language;
@property (readwrite,retain) NSString* currentPuzzle;
@property (readwrite) GameManagerSoundState managerSoundState; 
@property (nonatomic, retain) NSMutableDictionary *listOfSoundEffectFiles;
@property (nonatomic, retain) NSMutableDictionary *soundEffectsState;

//ADS
@property (nonatomic, retain) ADBannerView *bannerView;
@property (readwrite) BOOL isInterstitialAdReady;
@property (nonatomic, retain) ADInterstitialAd *interstitial;

-(void)setupAudioEngine; 
-(ALuint)playSoundEffect:(NSString*)soundEffectKey; 
-(void)runSceneWithID:(SceneTypes)sceneID withParameter:(NSString *)imageName;
+(GameManager*)sharedGameManager;                                  

@end

