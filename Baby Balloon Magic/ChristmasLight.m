//
//  ChristmasLight.m
//  Baby Balloon Magic
//
//  Created by Nicholas Rasband on 11/10/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "ChristmasLight.h"

#pragma mark -
#pragma mark Private Interface
@interface ChristmasLight ()
@end

#pragma mark -
@implementation ChristmasLight

#pragma mark Constructors
- (id) init
{
    self = [super init];
    if (self == nil)
        return nil;
    
    [self setLightAnimation:[self loadPlistForAnimationWithName:@"lightAnimation" andClassName:NSStringFromClass([self class]) withExtraPrefix:nil]];
    _animate = [[CCAnimate actionWithAnimation:[self lightAnimation] restoreOriginalFrame:YES] retain];
    CCRepeatForever* repeat = [CCRepeatForever actionWithAction:_animate];
    [self runAction:repeat];
    
    return self;
}

- (void) dealloc
{
    [_lightAnimation release];
    [_animate release];
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
@synthesize lightAnimation = _lightAnimation;

#pragma mark -
#pragma mark Methods

@end
