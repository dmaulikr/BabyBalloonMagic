//
//  SpeedSlider.h
//  BalloonMagic
//
//  Created by Nicholas Rasband on 8/12/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "Constants.h"
#import "Bar.h"

@interface SpeedSlider : CCSprite 
{
    float _currentValue;
    float _minValue;
    float _maxValue;
    float _barLeftmostX;
    float _barRightmostX;
    
    CCSprite* _bar;
    CCSprite* _indicator;
    
}

+ (id) speedSliderWithBar:(CCSprite*)bar indicator:(CCSprite*)indicator minValue:(float)minValue maxValue:(float)maxValue;
- (id) initWithBar:(CCSprite*)bar indicator:(CCSprite*)indicator minValue:(float)minValue maxValue:(float)maxValue;

- (void) updateSliderWithPoint:(CGPoint)point;

@property (assign) float currentValue;
@property (assign) float minValue;
@property (assign) float maxValue;
@property (assign) float barLeftmostX;
@property (assign) float barRightmostX;
@property (retain) CCSprite* bar;
@property (retain) CCSprite* indicator;

@end
