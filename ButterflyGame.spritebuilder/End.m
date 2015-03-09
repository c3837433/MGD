//
//  End.m
//  ButterflyGame
//
//  Created by Angela Smith on 3/9/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "End.h"

@implementation End

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"end";
    self.physicsBody.sensor = TRUE;
}

@end
