//
//  LeaderboardPosition.m
//  ButterflyGame
//
//  Created by Angela Smith on 4/17/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "LeaderboardPosition.h"

@implementation LeaderboardPosition


// NSCoder protocol for custom objects to save to NSUser Defaults
- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self != nil) {
    
    self.leaderName = [decoder decodeObjectForKey:@"leaderName"];
    self.leaderScore = [decoder decodeObjectForKey:@"leaderScore"];
    self.leaderScoreValue = [decoder decodeIntegerForKey:@"leaderScoreValue"];
    self.leaderBoardStop = [decoder decodeObjectForKey:@"leaderBoardStop"];
    self.leaderboardName = [decoder decodeObjectForKey:@"leaderboardName"];
    self.leaderboardRank = [decoder decodeObjectForKey:@"leaderboardRank"];
    self.leaderIsCurrentUser = [decoder decodeBoolForKey:@"leaderIsCurrentUser"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.leaderName forKey:@"leaderName"];
    [encoder encodeObject:self.leaderScore forKey:@"leaderScore"];
    [encoder encodeInteger:self.leaderScoreValue forKey:@"leaderScoreValue"];
    [encoder encodeObject:self.leaderBoardStop forKey:@"leaderBoardStop"];
    [encoder encodeObject:self.leaderboardName forKey:@"leaderboardName"];
    [encoder encodeObject:self.leaderboardRank forKey:@"leaderboardRank"];
}

@end
