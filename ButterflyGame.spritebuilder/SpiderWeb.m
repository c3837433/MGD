//
//  SpiderWeb.m
//  ButterflyGame
//
//  Created by Angela Smith on 3/9/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "SpiderWeb.h"

@implementation SpiderWeb


- (void)didLoadFromCCB {
    // prepare for a collision event
    self.physicsBody.collisionType = @"web";
}

@end
