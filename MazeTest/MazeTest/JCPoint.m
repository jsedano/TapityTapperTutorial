//
//  JCPoint.m
//  MazeTest
//
//  Created by Juan Carlos Sedano Salas on 12/05/14.
//  Copyright (c) 2014 Juan Carlos Sedano Salas. All rights reserved.
//

#import "JCPoint.h"

@interface JCPoint()
@property NSInteger x;
@property NSInteger y;


@end


@implementation JCPoint

+(id)initPointWithX:(NSInteger)x andY:(NSInteger)y{
    JCPoint *point = [[JCPoint alloc] init];
    point.x = x;
    point.y = y;
    return point;
}

@end
