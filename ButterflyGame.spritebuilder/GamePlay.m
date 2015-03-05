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
}

- (void)didLoadFromCCB {
    // start listening for user taps
    self.userInteractionEnabled = TRUE;

}

#pragma mark - USER TOUCH LISTENER
// When the user touches the screen
-(void) touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CCLOG(@"User tapped the screen");
    // Prepare audio
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    
    // Get the location of the touch
    CGPoint touchLocation = [touch locationInNode:self];
    
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
    }
}



@end
