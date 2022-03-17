//
//  Player.h
//  BLOXZ
//
//  Created by Pminu on 6/19/14.
//  Copyright (c) 2014 LGMRA Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface Player : SKSpriteNode
-(void)gameOn:(BOOL)game;
-(BOOL)isTouching;
@end
