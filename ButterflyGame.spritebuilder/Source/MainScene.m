
//  ButterflyGame
//
//  Created by Angela Smith on 3/4/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene {

    CCSprite* _mainButterfly;
    CCAnimationManager* animationManager;

}

//Once the game file loads, allow user interaction so the player can view the game scene
- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    animationManager = _mainButterfly.animationManager;
    [animationManager runAnimationsForSequenceNamed:@"FlapFacing"];
    // Preload the music
    //[[OALSimpleAudio sharedInstance] preloadBg:@"background_music.mp3"];
}

// When the user presses the play button
- (void) startGame {
    
    [animationManager setPaused:YES];
    // Switch to the game scene
  //  CCScene* scene = [CCBReader loadAsScene:@"GameScene"];
    CCScene* scene = [CCBReader loadAsScene:@"Map"];
    
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}

-(void)shouldStartTutorial {
    [animationManager setPaused:YES];
    // Switch to the game scene
    CCScene* scene = [CCBReader loadAsScene:@"Tutorial"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];


}

-(void) shouldOpenCredits {
    [animationManager setPaused:YES];
    // Switch to the game scene
    CCScene* scene = [CCBReader loadAsScene:@"Credits"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];

}


@end
