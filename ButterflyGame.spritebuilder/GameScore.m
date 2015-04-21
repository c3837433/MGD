//
//  GameScore.m
//  ButterflyGame
//
//  Created by Angela Smith on 4/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameScore.h"

@implementation GameScore

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self != nil) {
        self.gamePlayerName = [decoder decodeObjectForKey:@"gamePlayerName"];
        self.gameScore = [decoder decodeIntegerForKey:@"gameScore"];
        self.gameStop = [decoder decodeIntegerForKey:@"gameStop"];
        self.gameJourney = [decoder decodeObjectForKey:@"gameJourney"];
        self.gameLeaderboardName = [decoder decodeObjectForKey:@"gameLeaderboardName"];
        self.gameEnergy = [decoder decodeFloatForKey:@"gameEnergy"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.gamePlayerName forKey:@"gamePlayerName"];
    [encoder encodeInteger:self.gameScore forKey:@"gameScore"];
    [encoder encodeInteger:self.gameStop forKey:@"gameStop"];
    [encoder encodeObject:self.gameJourney forKey:@"gameJourney"];
    [encoder encodeObject:self.gameLeaderboardName forKey:@"gameLeaderboardName"];
    [encoder encodeFloat:self.gameEnergy forKey:@"gameEnergy"];
}

@end
