//
//  JCPoint.h
//  MazeTest
//
//  Created by Juan Carlos Sedano Salas on 12/05/14.
//  Copyright (c) 2014 Juan Carlos Sedano Salas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCPoint : NSObject
@property (readonly) NSInteger x;
@property (readonly) NSInteger y;

+(id)initPointWithX:(NSInteger)x andY:(NSInteger)y;

@end
