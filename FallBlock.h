//
//  FallBlock.h
//  BLOXZ
//
//  Created by Pminu on 6/19/14.
//  Copyright (c) 2014 LGMRA Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@protocol FallBlockDelegate <NSObject>
-(void)incrementScore;
@end

@interface FallBlock: SKSpriteNode

@property (unsafe_unretained,nonatomic) id<FallBlockDelegate> delegate;

-(void)updateFallBlocks:(NSTimeInterval)currentTime;
-(void)gameOn:(BOOL)game;
@end
