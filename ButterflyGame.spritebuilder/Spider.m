//
//  Spider.m
//  ButterflyGame
//
//  Created by Angela Smith on 3/9/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Spider.h"

@implementation Spider


- (void)didLoadFromCCB {
    // prepare for a collision event
    self.physicsBody.collisionType = @"spider";
}


@end
