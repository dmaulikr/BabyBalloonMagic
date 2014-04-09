//
//  MainScene.m
//  BalloonMagic
//
//  Created by Nicholas Rasband on 7/27/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene

- (id)init
{
    self = [super init];
    if (self == nil)
        return nil;
    
    GameplayLayer* gameplayLayer = [GameplayLayer node];
    [self addChild:gameplayLayer];
    
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

@end
