//
//  Star.m
//  BalloonMagic
//
//  Created by Nicholas Rasband on 8/12/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "Star.h"

#pragma mark -
#pragma mark Private Interface
@interface Star ()
- (void) triggerStarDelegate;
@end

#pragma mark -
@implementation Star

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
    _delegate = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
@synthesize delegate = _delegate;


#pragma mark -
#pragma mark Methods
- (void) fadeAway
{
    CCFadeTo* fadeTo = [CCFadeTo actionWithDuration:5.0f opacity:0];
    CCCallFunc* func = [CCCallFunc actionWithTarget:self selector:@selector(triggerStarDelegate)];
    CCSequence* sequence = [CCSequence actionOne:fadeTo two:func];
    [self runAction:sequence];
}

- (void) triggerStarDelegate
{
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(deleteStar:)])
    {
        [[self delegate] deleteStar:self];
    }
}

@end
