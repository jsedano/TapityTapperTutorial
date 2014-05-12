//
//  JCMyScene.m
//  MazeTest
//
//  Created by Juan Carlos Sedano Salas on 11/05/14.
//  Copyright (c) 2014 Juan Carlos Sedano Salas. All rights reserved.
//
#import "JCMyScene.h"
#import "JCCell.h"

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
                for (int j=0; j<10; j++) {
                    JCCell *cell = [[JCCell alloc] initCellWithSize:CGSizeMake(self.sizeOfCell, self.sizeOfCell) indexX:j andIndexY:i];
                    
                    cell.position = CGPointMake(self.size.width/2+self.tileZeroFactor+j*self.sizeOfCell,self.size.height/2+self.tileZeroFactor+i*self.sizeOfCell);;
                    
                    [self addChild:cell];
                    self.maze = [self.maze arrayByAddingObject:cell];
                }
            }
            break;
        case 1:
            [[self getCellX:0 Y:0] changeFillColor:[UIColor yellowColor]];
            self.mazeThread = [[NSThread alloc]  initWithTarget:self selector:@selector(carvePassagesFrom:) object:[self getCellX:0 Y:0]];
            [self.mazeThread start];
            break;
        case 2:
            [self removeAllChildren];
            self.maze = [[NSArray alloc] init];
            self.counter = -1;
            break;
        default:
            self.counter = -1;
            break;
    }
    
    self.counter++;
    
}

-(void)carvePassagesFrom:(JCCell *)currentCell{
    currentCell.visited = YES;
    [self shuffle];//we sort the list of directions
    for (int i = 0; i<self.directions.count; i++) {
        JCCell *nextCell = nil;
        NSInteger oppositeDirection = 0;
        NSNumber *direction = [self.directions objectAtIndex:i];
        switch (direction.intValue) {
            case LEFTWALL:
                if (currentCell.indexX-1 >= 0) {
                    nextCell = [self getCellX:currentCell.indexX-1 Y:currentCell.indexY];
                    oppositeDirection = RIGHTWALL;
                }
                break;
            case RIGHTWALL:
                if (currentCell.indexX+1 < 10) {
                    nextCell = [self getCellX:currentCell.indexX+1 Y:currentCell.indexY];
                    oppositeDirection = LEFTWALL;
                }
                break;
            case FRONTWALL:
                if (currentCell.indexY+1 < 10) {
                    nextCell = [self getCellX:currentCell.indexX Y:currentCell.indexY+1];
                    oppositeDirection = BACKWALL;
                }
                break;
            case BACKWALL:
                if (currentCell.indexY-1 >= 0) {
                    nextCell = [self getCellX:currentCell.indexX Y:currentCell.indexY-1];
                    oppositeDirection = FRONTWALL;
                }
                break;
            default:
                break;
        }
        if (nextCell) {
            if (!nextCell.visited) {
                nextCell.visited = YES;
                [currentCell removeWall:direction.intValue];
                [nextCell removeWall:oppositeDirection];
                [nextCell changeFillColor:[UIColor yellowColor]];
                [NSThread sleepForTimeInterval:0.1];
                [self carvePassagesFrom:nextCell];
                
            }
        }
    }
    
    
    
}

-(JCCell *)getCellX:(NSInteger)x Y:(NSInteger)y{
    for (JCCell *cell in self.maze) {
        if (cell.indexX==x&&cell.indexY==y) {
            return cell;
        }
    }
    return nil;
}

- (void)shuffle
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.directions];
    NSUInteger count = [self.directions count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = arc4random_uniform(nElements) + i;
        [tempArray exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    self.directions = [[NSArray alloc] initWithArray:tempArray];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
