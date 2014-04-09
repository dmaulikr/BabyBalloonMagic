//
//  MenuLayer.h
//  BalloonMagic
//
//  Created by Nicholas Rasband on 8/11/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "MainScene.h"
#import "SoundManager.h"
#import "SpeedSlider.h"

#define SoundSpriteTag 1
#define BalloonSpriteTag 2
#define SpeedSliderTag 3
#define LogoSpriteTag 4

@interface MenuLayer : CCLayer 
{
    // SpriteBatchNode to save resources
    CCSpriteBatchNode* _spriteBatchNode;
    SoundManager* _soundManager;
    SpeedSlider* _speedSlider;
    

    CGSize _screenSize;
    BOOL _soundEnabled;
}

@property (assign) CGSize screenSize;
@property (assign) BOOL soundEnabled;

@end
