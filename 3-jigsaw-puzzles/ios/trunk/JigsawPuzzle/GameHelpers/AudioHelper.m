//
//  AudioHelper.m
//  talele
//
//  Created by Maxwell Dayvson da Silva on 9/16/12.
//  Copyright 2012 Terra. All rights reserved.
//

#import "AudioHelper.h"
#import "GameManager.h"

@implementation AudioHelper

+(void) playStart{
    NSString* sound = @"Start.mp3";
    [[GameManager sharedGameManager] playSoundEffect:sound];
}
+(void) playBack{
    NSString* sound = @"Back.mp3";
    [[GameManager sharedGameManager] playSoundEffect:sound];
}
+(void) playNewGame{
    NSString* sound = @"NewGame.mp3";
    [[GameManager sharedGameManager] playSoundEffect:sound];
}
+(void) playYouWin{
    NSString* sound = @"CongratulationsLetsPlayAgain.mp3";
    [[GameManager sharedGameManager] playSoundEffect:sound];
}
+(void) playGreat{
    NSString* sound = @"Great.mp3";
    [[GameManager sharedGameManager] playSoundEffect:sound];
}
+(void) playCongratulations{
    NSString* sound = @"Congratulations.mp3";
    [[GameManager sharedGameManager] playSoundEffect:sound];
    
}
+(void) playSelectPicture{
    NSString* sound = @"SelectYourPicture.mp3";
    [[GameManager sharedGameManager] playSoundEffect:sound];

}
+(void) playWoohoo{
    NSString* sound = @"Woohoo.mp3";
    [[GameManager sharedGameManager] playSoundEffect:sound];    
}
+(void) playClick{
    NSString* sound = @"Click.mp3";
    [[GameManager sharedGameManager] playSoundEffect:sound];

}
@end
