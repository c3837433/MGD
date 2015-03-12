//
//  GameScene.m
//  ButterflyGame
//
//  Created by Angela Smith on 3/8/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameScene.h"

// Standard scroll speed
static const CGFloat scrollSpeed = 80.f;

@implementation GameScene {
    
    // Butterfly movement and position
    CGFloat setPostion;
    BOOL moveButterflyUp;
    BOOL moveButterflyDown;
    BOOL didBumpTop;
    CGPoint startPosition;
    
    // Game nodes
    CCSprite* _butterfly;
    CCSprite* _winButterfly;
    CCSprite* _loseButterfly;
    
    CCPhysicsNode* _gamePhysicNode;
    
    // PHYSICS NODE LAYER
    CCNode* _floor1;
    CCNode* _floor2;
    NSArray* _forestFloors;
    
    CCNode* _canopy1;
    CCNode* _canopy2;
    NSArray* _forestCanopy;
    
    CCNode* _trunks1;
    CCNode* _trunks2;
    NSArray* _treeTrunks;
    
    CCNode* _web1;
    CCSprite* _web2;
    CCNode* _rock1;
    CCSprite* _rock2;
    
    // PARALLAX BACKGROUND LAYERS
    CCNode* _cloud1;
    CCNode* _cloud2;
    NSArray* _cloudsLayer;
    CCNode* _farCloudNode;
    
    CCNode* _fronthill1;
    CCNode* _fronthill2;
    NSArray* _frontHillLayer;
    CCNode* _frontHillNode;
    
    CCNode* _backHill1;
    CCNode* _backHill2;
    NSArray* _backHillLayer;
    CCNode* _backhillNode;
    
    CCNode* _treeline1;
    CCNode* _treeline2;
    NSArray* _treeLineLayer;
    CCNode* _treelineNode;
    
    BOOL didFinish;
    BOOL didLand;
    BOOL didDie;
    BOOL didPause;
    
    CCNode* _levelNode;
    CCNode* _gamePauseNode;
    CCNode* _gameWinNode;
    CCNode* _gameLoseNode;
    
    OALSimpleAudio* audio;

    CCButton* _pauseButton;
    
    
    UITapGestureRecognizer* userTap;
    
}

- (void)didLoadFromCCB {
    CCLOG(@"Loaded Game");
    // get audio ready
    audio = [OALSimpleAudio sharedInstance];
    // Preload the music
    [audio  preloadBg:@"background_music.mp3"];
    
    // preset conditionals for frame updates
    didFinish = false;
    didLand = false;
    didDie = false;
    didBumpTop = false;
    didPause = false;
    
    //Load the first level
    CCScene *level = [CCBReader loadAsScene:@"Levels/Level1"];
    [_levelNode addChild:level];
    // set it in front of the trunks but behind the floor and canopy
    _levelNode.zOrder = DrawingOrderFrontLayer;

    // ALLOW TOUCH AND MULTI TOUCH
    self.userInteractionEnabled = TRUE;
    [[[CCDirector sharedDirector] view] setMultipleTouchEnabled:YES];
    
    // set up the background node arrays
    _forestFloors = @[_floor1, _floor2];
    _cloudsLayer = @[_cloud1, _cloud2];
    _forestCanopy =  @[_canopy1, _canopy2];
    _treeTrunks =  @[_trunks1, _trunks2];
    _frontHillLayer = @[_fronthill1, _fronthill2];
    _backHillLayer = @[_backHill1, _backHill2];
    _treeLineLayer = @[_treeline1, _treeline2];
    
    // INPUT CONTROL LISTENERS
    // Listen for a swipe Up
    UISwipeGestureRecognizer* swipeUp= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeUp];
    // listen for swipes down
    UISwipeGestureRecognizer* swipeDown= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeDown];
    // Listen for a single tap for buttons
   // userTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapped:)];
   // [[[CCDirector sharedDirector] view] addGestureRecognizer:userTap];
    
    
    // SET BACKGROUND LAYERS FOR PARALLAX EFFECT
    for (CCNode* cloud in _cloudsLayer) {
        cloud.zOrder = DrawingOrderClouds;
    }
    for (CCNode* trunk in _treeTrunks) {
        trunk.zOrder = DrawingOrderTrunks;
    }
    for (CCNode* canopy in _forestCanopy) {
        canopy.zOrder = DrawingOrderCanopy;
    }
    for (CCNode* hill in _backHillLayer) {
        hill.zOrder = DrawingOrderBackHill;
    }
    for (CCNode* hill in _frontHillLayer) {
        hill.zOrder = DrawingOrderFrontHill;
    }
    for (CCNode* trees in _treeLineLayer) {
        trees.zOrder = DrawingOrderTreeline;
    }
    for (CCNode* floor in _forestFloors) {
        floor.physicsBody.collisionType = @"floor";
        floor.zOrder = DrawingOrderFloor;
    }
    
    
    // COLLISION DELEGATE
    _gamePhysicNode.collisionDelegate = self;
    
    // set the buttergly colistion type and drawing order
    _butterfly.physicsBody.collisionType = @"butterfly";
    _butterfly.zOrder = DrawingOrdeButterfly;
    
    // set the butterfly to start animatting
    [self LaunchButterfly];
    
}

// GET THE BUTTERFLY AND BEGIN ANIMATING IT
-(void)LaunchButterfly {
    CCLOG(@"Launching Butterfly");
    // start the annimation
    CCAnimationManager* animationManager = _butterfly.animationManager;
    [animationManager runAnimationsForSequenceNamed:@"FlyButterfly"];
    // move the butterfly to the middle row
    //setPostion = 192;
    setPostion = 0.5;
    moveButterflyUp = true;
    //CGFloat currentPos = _butterfly.position.y;
    //CCLOG(@"The butterfly is at %f", currentPos);
    // ge
    //IF YOU WANT BACKGROUND MUSIC PLAYING
    //[audio playBg:@"background_music.mp3"];
}

#pragma MARK - FRAME UPDATES
    - (void)update:(CCTime)delta {
        // CHECK IF THE USER IS STILL PLAYING
        if (didPause) {
            audio.bgPaused = TRUE;
        } else  if (!didFinish) {
            // NORMAL GAME PLAY, MOVE OBJECTS
            if (didBumpTop) {
                // The user bumped the top canopy
                CCLOG(@"Bouncing off canopy position");
                // set the position to move up slightly
                CGPoint topPos = { _butterfly.position.x, setPostion + .01};
                // create the action to move the butterfly up
                CCActionMoveTo*  moveTo = [CCActionMoveTo actionWithDuration:.4 position:topPos];
                didBumpTop = false;
                CGPoint bottomPos = { _butterfly.position.x, setPostion};
                // and back to the correct position
                CCActionMoveTo* moveBack = [CCActionMoveTo actionWithDuration:.4 position:bottomPos];
                // run the action sequence to bump the canopy
                [_butterfly runAction:[CCActionSequence actions: moveTo, moveBack, nil]];

            } else {
                // BUTTERFLY
                _butterfly.position = ccp(_butterfly.position.x + delta * scrollSpeed + 0.1, _butterfly.position.y);
            }

            // CLOUD LAYER
            // Move the clouds slowest
            _farCloudNode.position = ccp(_farCloudNode.position.x - delta * (scrollSpeed - 50), _farCloudNode.position.y);
            //loop the clouds
            [self loopLayerObject:_cloudsLayer withNode:_farCloudNode];
            
            // BACK HILLS LAYER
            _backhillNode.position = ccp(_backhillNode.position.x - delta * (scrollSpeed - 30), _backhillNode.position.y);
            [self loopLayerObject:_backHillLayer withNode:_backhillNode];
            
            // TREELINE LAYER
            _treelineNode.position = ccp(_treelineNode.position.x - delta * (scrollSpeed - 20), _treelineNode.position.y);
            [self loopLayerObject:_treeLineLayer withNode:_treelineNode];
        
            
            // FRONT HILLS LAYER
            _frontHillNode.position = ccp(_frontHillNode.position.x - delta * (scrollSpeed - 10), _frontHillNode.position.y);
            [self loopLayerObject:_frontHillLayer withNode:_frontHillNode];
            
            
            // PHYSICS NODE LAYER
            _gamePhysicNode.position = ccp(_gamePhysicNode.position.x - (scrollSpeed *delta), _gamePhysicNode.position.y);
            // loop floor & canopy with the physics speed
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
                    // gently lower back down
                    CCActionEaseBackOut*  ease = [CCActionEaseBackOut actionWithAction:moveTo];
                    [_butterfly runAction: ease];
                }
                // reset to prevent multiple movements
                moveButterflyDown = false;
                moveButterflyUp = false;
            }
            // WHEN BUTTERFLY FALLS BEHIND LEFT VIEW AREA
            // make sure the butterfly did not leave the screen by checking it's position in the world
            CGPoint objectPostion = [_gamePhysicNode convertToWorldSpace:_butterfly.position];
            // If the x is less than -50 it has completely disappeared off screen
            if (objectPostion.x < -50) {
                CCLOG(@"Butterfly is off screen");
                didDie = YES;
                didFinish = YES;
            }

            
        } else {
              // THE GAME HAS ENDED FROM WIN OR LOSS
            if (didDie) {
                // Player died; check if it has landed yet
                if (!didLand) {
                    // Get the annimation manager
                    CCAnimationManager* animationManager = _loseButterfly.animationManager;
                    _gameLoseNode.visible = true;
                    _butterfly.visible = false;
                    [animationManager runAnimationsForSequenceNamed:@"SadButterfly"];
                    audio.bgPaused = TRUE;
                    CCLOG(@"pausing annimation and playing death effect");
                    [animationManager setPaused:YES];
                    [audio playEffect:@"loseGame.mp3"];
                    didLand = true;
                }
                
                
            } else {
                CCAnimationManager* animationManager = _winButterfly.animationManager;
                // The Player Won; if it hasn't landed on the flower yet
                if (!didLand) {
                    // move to flower
                    _gameWinNode.visible = true;
                    _butterfly.visible = false;
                    //CGPoint butterflyPosition =  ccp(1857 + 225, .25);
                    // create the action to move the butterfly
                    //CCActionMoveTo*  moveTo = [CCActionMoveTo actionWithDuration:1.5f position:butterflyPosition];
                    //CCActionEaseBackInOut*  ease = [CCActionEaseBackInOut actionWithAction:moveTo];
                    //[_butterfly runAction: ease];
                    // Change the annimation
                   // [animationManager runAnimationsForSequenceNamed:@"EndOnFlower"];
                    CCLOG(@"You win!");
                    didLand = true;
                    [audio playEffect:@"yahoo.mp3"];
                    // change the animation
                    [animationManager runAnimationsForSequenceNamed:@"FlapFacing"];
                }
            }
        }
    }


#pragma MARK - BACKGROUND LOOPING FOR PARALLAX EFFECT
// Loop the background objects in a regular node
-(void) loopLayerObject:(NSArray*) layerObjectArray withNode:(CCNode*) node {
    // GROUND
    for (CCNode* piece in layerObjectArray) {
        // get the position of the ground
        CGPoint objectPostion = [node convertToWorldSpace:piece.position];
        // get the current position on the screen
        CGPoint objectScreenPosition = [self convertToNodeSpace:objectPostion];
        // if the left corner is off the screen
        if (objectScreenPosition.x <= (- 0.5 * piece.contentSize.width)) {
            // set another piece right after the fist (-1 to fill in any gaps)
            piece.position = ccp(piece.position.x + 2 * piece.contentSize.width - 1, piece.position.y);
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
        if (objectScreenPosition.x <= ( -1 * piece.contentSize.width)) {
            piece.position = ccp(piece.position.x + 2 * piece.contentSize.width - 1, piece.position.y);
        }
    }
}

#pragma MARK - GESTURE METHODS
- (void)swipeDown {
    if (!didPause) {
        CGFloat currentPos = _butterfly.position.y;
        CCLOG(@"The butterfly is at %f", currentPos);
        moveButterflyDown = true;
        CCLOG(@"User swiped down");
        // this was a tap on the butterfly, see where he is
        if(_butterfly.position.y > .6){ //3
            CCLOG(@"Butterfly is in the top, moving to middle");
            [audio playEffect:@"flap.mp3"];
            setPostion = .5;
        } else  if(_butterfly.position.y < .3){ //3
            CCLOG(@"Butterfly will stay at the bottom");
            moveButterflyDown = false;
        } else {
            CCLOG(@"Butterfly is in the middle, moving to bottom");
            setPostion = .22;
            [audio playEffect:@"flap.mp3"];
        }
        

    }
}

-(void) swipeUp {
    if (!didPause) {
        CGFloat currentPos = _butterfly.position.y;
        CCLOG(@"The butterfly is at %f", currentPos);
        //CCLOG(@"User Swiped up");
        moveButterflyUp = true;
        // this was a tap on the butterfly, see where he is
        if(_butterfly.position.y > .6){ //3
            CCLOG(@"Butterfly will stay at the top");
            [audio playEffect:@"bounce.mp3"];
            setPostion = .74;
            didBumpTop = TRUE;
            // NO movement needed
            moveButterflyUp = false;
        }else  if(_butterfly.position.y < .30){ //3
            CCLOG(@"Butterfly is in the bottom, moving to middle");
            setPostion = .5;
            [audio playEffect:@"flap.mp3"];
        } else {
            CCLOG(@"Butterfly is in the middle, moving to top");
            setPostion = .74;
            [audio playEffect:@"flap.mp3"];
        }

    }
}
/*
-(void) userTapped:(UITapGestureRecognizer *)recognizer {
    CCLOG(@"User tapped on screen");
    CGPoint touchLocation = [[CCDirector sharedDirector] convertToGL:[self convertToNodeSpace:[userTap locationInView:[[CCDirector sharedDirector] view]]]];
    if (CGRectContainsPoint([_reloadButton boundingBox], touchLocation)) {
       CCLOG(@"The reload button was touched");
         if (_reloadButton.visible) {
            [self reloadGame];
         }
    } else if (CGRectContainsPoint([_pauseButton boundingBox], touchLocation)) {
        CCLOG(@"The pause button was touched");
        if (_pauseButton.visible) {
            [self shouldPause];
        }
    }


}
*/
#pragma MARK - COLLISION METHODS
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair butterfly:(CCNode *)butterfly rock:(CCNode *)rock {
    // Prepare audio
    NSLog(@"The butterfly hit the rock");
    [audio playEffect:@"bounce.mp3"];
    return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair butterfly:(CCNode *)butterfly end:(CCNode *)end {
    CCLOG(@"user finished the level");
    didFinish = true;
    return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair butterfly:(CCNode *)butterfly spider:(CCNode *)spider {
    NSLog(@"The butterfly hit the spider");
    [audio playEffect:@"enemy.mp3"];
    // stop the annimation
    didDie = true;
    didFinish = true;
    return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair butterfly:(CCNode *)butterfly web:(CCNode *)web {
    NSLog(@"The butterfly hit the spider web");
    [audio playEffect:@"enemy.mp3"];
    // stop the annimation
    didDie = true;
    didFinish = true;
    return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair butterfly:(CCNode *)butterfly nectar:(CCNode *)nectar {
    // Play nectar drop
    [audio playEffect:@"drop.mp3"];
    CCLOG(@"butterfly hit a nectar");
    [nectar removeFromParent];
    return TRUE;
}

#pragma MARK - RESET GAME
-(void) reloadGame {
    audio.bgPaused = false;
    CCScene* scene = [CCBReader loadAsScene:@"GameScene"];
    [[CCDirector sharedDirector] replaceScene:scene];

}

-(void) shouldPause {
    CCLOG(@"User paused the game");
    // pause the physic node
    _gamePhysicNode.paused = true;
    didPause = true;
    // Display the pause layer
    _gamePauseNode.visible = true;
}

-(void) shouldExitFromPause {
    CCLOG(@"User wants to exit from game");
    // Return to main scene
    CCScene* scene = [CCBReader loadAsScene:@"MainScene"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}

-(void)shouldRestartFromPause {
    CCLOG(@"User wants to restart game");
    [self shouldResumeFromPause];
    [self reloadGame];
}

-(void) shouldResumeFromPause {
    CCLOG(@"User wants to resume  game");
    _gamePauseNode.visible = NO;
    didPause = false;
    _gamePhysicNode.paused = NO;
}

-(void) winShouldReload {
    CCLOG(@"User won, should reload game");
    _gameWinNode.visible = false;
    [self reloadGame];
}

-(void)winShouldExit {
    CCLOG(@"User won, and wants to exit");
    _gameWinNode.visible = false;
    [self shouldExitFromPause];
}

-(void)loseShouldReload {
     CCLOG(@"User lost, and wants to try again");
    _gameLoseNode.visible = false;
    [self reloadGame];
}

-(void)loseShouldExit {
     CCLOG(@"User lost, and wants to exit");
     [self shouldExitFromPause];
}

@end
