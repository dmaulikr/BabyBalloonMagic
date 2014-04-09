//
//  GameObject.m
//  BalloonMagic
//
//  Created by Nicholas Rasband on 7/27/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "GameObject.h"

@implementation GameObject

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (CCAnimation*) loadPlistForAnimationWithName:(NSString*)animationName andClassName:(NSString*)className withExtraPrefix:(NSString*)extraPrefix
{
    
    CCAnimation* animationToReturn = nil;
    
    NSString* fullFileName = [NSString stringWithFormat:@"%@.plist",className];
    NSString* plistPath;
    
    // 1: Get the Path to the plist file
    NSString* rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:fullFileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] 
                     pathForResource:className ofType:@"plist"];
    }
    
    // 2: Read in the plist file
    NSDictionary* plistDictionary = 
    [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    // 3: If the plistDictionary was null, the file was not found.
    if (plistDictionary == nil) {
        CCLOG(@"Error reading plist: %@.plist", className);
        return nil; // No Plist Dictionary or file found
    }
    
    // 4: Get just the mini-dictionary for this animation
    NSDictionary* animationSettings = 
    [plistDictionary objectForKey:animationName];
    if (animationSettings == nil) {
        CCLOG(@"Could not locate AnimationWithName:%@",animationName);
        return nil;
    }
    
    // 5: Get the delay value for the animation
    float animationDelay = 
    [[animationSettings objectForKey:@"delay"] floatValue];
    animationToReturn = [CCAnimation animation];
    [animationToReturn setDelay:animationDelay];
    
    // 6: Add the frames to the animation
    NSString* animationFramePrefix = [animationSettings objectForKey:@"filenamePrefix"];
    
    // If there is an extra prefix, prepend it.
    if (extraPrefix != nil)
    {
        animationFramePrefix = [NSString stringWithFormat:@"%@%@", extraPrefix, animationFramePrefix];
    }
    NSString *animationFrames = [animationSettings objectForKey:@"animationFrames"];
    NSArray *animationFrameNumbers = [animationFrames componentsSeparatedByString:@","];
    
    for (NSString* frameNumber in animationFrameNumbers) 
    {
        NSString* frameName = [NSString stringWithFormat:@"%@%@.png", animationFramePrefix, frameNumber];
        [animationToReturn addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
    }
    
    return animationToReturn;
}

- (void) dealloc
{
    [super dealloc];
}

@end
