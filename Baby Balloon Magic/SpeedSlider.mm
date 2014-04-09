//
//  SpeedSlider.m
//  BalloonMagic
//
//  Created by Nicholas Rasband on 8/12/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "SpeedSlider.h"

#pragma mark -
#pragma mark Private Interface
@interface SpeedSlider ()
- (void) initializeIndicatorPosition;
- (float) valueToXPosition:(float)value;
@end

#pragma mark -
@implementation SpeedSlider

#pragma mark Constructors
+ (id) speedSliderWithBar:(CCSprite*)bar indicator:(CCSprite*)indicator minValue:(float)minValue maxValue:(float)maxValue
{
    return [[[self alloc] initWithBar:bar indicator:indicator minValue:minValue maxValue:maxValue] autorelease];
}

- (id) initWithBar:(CCSprite*)bar indicator:(CCSprite*)indicator minValue:(float)minValue maxValue:(float)maxValue
{
    self = [super init];
    if (self == nil)
        return nil;
    
    [self setBar:bar];
    [self setIndicator:indicator];
    [self setMinValue:minValue];
    [self setMaxValue:maxValue];
    
    [self setBarLeftmostX:[[self bar] position].x - ([[self bar] contentSize].width * 0.25f)];
    [self setBarRightmostX:[[self bar] position].x + ([[self bar] contentSize].width * 0.25f)];
    
    [self initializeIndicatorPosition];
    
    
    
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
@synthesize minValue = _minValue;
@synthesize maxValue = _maxValue;
@synthesize bar = _bar;
@synthesize indicator = _indicator;
@synthesize barLeftmostX = _barLeftmostX;
@synthesize barRightmostX = _barRightmostX;

- (void) setCurrentValue:(float)value
{
    if (value < [self minValue])
    {
        _currentValue = [self minValue];
    }
    else if (value > [self maxValue])
    {
        _currentValue = [self maxValue];
    }
    else
    {
        _currentValue = value;
    }
    
    [[NSUserDefaults standardUserDefaults] setFloat:value forKey:SpeedKey];
}

- (float) currentValue
{
    return _currentValue;
}

#pragma mark -
#pragma mark Methods
- (float) valueToXPosition:(float)value
{
    // Update the current position based off of the value.
    
    float width = [[self bar] contentSize].width * 0.5f;
    float ratio = width / ([self maxValue] - [self minValue]);
    float difference = value - [self minValue];
    float xPosition = ratio * difference + [self barLeftmostX];
    CCLOG(@"width: %f, x position of indicator: %f",width, xPosition);
    return xPosition;
}

- (void) initializeIndicatorPosition
{
    float value = [[NSUserDefaults standardUserDefaults] floatForKey:SpeedKey];
    /*
    if (value == 0)
    {
        float valToPass = ([self maxValue] - [self minValue]) / 2.0f;
        valToPass += [self minValue];
        [self setCurrentValue:valToPass];
        [self updateSliderWithPoint:[[self bar] position]];
    }
    */

    [self setCurrentValue:value];
    [self updateSliderWithPoint:ccp([self valueToXPosition:value], [[self bar] position].y)];

}
- (void) updateSliderWithPoint:(CGPoint)point
{
    // Position the indicator
    if (point.x > [self barRightmostX])
    {
        point.x = [self barRightmostX];
    }
    else if (point.x < [self barLeftmostX])
    {
        point.x = [self barLeftmostX];
    }
    
    [[self indicator] setPosition:ccp(point.x, [[self bar] position].y)];
    
    // Update the current value based off of the position.
    float ratio = ([self maxValue] - [self minValue]) / ([[self bar] contentSize].width * 0.5f);
    float difference = point.x - [self barLeftmostX];
    float calculatedValue = ratio * difference + [self minValue];
    //CCLOG(@"Value of the slider %f", calculatedValue);
    [self setCurrentValue:calculatedValue];
}


@end
