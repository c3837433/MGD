//
//  GamePlay.m
//  ButterflyGame
//
//  Created by Angela Smith on 3/4/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GamePlay.h"


@implementation GamePlay {
    // Set up the tappable sprites
    CCSprite* _spider;
    CCSprite* _rock;
    CCSprite* _nectar;
    CCSprite* _butterfly;
    CGFloat setPostion;
    BOOL moveButterflyUp;
    BOOL moveButterflyDown;
    CGPoint startPosition;
}


- (void)didLoadFromCCB {
    // start listening for user taps
    self.userInteractionEnabled = TRUE;
    
    UISwipeGestureRecognizer* swipeUp= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeUp];
    // listen for swipes down
    UISwipeGestureRecognizer* swipeDown= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeDown];
    
}

#pragma mark - USER TOUCH LISTENER

// When the user touches the screen
-(void) touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    // CCLOG(@"User tapped the screen");
    // Prepare audio
    //  OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    /*
     // this was a tap on the butterfly, see where he is
     if(_butterfly.position.y > 90){ //3
     CCLOG(@"Butterfly is in the top");
     // NO movement needed
     setPostion = 131;
     }else  if(_butterfly.position.y < 80){ //3
     CCLOG(@"Butterfly is in the bottom");
     setPostion = 83;
     } else {
     CCLOG(@"Butterfly is in the middle");
     setPostion = 131;
     }*/
    /*
     // Get the location of the touch
     CGPoint touchLocation = [touch locationInNode:self];
     // If the user tapped the butterfly, we need to see if we need to move him up
     if (CGRectContainsPoint([_butterfly boundingBox], touchLocation)) {
     moveButterflyUp = true;
     
     }*/
    /*
     // If the user touched within on of the audio sprites, play their specific sound effect
     if (CGRectContainsPoint([_spider boundingBox], touchLocation)) {
     CCLOG(@"The spider was touched");
     [audio playEffect:@"enemy.mp3"];
     } else if (CGRectContainsPoint([_rock boundingBox], touchLocation)) {
     CCLOG(@"The rock was touched");
     [audio playEffect:@"bounce.mp3"];
     } else if (CGRectContainsPoint([_nectar boundingBox], touchLocation)) {
     CCLOG(@"The nectar was touched");
     [audio playEffect:@"drop.mp3"];
     }*/
}

- (void)swipeDown {
    moveButterflyDown = true;
    CCLOG(@"User swiped down");
    // get the butterfly's current position
    // this was a tap on the butterfly, see where he is
    if(_butterfly.position.y > 90){ //3
        CCLOG(@"Butterfly is in the top");
        // NO movement needed
        setPostion = 83;
    } else  if(_butterfly.position.y < 35){ //3
        CCLOG(@"Butterfly is in the bottom");
       moveButterflyDown = false;
    } else {
        CCLOG(@"Butterfly is in the middle");
        setPostion = 35;
    }
}

-(void) swipeUp {
    CCLOG(@"User Swiped up");
    moveButterflyUp = true;
    // this was a tap on the butterfly, see where he is
    if(_butterfly.position.y > 90){ //3
        CCLOG(@"Butterfly is in the top");
        // NO movement needed
        moveButterflyUp = false;
    }else  if(_butterfly.position.y < 80){ //3
        CCLOG(@"Butterfly is in the bottom");
        setPostion = 83;
    } else {
        CCLOG(@"Butterfly is in the middle");
        setPostion = 131;
    }
}

- (void)update:(CCTime)delta {
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




@end
