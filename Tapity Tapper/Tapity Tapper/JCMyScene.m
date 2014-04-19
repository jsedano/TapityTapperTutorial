//
//  JCMyScene.m
//  Tapity Tapper
//
//  Created by Juan Carlos Sedano Salas on 18/04/14.
//  Copyright (c) 2014 Juan Carlos Sedano Salas. All rights reserved.
//

#import "JCMyScene.h"

@implementation JCMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        //get the location of the touch
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *rectangle = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(50, 50)];
        //set the newly created node position to the position of the touch
        rectangle.position = location;
        //initialize the physicsBody with the size of the rectangle
        rectangle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rectangle.size];
        //gravity is going to be simulated on this node
        rectangle.physicsBody.affectedByGravity = YES;
        //adding the node to the scene
        [self addChild:rectangle];
        
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
