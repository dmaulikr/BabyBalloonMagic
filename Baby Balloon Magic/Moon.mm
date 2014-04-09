//
//  Moon.m
//  BalloonMagic
//
//  Created by Nicholas Rasband on 8/9/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "Moon.h"

#pragma mark -
#pragma mark Private Interface
@interface Moon ()
@end

#pragma mark -
@implementation Moon

#pragma mark Constructors
- (id)init
{
    self = [super init];
    if (self) 
    {
        [self setMoonAnimation:[self loadPlistForAnimationWithName:@"moonAnimation" andClassName:NSStringFromClass([self class]) withExtraPrefix:nil]];
        _animate = [[CCAnimate actionWithAnimation:[self moonAnimation] restoreOriginalFrame:YES] retain];
    }
    
    _soundManager = [SoundManager sharedSoundManager];
    
    return self;
}

- (void) dealloc
{
    [_moonAnimation release];
    [_animate release];
    [super dealloc];
}

#pragma mark Accessors
@synthesize moonAnimation = _moonAnimation;

#pragma mark Methods
- (void) handleTap:(CGSize)screenSize
{
    if ([self neverAnimated] || [_animate isDone])
    {
        int chimeIndex = 1;
        chimeIndex = CCRANDOM_0_1() < 0.5f ? chimeIndex : 2;
        [_soundManager playSoundEffect:[NSString stringWithFormat:@"chimes_%i.caf", chimeIndex]];
        [self setNeverAnimated:NO];
        [self runAction:_animate];
    }
}

@end
