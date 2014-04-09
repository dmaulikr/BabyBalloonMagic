//
//  Tree.m
//  BalloonMagic
//
//  Created by Nicholas Rasband on 8/3/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "Tree.h"

#pragma mark -
#pragma mark Private Interface
@interface Tree ()
@end

#pragma mark -
@implementation Tree

#pragma mark Constructors
- (id) init
{
    self = [super init];
    if (self == nil)
        return nil;
    
    [self setShakeAnimation:[self loadPlistForAnimationWithName:@"shakeAnimation" andClassName:NSStringFromClass([self class]) withExtraPrefix:nil]];
    _animate = [[CCAnimate actionWithAnimation:[self shakeAnimation] restoreOriginalFrame:YES] retain];
    _soundManager = [SoundManager sharedSoundManager];
    
    return self;
}

- (void) dealloc
{
    [_shakeAnimation release];
    [_animate release];
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
@synthesize shakeAnimation = _shakeAnimation;

#pragma mark -
#pragma mark Methods
- (void) handleTap:(CGSize)screenSize
{
    if ([self neverAnimated] || [_animate isDone])
    {
        [self setNeverAnimated:NO];
        [_soundManager playSoundEffect:@"tree_shake.caf"];
        [self runAction:_animate];
    }
}

@end
