//
//  Player.m
//  BLOXZ
//
//  Created by Pminu on 6/19/14.
//  Copyright (c) 2014 LGMRA Studios. All rights reserved.
//

#import "Player.h"
#import "GameScene.h"

@interface Player()
@property (strong,nonatomic) SKAction * moveLeft;
@property (strong,nonatomic) SKAction * moveRight;
@property (strong,nonatomic) SKSpriteNode *player;
@property (nonatomic, assign) BOOL game;
@property (nonatomic, assign) BOOL touch;

@end

static const uint32_t playererCategory = 0x1 << 0;
static const uint32_t blockCategory = 0x1 << 1;

@implementation Player {
    BOOL _touch;
}

- (id)init
{
    if(self = [super init]){
        self = [Player spriteNodeWithImageNamed:@"playPressed"];
        self.size = CGSizeMake(80, 80);
        self.name = @"player";
        self.alpha = 1;
        self.game = YES;
        // 60  && 480-382 =98 
        self.position = CGPointMake(320/2, 480/8);
        self.userInteractionEnabled = YES;
        
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:40];
        [self.physicsBody setAffectedByGravity:FALSE];
        [self.physicsBody setAllowsRotation:NO];
        
        [self.physicsBody setCategoryBitMask:playererCategory];
        [self.physicsBody setCollisionBitMask:blockCategory];
        [self.physicsBody setContactTestBitMask:blockCategory];

    }
    return self;
}
-(void)gameOn:(BOOL)game
{
    self.game = game;
}
-(BOOL)isTouching {
    if (self.touch) {
        return YES;
    }else{
        return NO;
    }
}

//NOTE: notPressed = pressed && pressed = notPressed
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.touch = YES;
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    //make sure the game is not over
    if(self.game)
    {
        //make sure the touch is inside the player
        if(location.y < 20 || location.y > -20)
        {
            self.texture = [SKTexture textureWithImageNamed:@"playNotPressed"];
        }else{
            self.texture = [SKTexture textureWithImageNamed:@"playPressed"];
        }
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch and move begins */
    /* Control the player movements from here*/
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if(self.game)
    {
        //make sure the touch is still inside the player
        if(location.y < 20 || location.y > -20 || location.x < 20 || location.x < -20)
        {
            self.texture = [SKTexture textureWithImageNamed:@"playNotPressed"];
            //a touch began inside the player object
            //zero is the center of that touch, not the center of the object
            //the touch can move before ending
            //if X greater than 0 the touch has moved right
            //how far has the touch moved?
            //this is the distance we need to move the player
            if(location.x > 0)
            {
                SKAction *moveL = [SKAction moveTo:CGPointMake(node.position.x + location.x, node.position.y) duration:0.001];
                [node runAction:moveL];
            }
            //quick converters = abs() int || fabs() double || fabsf float
            //need to convert negative position into positive number to set new position
            else if (location.x < 0)
            {
                SKAction *moveR = [SKAction moveTo:CGPointMake(node.position.x - fabsf(location.x), node.position.y) duration:0.001];
                [node runAction:moveR];
            }
        //the touch is outside the player
        }else{
            self.texture = [SKTexture textureWithImageNamed:@"playPressed"];
        }
    }
    
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch ends */
    self.touch = NO;
    
    self.texture = [SKTexture textureWithImageNamed:@"playPressed"];
}
@end
