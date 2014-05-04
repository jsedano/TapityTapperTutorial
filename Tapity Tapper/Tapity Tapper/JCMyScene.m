//
//  JCMyScene.m
//  Tapity Tapper
//
//  Created by Juan Carlos Sedano Salas on 18/04/14.
//  Copyright (c) 2014 Juan Carlos Sedano Salas. All rights reserved.
//

#import "JCMyScene.h"

@interface JCMyScene() <SKPhysicsContactDelegate>{}

@property SKSpriteNode *rectangle;
@property SKAction *obstacleLoop;
@property BOOL gameOver;
@property UIAlertView *gameOverAlert;
@property SKLabelNode *startGameLabel;

typedef enum : uint8_t {
    JCColliderTypeRectangle = 1,
    JCColliderTypeObstacle  = 2
} JCColliderType;

@end

@implementation JCMyScene



-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
        self.physicsWorld.contactDelegate = self;
        
        SKAction *callAddObstacles = [SKAction performSelector:@selector(addObstacles) onTarget:self];
        SKAction *wait = [SKAction waitForDuration:1.5];
        SKAction *waitThenAdd = [SKAction sequence:@[callAddObstacles,wait]];
        self.obstacleLoop = [SKAction repeatActionForever:waitThenAdd];
        
        self.gameOverAlert = [[UIAlertView alloc] initWithTitle:@"Game Over"
                                                   message:nil
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
        
        self.startGameLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        self.startGameLabel.text = @"Tap to play";
        self.startGameLabel.fontSize = 15;
        self.startGameLabel.position = CGPointMake(size.width/2, size.height/2);
        
        self.gameOver = NO;
        
        self.rectangle = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(50, 50)];
        [self setRectanglePositionAndAddToScene];
        [self addChild:self.startGameLabel];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    if (!self.rectangle.physicsBody||self.gameOver) {
        if (!self.rectangle.physicsBody) {
            [self.startGameLabel removeFromParent];
            //initialize the physicsBody with the size of the rectangle
            self.rectangle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.rectangle.size];
            //gravity is going to be simulated on this node
            self.rectangle.physicsBody.affectedByGravity = YES;
            self.rectangle.physicsBody.allowsRotation = NO;
            self.rectangle.physicsBody.mass = 0.5f;
            //collision detection
            self.rectangle.physicsBody.categoryBitMask = JCColliderTypeRectangle;
            self.rectangle.physicsBody.collisionBitMask = JCColliderTypeObstacle | JCColliderTypeRectangle;
            self.rectangle.physicsBody.contactTestBitMask = JCColliderTypeObstacle;
        }
        if (self.gameOver) {
            [self removeAllChildren];
            self.paused = NO;
            self.gameOver = NO;
            [self setRectanglePositionAndAddToScene];
        }
        [self.rectangle runAction:self.obstacleLoop withKey:@"obstacles"];
    }
    else{
        [self.rectangle.physicsBody applyImpulse:CGVectorMake(0.0f, 250.0f)];
    }
    
}

-(void)addObstacles{
    float obstacleWidth = 50.0f;
    
    SKSpriteNode *upperObstacle = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(obstacleWidth, self.size.height/2-100)];
    
    SKSpriteNode *lowerObstacle = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(obstacleWidth, self.size.height/2-100)];
    
    upperObstacle.position = CGPointMake(self.size.width+obstacleWidth/2, self.size.height-upperObstacle.size.height/2);
    
    lowerObstacle.position = CGPointMake(self.size.width+obstacleWidth/2, lowerObstacle.size.height/2);
    
    
    SKAction *moveObstacle = [SKAction moveToX:-obstacleWidth/2 duration:2.0];
    
    [upperObstacle runAction:moveObstacle completion:^(void){
        [upperObstacle removeFromParent];
    }];
    [lowerObstacle runAction:moveObstacle completion:^(void){
        [lowerObstacle removeFromParent];
    }];
    
    //collision detection
    upperObstacle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:upperObstacle.size];
    //we don't want this object to be animated by the physics engine
    upperObstacle.physicsBody.dynamic = NO;
    upperObstacle.physicsBody.categoryBitMask = JCColliderTypeObstacle;
    //same with the lower obstacle
    lowerObstacle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:lowerObstacle.size];
    lowerObstacle.physicsBody.dynamic = NO;
    lowerObstacle.physicsBody.categoryBitMask = JCColliderTypeObstacle;
    [self addChild:upperObstacle];
    [self addChild:lowerObstacle];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(void)didBeginContact:(SKPhysicsContact *)contact{
    
    if ((contact.bodyA.categoryBitMask == JCColliderTypeRectangle && contact.bodyB.categoryBitMask == JCColliderTypeObstacle) || (contact.bodyB.categoryBitMask == JCColliderTypeRectangle && contact.bodyA.categoryBitMask == JCColliderTypeObstacle)) {
        self.paused = YES;
        [self.rectangle removeActionForKey:@"obstacles"];
        self.gameOver = YES;
        [self.gameOverAlert show];
        [self addChild:self.startGameLabel];
    }

}

-(void)setRectanglePositionAndAddToScene{
    self.rectangle.position = CGPointMake(60, self.size.height/2);
    [self addChild:self.rectangle];
}

@end
