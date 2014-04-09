//
//  Sheep.m
//  BalloonMagic
//
//  Created by Nicholas Rasband on 8/9/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "Sheep.h"

#pragma mark -
#pragma mark Private Interface
@interface Sheep ()
// Takes care of an action ending on a sheep, such as it reaching the end of the roof.
- (void) handleEndState;

// Triggered to allow the user to tap again
- (void) allowNextTap;

@end

#pragma mark -
@implementation Sheep

#pragma mark Constructors
- (id) init
{
    self = [super init];
    if (self == nil)
        return nil;
    
    [self setWalkLeftAnimation:[self loadPlistForAnimationWithName:@"walkLeftAnimation" andClassName:NSStringFromClass([self class]) withExtraPrefix:nil]];
    [self setWalkRightAnimation:[self loadPlistForAnimationWithName:@"walkRightAnimation" andClassName:NSStringFromClass([self class]) withExtraPrefix:nil]];
    [self setJumpAnimation:[self loadPlistForAnimationWithName:@"jumpAnimation" andClassName:NSStringFromClass([self class]) withExtraPrefix:nil]];
    
    [self schedule:@selector(allowNextTap) interval:0.4f];
    
    _soundManager = [SoundManager sharedSoundManager];

    
    return self;
}

- (void) dealloc
{
    //CCLOG(@"sheep dealloc called.");
    [_walkLeftAnimation release];
    [_walkRightAnimation release];
    [_jumpAnimation release];
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
@synthesize walkLeftAnimation = _walkLeftAnimation;
@synthesize walkRightAnimation = _walkRightAnimation;
@synthesize jumpAnimation = _jumpAnimation;
@synthesize sheepState = _sheepState;
@synthesize roofLeftX = _roofLeftX;
@synthesize roofRightX = _roofRightX;
@synthesize roofWidth = _roofWidth;
@synthesize isRoofSheep = _isRoofSheep;

#pragma mark -
#pragma mark Methods
- (void) handleTap:(CGSize)screenSize
{
    if ([self canTap])
    {
        int randomSoundIndex = CCRANDOM_0_1() * 7 + 1;
        // Play a random sheep sound
        [_soundManager playSoundEffect:[NSString stringWithFormat:@"sheep_%i.caf", randomSoundIndex]]; 
        
        [self setCanTap:NO];
        
        if ([self sheepState] == boundingAway)
        {
            [self setSheepState:jetAway];
            [_soundManager playSoundEffect:@"sheep_jump.caf"];
        }
        else
        {
        
            // With 15% chance, the roof sheep will bound away.
            BOOL bound = CCRANDOM_0_1() < 0.25 ? TRUE : FALSE;
            
            if (bound || [self sheepState] == boundingAway)
            {
                [self setSheepState:boundingAway];
            }
            else if ([self sheepState] == walkingLeft)
            {
                [self setSheepState:walkingRight];
            }
            else if ([self sheepState] == walkingRight)
            {
                [self setSheepState:walkingLeft];
            }
        }
            
        [self runAnimation];
    }
}

- (void) runAnimation
{
    // All sizes need to be relative to screen size.
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    // Make sure no actions are running.
    [self stopAllActions];
    
    if ([self sheepState] == walkingLeft)
    {
        CCAnimate* animate = [CCAnimate actionWithAnimation:[self walkLeftAnimation]];
        CCRepeat* repeat = [CCRepeat actionWithAction:animate times:50];
        
        float moveTime = LongestMoveTime * (([self position].x - [self roofLeftX])/[self roofWidth]);
        
        CCMoveTo* moveTo = [CCMoveTo actionWithDuration:moveTime position:ccp([self roofLeftX], [self position].y)];
        CCCallFunc* func = [CCCallFunc actionWithTarget:self selector:@selector(handleEndState)];
        CCSequence* sequence = [CCSequence actionOne:moveTo two:func];
        CCSpawn* spawn = [CCSpawn actionOne:repeat two:sequence];
        [self runAction:spawn];
    }
    else if ([self sheepState] == walkingRight)
    {
        CCAnimate* animate = [CCAnimate actionWithAnimation:[self walkRightAnimation]];
        CCRepeat* repeat = [CCRepeat actionWithAction:animate times:50];
        
        float moveTime = LongestMoveTime * (([self roofRightX] - [self position].x)/[self roofWidth]);
        
        CCMoveTo* moveTo = [CCMoveTo actionWithDuration:moveTime position:ccp([self roofRightX], [self position].y)];
        CCCallFunc* func = [CCCallFunc actionWithTarget:self selector:@selector(handleEndState)];
        CCSequence* sequence = [CCSequence actionOne:moveTo two:func];
        CCSpawn* spawn = [CCSpawn actionOne:repeat two:sequence];
        [self runAction:spawn];
    }
    else if ([self sheepState] == boundingAway)
    {
        // Generate a random angle between 15 and 175 degrees
        float randomAngle = CCRANDOM_0_1() * 160.0f + 15.0f;
        
        // Find out the vector that is formed by <1, 0> and the random angle.
        float x = cos(randomAngle * PI / 180.0f);
        float y = sqrt(1 - x*x);
        
        // Negate the sign of y sometimes.
        y = CCRANDOM_0_1() < 0.4f ? -y : y;
        
        /*
        //Now translate this point
        x = [self position].x + x;
        y = [self position].y + y;
        
        // Calculate the final vector
        x = x - [self position].x;
        y = y - [self position].y;
         */
        
        // Scale
        x = x * screenSize.width * 1.875f;
        y = y * screenSize.height * 1.25f;
        
        CCJumpTo* jumpTo = [CCJumpTo actionWithDuration:TimeToJump position:ccp(x, y) height:JumpHeight jumps:NumberOfJumps];
        CCAnimate* animate = [CCAnimate actionWithAnimation:[self jumpAnimation]];
        CCRepeat* repeat = [CCRepeat actionWithAction:animate times:50];
        CCSpawn* spawn = [CCSpawn actionOne:jumpTo two:repeat];
        [self runAction:spawn];
    }
    else if ([self sheepState] == jetAway)
    {
        [self unschedule:@selector(allowNextTap)];
        [self setCanTap:NO];
        
        // Generate a random angle between 15 and 175 degrees
        float randomAngle = CCRANDOM_0_1() * 160.0f + 15.0f;
        
        // Find out the vector that is formed by <1, 0> and the random angle.
        float x = cos(randomAngle * PI / 180.0f);
        float y = sqrt(1 - x*x);
        
        /*
         //Now translate this point
         x = [self position].x + x;
         y = [self position].y + y;
         
         // Calculate the final vector
         x = x - [self position].x;
         y = y - [self position].y;
         */
        
        // Scale
        x = x * screenSize.width * 1.35f;
        y = y * screenSize.height * 2.03f;
        
        CCJumpTo* jumpTo = [CCJumpTo actionWithDuration:2 position:ccp(x, y) height:JumpHeight jumps:2];
        CCAnimate* animate = [CCAnimate actionWithAnimation:[self jumpAnimation]];
        CCRepeat* repeat = [CCRepeat actionWithAction:animate times:10];
        CCSpawn* spawn = [CCSpawn actionOne:jumpTo two:repeat];
        [self runAction:spawn];   
    }
}
                                                                                
- (void) handleEndState
{
    [self handleTap:CGSizeZero];
}

- (void) allowNextTap
{
    [self setCanTap:YES];
}

- (BOOL) isOffScreen:(CGSize)screenSize
{
    BOOL offScreen = FALSE;
    
    float spriteHeight = [self boundingBox].size.height / 2;
    float spriteWidth = [self boundingBox].size.width / 2;
    
    // Check to see if sheep is off of the bottom, top, left, or right.
    if ([self position].x < -spriteWidth || [self position].y > screenSize.height + spriteHeight ||
        [self position].x > screenSize.width + spriteWidth || [self position].y < -spriteHeight)
    {
        offScreen = TRUE;
    }
    
    return offScreen;
}

@end
