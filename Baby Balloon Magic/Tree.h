//
//  Tree.h
//  BalloonMagic
//
//  Created by Nicholas Rasband on 8/3/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//
#import "TappableGameObject.h"
#import "SoundManager.h"

@interface Tree : TappableGameObject 
{
    CCAnimation* _shakeAnimation;
    CCAnimate* _animate;
    SoundManager* _soundManager;
}

@property (retain) CCAnimation* shakeAnimation;

@end
