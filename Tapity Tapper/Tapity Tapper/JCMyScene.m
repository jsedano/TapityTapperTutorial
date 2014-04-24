//
//  JCMyScene.m
//  Tapity Tapper
//
//  Created by Juan Carlos Sedano Salas on 18/04/14.
//  Copyright (c) 2014 Juan Carlos Sedano Salas. All rights reserved.
//

#import "JCMyScene.h"

@interface JCMyScene(){}

@property SKSpriteNode *rectangle;

@end

@implementation JCMyScene



-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    //is rectangle different from nil
    if (!self.rectangle) {
        //get a single touch
        UITouch *touch = [touches anyObject];
        //get the location of the touch
        CGPoint location = [touch locationInNode:self];
        self.rectangle = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(50, 50)];
        //set the newly created node position to the position of the touch
        self.rectangle.position = location;
        //initialize the physicsBody with the size of the rectangle
        self.rectangle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.rectangle.size];
        //gravity is going to be simulated on this node
        self.rectangle.physicsBody.affectedByGravity = YES;
        self.rectangle.physicsBody.mass = 0.5f;
        //adding the node to the scene
        [self addChild:self.rectangle];
        SKAction *callAddObstacles = [SKAction performSelector:@selector(addObstacles) onTarget:self];
        SKAction *wait = [SKAction waitForDuration:1.5];
        SKAction *waitThenAdd = [SKAction sequence:@[callAddObstacles,wait]];
        SKAction *obstacleLoop = [SKAction repeatActionForever:waitThenAdd];
        [self.rectangle runAction:obstacleLoop];
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
    [self addChild:upperObstacle];
    [self addChild:lowerObstacle];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
