//
//  JourneyA.m
//  ButterflyGame
//
//  Created by Angela Smith on 3/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "JourneyA.h"

@implementation JourneyA {
    CCButton* _level1AButton;
    CCButton* _level1BButton;
    CCButton* _level1CButton;
    
    CCSpriteFrame* greenDot;
    CCSpriteFrame* redDot;
    CCSpriteFrame* orangeDot;
    CCSpriteFrame* grayDot;

}


- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    greenDot = [CCSpriteFrame frameWithImageNamed:@"mapAssets/bigGreenDot.png"];
    redDot = [CCSpriteFrame frameWithImageNamed:@"mapAssets/bigRedDot.png"];
    orangeDot = [CCSpriteFrame frameWithImageNamed:@"mapAssets/bigOrangeDot.png"];
    grayDot = [CCSpriteFrame frameWithImageNamed:@"mapAssets/greyDot.png"];
}



-(void )shouldPlayFirstLevel {
    NSLog(@"User tapped first button");
    [_level1AButton setBackgroundSpriteFrame:greenDot forState:CCControlStateNormal];
}

// Journey level actions
-(void) shouldPlaySecondLevel {
    NSLog(@"User tapped second button");
    [_level1BButton setBackgroundSpriteFrame:redDot forState:CCControlStateNormal];

}

-(void) shouldPlayThirdLevel {
    NSLog(@"User tapped third button");
    [_level1CButton setBackgroundSpriteFrame:orangeDot forState:CCControlStateNormal];

}

@end
