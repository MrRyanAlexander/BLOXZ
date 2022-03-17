//
//  BorderBlocks.h
//  BLOXZ
//
//  Created by Pminu on 6/19/14.
//  Copyright (c) 2014 LGMRA Studios. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BorderBlocks : SKSpriteNode

- (void) borderBlocks:(CFTimeInterval)currentTime;
- (void) createBorderBlocks;
-(void)gameOn:(BOOL)game;

@end
