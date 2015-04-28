//
//  Player.m
//  ButterflyGame
//
//  Created by Angela Smith on 4/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Player.h"

@implementation Player

// Create a singleton instance
+ (instancetype)sharedGameData {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self loadInstance];
    });
    
    return sharedInstance;
}

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
        self.gameCenterPlayer = [decoder decodeBoolForKey:@"gameCenterPlayer"];
        // Achievements
        self.completedUnlock = [decoder decodeBoolForKey:@"completedUnlock"];
        self.completedDeath = [decoder decodeBoolForKey:@"completedDeath"];
        self.completedJourney1 = [decoder decodeBoolForKey:@"completedJourney1"];
        self.completedJourney2 = [decoder decodeBoolForKey:@"completedJourney2"];
        self.completedJourney3 = [decoder decodeBoolForKey:@"completedJourney3"];
        self.completedJOurney4 = [decoder decodeBoolForKey:@"completedJOurney4"];
        self.completedJourney5 = [decoder decodeBoolForKey:@"completedJourney5"];
        self.completedNectar10 = [decoder decodeBoolForKey:@"completedNectar10"];
        self.completedNectar50 = [decoder decodeBoolForKey:@"completedNectar50"];
        self.completedNectar100 = [decoder decodeBoolForKey:@"completedNectar100"];
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
    [encoder encodeBool:self.gameCenterPlayer forKey:@"gameCenterPlayer"];
    // Achievements
    [encoder encodeBool:self.completedUnlock forKey:@"completedUnlock"];
    [encoder encodeBool:self.completedDeath forKey:@"completedDeath"];
    [encoder encodeBool:self.completedJourney1 forKey:@"completedJourney1"];
    [encoder encodeBool:self.completedJourney2 forKey:@"completedJourney2"];
    [encoder encodeBool:self.completedJourney3 forKey:@"completedJourney3"];
    [encoder encodeBool:self.completedJOurney4 forKey:@"completedJOurney4"];
    [encoder encodeBool:self.completedJourney5 forKey:@"completedJourney5"];
    [encoder encodeBool:self.completedNectar10 forKey:@"completedNectar10"];
    [encoder encodeBool:self.completedNectar50 forKey:@"completedNectar50"];
    [encoder encodeBool:self.completedNectar100 forKey:@"completedNectar100"];
}

+(instancetype)loadInstance {
    NSData* decodedData = [NSData dataWithContentsOfFile: [Player filePath]];
    if (decodedData) {
        Player* playerData = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        return playerData;
    }
    
    return [[Player alloc] init];
}

+(NSString*)filePath {
    static NSString* filePath = nil;
    if (!filePath) {
        filePath =
        [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
         stringByAppendingPathComponent:@"playerData"];
    }
    return filePath;
}

-(void)save {
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject: self];
    [encodedData writeToFile:[Player filePath] atomically:YES];
}
@end
