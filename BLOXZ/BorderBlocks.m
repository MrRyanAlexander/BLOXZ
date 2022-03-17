//
//  BorderBlocks.m
//  BLOXZ
//
//  Created by Pminu on 6/19/14.
//  Copyright (c) 2014 LGMRA Studios. All rights reserved.
//

#import "BorderBlocks.h"
@interface BorderBlocks()
@property (strong, nonatomic)SKSpriteNode *borderBlockLeft;
@property (strong , nonatomic)SKSpriteNode *borderBlockRight;
@property (nonatomic, assign) BOOL game;
@end

//static const NSInteger kScrollSpeed = 5;

static const uint32_t playererCategory = 0x1 << 1;
static const uint32_t blockCategory = 0x1 << 0;

@implementation BorderBlocks

-(id)init
{
    if(self = [super init])
    {
        self.game = YES;
        [self createBorderBlocks];
    }
    return self;
}
-(void)gameOn:(BOOL)game
{
    self.game = game;
}
- (void)borderBlocks:(CFTimeInterval)currentTime
{
    if(self.game)
    {
        [self enumerateChildNodesWithName:@"block" usingBlock:^(SKNode *node, BOOL *stop) {
            if(node.position.y < -20){
                node.position = CGPointMake(node.position.x, 505);
            }else{
                node.position = CGPointMake(node.position.x, node.position.y-3);
            }
        }];
    }else{
        [self enumerateChildNodesWithName:@"block" usingBlock:^(SKNode *node, BOOL *stop) {
            [node.physicsBody setAffectedByGravity:TRUE];
            [node.physicsBody setAllowsRotation:YES];
        }];
    }
}
- (void) createBorderBlocks
{
    CGSize body = CGSizeMake(5,10);
    
    self.borderBlockLeft = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(15, 30)];
    self.borderBlockLeft.position = CGPointMake(10, 515);
    
    self.borderBlockLeft.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:body];
    [self.borderBlockLeft.physicsBody setAffectedByGravity:FALSE];
    [self.borderBlockLeft.physicsBody setAllowsRotation:NO];
    [self.borderBlockLeft.physicsBody setCategoryBitMask:playererCategory];
    [self.borderBlockLeft.physicsBody setCollisionBitMask:blockCategory];
    
    self.borderBlockLeft.alpha = 1;
    self.borderBlockLeft.name = @"block";
    [self addChild:self.borderBlockLeft];
    
    for(int i=0; i<=12; i++)
    {
        self.borderBlockLeft = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(15, 30)];
        self.borderBlockLeft.position = CGPointMake(10, 475 - i*40);
        self.borderBlockLeft.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:body];
        [self.borderBlockLeft.physicsBody setAffectedByGravity:FALSE];
        [self.borderBlockLeft.physicsBody setAllowsRotation:NO];
        [self.borderBlockLeft.physicsBody setCategoryBitMask:playererCategory];
        [self.borderBlockLeft.physicsBody setCollisionBitMask:blockCategory];
        
        self.borderBlockLeft.alpha = 1;
        self.borderBlockLeft.name = @"block";
        [self addChild:self.borderBlockLeft];
    }
    
    self.borderBlockRight = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(15, 30)];
    self.borderBlockRight.position = CGPointMake(310, 515);
    self.borderBlockRight.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:body];
    [self.borderBlockRight.physicsBody setAffectedByGravity:FALSE];
    [self.borderBlockRight.physicsBody setAllowsRotation:NO];
    [self.borderBlockRight.physicsBody setCategoryBitMask:playererCategory];
    [self.borderBlockRight.physicsBody setCollisionBitMask:blockCategory];
    
    self.borderBlockRight.alpha = 1;
    self.borderBlockRight.name = @"block";
    [self addChild:self.borderBlockRight];
    
    for(int i=0; i<=12; i++)
    {
        self.borderBlockRight = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(15, 30)];
        self.borderBlockRight.position = CGPointMake(310, 475 - i*40);
        self.borderBlockRight.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:body];
        [self.borderBlockRight.physicsBody setAffectedByGravity:FALSE];
        [self.borderBlockRight.physicsBody setAllowsRotation:NO];
        [self.borderBlockRight.physicsBody setCategoryBitMask:playererCategory];
        [self.borderBlockRight.physicsBody setCollisionBitMask:blockCategory];
        
        self.borderBlockRight.alpha = 1;
        self.borderBlockRight.name = @"block";
        [self addChild:self.borderBlockRight];
    }
}
@end
