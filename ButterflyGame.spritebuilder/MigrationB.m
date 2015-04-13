//
//  MigrationB.m
//  ButterflyGame
//
//  Created by Angela Smith on 4/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "MigrationB.h"
#import "Constants.h"

@implementation MigrationB  {
    CCButton* _level1AButton;
    CCButton* _level1BButton;
    CCButton* _level1CButton;
    
    CCSpriteFrame* greenDot;
    CCSpriteFrame* redDot;
    CCSpriteFrame* orangeDot;
    CCSpriteFrame* grayDot;
    CCSpriteFrame* greenHLDot;
    CCSpriteFrame* redHLDot;
    CCSpriteFrame* orangeHLDot;
    CCSpriteFrame* grayHLDot;
    NSInteger selectedStop;
    NSArray* journeyStops;
    
}

- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    greenDot = [CCSpriteFrame frameWithImageNamed:jGreenDot];
    redDot = [CCSpriteFrame frameWithImageNamed:jRedDot];
    orangeDot = [CCSpriteFrame frameWithImageNamed:jOrangenDot];
    grayDot = [CCSpriteFrame frameWithImageNamed:jUnlocked];
    greenHLDot = [CCSpriteFrame frameWithImageNamed:jGreenHighlighted];
    redHLDot = [CCSpriteFrame frameWithImageNamed:jRedHighlighted];
    orangeHLDot = [CCSpriteFrame frameWithImageNamed:jOrangeHighlighted];
    grayHLDot = [CCSpriteFrame frameWithImageNamed:jUnlockedHighlighted];
    journeyStops = [[NSArray alloc] initWithObjects:_level1AButton, _level1BButton, _level1CButton, nil];
    // check if the user has a highest stop saved yet
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:mHighestJourneyAStopUnlocked]) {
        self.highestPlayableStop = [userDefaults integerForKey:mHighestJourneyAStopUnlocked];
    } else {
        // set the default
        [userDefaults setInteger:1 forKey:mHighestJourneyAStopUnlocked];
        self.highestPlayableStop = 1;
    }
}



-(void )selectedJourneyStop {
    for (CCButton* mapButton in journeyStops) {
        // get the button name
        NSString* bName = mapButton.name;
        // Get the last number value
        NSString* buttonNum = [bName substringFromIndex:[bName length] - 1];
        // convert to integer
        selectedStop = [buttonNum integerValue];
    }
}


-(void)shouldReturnToMap {
    // Return to the main map
    CCScene* scene = [CCBReader loadAsScene:@"Map"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
    
}

-(void)shouldPlaySelectedLevel {
    // Just load the same game
    CCScene* scene = [CCBReader loadAsScene:@"GameScene"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}

@end
