//
//  BoyFly.h
//  BalloonMagic
//
//  Created by Nicholas Rasband on 8/13/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "GameObject.h"
#import "Balloon.h"
#import "Constants.h"

@class BoyFly;

@protocol BoyFlyDelegate

@required - (void) deleteBoyFly:(BoyFly*)boyFly withDirection:(NSString*)direction;

@end

@interface BoyFly : GameObject 
{
    CCAnimation* _boyFlyAnimation;
    CCSprite* _balloon;
    NSObject<BoyFlyDelegate>* _delegate;
    NSString* _direction;
}

// Properties
@property (retain) CCAnimation* boyFlyAnimation;
@property (retain) NSString* direction;
@property (assign) NSObject<BoyFlyDelegate>* delegate;

// Methods
- (void) flyUp;
- (void) flyDown:(CGPoint)boyPosition;
- (CCSprite*) balloon;


@end
