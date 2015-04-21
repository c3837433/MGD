//
//  GamePlayer.m
//  ButterflyGame
//
//  Created by Angela Smith on 4/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GamePlayer.h"
#import <Parse/PFObject+Subclass.h>

@implementation GamePlayer
@dynamic gamePlayerName, highestAStop, highestBStop, highestCStop, highestDStop, highestEStop, highestJourney;
/*
+ (void)load {
    [self registerSubclass];
} */

+ (NSString *)parseClassName {
    return @"GamePlayer";
}
@end
