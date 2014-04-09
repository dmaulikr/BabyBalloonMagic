//
//  Balloon.m
//  BalloonMagic
//
//  Created by Nicholas Rasband on 7/27/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "Balloon.h"

@implementation Balloon

- (id)init
{
    self = [super init];
    if (self) 
    {

    }
    
    return self;
}

- (void) dealloc
{
    //CCLOG(@"Deallocating balloon.");
    [_balloonName release];
    [super dealloc];
}

#pragma mark Accessors
@synthesize balloonName = _balloonName;
@synthesize offset = _offset;
@synthesize shouldPop = _shouldPop;
@synthesize isCatBalloon = _isCatBalloon;

- (CGSize) balloonSize
{
    if ([self balloonName] == nil)
    {
        return CGSizeZero;
    }
    else
    {
        // Make sure widths and heights are relative to screen size.
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        float width = 0;
        float height = 0;
        
        // Check to see if it is a heart balloon.
        if ([[self balloonName] rangeOfString:@"heart"].location != NSNotFound)
        {
            width = screenSize.width * 0.2125f;
            height = screenSize.height * 0.2f;
        }
        else if ([[self balloonName] rangeOfString:@"kitty"].location != NSNotFound)
        {
            width = screenSize.width * 0.2125f;
            height = screenSize.height * 0.25625f;
        }
        else if ([[self balloonName] rangeOfString:@"balloon"].location != NSNotFound)
        {
            width = screenSize.width * 0.129f;
            height = screenSize.height * 0.225f;
        }
        else
        {
            CCLOG(@"Invalid balloon name passed to balloonSize: %@", [self balloonName]);
        }
        
        return CGSizeMake(width, height);
    }
}

- (CGRect) popRect
{
    CGSize size = [self balloonSize];
    CGRect boundingRect = [self boundingBox];
    
    CGRect adjustedRect = CGRectZero;
    CGPoint adjustedOrigin = CGPointZero;
    
    adjustedRect.size = size;
    adjustedOrigin.x = boundingRect.origin.x;
    adjustedOrigin.y = boundingRect.origin.y + (boundingRect.size.height - size.height);
    adjustedRect.origin = adjustedOrigin;
    
    return adjustedRect;
}

#pragma mark Methods
- (void) handleTap:(CGSize)screenSize
{
    CCLOG(@"Right now, handleTap does nothing in the Balloon class.");
}

@end
