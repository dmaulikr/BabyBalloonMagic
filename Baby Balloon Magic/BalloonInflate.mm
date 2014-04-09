//
//  BalloonInflate.m
//  BalloonMagic
//
//  Created by Nicholas Rasband on 8/1/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "BalloonInflate.h"

#pragma mark -
#pragma mark Private Interface
@interface BalloonInflate ()
- (void) notifyDelegateForCleanup;
@end

#pragma mark -
@implementation BalloonInflate

#pragma mark Constructors
- (id) init
{
    self = [super init];
    if (self == nil)
        return nil;
    
    return self;
}

- (void) dealloc
{
    [_inflateBalloon release];
    [_balloonColor release];
    [self setDelegate:nil];
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
@synthesize inflateBalloon = _inflateBalloon;
@synthesize balloonColor = _balloonColor;
@synthesize delegate = _delegate;

#pragma mark -
#pragma mark Methods
- (void) startAnimationWithColor:(NSString*)color
{
    // Store the color for later reference.
    [self setBalloonColor:color];
    
    // Make sure we aren't running any actions.
    [self setInflateBalloon:[self loadPlistForAnimationWithName:@"inflateBalloon" andClassName:NSStringFromClass([self class]) withExtraPrefix:color]];
    CCAnimate* animate = [CCAnimate actionWithAnimation:[self inflateBalloon]];
    CCCallFunc* callFunc = [CCCallFunc actionWithTarget:self selector:@selector(notifyDelegateForCleanup)];
    CCSequence* sequence = [CCSequence actionOne:animate two:callFunc];
    [self runAction:sequence];
}

- (void) notifyDelegateForCleanup
{
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(cleanupBalloonInflate:)])
    {
        [[self delegate] cleanupBalloonInflate:self];
    }
}

@end
