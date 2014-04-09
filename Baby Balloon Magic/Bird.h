//
//  Bird.h
//  BalloonMagic
//
//  Created by Nicholas Rasband on 8/1/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "TappableGameObject.h"

#define FastFlyDelay 0.05f

@interface Bird : TappableGameObject
{
    CCAnimation* _flyingAnimation;
    int _numberOfTaps;
}

// Constructors
- (id) initWithSpriteFrame:(CCSpriteFrame*)spriteFrame andColor:(NSString*)color;

@property (retain) CCAnimation* flyingAnimation;
@property (assign) int numberOfTaps;

- (void) runAnimation;

@end
