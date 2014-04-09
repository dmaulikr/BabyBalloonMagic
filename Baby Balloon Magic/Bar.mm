//
//  Bar.m
//  BalloonMagic
//
//  Created by Nicholas Rasband on 8/13/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "Bar.h"

#pragma mark -
#pragma mark Private Interface
@interface Bar ()
@end

#pragma mark -
@implementation Bar

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
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors

#pragma mark -
#pragma mark Methods
- (CGRect) boundingBox
{
    // Get the original boundingBox
    CGRect rect = [super boundingBox];
    float originalHeight = rect.size.height;
    //float originalWidth = rect.size.width;
    //float halfWidth = originalWidth * 0.5f;
    
    // Increase the width
    //rect.origin.x -= halfWidth;
    //rect.size.width += originalWidth;
    
    // Take in the sides the height
    rect.origin.y -= originalHeight;
    rect.size.height += 2 * originalHeight;
    
    // Make it bigger.
    return rect;
    
}

@end
