//
//  BalloonInflate.h
//  BalloonMagic
//
//  Created by Nicholas Rasband on 8/1/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "GameObject.h"

@class BalloonInflate;

@protocol BalloonInflateDelegate

@required - (void) cleanupBalloonInflate:(BalloonInflate*)balloonInflate;

@end

@interface BalloonInflate : GameObject 
{
    NSObject<BalloonInflateDelegate>* _delegate;
    NSString* _balloonColor;
    CCAnimation* _inflateBalloon; // The actual balloon inflating.
}


@property (retain) CCAnimation* inflateBalloon;
@property (retain) NSString* balloonColor;
@property (assign) NSObject<BalloonInflateDelegate>* delegate;

- (void) startAnimationWithColor:(NSString*)color;

@end
