//
//  Nectar.m
//  ButterflyGame
//
//  Created by Angela Smith on 3/9/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Nectar.h"

@implementation Nectar


- (void)didLoadFromCCB {
    // prepare for a collision event
    self.physicsBody.collisionType = @"nectar";
}

@end
