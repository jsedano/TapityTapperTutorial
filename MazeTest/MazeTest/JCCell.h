//
//  JCCell.h
//  MazeTest
//
//  Created by Juan Carlos Sedano Salas on 11/05/14.
//  Copyright (c) 2014 Juan Carlos Sedano Salas. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface JCCell : SKShapeNode

typedef NS_ENUM(NSUInteger, JCWallType) {
    LEFTWALL,
    RIGHTWALL,
    FRONTWALL,
    BACKWALL
};
@property (readonly) BOOL leftWall;
@property (readonly) BOOL rightWall;
@property (readonly) BOOL frontWall;
@property (readonly) BOOL backWall;
@property BOOL visited;
@property NSInteger indexX;
@property NSInteger indexY;

-(id)initCellWithSize:(CGSize)size indexX:(NSInteger)indexX andIndexY:(NSInteger)indexY;
-(void)removeWall:(NSInteger)wall;
-(void)changeFillColor:(UIColor *)color;
@end



