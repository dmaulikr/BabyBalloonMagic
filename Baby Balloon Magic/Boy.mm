//
//  Boy.m
//  BalloonMagic
//
//  Created by Nicholas Rasband on 7/27/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "Boy.h"
#import "Balloon.h"

@implementation Boy

- (id)init
{
    self = [super init];
    if (self) 
    {
        [self setInflatingAnimation:[self loadPlistForAnimationWithName:@"inflationAnimation" andClassName:NSStringFromClass([self class]) withExtraPrefix:nil]];
    }
    
    return self;
}

- (void) dealloc
{
    [_inflatingAnimation release];
    [super dealloc];
}

#pragma mark Accessors
@synthesize inflatingAnimation = _inflatingAnimation;

#pragma mark Methods
- (void) startAnimation
{   
    CCAnimate* animate = [CCAnimate actionWithAnimation:[self inflatingAnimation]];
    [self runAction:animate];
}

@end
