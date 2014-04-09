//
//  Moon.h
//  BalloonMagic
//
//  Created by Nicholas Rasband on 8/9/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "TappableGameObject.h"
#import "SoundManager.h"

@interface Moon : TappableGameObject
{
    CCAnimation* _moonAnimation;
    CCAnimate* _animate;
    SoundManager* _soundManager;
}

@property (retain) CCAnimation* moonAnimation;

@end
