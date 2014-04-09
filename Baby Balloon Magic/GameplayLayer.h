//
//  GameplayLayer.h
//  BalloonMagic
//
//  Created by Nicholas Rasband on 7/27/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "Box2D.h"
#import "GLES-Render.h"
#import "Boy.h"
#import "BoyFly.h"
#import "Sun.h"
#import "Moon.h"
#import "Balloon.h"
#import "BalloonInflate.h"
#import "Pop.h"
#import "Bird.h"
#import "Tree.h"
#import "Sheep.h"
#import "SoundManager.h"
#import "Star.h"
#import "AnimatedStar.h"

@interface GameplayLayer : CCLayer
{
    // SpriteBatchNode to save resources
    CCSpriteBatchNode* _spriteBatchNode;
    
    SoundManager* _soundManager;
    
    // Array to keep track of all of the objects that can be touched.
    NSMutableArray* _touchableObjects;
    NSArray* _balloonNames;
    NSMutableArray* _stars;
    CGSize _screenSize;
    BOOL _isDay;
    BOOL _allowRoofSheep;
    BOOL _allowSwipe;
    float _balloonLift;
    double _timeBetweenBalloonSpawns;
    double _timeBetweenBoyAnimations;
    double _timeBetweenSheepSpawns;
    int _currentStar;
    CGPoint _boyPosition;
    
    CCSprite* _daySky;
    
    // Box2D world
    b2World* _world;
    GLESDebugDraw* _debugDraw;
    
    Moon* _moon;
    Sun* _sun;
}

@property (assign) CGSize screenSize;
@property (assign) BOOL isDay;
@property (assign) BOOL allowRoofSheep;
@property (assign) BOOL allowSwipe;
@property (assign) int currentStar;
@property (assign) float balloonLift;
@property (assign) double timeBetweenBalloonSpawns;
@property (assign) double timeBetweenBoyAnimations;
@property (assign) double timeBetweenSheepSpawns;
@property (assign) CGPoint boyPosition;

@end
