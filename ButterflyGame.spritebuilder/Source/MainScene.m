
// Angela Smith 3/4/1977

#import "MainScene.h"

@implementation MainScene

- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
}

- (void)play {
    CCScene* gameScene = [CCBReader loadAsScene:@"GamePlay"];
    [[CCDirector sharedDirector] replaceScene:gameScene];
}


@end
