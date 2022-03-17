//
//  MyScene.h
//  BLOXZ
//

//  Copyright (c) 2014 LGMRA Studios. All rights reserved.
//
//#import "SceneViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "FallBlock.h"

@protocol GameDelegate <NSObject>
- (void)loadGameOverView:(NSInteger)playerScore;
//- (void)updatePlayerScoreLabel:(NSInteger)userScore;
@end

@interface GameScene : SKScene<SKPhysicsContactDelegate, FallBlockDelegate>

@property (unsafe_unretained,nonatomic) id<GameDelegate> delegate;
@end
