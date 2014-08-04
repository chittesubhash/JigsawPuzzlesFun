

#import "AudioHelper.h"
#import "GameManager.h"

@implementation AudioHelper

+(void) playCongratulations{
    NSString* sound = @"Congratulations.mp3";
    [[GameManager sharedGameManager] playSoundEffect:sound];
}

+(void) playClick{
    NSString* sound = @"Click.mp3";
    [[GameManager sharedGameManager] playSoundEffect:sound];
}


+(void) playGreat{
    NSString* sound = @"Great.mp3";
    [[GameManager sharedGameManager] playSoundEffect:sound];
}

+(void) playWoohoo{
    NSString* sound = @"Woohoo.mp3";
    [[GameManager sharedGameManager] playSoundEffect:sound];
}


@end
