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
@interface JCMyScene ()

@property NSInteger counter;
@property NSArray *maze;
@property float sizeOfCell;
@property NSArray *directions;
@property CGFloat tileZeroFactor;
@property NSThread *mazeThread;

@end




@implementation JCMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [UIColor whiteColor];
        self.counter = 0;
        self.sizeOfCell = 30;
        self.maze = [[NSArray alloc] init];
        self.directions = [NSArray arrayWithObjects:[NSNumber numberWithInt:LEFTWALL],[NSNumber numberWithInt:RIGHTWALL],[NSNumber numberWithInt:FRONTWALL],[NSNumber numberWithInt:BACKWALL], nil];
        self.tileZeroFactor = -self.sizeOfCell*10/2+self.sizeOfCell/2;
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    switch (self.counter) {
        case 0:
            for (int i=0; i<10; i++) {
                NSArray *mazeRow = [[NSArray alloc] init];
                for (int j=0; j<10; j++) {
                    JCCell *cell = [[JCCell alloc] initCellWithSize:CGSizeMake(self.sizeOfCell, self.sizeOfCell)];
                    
                    cell.position = CGPointMake(self.size.width/2+self.tileZeroFactor+j*self.sizeOfCell,self.size.height/2+self.tileZeroFactor+i*self.sizeOfCell);;
                    
                    [self addChild:cell];
                    //self.maze = [self.maze arrayByAddingObject:cell];
                    mazeRow = [mazeRow arrayByAddingObject:cell];
                }
                self.maze =[self.maze arrayByAddingObject:mazeRow];
            }
            break;
        case 1:
            [[self getCellInPoint:[JCPoint initPointWithX:0 andY:0]] changeFillColor:[UIColor redColor]];
            self.mazeThread = [[NSThread alloc]  initWithTarget:self selector:@selector(carverHelper:) object:[NSArray arrayWithObjects:[self getCellInPoint:[JCPoint initPointWithX:0 andY:0]],[JCPoint initPointWithX:0 andY:0], nil]];
            [self.mazeThread start];
            break;
        default:
            break;
    }
    if (self.mazeThread!=nil && self.mazeThread.isFinished) {
        [self removeAllChildren];
        self.maze = [[NSArray alloc] init];
        self.counter  = -1;
        self.mazeThread = nil;
    }
    self.counter++;
    
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

-(JCCell *)getCellInPoint:(JCPoint*)point{
    return [[self.maze objectAtIndex:point.y] objectAtIndex:point.x];
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

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
