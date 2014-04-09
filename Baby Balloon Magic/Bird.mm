//
//  Bird.m
//  BalloonMagic
//
//  Created by Nicholas Rasband on 8/1/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "Bird.h"

#pragma mark -
#pragma mark Private Interface
@interface Bird ()

- (void) allowNextTap;

@end

#pragma mark -
@implementation Bird

#pragma mark Constructors

- (id) initWithSpriteFrame:(CCSpriteFrame*)spriteFrame andColor:(NSString*)color
{
    self = [super initWithSpriteFrame:spriteFrame];
    if (self)
    {
        if ([color isEqualToString:@"blue"])
        {
            [self setFlyingAnimation:[self loadPlistForAnimationWithName:@"flyingAnimation" andClassName:NSStringFromClass([self class]) withExtraPrefix:@"blue_"]];
        }
        else
        {
            [self setFlyingAnimation:[self loadPlistForAnimationWithName:@"flyingAnimation" andClassName:NSStringFromClass([self class]) withExtraPrefix:nil]];
        }
        [self schedule:@selector(allowNextTap) interval:0.4f];
    }
    
    return self;
}

- (void) dealloc
{
    //CCLOG(@"Deallocating bird.");
    [_flyingAnimation release];
    [super dealloc];
}

#pragma mark Accessors
@synthesize flyingAnimation = _flyingAnimation;
@synthesize numberOfTaps = _numberOfTaps;

#pragma mark Methods
- (void) handleTap:(CGSize)screenSize
{
    if ([self canTap])
    {
        [self setCanTap:NO];
    
        [self setNumberOfTaps:[self numberOfTaps] + 1];
        
        // Max number of seconds it can take to fly across the screen.
        float maxSeconds = 4.0f / [self numberOfTaps];
        
        // Figure out how much time the bird should have to get across the screen
        float timeToFly = ([self position].x / screenSize.width) * maxSeconds;
        
        // Stop current actions
        [self stopAllActions];
        
        //[_audioEngine playEffect:@"fast_bird.caf"];
        
        // Make the bird fly across the screen faster.
        [[self flyingAnimation] setDelay:FastFlyDelay];
        CCAnimate* animate = [CCAnimate actionWithAnimation:[self flyingAnimation]];
        CCRepeat* repeat = [CCRepeat actionWithAction:animate times:100];
        CCMoveTo* moveTo = [CCMoveTo actionWithDuration:timeToFly position:CGPointMake(-200.0f, [self position].y)];
        CCSpawn* spawn = [CCSpawn actionOne:repeat two:moveTo];
        [self runAction:spawn];
    }
}

- (void) runAnimation
{
    CCAnimate* animate = [CCAnimate actionWithAnimation:[self flyingAnimation]];
    CCRepeat* repeat = [CCRepeat actionWithAction:animate times:100];
    CCMoveTo* moveTo = [CCMoveTo actionWithDuration:25.0f position:CGPointMake(-200.0f, [self position].y)];
    CCSpawn* spawn = [CCSpawn actionOne:repeat two:moveTo];
    [self runAction:spawn];
}

- (CGRect) boundingBox
{
    // Get the original boundingBox
    CGRect rect = [super boundingBox];
    float originalHeight = rect.size.height;
    float originalWidth = rect.size.width;
    float halfWidth = originalWidth * 0.5f;
    
    // Increase the width
    rect.origin.x -= halfWidth;
    rect.size.width += originalWidth;
    
    // Increase the height
    rect.origin.y -= originalHeight;
    rect.size.height += 2 * originalHeight;
    
    // Make it bigger.
    return rect;
    
}

- (void) allowNextTap
{
    [self setCanTap:YES];
}

@end
