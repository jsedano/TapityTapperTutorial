//
//  JCCell.m
//  MazeTest
//
//  Created by Juan Carlos Sedano Salas on 11/05/14.
//  Copyright (c) 2014 Juan Carlos Sedano Salas. All rights reserved.
//

#import "JCCell.h"
@interface JCCell()

@property BOOL leftWall;
@property BOOL rightWall;
@property BOOL frontWall;
@property BOOL backWall;
@property SKShapeNode *leftWallNode;
@property SKShapeNode *rightWallNode;
@property SKShapeNode *frontWallNode;
@property SKShapeNode *backWallNode;
@property SKSpriteNode *fill;
@end

@implementation JCCell
-(id)initCellWithSize:(CGSize)size{
    if (self=[super init]) {
        int cellthikness = 3;
        self.visited = NO;
        self.fill = [SKSpriteNode spriteNodeWithColor:[UIColor grayColor] size:size];
        
        self.leftWallNode = [[SKShapeNode alloc]init];
        CGMutablePathRef leftWallPath = CGPathCreateMutable();
        CGPathAddRect(leftWallPath, NULL, CGRectMake(self.position.x-size.width/2, self.position.y-size.height/2, 3, size.height));
        self.leftWallNode.fillColor =  [UIColor blackColor];
        self.leftWallNode.lineWidth= 0;
        [[self leftWallNode] setPath:leftWallPath];
        CGPathRelease(leftWallPath);
        
        
        self.rightWallNode = [[SKShapeNode alloc]init];
        CGMutablePathRef rightWallPath = CGPathCreateMutable();
        CGPathAddRect(rightWallPath, NULL, CGRectMake(self.position.x+size.width/2-cellthikness, self.position.y-size.height/2, 3, size.height));
        self.rightWallNode.fillColor =  [UIColor blackColor];
        self.rightWallNode.lineWidth=0;
        [[self rightWallNode] setPath:rightWallPath];
        CGPathRelease(rightWallPath);
        
        self.frontWallNode = [[SKShapeNode alloc]init];
        CGMutablePathRef frontWallPath = CGPathCreateMutable();
        CGPathAddRect(frontWallPath, NULL, CGRectMake(self.position.x-size.width/2, self.position.y+size.height/2-cellthikness, size.width, 3));
        self.frontWallNode.fillColor =  [UIColor blackColor];
        self.frontWallNode.lineWidth=0;
        [[self frontWallNode] setPath:frontWallPath];
        CGPathRelease(frontWallPath);
        
        
        self.backWallNode = [[SKShapeNode alloc]init];
        CGMutablePathRef backWallPath = CGPathCreateMutable();
        CGPathAddRect(backWallPath, NULL, CGRectMake(self.position.x-size.width/2, self.position.y-size.height/2, size.width, 3));
        self.backWallNode.fillColor =  [UIColor blackColor];
        self.backWallNode.lineWidth=0;
        [[self backWallNode] setPath:backWallPath];
        CGPathRelease(backWallPath);
        
        [self addChild:self.fill];
        [self addChild:self.leftWallNode];
        [self addChild:self.rightWallNode];
        [self addChild:self.frontWallNode];
        [self addChild:self.backWallNode];
    }
    return self;
}

-(void)removeWall:(NSInteger)wall{
    switch (wall) {
        case LEFTWALL:
            self.leftWall = NO;
            [self.leftWallNode removeFromParent];
            break;
        case RIGHTWALL:
            self.rightWall = NO;
            [self.rightWallNode removeFromParent];
            break;
        case FRONTWALL:
            self.frontWall = NO;
            [self.frontWallNode removeFromParent];
            break;
        case BACKWALL:
            self.backWall = NO;
            [self.backWallNode removeFromParent];
            self.backWallNode = nil;
            break;
        default:
            break;
    }
    
}

-(void)changeFillColor:(UIColor *)color{
    self.fill.color = color;
}
@end
