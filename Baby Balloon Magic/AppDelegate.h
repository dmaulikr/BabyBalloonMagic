//
//  AppDelegate.h
//  Baby Balloon Magic
//
//  Created by Nicholas Rasband on 8/17/11.
//  Copyright Nick Rasband 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
