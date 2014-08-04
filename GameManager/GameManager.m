
#import "GameManager.h"
#import "PlayArea.h"
#import "GameConstants.h"
#import "HomeScreenLayer.h"
#import "LevelSelectionLayer.h"
#import "IntroLayer.h"

@implementation GameManager

static GameManager* _sharedGameManager = nil;
@synthesize isMusicON;
@synthesize currentPuzzle;
@synthesize currentPage;
@synthesize language;
@synthesize listOfSoundEffectFiles;
@synthesize managerSoundState;
@synthesize soundEffectsState;

+(GameManager*)sharedGameManager {
    @synchronized([GameManager class])
    {
        if(!_sharedGameManager){
            _sharedGameManager = [[self alloc] init];
        }
        return _sharedGameManager;
    }
    return nil; 
}

+(id)alloc 
{
    @synchronized ([GameManager class])
    {
        NSAssert(_sharedGameManager == nil,
                 @"Attempted to allocated a second instance of the Game Manager singleton");                                          
        _sharedGameManager = [super alloc];
        return _sharedGameManager;
    }
    return nil;
}

-(id)init {
    self = [super init];
    if (self != nil) {
        CCLOG(@"Game Manager Singleton, init");
        isMusicON = YES;
        currentScene = kNoSceneUninitialized;
        audioInitialized = NO;
        soundEngine = nil;
        managerSoundState = kAudioManagerUninitialized;
        currentPage = 0;
        
        _bannerView = [[ADBannerView alloc] initWithFrame:CGRectZero];
        _bannerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_bannerView setDelegate:self];
        [[[CCDirector sharedDirector] view] addSubview:_bannerView];
        
        [self moveBannerOffScreen];
        
        _interstitial = [[ADInterstitialAd alloc] init];
        _interstitial.delegate = self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RemoveAdds) name:@"RemoveAds" object:nil];
    }
    return self;
}

-(void) moveBannerOnScreen
{
    _bannerView.hidden = NO;

    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    [UIView beginAnimations:@"BannerViewIntro" context:NULL];
    _bannerView.frame = CGRectMake(0, windowSize.height - 60, windowSize.width, 100);;
    [UIView commitAnimations];
    
    if(IS_IPHONE_4 || IS_IPHONE_5)
    {
        _bannerView.frame = CGRectMake(0, 288, windowSize.width, 64);;
    }

}

-(void) moveBannerOffScreen
{
    _bannerView.hidden = YES;

    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    _bannerView.frame = CGRectMake(0, (-1) * windowSize.height, windowSize.width, 100);
}


#pragma mark - iAD Delegate

-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    
    return YES;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    
    NSLog(@"bannerViewDidLoadAd");
    
    [self moveBannerOnScreen];
    
}



-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    
}


#pragma mark ADInterstitialViewDelegate methods

// The application should implement this method so that when the user dismisses the interstitial via
// the top left corner dismiss button (which will hide the content of the interstitial) the
// application can then move the view offscreen.
- (void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd
{
    
}

// This method is invoked each time a interstitial loads a new advertisement.
// The delegate should implement this method so that it knows when the interstitial is ready to be displayed.
- (void)interstitialAdDidLoad:(ADInterstitialAd *)interstitialAd
{
    NSLog(@"***interstitialAdDidLoad****");
//    [self RemoveAdds];
    _isInterstitialAdReady = YES;
}


- (void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error
{
    NSLog(@"interstitialAd <%@> recieved error <%@>", interstitialAd, error);
    _isInterstitialAdReady = NO;
}

- (BOOL)interstitialAdActionShouldBegin:(ADInterstitialAd *)interstitialAd willLeaveApplication:(BOOL)willLeave
{
    return YES;
}


- (void)interstitialAdActionDidFinish:(ADInterstitialAd *)interstitialAd
{
    
    NSLog(@"****interstitialAdActionDidFinish***");
}


- (void)RemoveAdds {
    
    NSLog(@"***Removing_Ads***");
    _bannerView.delegate = nil;
    [_bannerView removeFromSuperview];
    
    _interstitial.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)runSceneWithID:(SceneTypes)sceneID withParameter:(NSString *)imageName {
    SceneTypes oldScene = currentScene;
    currentScene = sceneID;
    id sceneToRun = nil;

    switch (sceneID) {
        case kHomeScreen:
            sceneToRun = [CCTransitionFade transitionWithDuration:1.5 scene:[HomeScreenLayer scene] ];
            break;
        case kCategorySelection:
            sceneToRun = [CCTransitionFadeTR transitionWithDuration:1.5 scene:[LevelSelectionLayer sceneParameter:imageName]];
            break;
        case kLevelEasy:
//            sceneToRun = [CCTransitionFadeTR transitionWithDuration:1.0 scene:[LevelEasyLayer sceneWithParameter:imageName]];
            break;
        case kLevelNormal:
            sceneToRun = [CCTransitionSlideInB transitionWithDuration:0.5 scene:[IntroLayer scene]];
            break;
//        case kLevelHard:
//            sceneToRun = [CCTransitionSlideInB transitionWithDuration:0.5 scene:[LevelHardLayer scene]];
//            break;
        default:
            CCLOG(@"Unknown ID, cannot switch scenes");
            return;
            break;
    }
    if (sceneToRun == nil) {
        currentScene = oldScene;
        return;
    }

    if ([[CCDirector sharedDirector] runningScene] == nil) {
        [[CCDirector sharedDirector] runWithScene:sceneToRun];
    } else {        
        [[CCDirector sharedDirector] replaceScene:sceneToRun];
    }   
}

-(void)initAudioAsync {
    managerSoundState = kAudioManagerInitializing;
    [CDSoundEngine setMixerSampleRate:CD_SAMPLE_RATE_MID];
    [CDAudioManager initAsynchronously:kAMM_FxPlusMusicIfNoOtherAudio];
    while ([CDAudioManager sharedManagerState] != kAMStateInitialised)
    {
        [NSThread sleepForTimeInterval:0.1];
    }
    CDAudioManager *audioManager = [CDAudioManager sharedManager];
    if (audioManager.soundEngine == nil ||
        audioManager.soundEngine.functioning == NO) {
        CCLOG(@"CocosDenshion failed to init, no audio will play.");
        managerSoundState = kAudioManagerFailed;
    } else {
        [audioManager setResignBehavior:kAMRBStopPlay autoHandle:YES];
        soundEngine = [SimpleAudioEngine sharedEngine];
        managerSoundState = kAudioManagerReady;
        CCLOG(@"CocosDenshion is Ready");
    } 
    
}

-(void)setupAudioEngine {
    if (audioInitialized == YES) {
        CCLOG(@"AUDIO ENGINE WAS INIT");
        return;
    } else {
        audioInitialized = YES;
        NSOperationQueue *queue = [NSOperationQueue new];
        NSInvocationOperation *asyncSetupOperation =
        [[NSInvocationOperation alloc] initWithTarget:self
                                             selector:@selector(initAudioAsync)
                                               object:nil];
        [queue addOperation:asyncSetupOperation];
    }
}

-(ALuint)playSoundEffect:(NSString*)soundEffectKey {
    ALuint soundID = 0;    
    if (managerSoundState == kAudioManagerReady) {
        soundID = [soundEngine playEffect:soundEffectKey];
    } else {
        CCLOG(@"GameMgr: Sound Manager is not ready, cannot play %@",
              soundEffectKey);
    }
    return soundID;
}


@end

