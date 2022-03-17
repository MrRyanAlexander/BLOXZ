//
//  AppDelegate.h
//  BLOXZ
//
//  Created by Pminu on 6/4/14.
//  Copyright (c) 2014 LGMRA Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, NSURLConnectionDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIStoryboard *storyboard;
@property (strong, nonatomic) UIViewController *vc ;
@end