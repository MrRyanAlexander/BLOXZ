//
//  FallBlock.m
//  BLOXZ
//
//  Created by Pminu on 6/19/14.
//  Copyright (c) 2014 LGMRA Studios. All rights reserved.
//

#import "FallBlock.h"
#import "GameScene.h"

@interface FallBlock()
@property (nonatomic, strong) SKSpriteNode *block;
@property (nonatomic, assign) BOOL game;
@end

static const CGFloat posA = 80;
static const CGFloat posB = 160;
static const CGFloat posC = 240;
static const CGFloat Xpos = 650;

/* static ints */
static const NSInteger closed = 0;
static const NSInteger arc0 = 0;
static const NSInteger arc1 = 1;
static const NSInteger arc2 = 2;
static const NSInteger arc3 = 3;
static const NSInteger arc4 = 4;

static const NSInteger kScrollSpeed = 5;
static const NSInteger dotSpawnInterval = kScrollSpeed*8;

/*bit masks*/
static const uint32_t playererCategory = 0x1 << 1;
static const uint32_t blockCategory = 0x1 << 0;

@implementation FallBlock
{
    NSInteger _dotCountDecrementTimer;
    NSInteger _gameTimer;
    NSInteger _lastArc;
    //track patterns that are two easy and start again when they are using the centers empty space as a point of interest
    NSInteger _emptyCenterPatternTimes;
    BOOL _firstFall;
    BOOL _lastFall;
}

- (id) init {
    if (self = [super init]) {
        self.game = YES;
        _firstFall = YES;
        _lastFall = NO;
        }
    return self;
}
- (void) gameOn:(BOOL)game {
    self.game = game;
}
- (void) updateFallBlocks:(NSTimeInterval)currentTime {
    if(self.game)
    {
        _gameTimer++;
        if ( _gameTimer>dotSpawnInterval ){
            [self createBlocksFromPattern];
            _gameTimer = closed;
        }
        [self removeMoveBlocksUpdateScore];
    }else{
        [self crashBlocks];
    }
    
}
- (void) createBlocksFromPattern {
    NSInteger try = arc4random_uniform(arc4);
    if(_firstFall) {
        //create the very first block the same way everytime the game restarts
        //pattern 0-1-0
        [self createBlock:posB];
        [self scoreTrackerBlock];
        //set first fall to NO;
        _firstFall = NO;
    }
    else if(_lastArc == try || _emptyCenterPatternTimes > 3)
    {
        if(_emptyCenterPatternTimes > 3) {
            _emptyCenterPatternTimes = 0;
        }
        //recursive try again to call again a new set of blocks since last one was same as before
        [self createBlocksFromPattern];
        
    }else{
        
        if(try == arc0)
        {
            //pattern 1-0-1
            //NSLog(@"Doing pattern 1-0-1");
            [self createBlock:posA];
            [self createBlock:posC];
            [self scoreTrackerBlock];
            _emptyCenterPatternTimes++;
        }
        else if(try == arc1)
        {
            //pattern 1-0-0
            //NSLog(@"Doing pattern 1-0-0");
            [self createBlock:posA];
            [self scoreTrackerBlock];
            _emptyCenterPatternTimes++;
        }
        else if(try == arc2)
        {
            //pattern 0-0-1
            //NSLog(@"Doing pattern 0-0-1");
            [self createBlock:posC];
            [self scoreTrackerBlock];
            _emptyCenterPatternTimes++;
        }
        else if(try == arc3)
        {
            //pattern 0-1-0
            //NSLog(@"Doing pattern 0-1-0");
            [self createBlock:posB];
            [self scoreTrackerBlock];
            _emptyCenterPatternTimes = 0;
        }
        //store the last arc try to use again to prevent same blocks from falling twice in a row
        _lastArc = try;
    }
}
- (void) createBlock:(NSInteger)Ypos {
    CGSize body = CGSizeMake(52,40);
    self.block = [FallBlock spriteNodeWithImageNamed:@"enemyBlockNoCol"];
    [self.block setPosition:CGPointMake(Ypos, Xpos)];
    self.block.alpha = 1;
    self.block.name =@"fallBlock";
    self.block.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:body];
    [self.block.physicsBody setAffectedByGravity:FALSE];
    [self.block.physicsBody setAllowsRotation:NO];
    [self.block.physicsBody setCategoryBitMask:playererCategory];
    [self.block.physicsBody setCollisionBitMask:blockCategory];
    
    [self addChild:self.block];
}
- (void) scoreTrackerBlock {
    SKSpriteNode *tracker = [[SKSpriteNode alloc]init];
    [tracker setPosition:CGPointMake(posB,Xpos)];
    tracker.alpha = 1;
    tracker.name = @"trackingBlock";
    [self addChild:tracker];
}
- (void) removeMoveBlocksUpdateScore {
    //scroll blocks and remove them once they leave the screen
    [self enumerateChildNodesWithName:@"fallBlock" usingBlock:^(SKNode *node, BOOL *stop) {
        if(node.position.y < -10){
            _dotCountDecrementTimer ++;
            [node removeFromParent];
        }else{
            node.position = CGPointMake(node.position.x, node.position.y-kScrollSpeed);
        }
    }];
    //scroll the score tracking block, log a point, remove the block
    [self enumerateChildNodesWithName:@"trackingBlock" usingBlock:^(SKNode *node, BOOL *stop) {
        if(node.position.y < 30){
            [self.delegate incrementScore];
            [node removeFromParent];
        }else{
            node.position = CGPointMake(node.position.x, node.position.y-kScrollSpeed);
        }
    }];
}
-(void)crashBlocks {
    [self enumerateChildNodesWithName:@"fallBlock" usingBlock:^(SKNode *node, BOOL *stop) {
        [node.physicsBody setAffectedByGravity:TRUE];
        [node.physicsBody setAllowsRotation:YES];
    }];
}
@end
