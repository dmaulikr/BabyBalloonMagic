//
//  MenuScene.m
//  BalloonMagic
//
//  Created by Nicholas Rasband on 7/28/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "MenuScene.h"

#pragma mark -
#pragma mark Private Interface
@interface MenuScene ()
@end

#pragma mark -
@implementation MenuScene

#pragma mark Constructors
- (id) init
{
    self = [super init];
    if (self == nil)
        return nil;
    
    MenuLayer* menuLayer = [MenuLayer node];
    [self addChild:menuLayer];
    
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors

#pragma mark -
#pragma mark Methods

@end
