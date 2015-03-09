//
//  Rock.m
//  ButterflyGame
//
//  Created by Angela Smith on 3/8/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Rock.h"

@implementation Rock

- (void)didLoadFromCCB {
    // prepare for a collision event
    self.physicsBody.collisionType = @"rock";
}

@end
