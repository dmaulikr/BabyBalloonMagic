//
//  Constants.h
//  BalloonMagic
//
//  Created by Nicholas Rasband on 7/27/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

// Tags
#define BackgroundSpriteTag 0
#define BoySpriteTagValue 1
#define BoyFlyTagValue 2
#define BoysBalloonTagValue 3
#define BirdSpriteTagValue 4
#define BalloonInflateTagValue 5
#define RoofTagValue 6

// zValues
#define BirdSpriteZValue 12
#define BalloonInFrontOfRoofZValue 11
#define PopSpriteZValue 10
#define TreeZValue 9
#define BoySpriteZValue 8
#define SheepSpriteZValue 7
#define ChristmasRoofZValue 6
#define RoofZValue 5
#define BoyFlySpriteZValue 4
#define BalloonSpriteZValue 4
#define BoysBalloonSpriteZValue 3
#define BalloonInflateZValue 3
#define MoonSpriteZValue 2
#define SunSpriteZValue 2
#define StarSpriteZValue 1
#define SkyZValue 0

#define DayLength 120.0f
#define NightLength 120.0f
#define DayCycleOffset 60.0f

#define PTM_RATIO ((UI_USER_INTERFACE_IDIOM() == \
UIUserInterfaceIdiomPad) ? 130.0f : 65.0f)

#define iPadSpriteFile @"project_ipad.png"
#define iPadPlist @"project_ipad.plist"
#define iPhoneSpriteFile @"project_iphone.png"
#define iPhonePlist @"project_iphone.plist"

#define TimeBetweenStarSpawns 2.0f
#define TimeBetweenBirdSpawns 5.0f

#define MinTimeBetweenBalloonSpawns 0.8f
#define MaxTimeBetweenBalloonSpawns 3.0f

#define MinTimeBetweenBoyAnimations 3.0f
#define MaxTimeBetweenBoyAnimations 12.0f

#define MinTimeBetweenSheepSpawns 0.6f
#define MaxTimeBetweenSheepSpawns 2.0f

#define MinimumNumBalloonsCreated 3
#define MaximumNumBalloonsCreated 6

#define MinBalloonLift 0.0338f
#define MaxBalloonLift 0.037f

#define BalloonInflateXOffset [[CCDirector sharedDirector] winSize].width * 0.0625f
#define BalloonInflateYOffset 0

#define SpeedKey @"BalloonSpeed"