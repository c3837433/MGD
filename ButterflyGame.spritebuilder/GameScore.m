//
//  GameScore.m
//  ButterflyGame
//
//  Created by Angela Smith on 4/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameScore.h"

@implementation GameScore


// Create a singleton instance
+ (instancetype)sharedGameData {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self loadInstance];
    });
    
    return sharedInstance;
}
// set up encoding
- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self != nil) {
        self.gamePlayer = [decoder decodeObjectForKey:@"gamePlayer"];
        self.gameScore = [decoder decodeIntegerForKey:@"gameScore"];
        self.gameStop = [decoder decodeIntegerForKey:@"gameStop"];
        self.gameJourney = [decoder decodeObjectForKey:@"gameJourney"];
       // self.gameLeaderboardName = [decoder decodeObjectForKey:@"gameLeaderboardName"];
        self.gameEnergy = [decoder decodeFloatForKey:@"gameEnergy"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.gamePlayer forKey:@"gamePlayer"];
    [encoder encodeInteger:self.gameScore forKey:@"gameScore"];
    [encoder encodeInteger:self.gameStop forKey:@"gameStop"];
    [encoder encodeObject:self.gameJourney forKey:@"gameJourney"];
   // [encoder encodeObject:self.gameLeaderboardName forKey:@"gameLeaderboardName"];
    [encoder encodeFloat:self.gameEnergy forKey:@"gameEnergy"];
}

// Check if there is a file of data
+(instancetype)loadInstance
{
    NSData* decodedData = [NSData dataWithContentsOfFile: [GameScore filePath]];
    if (decodedData) {
        // get that file
        GameScore* gameScoreData = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        return gameScoreData;
    }
    // Create a new file
    return [[GameScore alloc] init];
}

// Store the file
+(NSString*)filePath
{
    static NSString* filePath = nil;
    if (!filePath) {
        filePath =
        [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
         stringByAppendingPathComponent:@"gameScores"];
    }
    return filePath;
}

-(void)save
{
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject: self];
    [encodedData writeToFile:[GameScore filePath] atomically:YES];
}
@end
