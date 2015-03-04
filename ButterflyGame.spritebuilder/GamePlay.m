//
//  GamePlay.m
//  ButterflyGame
//
//  Created by Angela Smith on 3/4/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GamePlay.h"


@implementation GamePlay {

    CCSprite* _spider;
    CCSprite* _rock;
    CCSprite* _butterfly;
    CCSprite* _nectar;
}

- (void)didLoadFromCCB {
    // start listening for taps
    self.userInteractionEnabled = TRUE;

}

// called on every touch in this scene
-(void) touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CCLOG(@"User tapped the screen");
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    CGPoint touchLocation = [touch locationInNode:self];
    if (CGRectContainsPoint([_spider boundingBox], touchLocation)) {
       CCLOG(@"The spider was touched");
        // play sound effect
        [audio playEffect:@"enemy.mp3"];
    } else if (CGRectContainsPoint([_rock boundingBox], touchLocation)) {
        CCLOG(@"The rock was touched");
        // play sound effect
        [audio playEffect:@"bounce.mp3"];
    } else if (CGRectContainsPoint([_butterfly boundingBox], touchLocation)) {
        CCLOG(@"The butterfly was touched");
    } else if (CGRectContainsPoint([_nectar boundingBox], touchLocation)) {
        CCLOG(@"The nectar was touched");
        // play sound effect
        [audio playEffect:@"drop.mp3"];
    }
}



@end
