//
//  BoyFly.m
//  BalloonMagic
//
//  Created by Nicholas Rasband on 8/13/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "BoyFly.h"

#pragma mark -
#pragma mark Private Interface
@interface BoyFly ()
- (void) makeBalloonMove;
- (void) removeBoyFly;
@end

#pragma mark -
@implementation BoyFly

#pragma mark Constructors
- (id) init
{
    self = [super init];
    if (self == nil)
        return nil;
    
    [self setBoyFlyAnimation:[self loadPlistForAnimationWithName:@"boyFlyAnimation" andClassName:NSStringFromClass([self class]) withExtraPrefix:nil]];
    
    return self;
}

- (void) dealloc
{
    CCLOG(@"Deallocating boyfly");
    [_balloon release];
    _delegate = nil;
    [_boyFlyAnimation release];
    [_direction release];

    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
@synthesize boyFlyAnimation = _boyFlyAnimation;
@synthesize direction = _direction;
@synthesize delegate = _delegate;

- (CCSprite*) balloon
{
    return _balloon;
}

#pragma mark -
#pragma mark Methods
- (void) flyUp
{
    [self setDirection:@"up"];
    CCAnimate* animate = [CCAnimate actionWithAnimation:[self boyFlyAnimation] restoreOriginalFrame:NO];
    CCCallFunc* func = [CCCallFunc actionWithTarget:self selector:@selector(makeBalloonMove)];
    CCSequence* sequence = [CCSequence actionOne:animate two:func];
    [self runAction:sequence];
}

- (void) flyDown:(CGPoint)boyPosition
{
    // Position everything by percentages.
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    [self setDirection:@"down"];
    CCMoveTo* boyMoveTo = [CCMoveTo actionWithDuration:4.8f position:boyPosition];
    CCCallFunc* func = [CCCallFunc actionWithTarget:self selector:@selector(removeBoyFly)];
    CCSequence* sequence = [CCSequence actionOne:boyMoveTo two:func];
    
    // Create a new balloon and add it to the batch node
    _balloon = [[Balloon alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"red_balloon.png"]];
    [_balloon setPosition:ccp([self position].x + screenSize.width * 0.06f, screenSize.height * 1.6)];
    [[self batchNode] addChild:_balloon z:BoysBalloonSpriteZValue tag:BoysBalloonTagValue];
    
    CCMoveTo* balloonMoveTo = [CCMoveTo actionWithDuration:5.5f position:ccp([_balloon position].x, boyPosition.y)];
    
    [self runAction:sequence];
    [_balloon runAction:balloonMoveTo];
    
    
}
                        
- (void) makeBalloonMove
{
    // Position everything by percentages.
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    // Create a new balloon and add it to the batch node
    _balloon = [[Balloon alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"red_balloon.png"]];
    [_balloon setPosition:ccp([self position].x + screenSize.width * 0.06f, [self position].y + screenSize.height * 0.31f)];
    [[self batchNode] addChild:_balloon z:BoysBalloonSpriteZValue tag:BoysBalloonTagValue];
    
    // BoyFly actions
    CCMoveTo* moveToBoy = [CCMoveTo actionWithDuration:4.8f position:ccp([self position].x, screenSize.height * 1.4f)];
    CCCallFunc* func = [CCCallFunc actionWithTarget:self selector:@selector(removeBoyFly)];
    CCSequence* sequence = [CCSequence actionOne:moveToBoy two:func];
    
    // Balloon action
    CCMoveTo* moveToBalloon = [CCMoveTo actionWithDuration:3.6f position:ccp([_balloon position].x, screenSize.height * 1.4f)];
    
    
    [self stopAllActions];
    [self runAction:sequence];
    [_balloon runAction:moveToBalloon];
    
}

- (void) removeBoyFly
{
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(deleteBoyFly:withDirection:)])
    {
        if ([[self direction] isEqualToString:@"up"])
        {
            [[self delegate] deleteBoyFly:self withDirection:@"up"];
        }
        else
        {
            [[self delegate] deleteBoyFly:self withDirection:@"down"];
        }
    }
}




@end
