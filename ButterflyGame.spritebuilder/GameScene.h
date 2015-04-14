//
//  GameScene.h
//  ButterflyGame
//
//  Created by Angela Smith on 3/8/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface GameScene : CCNode <CCPhysicsCollisionDelegate>

typedef NS_ENUM(NSInteger, DrawingOrder) {
    DrawingOrderClouds,
    DrawingOrderTreeline,
    DrawingOrderBackHill,
    DrawingOrderFrontHill,
    DrawingOrderTrunks,
    DrawingOrderFrontLayer,
    DrawingOrderFloor,
    DrawingOrderCanopy,
    DrawingOrdeButterfly
};

@property (nonatomic, strong) NSString* currentJourney;
@property (nonatomic) NSInteger currentStop;
@property (nonatomic) BOOL forUnlock;

#define HORIZ_SWIPE_DRAG_MIN  12
#define VERT_SWIPE_DRAG_MAX    4
@end
