//
//  Balloon.h
//  BalloonMagic
//
//  Created by Nicholas Rasband on 7/27/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "TappableGameObject.h"


@interface Balloon : TappableGameObject
{
    NSString* _balloonName;
    float _offset;
    BOOL _shouldPop;
    BOOL _isCatBalloon;
}

@property (retain) NSString* balloonName;
@property (assign) float offset;
@property (assign) BOOL shouldPop;
@property (assign) BOOL isCatBalloon;

- (CGSize) balloonSize;
- (CGRect) popRect;

@end
