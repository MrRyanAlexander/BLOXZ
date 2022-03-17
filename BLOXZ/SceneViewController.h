//
//  SceneViewController.h
//  BLOXZ
//
//  Created by Pminu on 6/5/14.
//  Copyright (c) 2014 LGMRA Studios. All rights reserved.
//
#import <iAd/iAd.h>
#import <GameKit/GameKit.h>
#import "GameScene.h"
#import "GADInterstitial.h"

@interface SceneViewController : UIViewController<ADBannerViewDelegate, GameDelegate, GADInterstitialDelegate>

@end
