//
//  MyScene.m
//  BLOXZ
//
//  Created by Pminu on 6/4/14.
//  Copyright (c) 2014 LGMRA Studios. All rights reserved.
//
#import "GameScene.h"
#import "FallBlock.h"
#import "Player.h"
#import "BorderBlocks.h"
#import "SecureData.h"
#import "Score.h"
#import "Sound.h"

@interface GameScene()
@property (nonatomic, strong) NSMutableArray *dots;
@property (strong, nonatomic) Player *player;
@property (strong, nonatomic) FallBlock *fallBlock;
@property (strong, nonatomic) BorderBlocks *borderBlocks;
@property (nonatomic, retain) Sound *sounds;
@property (nonatomic, assign) BOOL game;

@end

static const NSInteger kStaticTwo = 2;
static const uint32_t playererCategory = 0x1 << 0;
static const uint32_t blockCategory = 0x1 << 1;

@implementation GameScene
{
    NSInteger _score;
    NSInteger _gameTimer;
    BOOL _firstContact;
    SKLabelNode *scoreLabel;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size ]) {
        /*ONLY INIT SELF; DO SETUP BELOW*/
    }
    return self;
}
//use didMoveToView to load and reload the scene
-(void)didMoveToView:(SKView *)view
{
    [self setup:view];
}

-(void)setup:(SKView *)view
{
    _firstContact = YES;
    self.game = YES;
    self.sounds = [[Sound alloc]init];
    //sets the contact delegate to this scenes view controller
    self.physicsWorld.contactDelegate = self;
    //create a self contained backgrond
    //[self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundBlank"]]];
    
    SKSpriteNode *back = [SKSpriteNode spriteNodeWithImageNamed:@"backgroundBlank"];
    back.position = CGPointMake(self.size.width/kStaticTwo, self.size.height/kStaticTwo);
    back.size = view.frame.size;
    //back.name = @"background";
    [self addChild:back];
    self.borderBlocks = [[BorderBlocks alloc]init];
    self.fallBlock = [[FallBlock alloc]init];
    self.fallBlock.delegate = self;
    self.player = [[Player alloc]init];
    scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Cooperplate-Bold"];
    scoreLabel.text = @"0";
    scoreLabel.fontSize = 100;
    scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), 200);
    scoreLabel.alpha = 1;
    [self addChild:scoreLabel];
    
    //turn all the moving nodes Oon
    [self.borderBlocks gameOn:YES];
    [self.fallBlock gameOn:YES];
    [self.player gameOn:YES];
    //add the nodes to the scene
    [self addChild:self.borderBlocks];
    [self addChild:self.fallBlock];
    [self addChild:self.player];
    //self.gameDelegate = self;
    _score = 0;
}
//increments the score and updates the gameSceneBanner label for the playerScore
 -(void)incrementScore{
    _score++;
     scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)_score];
     //[self.delegate updatePlayerScoreLabel:_score];
}
-(void)update:(CFTimeInterval)currentTime
{
    if([self.player isTouching]){
        [self.borderBlocks borderBlocks:currentTime];
        [self.fallBlock updateFallBlocks:currentTime];
    }else{
        [self.borderBlocks borderBlocks:currentTime];
    }
    
}
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    [self.sounds playSound];

    if(_firstContact){
        _firstContact = NO;
        [Score registerScore:_score];

        SKSpriteNode *blockNode, *playerNode;
        blockNode = (SKSpriteNode *)contact.bodyA.node;
        playerNode = (SKSpriteNode *)contact.bodyB.node;
    
        if((contact.bodyA.categoryBitMask == blockCategory) && (contact.bodyB.categoryBitMask == playererCategory)){

            if([blockNode.name isEqualToString:@"fallBlock"])
            {
                blockNode.texture = [SKTexture textureWithImageNamed:@"enemyBlockCol"];
            }
            if([blockNode.name isEqualToString:@"block"])
            {
                blockNode.texture = [SKTexture textureWithImageNamed:@"borderBlockCol"];
            }
            //turn all moving nodes off
            [self.borderBlocks gameOn:NO];
            [self.fallBlock gameOn:NO];
            [self.player gameOn:NO];
        
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //set the local score
                //[self.delegate updateUserScore:_score];
                //start the game over
                [self.delegate loadGameOverView:_score];
                //remove the scenes nodes
                [self removeAllChildren];
                
                return;
            });
        }
    }
}

@end

