//
//  ChristmasLight.h
//  Baby Balloon Magic
//
//  Created by Nicholas Rasband on 11/10/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//
#import "GameObject.h"

@interface ChristmasLight : GameObject 
{
    CCAnimation* _lightAnimation;
    CCAnimate* _animate;
}

@property (retain) CCAnimation* lightAnimation;

@end
