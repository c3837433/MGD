//
//  Utility.m
//  ButterflyGame
//
//  Created by Angela Smith on 4/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Utility.h"
#import "GameScene.h"
#import "Constants.h"

@implementation Utility

#pragma mark - BUTTON METHODS
+ (void) setButtonImage:(CCButton*)button forEnergy:(CGFloat)energy {

    NSLog(@"selected stop energy level: %f", energy);
    if (energy > .5) {
        // green image
        NSLog(@"button should be green");
        [button setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:jGreenDot] forState:CCControlStateNormal];
        [button setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:jGreenHighlighted] forState:CCControlStateHighlighted];
        [button setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:jGreenHighlighted] forState:CCControlStateSelected];
    } else if (energy > .3) {
        // orange image
        NSLog(@"button should be orange");
        [button setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:jOrangenDot] forState:CCControlStateNormal];
        [button setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:jOrangeHighlighted] forState:CCControlStateHighlighted];
        [button setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:jOrangeHighlighted] forState:CCControlStateSelected];
    } else if (energy > 0) {
        // red
        NSLog(@"button should be red");
        [button setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:jRedDot] forState:CCControlStateNormal];
        [button setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:jRedHighlighted] forState:CCControlStateHighlighted];
        [button setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:jRedHighlighted] forState:CCControlStateSelected];
    } else {
        // dark grey
        NSLog(@"button should be grey");
        [button setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:jUnlocked] forState:CCControlStateNormal];
        [button setBackgroundSpriteFrame: [CCSpriteFrame frameWithImageNamed:jUnlockedHighlighted] forState:CCControlStateHighlighted];
        [button setBackgroundSpriteFrame: [CCSpriteFrame frameWithImageNamed:jUnlockedHighlighted] forState:CCControlStateSelected];
    }
    [button setSelected:true];
    
}


+ (void) setActiveButtons:(NSArray*)buttonArray withHighestStop:(NSInteger) highestStop {
    // Create an array of all the journey nodes
    for (CCButton* button in buttonArray) {
        // get the button name
        NSString* buttonName = button.name;
        // Get the last number value
        NSString* buttonNum = [buttonName substringFromIndex:[buttonName length] - 1];
        // convert to integer
        NSInteger buttonInt = [buttonNum integerValue];
        // if this is higher than the current hghest level, hide it
        if (buttonInt <= highestStop) {
            [button setVisible:true];
            button.userInteractionEnabled = true;
            [button setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:jUnlocked] forState:CCControlStateNormal];
            [button setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:jUnlockedHighlighted] forState:CCControlStateHighlighted];
            [button setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:jUnlockedHighlighted] forState:CCControlStateSelected];
        }
    }
}


+ (void)shouldReturnToMap  {
    // Return to the main map
    CCScene* scene = [CCBReader loadAsScene:@"Map"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
    
}

+(void)shouldPlaySelectedLevelWithStop:(NSInteger)selectedStop andHighestStop:(NSInteger)highestStop forJourney:(NSString*)journey {
    // Just load the same game
    CCScene* scene = [CCBReader loadAsScene:@"GameScene"];
    GameScene* gameScene = [[scene children] firstObject];
    gameScene.currentStop = selectedStop;
    //NSLog(@"Selected stop: %ld", (long)selectedStop);
    //NSLog(@"Hichest stop: %ld", (long)self.highestPlayableStop);
    if (selectedStop == highestStop) {
        gameScene.forUnlock = YES;
        NSLog(@"This is for unlocking");
    }
    gameScene.currentJourney = journey;
    
    [[CCDirector sharedDirector] replaceScene:scene];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}

@end
