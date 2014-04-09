//
//  SoundManager.h
//  BalloonMagic
//
//  Created by Nicholas Rasband on 8/11/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "SimpleAudioEngine.h"

#define SoundOn 1
#define SoundOff 2
#define SoundSetting @"Sound"

@interface SoundManager : NSObject 
{
    SimpleAudioEngine* _audioEngine;
    BOOL _soundIsOn;
}

// Properties
@property (assign) BOOL soundIsOn;

// Class methods
+ (SoundManager*) sharedSoundManager;

// Instance methods
- (void) loadMainSceneAudio;
- (void) loadNightAudio;
- (void) loadMenuAudio;
- (void) loadSoundEffect:(NSString*)soundEffectName;
- (void) playSoundEffect:(NSString*)soundEffectName;
- (void) unloadMainSceneAudio;
- (void) unloadNightAudio;
- (void) unloadMenuAudio;
- (void) unloadSoundEffect:(NSString*)soundEffectName;
- (void) playNightMusic;
- (void) playMenuMusic;
- (void) playDayMusic;
- (void) stopMusic;
- (void) startMusic;

@end
