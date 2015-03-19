//
//  GameScene.m
//  ButterflyGame
//
//  Created by Angela Smith on 3/8/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameScene.h"
#import <CoreMotion/CoreMotion.h>

// Standard scroll speed
static const CGFloat scrollSpeed = 80.f;

@implementation GameScene {
    
    // Butterfly movement and position
    CGFloat setPostion;
    CGFloat dropsGathered;
    CGFloat timeElapsed;
    
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
    BOOL nectarWarningRunning;
    
    CCNode* _levelNode;
    CCNode* _gamePauseNode;
    CCNode* _gameWinNode;
    CCNode* _gameLoseNode;
    
    OALSimpleAudio* audio;

    CCButton* _pauseButton;
    
    // Health Bar
    CCNodeColor* _healthColorBar;
    CCNode* _healthNectar;
    CGFloat currentEnergy;
    
    CCLabelTTF* _winScoreLabel;
    
    // Create an instance of the core motion manager
    CMMotionManager* motionManager;

}

- (void)didLoadFromCCB {
    CCLOG(@"Loaded Game");
    
    [self preloadMusic];
    // preset conditionals for frame updates
    didFinish = false;
    didLand = false;
    didDie = false;
    didBumpTop = false;
    didPause = false;
    nectarWarningRunning = false;
    dropsGathered = 0;
    timeElapsed = 0;
    
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
    // Listen for swipes right for dash
    UISwipeGestureRecognizer* swipeRight= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeRight];
    
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
    
    currentEnergy = 1;
    
    // COLLISION DELEGATE
    _gamePhysicNode.collisionDelegate = self;
    
    // set the buttergly colistion type and drawing order
    _butterfly.physicsBody.collisionType = @"butterfly";
    _butterfly.zOrder = DrawingOrdeButterfly;
    
    // set the butterfly to start animatting
    [self LaunchButterfly];
    
    // set Health bar
    CCAnimationManager* animationManager = _healthNectar.animationManager;
    [animationManager runAnimationsForSequenceNamed:@"HealthBar"];
    
    // set up the accelerometer
    motionManager = [[CMMotionManager alloc] init];
}
- (void)onEnter
{
    [super onEnter];
    
    [motionManager startAccelerometerUpdates];
}

// PRELOAD MUSIC
-(void) preloadMusic {
    // get audio ready
    audio = [OALSimpleAudio sharedInstance];
    // Preload the music
    [audio  preloadBg:@"background_music.mp3"];
    [audio preloadEffect:@"loseGame.mp3"];
    [audio preloadEffect:@"yahoo.mp3"];
    [audio preloadEffect:@"flap.mp3"];
    [audio preloadEffect:@"bounce.mp3"];
    [audio preloadEffect:@"drop.mp3"];
    [audio preloadEffect:@"enemy.mp3"];
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
    _pauseButton.visible = true;

    //IF YOU WANT BACKGROUND MUSIC PLAYING
    //[audio playBg:@"background_music.mp3"];
}

#pragma MARK - FRAME UPDATES
    - (void)update:(CCTime)delta {
        // CHECK IF THE USER IS STILL PLAYING
        if (didPause) {
            audio.bgPaused = TRUE;
            [motionManager stopAccelerometerUpdates];

        } else  if (!didFinish) {
            timeElapsed = timeElapsed + delta;
           // CCLOG(@"Time elapsed: %f", timeElapsed);

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
                // get the accelerometer data
                CMAccelerometerData* data = motionManager.accelerometerData;
                CMAcceleration acceleration = data.acceleration;
                // move the butterfly up as the device is rotated forward, and set its reverse
                CGFloat yPos = _butterfly.position.y - acceleration.x * 5 * delta;
                // make sure it stays within the floor/ceiling boundries
                yPos = clampf(yPos, .19, .79);
                // set speed based on position
               if (_butterfly.position.x < 600) {
                    // give it a little boost
                   _butterfly.position = ccp(_butterfly.position.x + delta * scrollSpeed + 0.1, yPos);
                } else {
                    // normal speed
                    _butterfly.position = ccp(_butterfly.position.x + delta * scrollSpeed, yPos);
                }
                
                CCAnimationManager* animationManager = _healthNectar.animationManager;
                // update the health bar
               // Reduce the health bar
                //CCLOG(@"Health bar scale x = %f", _healthColorBar.scaleX);
                [_healthColorBar setScaleX:_healthColorBar.scaleX - .0015];
                currentEnergy = _healthColorBar.scaleX;
                if (currentEnergy < 0.5) {
                    // change the color
                    if (currentEnergy < 0.3) {
                        // Red color
                        _healthColorBar.color = [CCColor colorWithRed:0.89 green:0.22 blue:0.18 alpha:1];
                        if (!nectarWarningRunning) {
                            // if the warning is not running, start it
                            [animationManager runAnimationsForSequenceNamed:@"LowNectar"];
                            nectarWarningRunning = true;
                        }


                    } else {
                        // Orange/yellow color
                        _healthColorBar.color = [CCColor colorWithRed:0.99 green:0.64 blue:0.26 alpha:1];
                        if (nectarWarningRunning) {
                            // stop it
                            [animationManager paused];
                            nectarWarningRunning = false;
                            [animationManager runAnimationsForSequenceNamed:@"HealthBar"];
                        }
                    }
                } else {
                    // Green color
                    _healthColorBar.color = [CCColor colorWithRed:0.27 green:0.68 blue:0.13 alpha:1];
                }

            }
            
            if (currentEnergy <= 0) {
                didDie = YES;
                didFinish = YES;
                _pauseButton.visible = NO;
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
            
            // WHEN BUTTERFLY FALLS BEHIND LEFT VIEW AREA
            // make sure the butterfly did not leave the screen by checking it's position in the world
            CGPoint objectPostion = [_gamePhysicNode convertToWorldSpace:_butterfly.position];
            // If the x is less than -50 it has completely disappeared off screen
            if (objectPostion.x < -50) {
                CCLOG(@"Butterfly is off screen");
                didDie = YES;
                didFinish = YES;
                _pauseButton.visible = false;
            }

            
        } else {
              // THE GAME HAS ENDED FROM WIN OR LOSS
            if (didDie) {
                // make sure the accelerometer stops
                [motionManager stopAccelerometerUpdates];
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
                    CCLOG(@"You win!");
                    didLand = true;
                    [audio playEffect:@"yahoo.mp3"];
                    _pauseButton.visible = false;
                    // change the animation
                    [animationManager runAnimationsForSequenceNamed:@"FlapFacing"];
                    // update the label with a score
                    float updateForTime = 1;
                    int totalScore = timeElapsed * (dropsGathered * 8);
                    CCLOG(@"Total Score: %d", totalScore);
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        for (int i = 1; i < totalScore; i ++) {
                            //increment the count
                            usleep(updateForTime/100 * 10000);
                            dispatch_async(dispatch_get_main_queue(), ^{
                                // update the score
                                _winScoreLabel.string = [NSString stringWithFormat:@"Score %d", i];
                            });
                        }
                    });
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

-(void)swipeRight {
    // make sure we are not done
    if ((!didPause) && (!didFinish)) {
        CGPoint currentPosition = [_gamePhysicNode convertToWorldSpace:_butterfly.position];
        //CCLOG(@"Current dash position : %f", currentPosition.x);
        CCAnimationManager* animationManager = _butterfly.animationManager;
        [animationManager runAnimationsForSequenceNamed:@"BoostFlap"];
        // If the butterfly is not past the dash level
        CGFloat currentXPos = (currentPosition.x < 400) ? _butterfly.position.x + 60 : _butterfly.position.x;
        // set the end dash position
        CGPoint dashPos = { currentXPos, setPostion};
        // start rotating the butterfly slightly
        CCActionRotateBy* rotate = [CCActionRotateBy actionWithDuration:.2 angle:35];
        // move to position
        CCActionMoveTo*  moveTo = [CCActionMoveTo actionWithDuration:.4 position:dashPos];
        // return the butterfly to it's original angle
        CCActionRotateBy* rotateBack = [CCActionRotateBy actionWithDuration:.2 angle:-35];
        // prepare the sequence with the callback
        CCActionSequence *sequence = [CCActionSequence actionWithArray:@[rotate, moveTo, rotateBack, [CCActionCallFunc actionWithTarget:self selector:@selector(finishedDashSequence)]]];
        // run the sequence
        [_butterfly runAction:sequence];
        // reduce the energy bar
        if (_healthColorBar.scaleX - .04 < 0) {
            // if it would be more than the current, set to full
            _healthColorBar.scaleX = 0;
        } else {
            // otherwise add to the bar
            [_healthColorBar setScaleX:_healthColorBar.scaleX - .04];
        }
    }
}

// WHEN DASH SEQUENCE IS COMPLETE
-(void)finishedDashSequence{
    CCAnimationManager* animationManager = _butterfly.animationManager;
    // stop the fast flying
    [animationManager runAnimationsForSequenceNamed:@"FlyButterfly"];
}

#pragma MARK - COLLISION METHODS
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair butterfly:(CCNode *)butterfly rock:(CCNode *)rock {

    // Play audio
    [audio playEffect:@"bounce.mp3"];

    CCParticleSystem* rockDust = (CCParticleSystem *)[CCBReader load:@"BumpDust"];
    rockDust.autoRemoveOnFinish = TRUE;
    // set dust off the rock
    rockDust.position = rock.position;
    // add the effect to the rock parent node
    [rock.parent addChild:rockDust];
    return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair butterfly:(CCNode *)butterfly end:(CCNode *)end {
    CCLOG(@"user finished the level");
    didFinish = true;
    _pauseButton.visible = false;
    return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair butterfly:(CCNode *)butterfly spider:(CCNode *)spider {
    NSLog(@"The butterfly hit the spider");
    [audio playEffect:@"enemy.mp3"];
    // stop the annimation
    didDie = true;
    didFinish = true;
    _pauseButton.visible = false;
    return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair butterfly:(CCNode *)butterfly web:(CCNode *)web {
    NSLog(@"The butterfly hit the spider web");
    [audio playEffect:@"enemy.mp3"];
    // stop the annimation
    didDie = true;
    didFinish = true;
    _pauseButton.visible = false;
    return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair butterfly:(CCNode *)butterfly nectar:(CCNode *)nectar {
    //CCLOG(@"butterfly hit a nectar");
    dropsGathered = dropsGathered + 1;
    // run the nectar disappear annimation
    CCAnimationManager* animationManager = nectar.animationManager;
    [animationManager setCompletedAnimationCallbackBlock:^(id sender) {
        // Once done, remove the nectar drop
        [nectar removeFromParent];
        [audio playEffect:@"drop.mp3"];
        // increase the health bar
        if (_healthColorBar.scaleX + .14 > 1) {
            // if it would be more than the current, set to full
            _healthColorBar.scaleX = 1;
        } else {
            // otherwise add to the bar
              [_healthColorBar setScaleX:_healthColorBar.scaleX + .14];
        }
        
    }];
    [animationManager runAnimationsForSequenceNamed:@"NectarSpriteSheetAnnimation"];
    return TRUE;
}

#pragma MARK - RESET GAME
-(void) reloadGame {
    // pause the music
    audio.bgPaused = false;
    // reload the scene
    CCScene* scene = [CCBReader loadAsScene:@"GameScene"];
    [[CCDirector sharedDirector] replaceScene:scene];

}

#pragma  mark - PAUSE MENU METHODS
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
    // pause game layer
    [self shouldResumeFromPause];
    // restart game
    [self reloadGame];
}

-(void) shouldResumeFromPause {
    CCLOG(@"User wants to resume  game");
    // show the pause menu
    _gamePauseNode.visible = NO;
    didPause = false;
    // pause the physics layer
    _gamePhysicNode.paused = NO;
}

#pragma  mark - WIN / LOSS MENU METHODS
-(void) winShouldReload {
    CCLOG(@"User won, should reload game");
    // hide the win layer and reload the game
    _gameWinNode.visible = false;
    [self reloadGame];
}

-(void)winShouldExit {
    CCLOG(@"User won, and wants to exit");
    // hid the win layer and move back to the main view
    _gameWinNode.visible = false;
    [self shouldExitFromPause];
}

-(void)loseShouldReload {
     CCLOG(@"User lost, and wants to try again");
    // hide the lose layer and reload
    _gameLoseNode.visible = false;
    [self reloadGame];
}

-(void)loseShouldExit {
     CCLOG(@"User lost, and wants to exit");
    // return to the main
     [self shouldExitFromPause];
}


@end
