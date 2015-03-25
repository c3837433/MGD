//
//  Tutorial.m
//  ButterflyGame
//
//  Created by Angela Smith on 3/19/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Tutorial.h"

@implementation Tutorial {

    CCNode* _tutorialANode;
    CCNode* _tutorialBNode;

}


// Enable button presses
- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
}

-(void)shouldCloseTutorial {
    CCLOG(@"User done with tutorial, load game");
    // Start Game
    CCScene* scene = [CCBReader loadAsScene:@"GameScene"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];

}

-(void)shouldOpenNextScreen {
    CCLOG(@"Change nodes to display the second view in the tutorial");
    _tutorialANode.visible = false;
    _tutorialBNode.visible = true;
}

-(void) shouldReturnToMenu {
    // reopen the main menu
    CCScene* scene = [CCBReader loadAsScene:@"MainScene"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
    
}

@end
