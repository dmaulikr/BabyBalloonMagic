//
//  Sun.m
//  BalloonMagic
//
//  Created by Nicholas Rasband on 7/28/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "Sun.h"
@implementation Sun

- (id)init
{
    self = [super init];
    if (self) 
    {
        [self setSurpriseAnimation:[self loadPlistForAnimationWithName:@"surpriseAnimation" andClassName:NSStringFromClass([self class]) withExtraPrefix:nil]];
        _animate = [[CCAnimate actionWithAnimation:[self surpriseAnimation] restoreOriginalFrame:YES] retain];
    }
    
    _soundManager = [SoundManager sharedSoundManager];
    
    return self;
}

- (void) dealloc
{
    [_surpriseAnimation release];
    [_animate release];
    [super dealloc];
}

#pragma mark Accessors
@synthesize surpriseAnimation = _surpriseAnimation;

#pragma mark Methods
- (void) handleTap:(CGSize)screenSize
{
    if ([self neverAnimated] || [_animate isDone])
    {
        [_soundManager playSoundEffect:@"sun_rattle.caf"];
        [self setNeverAnimated:NO];
        [self runAction:_animate];
    }
}

@end
