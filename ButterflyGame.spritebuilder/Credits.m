//
//  Credits.m
//  ButterflyGame
//
//  Created by Angela Smith on 3/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Credits.h"

@implementation Credits



- (void)didLoadFromCCB {
    // listen for touches
    self.userInteractionEnabled = TRUE;
}

-(void) shouldReturnToMenu {
    // return to the main menu
    CCScene* scene = [CCBReader loadAsScene:@"MainScene"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];

}

@end
