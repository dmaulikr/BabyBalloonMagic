//
//  AnimatedStar.h
//  BalloonMagic
//
//  Created by Nicholas Rasband on 8/12/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "Star.h"

@interface AnimatedStar : Star 
{
    CCAnimation* _starAnimation;
}
// Constructors
- (id) initWithStarID:(int)starID andSpriteFrameName:(NSString*)spriteFrameName;

@property (retain) CCAnimation* starAnimation;

@end
