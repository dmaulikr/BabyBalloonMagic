//
//  Pop.m
//  BalloonMagic
//
//  Created by Nicholas Rasband on 7/28/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "Pop.h"

#pragma mark -
#pragma mark Private Interface
@interface Pop ()

- (void) notifyDelegateForCleanup;

@end

#pragma mark -
@implementation Pop

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
    [self setDelegate:nil];
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
@synthesize delegate = _delegate;

#pragma mark -
#pragma mark Methods
- (void) startFading
{
    CCFadeOut* fadeOut = [CCFadeOut actionWithDuration:0.7f];
    CCEaseSineIn* easeIn = [CCEaseSineIn actionWithAction:fadeOut];
    CCCallFunc* callFunc = [CCCallFunc actionWithTarget:self selector:@selector(notifyDelegateForCleanup)];
    CCSequence* sequence = [CCSequence actionOne:easeIn two:callFunc];
    [self runAction:sequence];
}
                            
- (void) notifyDelegateForCleanup
{
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(disposeOfPop:)])
    {
        [[self delegate] disposeOfPop:self];
    }
}



@end
