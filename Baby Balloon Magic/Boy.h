//
//  Boy.h
//  BalloonMagic
//
//  Created by Nicholas Rasband on 7/27/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "GameObject.h"

@interface Boy : GameObject
{
    CCAnimation* _inflatingAnimation; // The boy moving to inflate the balloon.
}

// Properties
@property (retain) CCAnimation* inflatingAnimation;

// Methods
- (void) startAnimation;



@end
