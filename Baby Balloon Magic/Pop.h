//
//  Pop.h
//  BalloonMagic
//
//  Created by Nicholas Rasband on 7/28/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//
#import "GameObject.h"

@class Pop;

@protocol PopDelegate

@required - (void) disposeOfPop:(Pop*)pop;

@end

@interface Pop : GameObject 
{
    NSObject<PopDelegate>* _delegate;
    
}

// Accessors
@property (assign) NSObject<PopDelegate>* delegate;

- (void) startFading;

@end
