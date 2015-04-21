//
//  Score.m
//  ButterflyGame
//
//  Created by Angela Smith on 4/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Score.h"
#import <Parse/PFObject+Subclass.h>

@implementation Score

@dynamic scoreEnergy, scoreJourney, stopHighScore, gamePlayer, scoreStop;
/*
+ (void)load {
    [self registerSubclass];
}
*/
+ (NSString *)parseClassName {
    return @"Score";
}

@end
