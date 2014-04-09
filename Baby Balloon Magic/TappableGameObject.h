//
//  TappableGameObject.h
//  BalloonMagic
//
//  Created by Nicholas Rasband on 7/28/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//
#import "GameObject.h"

@interface TappableGameObject : GameObject 
{
    BOOL _neverAnimated;
    BOOL _canTap;
}

- (void) handleTap:(CGSize)screenSize;
- (BOOL) isOffScreen:(CGSize)screenSize;

@property (assign) BOOL neverAnimated;
@property (assign) BOOL canTap;

@end
