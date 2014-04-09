//
//  Sheep.h
//  BalloonMagic
//
//  Created by Nicholas Rasband on 8/9/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "TappableGameObject.h"
#import "SoundManager.h"

#include <math.h>

#define LongestMoveTime 10
#define DistanceBetweenBounds [[CCDirector sharedDirector] winSize].height * 0.03125f
#define JumpHeight [[CCDirector sharedDirector] winSize].height * 0.172f
#define TimeToJump 12
#define NumberOfJumps 10
#define PI 3.14159265

typedef enum
{
    walkingLeft,
    walkingRight,
    boundingAway,
    jetAway
} SheepState;

@interface Sheep : TappableGameObject
{
    CCAnimation* _walkLeftAnimation;
    CCAnimation* _walkRightAnimation;
    CCAnimation* _jumpAnimation;
    SheepState _sheepState;
    BOOL _isRoofSheep;
    float _roofLeftX;
    float _roofRightX;
    float _roofWidth;
    SoundManager* _soundManager;
    
}
@property (retain) CCAnimation* walkLeftAnimation;
@property (retain) CCAnimation* walkRightAnimation;
@property (retain) CCAnimation* jumpAnimation;
@property (assign) SheepState sheepState;
@property (assign) float roofLeftX;
@property (assign) float roofRightX;
@property (assign) float roofWidth;
@property (assign) BOOL isRoofSheep;

- (void) runAnimation;

@end
