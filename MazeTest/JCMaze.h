//
//  JCMaze.h
//  MazeTest
//
//  Created by Juan Carlos Sedano Salas on 13/05/14.
//  Copyright (c) 2014 Juan Carlos Sedano Salas. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "JCPoint.h"
#import "JCCell.h"
@interface JCMaze : SKShapeNode


- (id)init;
-(JCCell *)getCellInPoint:(JCPoint*)point;
-(void)carverHelper:(NSArray *)cellAndPoint;
-(void)carvePassagesFrom:(JCCell *)currentCell inPoint:(JCPoint *)point;
-(void)startCarving;
- (NSArray *)shuffle;
- (BOOL)isCarving;
@end
