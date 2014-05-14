//
//  JCMaze.m
//  MazeTest
//
//  Created by Juan Carlos Sedano Salas on 13/05/14.
//  Copyright (c) 2014 Juan Carlos Sedano Salas. All rights reserved.
//

#import "JCMaze.h"


@interface JCMaze()

@property NSInteger counter;
@property NSArray *maze;
@property float sizeOfCell;
@property NSArray *directions;
@property CGFloat tileZeroFactor;
@property NSThread *mazeThread;

@end

@implementation JCMaze

- (id)init{
    if (self = [super init]) {
        self.sizeOfCell = 30;
        self.maze = [[NSArray alloc] init];
        self.directions = [NSArray arrayWithObjects:[NSNumber numberWithInt:LEFTWALL],[NSNumber numberWithInt:RIGHTWALL],[NSNumber numberWithInt:FRONTWALL],[NSNumber numberWithInt:BACKWALL], nil];
        self.tileZeroFactor = -self.sizeOfCell*10/2+self.sizeOfCell/2;

        for (int i=0; i<10; i++) {
            NSArray *mazeRow = [[NSArray alloc] init];
            for (int j=0; j<10; j++) {
                JCCell *cell = [[JCCell alloc] initCellWithSize:CGSizeMake(self.sizeOfCell, self.sizeOfCell)];
            
                cell.position = CGPointMake(self.position.x+self.tileZeroFactor+j*self.sizeOfCell,self.position.y+self.tileZeroFactor+i*self.sizeOfCell);;
            
                [self addChild:cell];
                mazeRow = [mazeRow arrayByAddingObject:cell];
            }
            self.maze =[self.maze arrayByAddingObject:mazeRow];
        }

    }
    return self;
}

-(JCCell *)getCellInPoint:(JCPoint*)point{
    return [[self.maze objectAtIndex:point.y] objectAtIndex:point.x];
}

-(void)carverHelper:(NSArray *)cellAndPoint{
    [self carvePassagesFrom:[cellAndPoint objectAtIndex:0] inPoint:[cellAndPoint objectAtIndex:1]];
}



-(void)carvePassagesFrom:(JCCell *)currentCell inPoint:(JCPoint *)point{
    currentCell.visited = YES;
    [currentCell changeFillColor:[UIColor lightGrayColor]];
    NSArray *directions = [self shuffle];
    for (int i = 0; i<self.directions.count; i++) {
        JCCell *nextCell = nil;
        JCPoint *nextPoint = nil;
        NSInteger oppositeDirection = 0;
        NSNumber *direction = [directions objectAtIndex:i];
        switch (direction.intValue) {
            case LEFTWALL:
                if (point.x-1 >= 0) {
                    nextPoint = [JCPoint initPointWithX:point.x-1 andY:point.y];
                    oppositeDirection = RIGHTWALL;
                }
                break;
            case RIGHTWALL:
                if (point.x+1 < 10) {
                    nextPoint = [JCPoint initPointWithX:point.x+1 andY:point.y];
                    oppositeDirection = LEFTWALL;
                }
                break;
            case FRONTWALL:
                if (point.y+1 < 10) {
                    nextPoint = [JCPoint initPointWithX:point.x andY:point.y+1];
                    oppositeDirection = BACKWALL;
                }
                break;
            case BACKWALL:
                if (point.y-1 >= 0) {
                    nextPoint = [JCPoint initPointWithX:point.x andY:point.y-1];
                    oppositeDirection = FRONTWALL;
                }
                break;
            default:
                break;
        }
        if (nextPoint) {
            nextCell = [self getCellInPoint:nextPoint];
            if (!nextCell.visited) {
                nextCell.visited = YES;
                [currentCell removeWall:direction.intValue];
                [nextCell removeWall:oppositeDirection];
                [nextCell changeFillColor:[UIColor redColor]];
                [NSThread sleepForTimeInterval:0.1];
                [self carvePassagesFrom:nextCell inPoint:nextPoint];
            }
        }
        
        
    }
}

-(BOOL)isCarving{
    return self.mazeThread.isFinished;
}

-(void)startCarving{
    [[self getCellInPoint:[JCPoint initPointWithX:0 andY:0]] changeFillColor:[UIColor redColor]];
    self.mazeThread = [[NSThread alloc]  initWithTarget:self selector:@selector(carverHelper:) object:[NSArray arrayWithObjects:[self getCellInPoint:[JCPoint initPointWithX:0 andY:0]],[JCPoint initPointWithX:0 andY:0], nil]];
    [self.mazeThread start];
}

- (NSArray *)shuffle
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.directions];
    NSUInteger count = [self.directions count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = arc4random_uniform(nElements) + i;
        [tempArray exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    return [[NSArray alloc] initWithArray:tempArray];
}


@end
