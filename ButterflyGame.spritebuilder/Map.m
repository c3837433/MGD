//
//  Map.m
//  ButterflyGame
//
//  Created by Angela Smith on 3/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Map.h"

@implementation Map {
    BOOL shouldZoom;
    CCNode* _journeyA;
    CCNode* _mainNode;
    BOOL isZooming;
    CCButton* _JourneyAButton;
    CGPoint nodePostion;
    CCNode* _firstNode;
    CCNode* _mapNode;
}



- (void)didLoadFromCCB {
    shouldZoom = false;
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
}

-(void) touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    nodePostion = [touch locationInNode:_mapNode];
    nodePostion = [_mapNode convertToNodeSpace:nodePostion];

    CCLOG(@"User touched position x: %f y: %f", nodePostion.x, nodePostion.y);
    CCLOG(@"Map position position x%f y:%f", _mapNode.position.x, _mapNode.position.y);
    
    if (CGRectContainsPoint([_firstNode boundingBox], nodePostion)){
        CCLOG(@"User tapped first journey");
        CCActionScaleTo* scale = [CCActionScaleTo actionWithDuration:0.7f scale:3.0f];
        CGPoint posDifference = { 1.0 - _firstNode.position.x + 0.45, 1.0 - _firstNode.position.y - 0.35};
        //CGPoint posDifference = { 0.201, 0.788};
        //CGPoint posDifference = ccpSub(pos, nodePostion); 20.1, 73.8
        CCLOG(@"First Node position x: %f y: %f", _firstNode.position.x, _firstNode.position.y);

        CCAction* move = [CCActionMoveTo actionWithDuration:0.7 position:posDifference];
        [_mapNode runAction:scale];
        CCActionSequence *sequence = [CCActionSequence actionWithArray:@[move, [CCActionCallFunc actionWithTarget:self selector:@selector(shouldStartFirstJourney)]]];
        // run the sequence
        [_mapNode runAction:sequence];
    }

}


- (void)shouldStartFirstJourney {
    //runAction(CCOrbitCamera::actionWithDuration(1.0f, 1, 0, 270, 90, 90, 0)); in your scene
    CCScene* scene = [CCBReader loadAsScene:@"JourneyA"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}

- (void)shouldStartSecondJourney {
    //  check the location
    CCScene* scene = [CCBReader loadAsScene:@"JourneyA"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}
- (void)shouldStartThirdJourney {
    //  check the location
    CCScene* scene = [CCBReader loadAsScene:@"JourneyA"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}

- (void)shouldStartFourthJourney {
    //  check the location
    CCScene* scene = [CCBReader loadAsScene:@"JourneyA"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}

- (void)shouldStartFifthJourney {
    //  check the location
    CCScene* scene = [CCBReader loadAsScene:@"JourneyA"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}

-(void) update:(CCTime)delta {
    
}



@end
