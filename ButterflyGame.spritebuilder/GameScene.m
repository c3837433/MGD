//
//  GameScene.m
//  ButterflyGame
//
//  Created by Angela Smith on 3/8/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameScene.h"

static const CGFloat scrollSpeed = 80.f;

@implementation GameScene {
    
    // Butterfly movement and position
    CGFloat setPostion;
    BOOL moveButterflyUp;
    BOOL moveButterflyDown;
    CGPoint startPosition;
    
    // Game nodes
    CCSprite* _butterfly;
    CCPhysicsNode* _gamePhysicNode;
    
    // Background items for floor or ceiling
    CCNode* _floor1;
    CCNode* _floor2;
    NSArray* _forestFloors;
    
    CCNode* _canopy1;
    CCNode* _canopy2;
    NSArray* _forestCanopy;
    
    CCNode* _trunks1;
    CCNode* _trunks2;
    NSArray* _treeTrunks;
    
    CCNode* _cloud1;
    CCNode* _cloud2;
    NSArray* _cloudsLayer;
    CCNode* _farCloudNode;

}

- (void)didLoadFromCCB {
    
    self.userInteractionEnabled = TRUE;
    // set up the node arrays
    _forestFloors = @[_floor1, _floor2];
    _cloudsLayer = @[_cloud1, _cloud2];
    _forestCanopy =  @[_canopy1, _canopy2];
    _treeTrunks =  @[_trunks1, _trunks2];
    
    UISwipeGestureRecognizer* swipeUp= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeUp];
    // listen for swipes down
    UISwipeGestureRecognizer* swipeDown= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeDown];
}
- (void)update:(CCTime)delta {
    // Move the objects
   // BUTTERFLY
   _butterfly.position = ccp(_butterfly.position.x + delta * scrollSpeed, _butterfly.position.y);
    
    // CLOUD LAYER
    _farCloudNode.position = ccp(_farCloudNode.position.x - (20.f *delta), _farCloudNode.position.y);
    //loop the clouds
    [self loopLayerObject:_cloudsLayer withNode:_farCloudNode];

    // PHYSICS NODE LAYER
    _gamePhysicNode.position = ccp(_gamePhysicNode.position.x - (scrollSpeed *delta), _gamePhysicNode.position.y);
    // loop floor & canopy
    [self loopLayerObject:_forestFloors withPhysicsNode:_gamePhysicNode];
    [self loopLayerObject:_forestCanopy withPhysicsNode:_gamePhysicNode];
    [self loopLayerObject:_treeTrunks withNode:_gamePhysicNode];
    
    // if we need to update the current position of the butterfly
    if ((moveButterflyUp || (moveButterflyDown))) {
        CCLOG(@"Updating position");
        // get the current  x position and the new y
        CGPoint butterflyPosition = { _butterfly.position.x, setPostion};
        // create the action to move the butterfly
        CCActionMoveTo*  moveTo = [CCActionMoveTo actionWithDuration:.8 position:butterflyPosition];
        // set the ease action to slightly drop for liftoff and settle when at right location
        if (moveButterflyUp) {
            CCActionEaseBackInOut*  ease = [CCActionEaseBackInOut actionWithAction:moveTo];
            [_butterfly runAction: ease];
        } else if ( moveButterflyDown) {
            CCActionEaseBackOut*  ease = [CCActionEaseBackOut actionWithAction:moveTo];
            [_butterfly runAction: ease];
        }
        moveButterflyDown = false;
        moveButterflyUp = false;
    }

}


// Loop the background objects in a regular node
-(void) loopLayerObject:(NSArray*) layerObjectArray withNode:(CCNode*) node {
    // GROUND
    for (CCNode* piece in layerObjectArray) {
        // get the position of the ground
        CGPoint objectPostion = [node convertToWorldSpace:piece.position];
        // get the current position on the screen
        CGPoint objectScreenPosition = [self convertToNodeSpace:objectPostion];
        // if the left corner is halfway off the screen move it
        if (objectScreenPosition.x <= (-0.5 * piece.contentSize.width)) {
            piece.position = ccp(piece.position.x + 2 * piece.contentSize.width, piece.position.y);
        }
    }
}


// Loop the objects in the physics node
-(void) loopLayerObject:(NSArray*) layerObjectArray withPhysicsNode:(CCPhysicsNode*) physicsNode {
    
    // GROUND
    for (CCNode* piece in layerObjectArray) {
        // get the position of the ground
        CGPoint objectPostion = [physicsNode convertToWorldSpace:piece.position];
        // get the current position on the screen
        CGPoint objectScreenPosition = [self convertToNodeSpace:objectPostion];
        // if the left corner is halfway off the screen move it
        if (objectScreenPosition.x <= (-0.5 * piece.contentSize.width)) {
            piece.position = ccp(piece.position.x + 2 * piece.contentSize.width, piece.position.y);
        }
    }
}

- (void)swipeDown {
    moveButterflyDown = true;
    CCLOG(@"User swiped down");
    // this was a tap on the butterfly, see where he is
    if(_butterfly.position.y > 200){ //3
        CCLOG(@"Butterfly is in the top, moving to middle");
        // NO movement needed
        setPostion = 152;
    } else  if(_butterfly.position.y < 90){ //3
        CCLOG(@"Butterfly will stay at the bottom");
        moveButterflyDown = false;
    } else {
        CCLOG(@"Butterfly is in the middle, moving to bottom");
        setPostion = 85;
    }
}

-(void) swipeUp {
    CCLOG(@"User Swiped up");
    moveButterflyUp = true;
    // this was a tap on the butterfly, see where he is
    if(_butterfly.position.y > 200){ //3
        CCLOG(@"Butterfly will stay at the top");
        // NO movement needed
        moveButterflyUp = false;
    }else  if(_butterfly.position.y < 90){ //3
        CCLOG(@"Butterfly is in the bottom, moving to middle");
        setPostion = 152;
    } else {
        CCLOG(@"Butterfly is in the middle, moving to top");
        setPostion = 223;
    }
}


@end
