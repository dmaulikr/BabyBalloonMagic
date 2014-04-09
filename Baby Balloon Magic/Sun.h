//
//  Sun.h
//  BalloonMagic
//
//  Created by Nicholas Rasband on 7/28/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "TappableGameObject.h"
#import "SoundManager.h"

@interface Sun : TappableGameObject
{
    CCAnimation* _surpriseAnimation;
    CCAnimate* _animate;
    SoundManager* _soundManager;
}

@property (retain) CCAnimation* surpriseAnimation;

@end
