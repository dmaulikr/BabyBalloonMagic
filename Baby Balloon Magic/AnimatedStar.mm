//
//  AnimatedStar.m
//  BalloonMagic
//
//  Created by Nicholas Rasband on 8/12/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "AnimatedStar.h"

#pragma mark -
#pragma mark Private Interface
@interface AnimatedStar ()
@end

#pragma mark -
@implementation AnimatedStar

#pragma mark Constructors
- (id) initWithStarID:(int)starID andSpriteFrameName:(NSString*)spriteFrameName
{
    self = [super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:spriteFrameName]];
    if (self == nil)
        return nil;
    
    [self setStarAnimation:[self loadPlistForAnimationWithName:[NSString stringWithFormat:@"starAnimation%i", starID] andClassName:NSStringFromClass([self class]) withExtraPrefix:nil]];
    
    CCAnimate* animate = [CCAnimate actionWithAnimation:[self starAnimation] restoreOriginalFrame:YES];
    CCRepeatForever* repeat = [CCRepeatForever actionWithAction:animate];
    [self runAction:repeat];
    
    return self;
}

- (void) dealloc
{
    [_starAnimation release];    
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
@synthesize starAnimation = _starAnimation;

#pragma mark -
#pragma mark Methods

@end
