//
//  GameplayLayer.m
//  BalloonMagic
//
//  Created by Nicholas Rasband on 7/27/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "GameplayLayer.h"
#import "Constants.h"
#import "ChristmasLight.h"

@interface GameplayLayer()<PopDelegate, BalloonInflateDelegate, StarDelegate, BoyFlyDelegate>

// Creates the Box2D world
- (void) setupWorld;

// Sets up debug drawing in Box2D
- (void) setupDebugDraw;

    // Create the Box2D floor and walls
- (void) createBoundaries:(CGSize)screenSize;

- (void) createBalloonAtLocation:(CGPoint)location withName:(NSString*)balloonName inFrontOfRoof:(BOOL)inFrontOfRoof;

// Pops the balloon and removes its resources.
- (void) popBalloon:(Balloon*)balloon AtPoint:(CGPoint)point;

- (void) popWhiteBalloonAtPoint:(CGPoint)point;

// Creates balloons at the bottom of the screen
- (void) spawnRandomBalloons;

// Spawns a bird from the right side of the screen
- (void) spawnBird;

// Spawns a sheep that jumps around the sky
- (void) spawnSheep;

// Spawns a sheep that walks on the roof
- (void) spawnRoofSheep;

// Animates the boy blowing up a balloon and creates the balloon
- (void) animateBoy;

- (void) spawnFlyBoy:(NSString*)direction;

// Adds the sun to the scene.
- (void) addSun;

// Removes the sun from the scene.
- (void) removeSun;

// Adds the moon to the scene.
- (void) addMoon;

- (void) addStar;

// Removes the moon from the scene.
- (void) removeMoon;

- (void) processTouches:(NSSet*)touches;

@end

@implementation GameplayLayer

- (id)init
{
    self = [super init];
    if (self == nil)
        return nil;
    
    [self setScreenSize:[[CCDirector sharedDirector] winSize]];
    CGSize screenSize = [self screenSize];
    
    _soundManager = [SoundManager sharedSoundManager];
    
    // Find out the user's current speed setting and time the game based off of that.
    float currentSpeedSetting = [[NSUserDefaults standardUserDefaults] floatForKey:SpeedKey];
    
    if (currentSpeedSetting > 50)
    {
        [self setAllowSwipe:NO];
    }
    else
    {
        [self setAllowSwipe:YES];
    }
    
    float normalizedSpeed = currentSpeedSetting / 100.0f;
    
    // Set the balloon lift
    float lift = (MaxBalloonLift - MinBalloonLift) * normalizedSpeed + MinBalloonLift;
    [self setBalloonLift:lift];
    CCLOG(@"balloon lift: %f", lift);
    
    // Set the time between balloon spawns
    float balloonSpawnTime = (1.0f - normalizedSpeed) * (MaxTimeBetweenBalloonSpawns - MinTimeBetweenBalloonSpawns) + MinTimeBetweenBalloonSpawns;
    [self setTimeBetweenBalloonSpawns:balloonSpawnTime];
    CCLOG(@"balloonSpawnTime: %f", balloonSpawnTime);
    
    // Set the time between boy animations
    float boyAnimationTime = (1.0f - normalizedSpeed) * (MaxTimeBetweenBoyAnimations - MinTimeBetweenBoyAnimations) + MinTimeBetweenBoyAnimations;
    [self setTimeBetweenBoyAnimations:boyAnimationTime];
    CCLOG(@"boyAnimationTime: %f", boyAnimationTime);
    
    // Set time between sheep spawns
    float sheepSpawnTime = (1.0f - normalizedSpeed) * (MaxTimeBetweenSheepSpawns - MinTimeBetweenSheepSpawns) + MinTimeBetweenSheepSpawns;
    [self setTimeBetweenSheepSpawns:sheepSpawnTime];
    CCLOG(@"sheepSpawnTime: %f", sheepSpawnTime);
    
    // Enable touches
    [self setIsTouchEnabled:YES];
    
    // Use the iPad sprite sheet if running on iPad
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // Add the frames to the sharedSpriteFrameCache
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:iPadPlist];
        _daySky = [[CCSprite spriteWithFile:@"sky_background_ipad.png"] retain];
        _spriteBatchNode = [[CCSpriteBatchNode batchNodeWithFile:iPadSpriteFile capacity:108] retain];
        [self setBoyPosition:ccp(screenSize.width * 0.28f, screenSize.height * 0.30f)];
    }
    else
    {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:iPhonePlist];
        _daySky = [[CCSprite spriteWithFile:@"sky_background.png"] retain];        
        _spriteBatchNode = [[CCSpriteBatchNode batchNodeWithFile:iPhoneSpriteFile capacity:108] retain];
        [self setBoyPosition:ccp(screenSize.width * 0.28f, screenSize.height * 0.32f)];
    }
    
    [self addChild:_daySky z:0];
    [self addChild:_spriteBatchNode z:0];
    
    CCSprite* roof = [[[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]  spriteFrameByName:@"roof.png"]] autorelease];
    
    float roofXPos = screenSize.width - [roof boundingBox].size.width * 0.5f;
    float roofYPos = [roof boundingBox].size.height * 0.5f;
    CGPoint roofPos = ccp(roofXPos, roofYPos);
    
    [roof setPosition:roofPos];
    [_daySky setPosition:ccp(screenSize.width / 2, screenSize.height / 2)];
    
    [_spriteBatchNode addChild:roof z:RoofZValue tag:RoofTagValue];
    
    // Create the Christmas roof
    ChristmasLight* christmasLight = [[[ChristmasLight alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"christmas_light_1.png"]] autorelease];
    [christmasLight setPosition:roofPos];
    [_spriteBatchNode addChild:christmasLight z:ChristmasRoofZValue];
    
    
    // Create a night/day cycle that changes every DayNightLength. Run this forever.
    CCFiniteTimeAction* getDark = [CCTintTo actionWithDuration:DayLength red:8 green:12 blue:69];
    CCFiniteTimeAction* getLight = [CCTintTo actionWithDuration:NightLength red:255 green:255 blue:255];
    CCSequence* sequence = [CCSequence actionOne:getDark two:getLight];
    CCRepeatForever* repeat = [CCRepeatForever actionWithAction:sequence];
    [_daySky runAction:repeat];
    
    
    // Create boy
    Boy* boy = [[[Boy alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]  spriteFrameByName:@"boy_ani_1.png"]] autorelease];
    
    // Set the boy's position on the screen
    
    [boy setPosition:[self boyPosition]];
    
    // Add the boy to the Sprite batch node for performance.
    [_spriteBatchNode addChild:boy z:BoySpriteZValue tag:BoySpriteTagValue];
    
    // Create the tree
    Tree* tree = [[[Tree alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tree_ani_1.png"]] autorelease];
    
    // Set the tree's position
    [tree setPosition:ccp([tree boundingBox].size.width * 0.5f, [tree boundingBox].size.height * 0.45f)];
    
    // Add the tree to the sprite batch node
    [_spriteBatchNode addChild:tree z:TreeZValue];
    
    // Create an array of all touchable objects.
    _touchableObjects = [[NSMutableArray arrayWithObjects:tree, nil] retain];
    
    [self addSun];
    
    // Store the names of the balloons
    _balloonNames = [[NSArray arrayWithObjects:@"blue_balloon.png", @"blue_heart_balloon.png", 
                      @"kitty_balloon.png", @"green_balloon.png", @"green_heart_balloon.png",
                      @"purple_balloon.png", @"red_balloon.png", @"red_heart_balloon.png", 
                      @"violet_balloon.png", @"violet_heart_balloon.png", @"yellow_balloon.png",
                      @"yellow_heart_balloon.png", nil] retain];
    
    [self setIsDay:YES]; // Start out in the day time.
    [self setAllowRoofSheep:YES];
    
    [self setupWorld];
    [self createBoundaries:screenSize];
    //[self setupDebugDraw];
    [self scheduleUpdate];
    
    [_soundManager playDayMusic];
    
    return self;
}

- (void) dealloc
{
    // Release objective-c variables
    [self stopAllActions];
    [_touchableObjects release];
    [_balloonNames release];
    [_spriteBatchNode release];
    [_daySky release];
    if (_stars != nil)
    {
        [_stars release];
    }
    
    if (_moon != nil)
    {
        [_moon release];
    }
    
    if (_sun != nil)
    {
        [_sun release];
    }
    
    // Delete Box2D variables
    delete _world;
    _world = NULL;
    
    //delete _debugDraw;
    //_debugDraw = NULL;
    
    [_soundManager unloadMainSceneAudio];
    
    //[[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    
    
    // Delete
    [super dealloc];
}

#pragma mark Accessors
@synthesize screenSize = _screenSize;
@synthesize isDay = _isDay;
@synthesize allowRoofSheep = _allowRoofSheep;
@synthesize allowSwipe = _allowSwipe;
@synthesize balloonLift = _balloonLift;
@synthesize timeBetweenBalloonSpawns = _timeBetweenBalloonSpawns;
@synthesize timeBetweenBoyAnimations = _timeBetweenBoyAnimations;
@synthesize timeBetweenSheepSpawns = _timeBetweenSheepSpawns;
@synthesize currentStar = _currentStar;
@synthesize boyPosition = _boyPosition;

/*
- (void) draw
{
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_COLOR_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
    _world->DrawDebugData();
    
    glEnable(GL_TEXTURE_2D);
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
}
*/

#pragma mark Methods

- (void) update:(ccTime)deltaTime
{    
    static double UPDATE_INTERVAL = 1.0f/60.0f;
    static double MAX_CYCLES_PER_FRAME = 5;
    static double timeAccumulator = 0;
    static double timeSinceLastBalloonSpawn = [self timeBetweenBalloonSpawns]; // Start out with balloons
    static double timeSinceLastBirdSpawn = 0.0;
    static double timeSinceLastBoyAnimation = [self timeBetweenBoyAnimations]; // Start out with balloon
    static double timePassedForCurrentPhase = DayCycleOffset; // Time passed while it is day or night.
    static double timeSinceLastSheepSpawn = [self timeBetweenSheepSpawns];
    static double timeSinceLastStarSpawn = 0.0;
    
    timeSinceLastBalloonSpawn += deltaTime;
    timeSinceLastBirdSpawn += deltaTime;
    timeSinceLastBoyAnimation += deltaTime;
    timePassedForCurrentPhase += deltaTime;
    timeSinceLastSheepSpawn += deltaTime;
    
    // Spawn more balloons if it has been long enough
    if ([self isDay] && timeSinceLastBalloonSpawn > [self timeBetweenBalloonSpawns])
    {
        // Reset time
        timeSinceLastBalloonSpawn = 0.0;
        
        //CCLOG(@"touchableObjects: %i", [_touchableObjects count]);
        //CCLOG(@"_sprites: %i", [[_spriteBatchNode descendants] count]);
        
        // Spawn more balloons
        [self spawnRandomBalloons];
        
    }
    
    // Spawn another bird if it has been long enough
    if ([self isDay] && timeSinceLastBirdSpawn > TimeBetweenBirdSpawns)
    {
        timeSinceLastBirdSpawn = 0.0;
        
        // Spawn bird
        [self spawnBird];
    }
    
    // Have the boy blow up a balloon if it has been long enough
    if ([self isDay] && timeSinceLastBoyAnimation > [self timeBetweenBoyAnimations] && timePassedForCurrentPhase < DayLength - 5)
    {
        timeSinceLastBoyAnimation = 0.0;
        
        // Animate boy
        [self animateBoy];
    }
    
    // Switch from day to night or night to day.
    if ([self isDay] && timePassedForCurrentPhase > DayLength)
    {
        // Create array to store stars
        _stars = [[NSMutableArray array] retain];
        // Reset time passed
        timePassedForCurrentPhase = 0.0;
        
        [self spawnFlyBoy:@"up"];
        
        // Switch from day to night
        [self setIsDay:NO];
        
        // Load night sounds        
        [_soundManager playNightMusic];
        [self setAllowRoofSheep:YES];
        


        // Get rid of balloons and birds that shouldn't be around anymore.
        NSMutableArray* itemsToDelete = [NSMutableArray array];
        for (GameObject* gameObject in _touchableObjects) 
        {
            if ([gameObject isKindOfClass:[Bird class]] || [gameObject isKindOfClass:[Balloon class]])
            {                
                if ([gameObject isKindOfClass:[Balloon class]])
                {
                    Balloon* balloon = (Balloon*)gameObject;
                    [balloon setShouldPop:YES];
                }
                else
                {
                    [self popWhiteBalloonAtPoint:[gameObject position]];
                    [itemsToDelete addObject:gameObject];
                    [_spriteBatchNode removeChild:gameObject cleanup:YES];
                }
            }
        }
        
        // Remove items from touchableObjects array
        [_touchableObjects removeObjectsInArray:itemsToDelete];
         
        // Remove the sun from memory and add the moon.
        [self removeSun];
        [self addMoon];
    }
    else if (![self isDay] && timePassedForCurrentPhase > NightLength)
    {
        // Reset the time passed
        timePassedForCurrentPhase = 0.0;
        
        [self spawnFlyBoy:@"down"];
        
        [self setIsDay:YES];
        
        [_soundManager playDayMusic];
        
        // Unload night sounds
        [_soundManager unloadNightAudio];
        
        // Get rid of sheep and stars that shouldn't be around anymore.
        NSMutableArray* sheepToDelete = [NSMutableArray array];
        for (GameObject* gameObject in _touchableObjects) 
        {
            if ([gameObject isKindOfClass:[Sheep class]])
            {
                [sheepToDelete addObject:gameObject];
                [_spriteBatchNode removeChild:gameObject cleanup:YES];
                [self popWhiteBalloonAtPoint:[gameObject position]];
            }
        }
        
        // Remove sheep from touchableObjects array
        [_touchableObjects removeObjectsInArray:sheepToDelete];
        
        for (Star* star in _stars)
        {
            [star fadeAway];
        }
        
        [_stars release];
        [self setCurrentStar:0];
            
        // Remove the moon and add the sun.
        [self removeMoon];
        [self addSun];
    }
    
    // Now make the sun or moon move.
    if ([self isDay])
    {
        CGPoint currentPosition = [_sun position];
        
        if (currentPosition.y > [self screenSize].height * 0.875f)
        {
            float offset =  ([self screenSize].height / DayLength) * deltaTime;
            [_sun setPosition:ccp(currentPosition.x - offset, currentPosition.y - offset)];
        }
        
        if (timePassedForCurrentPhase > DayLength - 10)
        {
            // Make the sun drop quickly
            float yOffset = (currentPosition.y / (DayLength - timePassedForCurrentPhase)) * deltaTime;
            [_sun setPosition:ccp(currentPosition.x - (yOffset * 0.5f), currentPosition.y - yOffset)];
        }
    }
    else
    {
        timeSinceLastStarSpawn += deltaTime;
        if ([self currentStar] < 19 && timeSinceLastStarSpawn >= 2.0)
        {
            timeSinceLastStarSpawn = 0.0;
            [self addStar];
        }
        
        CGPoint currentPosition = [_moon position];
        
        if (currentPosition.y > [self screenSize].height * 0.875f)
        {
            float offset =  ([self screenSize].height / NightLength) * deltaTime;
            [_moon setPosition:ccp(currentPosition.x - offset, currentPosition.y - offset)];
        }
        
        if (timePassedForCurrentPhase > NightLength - 10)
        {
            // Make the sun drop quickly
            float yOffset = (currentPosition.y / (NightLength - timePassedForCurrentPhase)) * deltaTime;
            [_moon setPosition:ccp(currentPosition.x - (yOffset * 0.5f), currentPosition.y - yOffset)];
        }
    }
    
    // If it is night time and enough time has passed, spawn a sheep.
    if (![self isDay] && timeSinceLastSheepSpawn >= [self timeBetweenSheepSpawns])
    {
        // Reset sheep spawn time
        timeSinceLastSheepSpawn = 0.0;
        
        // Spawn more sheep
        if ([self allowRoofSheep])
        {
            [self spawnRoofSheep];
        }
        else
        {
            [self spawnSheep];
        }
    }
    
    timeAccumulator += deltaTime;
    
    if (timeAccumulator > (MAX_CYCLES_PER_FRAME * UPDATE_INTERVAL))
    {
        timeAccumulator = UPDATE_INTERVAL;
    }
    
    int32 velocityIterations = 6;
    int32 positionIterations = 4;
    
    while (timeAccumulator >= UPDATE_INTERVAL)
    {
        timeAccumulator -= UPDATE_INTERVAL;
        _world->Step(UPDATE_INTERVAL, velocityIterations, positionIterations);
        
        //Iterate over the bodies in the physics world
        for (b2Body* b = _world->GetBodyList(); b; b = b->GetNext())
        {
            if (b->GetUserData() != NULL) 
            {
                //Synchronize the AtlasSprites position and rotation with the corresponding body
                Balloon* balloon = (Balloon*)b->GetUserData();
                
                // Time to release the balloon
                if ([balloon position].y > [self screenSize].height * 1.56f || [balloon shouldPop])
                {
                    if ([balloon shouldPop])
                    {
                        CGSize balloonSize = [balloon balloonSize];
                        float yLocation = [balloon boundingBox].origin.y + [balloon boundingBox].size.height - (balloonSize.height * 0.5f);
                        [self popWhiteBalloonAtPoint:CGPointMake([balloon position].x, yLocation)];
                    }
                    
                    [_touchableObjects removeObject:balloon];
                    [_spriteBatchNode removeChild:balloon cleanup:YES];
                    _world->DestroyBody(b);
                }
                else
                {
                    [balloon setPosition:ccp( b->GetPosition().x * PTM_RATIO, (b->GetPosition().y - [balloon offset] / PTM_RATIO) * PTM_RATIO)];
                    b->ApplyLinearImpulse(b2Vec2(0, [self balloonLift]), b2Vec2([balloon position].x / PTM_RATIO, [balloon position].y / PTM_RATIO));
                    [balloon setRotation:-1 * CC_RADIANS_TO_DEGREES(b->GetAngle())];
                }
            }	
        }

        // Check for items that need to be removed because they are offscreen
        // Don't do this for balloons, because they are already being handled.
        NSMutableArray* itemsToDelete = [NSMutableArray array];
        for (TappableGameObject* gameObject in _touchableObjects)
        {
            if (![gameObject isKindOfClass:[Balloon class]] && [gameObject isOffScreen:[self screenSize]])
            {
                // Check to see if another sheep can be put on the roof
                if ([gameObject isKindOfClass:[Sheep class]])
                {
                    Sheep* sheep = (Sheep*)gameObject;
                    if ([sheep isRoofSheep])
                    {
                        [self setAllowRoofSheep:YES];
                    }
                }
                [itemsToDelete addObject:gameObject];
                [_spriteBatchNode removeChild:gameObject cleanup:YES];
            }
        }
        
        // Delete objects that are off-screen
        [_touchableObjects removeObjectsInArray:itemsToDelete];
    
    }
}

- (void)processTouches:(NSSet*)touches
{
    //BOOL tappableObjectTapped = FALSE;
    NSMutableArray* balloonsToPop = [NSMutableArray array];
    
    // Loop through all of the touches in the set
    for (UITouch* touch in touches) 
    {
        CGPoint touchPoint = [self convertTouchToNodeSpace:touch];
        
        // Loop through all of the tappable objects to see if one was tapped.
        for (TappableGameObject* tappableObject in _touchableObjects) 
        {
            // Check to see if this object was tapped.
            if (CGRectContainsPoint([tappableObject boundingBox], touchPoint))
            {
                if ([tappableObject isKindOfClass:[Balloon class]])
                {
                    // Pop the balloon
                    Balloon* balloon = (Balloon*)tappableObject;
                    if (CGRectContainsPoint([balloon popRect], touchPoint))
                    {
                        // Add this balloon to the list of balloons that will be destroyed.
                        [balloonsToPop addObject:balloon];
                    }
                }
                else
                {
                    // Run this item's handleTap method to respond to the tap
                    [tappableObject handleTap:[self screenSize]];
                } 
            }
        }
    }
    
    
    // If there are balloons to pop, pop them.
    if ([balloonsToPop count] > 0)
    {
        // Remove resources of balloon
        // Find the world body and delete it.
        for (b2Body* b = _world->GetBodyList(); b; b = b->GetNext())
        {
            if (b->GetUserData() != NULL)
            {
                // If this is the correct balloon, delete it.
                Balloon* balloonToDelete = (Balloon*)b->GetUserData();
                
                // Check against the balloonsToPop balloons
                for (Balloon* balloon in balloonsToPop) 
                {
                    if ([balloon isEqual:balloonToDelete])
                    {                    
                        _world->DestroyBody(b);
                        [_spriteBatchNode removeChild:balloon cleanup:YES];
                        
                        // Pop the balloon
                        // Calculate the center of the balloon so that the balloon pops at that spot.
                        CGSize balloonSize = [balloon balloonSize];
                        float yLocation = [balloon boundingBox].origin.y + [balloon boundingBox].size.height - (balloonSize.height * 0.5f);
                        [self popBalloon:(Balloon*)balloon AtPoint:CGPointMake([balloon position].x, yLocation)];
                        break;
                    }
                }
            }
        }
        
        // Delete balloons from the _toucableObjects array
        [_touchableObjects removeObjectsInArray:balloonsToPop];
        
    }
    
    // If the user didn't tap anything, use this opportunity to create a new balloon.
    /*
     if (!tappableObjectTapped)
     {
     CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
     [self createBalloonAtLocation:location];
     }
     */    
}

- (void)ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent *)event;
{
    [self processTouches:touches];
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Only allow swipe if the speed setting is low enough.
    if ([self allowSwipe])
    {
        [self processTouches:touches];
    }
}

- (void) setupWorld
{
    b2Vec2 gravity = b2Vec2(0.0f, -10.0f);
    bool doSleep = false;
    _world = new b2World(gravity, doSleep);
}

- (void) setupDebugDraw 
{
    _debugDraw = new GLESDebugDraw(PTM_RATIO * [[CCDirector sharedDirector] contentScaleFactor]);
    _world->SetDebugDraw(_debugDraw);
    _debugDraw->SetFlags(b2DebugDraw::e_shapeBit);
}

- (void) createBoundaries:(CGSize)screenSize
{
    b2BodyDef groundBodyDef;
    groundBodyDef.type = b2_staticBody;
    groundBodyDef.position.Set(0, 0); // Bottom-left corner
    
    b2Body* groundBody = _world->CreateBody(&groundBodyDef);
    
    // Define the ground box shape.
    b2PolygonShape groundBox;
    
    // bottom
    //groundBox.SetAsEdge(b2Vec2(0, 0), b2Vec2(screenSize.width / PTM_RATIO, 0));
    //groundBody->CreateFixture(&groundBox, 0);
    
    // Left
    groundBox.SetAsEdge(b2Vec2(0, screenSize.height / PTM_RATIO), b2Vec2(0, 0));
    groundBody->CreateFixture(&groundBox, 0);
    
    // Right
    groundBox.SetAsEdge(b2Vec2(screenSize.width / PTM_RATIO, screenSize.height / PTM_RATIO), b2Vec2(screenSize.width / PTM_RATIO, 0));
    groundBody->CreateFixture(&groundBox, 0);
    
}

- (void) createBalloonAtLocation:(CGPoint)location withName:(NSString*)balloonName inFrontOfRoof:(BOOL)inFrontOfRoof
{
    // Choose a random balloon
    int balloonIndex = CCRANDOM_0_1() * ([_balloonNames count] - 1);
    
    // Create a sprite to represent the balloon
    Balloon* balloon = nil;
    
    if (balloonName == nil)
    {
        balloonName = [_balloonNames objectAtIndex:balloonIndex];
        balloon = [[[Balloon alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:balloonName]] autorelease];
    }
    else
    {
        balloon = [[[Balloon alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:balloonName]] autorelease];
    }
    
    if ([balloonName isEqualToString:@"kitty_balloon.png"])
    {
        [balloon setIsCatBalloon:YES];
    }
        
    [balloon setPosition:location];
    [balloon setBalloonName:[_balloonNames objectAtIndex:balloonIndex]];
    
    if (inFrontOfRoof)
    {
        [_spriteBatchNode addChild:balloon z:BalloonInFrontOfRoofZValue];
    }
    else
    {
        [_spriteBatchNode addChild:balloon z:BalloonSpriteZValue];
    }
    
    [_touchableObjects addObject:balloon];
    
    
    // Create the balloon's body
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    
    CGSize balloonSize = [balloon balloonSize];
    float yLocation = [balloon boundingBox].origin.y + [balloon boundingBox].size.height - (balloonSize.height * 0.5f);

    [balloon setOffset:yLocation - [balloon position].y];
        
    bodyDef.position = b2Vec2(location.x / PTM_RATIO, yLocation / PTM_RATIO);
    bodyDef.userData = balloon;
    b2Body* body = _world->CreateBody(&bodyDef);
    
    // Create the fixture for the balloon
    b2PolygonShape shape;
    shape.SetAsBox((balloonSize.width * 0.5f) / PTM_RATIO, (balloonSize.height * 0.5f) / PTM_RATIO);
    
    b2FixtureDef balloonFixture;
    balloonFixture.shape = &shape;
    balloonFixture.density = 0.1f;
    
    body->CreateFixture(&balloonFixture);
    
    // Set the body's mass to a constant
    b2MassData massData;
    massData.center = bodyDef.position;
    massData.mass = 0.2f;
    massData.I = 0;
    body->SetMassData(&massData);
}

- (void) popBalloon:(Balloon*)balloon AtPoint:(CGPoint)point
{
    int popIndex = CCRANDOM_0_1() * 10 + 1;
    
    if ([balloon isCatBalloon])
    {
        [_soundManager playSoundEffect:@"cat_1.caf"];
    }
    else
    {
        // Play the correct pop
        [_soundManager playSoundEffect:[NSString stringWithFormat:@"pop_%i.caf", popIndex]];
    }
    
    // Now create the pop
    // First choose a random pop image
    
    Pop* pop = [[[Pop alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"pop_%i.png", popIndex]]] autorelease];
    [pop setDelegate:self];
    [_spriteBatchNode addChild:pop z:PopSpriteZValue];
    [pop setPosition:point];
    [pop startFading];
    
}

- (void) popWhiteBalloonAtPoint:(CGPoint)point
{
    int popIndex = 9;
    
    // Play the correct pop
    [_soundManager playSoundEffect:[NSString stringWithFormat:@"pop_%i.caf", popIndex]];
    
    Pop* pop = [[[Pop alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"pop_%i.png", popIndex]]] autorelease];
    [pop setDelegate:self];
    [_spriteBatchNode addChild:pop z:PopSpriteZValue];
    [pop setPosition:point];
    [pop startFading];}

- (void) spawnRandomBalloons
{
    int numberOfBalloonsToSpawn = clampf(CCRANDOM_0_1() * MaximumNumBalloonsCreated, MinimumNumBalloonsCreated, MaximumNumBalloonsCreated);
    
    for (int i = 0; i < numberOfBalloonsToSpawn; i++) 
    {
        // Randomly choose whether to put ballons in front of the roof or not.
        BOOL inFront = CCRANDOM_0_1() >= 0.5f ? FALSE : TRUE;
        float xSpawn = CCRANDOM_0_1() * [self screenSize].width;
        
        // Spawn at the bottom of the screen
        CGPoint location = CGPointMake(xSpawn, -20.0f);
        [self createBalloonAtLocation:location withName:nil inFrontOfRoof:inFront];
    }
}

- (void) spawnBird
{
    // Create blue birds half of the time.
    BOOL createBlueBird = CCRANDOM_0_1() < 0.5f;
    
    Bird* bird = nil;
    
    // Create a bird
    if (createBlueBird)
    {
        bird = [[[Bird alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"blue_bird_ani_1.png"] andColor:@"blue"] autorelease];
    }
    else
    {
        bird = [[[Bird alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bird_ani_1.png"] andColor:@"pink"] autorelease];
    }
    
    [bird setPosition:CGPointMake([self screenSize].width + [self screenSize].width * 0.416f, CCRANDOM_0_1() * [self screenSize].height)];
    [_spriteBatchNode addChild:bird z:BirdSpriteZValue];
    [_touchableObjects addObject:bird];
    [bird runAnimation];
}

- (void) spawnSheep
{
    Sheep* sheep = [[[Sheep alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                   spriteFrameByName:@"sheep1_ani_1.png"]] autorelease];
    float thirdOfScreenWidth = [self screenSize].width * 0.33f;
    float thirdOfScreenHeight = [self screenSize].height * 0.33f;
    [sheep setPosition:ccp(thirdOfScreenWidth * CCRANDOM_0_1() + thirdOfScreenWidth, thirdOfScreenHeight * CCRANDOM_0_1() + thirdOfScreenHeight)];
    [sheep setSheepState:boundingAway];
    [_spriteBatchNode addChild:sheep z:SheepSpriteZValue];
    [_touchableObjects addObject:sheep];
    [sheep runAnimation];
}

- (void) spawnRoofSheep
{
    [self setAllowRoofSheep:NO];
    
    // Get the roof so that we can position the sheep correctly.
    CCSprite* roof = (CCSprite*)[_spriteBatchNode getChildByTag:RoofTagValue];
    float roofY = [roof boundingBox].origin.y + [roof boundingBox].size.height * 0.5f;
    
    // Create a sheep and position it.
    NSString* spriteName = @"sheep1_ani_1.png";
    
    Sheep* sheep = [[[Sheep alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:spriteName]] autorelease];
    [sheep setIsRoofSheep:YES];
    [sheep setPosition:ccp([self screenSize].width / 2, roofY + [sheep boundingBox].size.height * 0.5f)];
    [sheep setSheepState:walkingLeft];
    [sheep setRoofLeftX:[roof boundingBox].origin.x + [sheep boundingBox].size.width * 0.5f];
    [sheep setRoofRightX:[roof boundingBox].origin.x + [roof boundingBox].size.width - [sheep boundingBox].size.width * 0.5f];
    [sheep setRoofWidth:[roof boundingBox].size.width];
    [_spriteBatchNode addChild:sheep z:SheepSpriteZValue];
    [_touchableObjects addObject:sheep];
    [sheep runAnimation];
}

- (void) animateBoy
{
    Boy* boy = (Boy*)[_spriteBatchNode getChildByTag:BoySpriteTagValue];
    
    // Choose a random balloon
    int balloonIndex = CCRANDOM_0_1() * ([_balloonNames count] - 1);
    
    NSString* color = [_balloonNames objectAtIndex:balloonIndex];
    
    // Strip off just the color part of the string.
    NSRange range = [color rangeOfString:@"_"];
    color = [color substringToIndex:range.location];
    //CCLOG(@"color: %@", color);
    
    NSString* frameName = [NSString stringWithFormat:@"%@_balloon_ani_1.png", color];
    
    // Start the balloon animation.
    BalloonInflate* inflate = [[[BalloonInflate alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]] autorelease];
    [inflate setPosition:CGPointMake([boy position].x + BalloonInflateXOffset, [boy position].y + BalloonInflateYOffset)];
    [inflate setDelegate:self];
    [_spriteBatchNode addChild:inflate];
    [inflate startAnimationWithColor:color];
    
    // Start the boy's animation.
    [boy startAnimation];
    
}

- (void) addStar
{
    [self setCurrentStar:[self currentStar]+1];
    
    if ([self currentStar] < 19)
    {
        //CGPoint starLocation = ccp([self screenSize].width * CCRANDOM_0_1(), ([self screenSize].height / 2) * CCRANDOM_0_1() + [self screenSize].height / 2);
        // Add an animated star
        if ([self currentStar] < 6)
        {
            AnimatedStar* animatedStar = [[[AnimatedStar alloc] initWithStarID:[self currentStar] andSpriteFrameName:[NSString stringWithFormat:@"star%i_ani_1.png", [self currentStar]]] autorelease];
            [_spriteBatchNode addChild:animatedStar z:StarSpriteZValue];
            [_stars addObject:animatedStar];
            
            switch ([self currentStar])
            {
                case 1:
                    [animatedStar setPosition:ccp([self screenSize].width * 0.20f, [self screenSize].height * 0.75f)];
                    break;
                case 2:
                    [animatedStar setPosition:ccp([self screenSize].width * 0.40f, [self screenSize].height * 0.60f)];
                    break;
                case 3:
                    [animatedStar setPosition:ccp([self screenSize].width * 0.60f, [self screenSize].height * 0.75f)];
                    break;
                case 4:
                    [animatedStar setPosition:ccp([self screenSize].width * 0.75f, [self screenSize].height * 0.90f)];
                    break;
                case 5:
                    [animatedStar setPosition:ccp([self screenSize].width * 0.43f, [self screenSize].height * 0.92f)];
                    break;
            }
                                          
        }
        else
        {
            // Add a static star to the sky
            if (([self currentStar] > 5 && [self currentStar] < 9) || [self currentStar] == 11)
            {
                Star* star = [[[Star alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"star%i.png", [self currentStar]]]] autorelease];
                [_spriteBatchNode addChild:star z:StarSpriteZValue];
                [_stars addObject:star];
                
                switch([self currentStar])
                {
                    case 6:
                        [star setPosition:ccp([self screenSize].width * 0.98f, [self screenSize].height * 0.98f)];
                        break;
                    case 7:
                        [star setPosition:ccp([self screenSize].width * 0.30f, [self screenSize].height * 0.80f)];
                        break;
                    case 8:
                        [star setPosition:ccp([self screenSize].width * 0.18f, [self screenSize].height * 0.85f)];
                        break;
                    case 9:
                        [star setPosition:ccp([self screenSize].width * 0.05f, [self screenSize].height * 0.97f)];
                        break;
                    case 11:
                        [star setPosition:ccp([self screenSize].width * 0.12f, [self screenSize].height * 0.68f)];
                }
            }
            
            if ([self currentStar] == 10 || [self currentStar] > 11)
            {
                switch ([self currentStar])
                {
                    case 10:
                    {
                        Star* star0 = [[[Star alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"star%i.png", 10]]] autorelease];
                        [_spriteBatchNode addChild:star0 z:StarSpriteZValue];
                        [_stars addObject:star0];
                        [star0 setPosition:ccp([self screenSize].width * 0.08f, [self screenSize].height * 0.62f)];
                    }
                        break;
                    
                    case 12:
                    {
                        Star* star1 = [[[Star alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"star%i.png", 10]]] autorelease];
                        [_spriteBatchNode addChild:star1 z:StarSpriteZValue];
                        [_stars addObject:star1];
                        [star1 setPosition:ccp([self screenSize].width * 0.20f, [self screenSize].height * 0.92f)];
                    }
                        break;
                    
                    case 13:
                    {
                        Star* star2 = [[[Star alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"star%i.png", 10]]] autorelease];
                        [_spriteBatchNode addChild:star2 z:StarSpriteZValue];
                        [_stars addObject:star2];
                        [star2 setPosition:ccp([self screenSize].width * .18f, [self screenSize].height * 0.50f)];
                    }
                        break;
                    
                    case 14:
                    {
                        Star* star3 = [[[Star alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"star%i.png", 10]]] autorelease];
                        [_spriteBatchNode addChild:star3 z:StarSpriteZValue];
                        [_stars addObject:star3];
                        [star3 setPosition:ccp([self screenSize].width * 0.23f, [self screenSize].height * 0.72f)];
                    }
                        break;
                        
                    case 15:
                    {
                        Star* star4 = [[[Star alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"star%i.png", 10]]] autorelease];
                        [_spriteBatchNode addChild:star4 z:StarSpriteZValue];
                        [_stars addObject:star4];
                        [star4 setPosition:ccp([self screenSize].width * 0.45f, [self screenSize].height * 0.52f)];
                    }
                        break;
                        
                    case 16:
                    {
                        Star* star5 = [[[Star alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"star%i.png", 10]]] autorelease];
                        [_spriteBatchNode addChild:star5 z:StarSpriteZValue];
                        [_stars addObject:star5];
                        [star5 setPosition:ccp([self screenSize].width * 0.70f, [self screenSize].height * 0.65f)];
                    }
                        break;
                        
                    case 17:
                    {
                        Star* star6 = [[[Star alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"star%i.png", 10]]] autorelease];
                        [_spriteBatchNode addChild:star6 z:StarSpriteZValue];
                        [_stars addObject:star6];
                        [star6 setPosition:ccp([self screenSize].width * 0.48f, [self screenSize].height * 0.96f)];
                    }
                        break;
                    
                    case 18:
                    {
                        Star* star7 = [[[Star alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"star%i.png", 10]]] autorelease];
                        [_spriteBatchNode addChild:star7 z:StarSpriteZValue];
                        [_stars addObject:star7];
                        [star7 setPosition:ccp([self screenSize].width * 0.90f, [self screenSize].height * 0.68f)];
                    }
                        break;
                }
            }
        }
    }
}



- (void) addSun
{
    // Create the sun
    _sun = [[Sun alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"sun_surprise_ani_1.png"]];
    
    // Set the sun's position on the screen
    [_sun setPosition:ccp([self screenSize].width + 20, [self screenSize].height + 20)];
    
    // Add the sun to the Sprite Batch Node for performance.
    [_spriteBatchNode addChild:_sun z:SunSpriteZValue];
    [_touchableObjects addObject:_sun];
}

- (void) removeSun
{
    [_spriteBatchNode removeChild:_sun cleanup:YES];
    [_touchableObjects removeObject:_sun];
    [_sun release];
    _sun = nil;
}

- (void) addMoon
{
    _moon = [[Moon alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"moon_ani_1.png"]];
    [_moon setPosition:ccp([self screenSize].width + 20, [self screenSize].height + 20)];
    [_spriteBatchNode addChild:_moon z:MoonSpriteZValue];
    [_touchableObjects addObject:_moon];
}

- (void) removeMoon
{
    [_spriteBatchNode removeChild:_moon cleanup:YES];
    [_touchableObjects removeObject:_moon];
    [_moon release];
    _moon = nil;
}

- (void) spawnFlyBoy:(NSString*)direction
{
    if ([direction isEqualToString:@"up"])
    {
        // Get rid of current boy.
        Boy* boy = (Boy*)[_spriteBatchNode getChildByTag:BoySpriteTagValue];
        
        // Have boy float away
        BoyFly* boyFly = [BoyFly spriteWithSpriteFrameName:@"boyfly_ani_1.png"];
        [boyFly setDelegate:self];
        [_spriteBatchNode addChild:boyFly z:BoyFlySpriteZValue tag:BoyFlyTagValue];
        
        // Position BoyFly
        [boyFly setPosition:ccp([boy position].x, [boy position].y + [self screenSize].height * 0.0156f)];

        
        // Delete boy
        [_spriteBatchNode removeChild:boy cleanup:YES];
        [boyFly flyUp];
    }
    else
    {
        // Fly down
        BoyFly* boyFly = [BoyFly spriteWithSpriteFrameName:@"boyfly_ani_12.png"];
        [boyFly setDelegate:self];
        [_spriteBatchNode addChild:boyFly z:BoyFlySpriteZValue tag:BoyFlyTagValue];
        
        // Position boyfly
        [boyFly setPosition:ccp([self boyPosition].x, [self screenSize].height * 1.4f)];
        
        [boyFly flyDown:[self boyPosition]];
    }
}

#pragma mark PopDelegate methods
- (void) disposeOfPop:(Pop*)pop
{
    [_spriteBatchNode removeChild:pop cleanup:YES];
}

#pragma mark BalloonInflateDelegate methods
- (void) cleanupBalloonInflate:(BalloonInflate*)balloonInflate
{
    // Create the new balloon of the same color
    NSString* color = [balloonInflate balloonColor];
    NSString* balloonName = nil;
    
    // Only one type of kitty balloon and one type of purple balloon, so they must be handled specially.
    if ([color isEqualToString:@"kitty"])
    {
        balloonName = @"kitty_balloon.png";
    }
    else if ([color isEqualToString:@"purple"])
    {
        balloonName = @"purple_balloon.png";
    }
    else
    {
        float randomNum = CCRANDOM_0_1();
        if (randomNum >= 0.5f)
        {
            // Create a normal balloon
            balloonName = [NSString stringWithFormat:@"%@_balloon.png", color];
            
        }
        else
        {
            // Create a heart balloon
            balloonName = [NSString stringWithFormat:@"%@_heart_balloon.png", color];
        }
    }
    
    if (balloonName != nil)
    {
        [self createBalloonAtLocation:CGPointMake([balloonInflate position].x, [balloonInflate position].y - 15) withName:balloonName inFrontOfRoof:FALSE];
    }
    
    
    [_spriteBatchNode removeChild:balloonInflate cleanup:YES];
}

#pragma mark StarDelegate methods
- (void) deleteStar:(Star*)star
{
    [_spriteBatchNode removeChild:star cleanup:YES];
}

#pragma mark BoyFlyDelegate methods
- (void) deleteBoyFly:(BoyFly*)boyFly withDirection:(NSString*)direction
{
    // If BoyFly is going down, we need to create a new boy to replace him.
    if ([direction isEqualToString:@"down"])
    {
        // Create boy
        Boy* boy = [[[Boy alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]  spriteFrameByName:@"boy_ani_1.png"]] autorelease];
        
        // Set the boy's position on the screen
        
        [boy setPosition:[self boyPosition]];
        
        // Add the boy to the Sprite batch node for performance.
        [_spriteBatchNode addChild:boy z:BoySpriteZValue tag:BoySpriteTagValue];
    }
    
    [[boyFly batchNode] removeChild:[boyFly balloon] cleanup:YES];
    
    // Delete boyFly     
    [_spriteBatchNode removeChild:boyFly cleanup:YES];
}

@end
