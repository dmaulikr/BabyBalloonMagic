//
//  Star.h
//  BalloonMagic
//
//  Created by Nicholas Rasband on 8/12/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "GameObject.h"

@class Star;

@protocol StarDelegate

@required - (void) deleteStar:(Star*)star;

@end

@interface Star : GameObject 
{
    NSObject<StarDelegate>* _delegate;
}

@property (assign) NSObject<StarDelegate>* delegate;

- (void) fadeAway;

@end
