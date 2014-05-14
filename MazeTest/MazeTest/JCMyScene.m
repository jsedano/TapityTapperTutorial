//
//  JCMyScene.m
//  MazeTest
//
//  Created by Juan Carlos Sedano Salas on 11/05/14.
//  Copyright (c) 2014 Juan Carlos Sedano Salas. All rights reserved.
//
#import "JCMyScene.h"
#import "JCCell.h"
#import "JCPoint.h"
#import "JCMaze.h"
#import "JCJoystick.h"
@interface JCMyScene ()

@property NSInteger counter;
@property JCMaze *maze;
@property JCJoystick *joystick;
@end




@implementation JCMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [UIColor whiteColor];
        self.counter = 0;
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    switch (self.counter) {
        case 0:
            self.maze = [[JCMaze alloc] init];
            self.maze.position = CGPointMake(self.size.width/2, self.size.height/2);
            [self addChild:self.maze];
            break;
        case 1:
            [self.maze startCarving];
            
            break;
        default:
            break;
    }
    if ([self.maze isCarving]) {
        [self removeAllChildren];
        self.maze = nil;
        self.counter = -1;
    }
    self.counter++;
    
}





-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
