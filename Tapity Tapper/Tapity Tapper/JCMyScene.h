//
//  JCMyScene.h
//  Tapity Tapper
//

//  Copyright (c) 2014 Juan Carlos Sedano Salas. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface JCMyScene : SKScene
+ (id)initSharedManagerWithSize:(CGSize)size;
+ (id)sharedManager;
- (void)pauseGame;
@end
static JCMyScene *sharedMyManager;