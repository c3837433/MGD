
//  ButterflyGame
//
//  Created by Angela Smith on 3/4/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene

//Once the game file loads, allow user interaction so the player can view the game scene
- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
}

// When the user presses the play button
- (void) startGame {
    // Load the GamePlay scene
    //CCScene* gameScene = [CCBReader loadAsScene:@"GamePlay"];
    //[[CCDirector sharedDirector] replaceScene:gameScene];
    CCScene* scene = [CCBReader loadAsScene:@"GameScene"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}


@end
