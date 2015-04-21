//
//  Player.m
//  ButterflyGame
//
//  Created by Angela Smith on 4/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Player.h"

@implementation Player

// NSCoder protocol for custom objects to save to NSUser Defaults
- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self != nil) {
        self.playerName = [decoder decodeObjectForKey:@"playerName"];
        self.highestAStop = [decoder decodeIntegerForKey:@"highestAStop"];
        self.highestBStop = [decoder decodeIntegerForKey:@"highestBStop"];
        self.highestCStop = [decoder decodeIntegerForKey:@"highestCStop"];
        self.highestDStop = [decoder decodeIntegerForKey:@"highestDStop"];
        self.highestEStop = [decoder decodeIntegerForKey:@"highestEStop"];
        self.highestJourney = [decoder decodeIntegerForKey:@"highestJourney"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.playerName forKey:@"playerName"];
    [encoder encodeInteger:self.highestAStop forKey:@"highestAStop"];
    [encoder encodeInteger:self.highestBStop forKey:@"highestBStop"];
    [encoder encodeInteger:self.highestCStop forKey:@"highestCStop"];
    [encoder encodeInteger:self.highestDStop forKey:@"highestDStop"];
    [encoder encodeInteger:self.highestEStop forKey:@"highestEStop"];
    [encoder encodeInteger:self.highestJourney forKey:@"highestJourney"];
}

@end
