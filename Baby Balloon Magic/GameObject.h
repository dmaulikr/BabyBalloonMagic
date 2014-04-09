//
//  GameObject.h
//  BalloonMagic
//
//  Created by Nicholas Rasband on 7/27/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "CCSprite.h"

@interface GameObject : CCSprite


- (CCAnimation*) loadPlistForAnimationWithName:(NSString*)animationName andClassName:(NSString*)className withExtraPrefix:(NSString*)extraPrefix;
@end
