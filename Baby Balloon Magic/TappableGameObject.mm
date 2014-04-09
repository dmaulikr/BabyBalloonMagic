//
//  TappableGameObject.m
//  BalloonMagic
//
//  Created by Nicholas Rasband on 7/28/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "TappableGameObject.h"

#pragma mark -
#pragma mark Private Interface
@interface TappableGameObject ()
@end

#pragma mark -
@implementation TappableGameObject

#pragma mark Constructors
- (id) init
{
    self = [super init];
    if (self == nil)
        return nil;
    
    [self setNeverAnimated:YES];
    [self setCanTap:YES];
    
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
@synthesize neverAnimated = _neverAnimated;
@synthesize canTap = _canTap;

#pragma mark -
#pragma mark Methods
- (void) handleTap:(CGSize)screenSize
{
    CCLOG(@"The handleTap method should be overridden.");
}

- (BOOL) isOffScreen:(CGSize)screenSize
{
    BOOL offScreen = FALSE;
    
    float spriteHeight = [self boundingBox].size.height / 2;
    float spriteWidth = [self boundingBox].size.width / 2;
    
    if ([self position].x < -spriteWidth)
    {
        offScreen = TRUE;
    }
    else if ([self position].y > screenSize.height + spriteHeight)
    {
        offScreen = TRUE;
    }
    
    return offScreen;
}

@end
