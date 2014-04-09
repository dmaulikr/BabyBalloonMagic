//
//  SoundManager.m
//  BalloonMagic
//
//  Created by Nicholas Rasband on 8/11/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "SoundManager.h"

#pragma mark -
#pragma mark Private Interface
@interface SoundManager ()
- (void) setupAudio;
@end

#pragma mark -
@implementation SoundManager

static SoundManager* _sharedSoundManager = nil;  

#pragma mark Constructors
 
+ (SoundManager*) sharedSoundManager 
{
    @synchronized([SoundManager class])
    {
        if(!_sharedSoundManager)       
            [[self alloc] init]; 
        return _sharedSoundManager;    
    }
    return nil; 
}

+ (id) alloc 
{
    @synchronized ([SoundManager class])
    {
        NSAssert(_sharedSoundManager == nil, @"Attempted to allocated a second instance of the Sound Manager singleton");
        _sharedSoundManager = [super alloc];
        return _sharedSoundManager;
    }
    return nil;  
}

- (id) init 
{
    self = [super init];
    if (self != nil) 
    {
        // Sound Manager initialized
        CCLOG(@"Sound Manager Singleton, init");
        // Check to see if sound is enabled
        [self setupAudio];
        int soundSetting = [[NSUserDefaults standardUserDefaults] integerForKey:SoundSetting];
        
        if (soundSetting == 0)
        {
            [self setSoundIsOn:YES];
        }
        else
        {
            if (soundSetting == SoundOn)
            {
                [self setSoundIsOn:YES];
            }
            else
            {
                [self setSoundIsOn:NO];
            }
        }
    }
    
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
- (void) setSoundIsOn:(BOOL)setting
{
    if (setting == YES)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:SoundOn forKey:SoundSetting];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setInteger:SoundOff forKey:SoundSetting];
    }
    
    _soundIsOn = setting;
    
}

- (BOOL) soundIsOn
{
    return _soundIsOn;
}

#pragma mark -
#pragma mark Methods
- (void) setupAudio
{
    [CDSoundEngine setMixerSampleRate:CD_SAMPLE_RATE_MID];
    [[CDAudioManager sharedManager] setResignBehavior:kAMRBStopPlay autoHandle:YES];
    _audioEngine = [SimpleAudioEngine sharedEngine];
}

- (void) loadSoundEffect:(NSString*)soundEffectName
{
    [_audioEngine preloadEffect:soundEffectName];
}

- (void) loadMainSceneAudio
{
    [_audioEngine preloadEffect:@"pop_1.caf"];
    [_audioEngine preloadEffect:@"pop_2.caf"];
    [_audioEngine preloadEffect:@"pop_3.caf"];
    [_audioEngine preloadEffect:@"pop_4.caf"];
    [_audioEngine preloadEffect:@"pop_5.caf"];
    [_audioEngine preloadEffect:@"pop_6.caf"];
    [_audioEngine preloadEffect:@"pop_7.caf"];
    [_audioEngine preloadEffect:@"pop_8.caf"];
    [_audioEngine preloadEffect:@"pop_9.caf"];
    [_audioEngine preloadEffect:@"pop_10.caf"];
    [_audioEngine preloadEffect:@"pop_11.caf"];
    [_audioEngine preloadEffect:@"tree_shake.caf"];
    [_audioEngine preloadEffect:@"cat_1.caf"];
    [_audioEngine preloadEffect:@"cat_2.caf"];
    [_audioEngine preloadEffect:@"sun_rattle.caf"];    
}

- (void) loadNightAudio
{
    [_audioEngine preloadEffect:@"sheep_1.caf"];
    [_audioEngine preloadEffect:@"sheep_2.caf"];
    [_audioEngine preloadEffect:@"sheep_3.caf"];
    [_audioEngine preloadEffect:@"sheep_4.caf"];
    [_audioEngine preloadEffect:@"sheep_5.caf"];
    [_audioEngine preloadEffect:@"sheep_6.caf"];
    [_audioEngine preloadEffect:@"sheep_7.caf"];
    [_audioEngine preloadEffect:@"sheep_8.caf"];
    [_audioEngine preloadEffect:@"sheep_jump.caf"];
    [_audioEngine preloadEffect:@"chimes_1.caf"];
    [_audioEngine preloadEffect:@"chimes_2.caf"];

}

- (void) loadMenuAudio
{
    [_audioEngine preloadEffect:@"pop_6.caf"];
    [_audioEngine preloadEffect:@"toggle_sound.caf"];
    [_audioEngine preloadEffect:@"play_game.caf"];
}

- (void) playSoundEffect:(NSString*)soundEffectName
{
    if ([self soundIsOn]) 
    {
        [_audioEngine playEffect:soundEffectName];
    }
}

- (void) unloadMainSceneAudio
{
    [_audioEngine unloadEffect:@"pop_1.caf"];
    [_audioEngine unloadEffect:@"pop_2.caf"];
    [_audioEngine unloadEffect:@"pop_3.caf"];
    [_audioEngine unloadEffect:@"pop_4.caf"];
    [_audioEngine unloadEffect:@"pop_5.caf"];
    [_audioEngine unloadEffect:@"pop_6.caf"];
    [_audioEngine unloadEffect:@"pop_7.caf"];
    [_audioEngine unloadEffect:@"pop_8.caf"];
    [_audioEngine unloadEffect:@"pop_9.caf"];
    [_audioEngine unloadEffect:@"pop_10.caf"];
    [_audioEngine unloadEffect:@"tree_shake.caf"];
    [_audioEngine unloadEffect:@"cat_1.caf"];
    [_audioEngine unloadEffect:@"cat_2.caf"];
    [_audioEngine unloadEffect:@"sun_rattle.caf"];
}

- (void) unloadNightAudio
{
    [_audioEngine unloadEffect:@"sheep_1.caf"];
    [_audioEngine unloadEffect:@"sheep_2.caf"];
    [_audioEngine unloadEffect:@"sheep_3.caf"];
    [_audioEngine unloadEffect:@"sheep_4.caf"];
    [_audioEngine unloadEffect:@"sheep_5.caf"];
    [_audioEngine unloadEffect:@"sheep_6.caf"];
    [_audioEngine unloadEffect:@"sheep_7.caf"];
    [_audioEngine unloadEffect:@"sheep_8.caf"];
    [_audioEngine unloadEffect:@"sheep_jump.caf"];
    [_audioEngine unloadEffect:@"chimes_1.caf"];
    [_audioEngine unloadEffect:@"chimes_2.caf"]; 
}

- (void) unloadMenuAudio
{
    [_audioEngine unloadEffect:@"pop_6.caf"];
    [_audioEngine unloadEffect:@"toggle_sound.caf"];
    [_audioEngine unloadEffect:@"play_game.caf"];
}

- (void) unloadSoundEffect:(NSString*)soundEffectName
{
    [_audioEngine unloadEffect:soundEffectName];
}

- (void) playNightMusic
{
    if ([self soundIsOn])
    {
        [_audioEngine preloadBackgroundMusic:@"crickets.caf"];
        [_audioEngine playBackgroundMusic:@"crickets.caf"];
        [_audioEngine setBackgroundMusicVolume:0.5f];
    }

}

- (void) playMenuMusic
{
    if ([self soundIsOn])
    {
        [_audioEngine preloadBackgroundMusic:@"balloonappsong_grandpiano.caf"];
        [_audioEngine playBackgroundMusic:@"balloonappsong_grandpiano.caf"];  
        [_audioEngine setBackgroundMusicVolume:0.75f];
    }
}

- (void) playDayMusic
{
    if ([self soundIsOn])
    {
        [_audioEngine preloadBackgroundMusic:@"dayforest.caf"];
        [_audioEngine playBackgroundMusic:@"dayforest.caf"];
        [_audioEngine setBackgroundMusicVolume:0.2f];
    }
}

- (void) stopMusic
{
    if ([_audioEngine isBackgroundMusicPlaying])
    {
        [_audioEngine pauseBackgroundMusic];
    }
}

- (void) startMusic
{
    [self playMenuMusic];
}

@end
