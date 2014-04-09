//
//  MenuLayer.m
//  BalloonMagic
//
//  Created by Nicholas Rasband on 8/11/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "MenuLayer.h"
#import "CCTouchDispatcher.h"

@interface MenuLayer()
- (void) startGame;
- (void) playKidSound;
@end


@implementation MenuLayer

- (id)init
{
    self = [super init];
    if (self == nil)
        return nil;
    
    [self setScreenSize:[[CCDirector sharedDirector] winSize]];
    CGSize screenSize = [self screenSize];
    
    // Enable touches
    [self setIsTouchEnabled:YES];
    
    // Use the iPad sprite sheet if running on iPad
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // Add the frames to the sharedSpriteFrameCache
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:NSLocalizedString(@"MenuArtPlistiPad", @"")];
        
        _spriteBatchNode = [[CCSpriteBatchNode batchNodeWithFile:NSLocalizedString(@"MenuArtPicsiPad", @"")] retain];
    }
    else
    {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:NSLocalizedString(@"MenuArtPlistiPhone", @"")];
        
        _spriteBatchNode = [[CCSpriteBatchNode batchNodeWithFile:NSLocalizedString(@"MenuArtPicsiPhone", @"")] retain];
    }
    
    [self addChild:_spriteBatchNode z:0];
    
    // Create the background
    CCSprite* background = [[[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"menu-background.png"]] autorelease];
    [_spriteBatchNode addChild:background z:0];
    [background setPosition:ccp(screenSize.width * 0.5f, screenSize.height * 0.5f)];
    
    // Get the sound manager and then set up the sound icon
    _soundManager = [SoundManager sharedSoundManager];
    if ([_soundManager soundIsOn])
    {
        [_soundManager loadMenuAudio];
        [self setSoundEnabled:YES];
    }
    else
    {
        [self setSoundEnabled:NO];
    }
    
    
    
    // Create the balloon sprite
    CCSprite* balloon = [CCSprite spriteWithSpriteFrameName:@"start.png"];
    [_spriteBatchNode addChild:balloon z:1 tag:BalloonSpriteTag];
    [balloon setPosition:ccp(screenSize.width * 0.78f, screenSize.height * 0.64f)];
    
    // Create the logo sprite
    CCSprite* logo = [CCSprite spriteWithSpriteFrameName:@"logo.png"];
    [_spriteBatchNode addChild:logo z:1 tag:LogoSpriteTag];
    [logo setPosition:ccp(screenSize.width * 0.12f, screenSize.height * 0.85f)];
    
    // Create the speed slider
    Bar* bar = [Bar spriteWithSpriteFrameName:@"slow-fast-toggle.png"];
    [_spriteBatchNode addChild:bar z:1 tag:SpeedSliderTag];
    [bar setPosition:ccp(screenSize.width * 0.75f, screenSize.height * 0.10f)];    
    
    CCSprite* indicator = [CCSprite spriteWithSpriteFrameName:@"speed-bar.png"];
    [_spriteBatchNode addChild:indicator z:2];
    
    _speedSlider = [[SpeedSlider speedSliderWithBar:bar indicator:indicator minValue:0.0f maxValue:100.0f] retain];
    
    [_soundManager playMenuMusic];
    
    return self;
}

- (void) dealloc
{
    CCLOG(@"Released menu layer");
    [_spriteBatchNode release];
    [_soundManager unloadMenuAudio];
    [_speedSlider release];
    
    // Delete
    [super dealloc];
}

#pragma mark Accessors
@synthesize screenSize = _screenSize;

- (void) setSoundEnabled:(BOOL)setting
{
    [_soundManager setSoundIsOn:setting];
    
    if (setting == NO)
    {
        [_soundManager stopMusic];
    }
    else
    {
        [_soundManager startMusic];
    }
    
    // Remove old sprite if it exists.
    CCSprite* soundSprite = (CCSprite*)[_spriteBatchNode getChildByTag:SoundSpriteTag];
    if (soundSprite != nil)
    {
        [_spriteBatchNode removeChild:soundSprite cleanup:NO];
    }
    
    if (setting == YES)
    {
        CCSprite* soundSprite = [CCSprite spriteWithSpriteFrameName:@"music-on-button.png"];
        [_spriteBatchNode addChild:soundSprite z:1 tag:SoundSpriteTag];
        [soundSprite setPosition:ccp([self screenSize].width * 0.13f, [self screenSize].height * 0.1f)];
    }
    else
    {
        CCSprite* soundSprite = [CCSprite spriteWithSpriteFrameName:@"music-off-button.png"];
        [_spriteBatchNode addChild:soundSprite z:1 tag:SoundSpriteTag];
        [soundSprite setPosition:ccp([self screenSize].width * 0.13f, [self screenSize].height * 0.1f)];
    }
    
    _soundEnabled = setting;
    
}

- (BOOL) soundEnabled
{
    return _soundEnabled;
}


#pragma mark Methods

- (void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [self convertTouchToNodeSpace:touch];
    
    CCSprite* soundSprite = (CCSprite*)[_spriteBatchNode getChildByTag:SoundSpriteTag];
    CCSprite* balloonSprite = (CCSprite*)[_spriteBatchNode getChildByTag:BalloonSpriteTag];
    CCSprite* logoSprite = (CCSprite*)[_spriteBatchNode getChildByTag:LogoSpriteTag];
    
    // If it is the sound icon, toggle it.
    if (CGRectContainsPoint([soundSprite boundingBox], touchPoint))
    {        
        if ([self soundEnabled])
        {
            [self setSoundEnabled:NO];
        }
        else
        {
            [self setSoundEnabled:YES];
        }
        // Play sound effect
        [_soundManager playSoundEffect:@"toggle_sound.caf"];
    }
    else if (CGRectContainsPoint([balloonSprite boundingBox], touchPoint))
    {
        // Create the pop image and remove the balloon image
        CCSprite* pop = [CCSprite spriteWithSpriteFrameName:@"pop_7.png"];
        [pop setPosition:[balloonSprite position]];
        CCFadeTo* fadeTo = [CCFadeTo actionWithDuration:1.0f opacity:0];
        [pop runAction:fadeTo];
        
        [_spriteBatchNode removeChild:balloonSprite cleanup:YES];
         [_spriteBatchNode addChild:pop];
        [_soundManager playSoundEffect:@"pop_6.caf"];
        [self schedule:@selector(playKidSound) interval:0.3f];
    }
    else if (CGRectContainsPoint([logoSprite boundingBox], touchPoint))
    {
        // Launch the website contact page.
        NSURL* url = [NSURL URLWithString:@"http://cocodrilostudios.com/contact"];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void) ccTouchMoved:(UITouch*)touch withEvent:(UIEvent*)event
{
    CGPoint touchPoint = [self convertTouchToNodeSpace:touch];
    
    Bar* bar = (Bar*)[_spriteBatchNode getChildByTag:SpeedSliderTag];
    
    if (CGRectContainsPoint([bar boundingBox], touchPoint))
    {
        [_speedSlider updateSliderWithPoint:touchPoint];
    }
}

- (void) playKidSound
{
    [self unschedule:@selector(playKidSound)];
    [_soundManager playSoundEffect:@"play_game.caf"];
    [self schedule:@selector(startGame) interval:1.4f];
}

- (void) startGame
{
    [self unschedule:@selector(startGame)];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeTR transitionWithDuration:1.0f scene:[MainScene node]]];
}

@end
