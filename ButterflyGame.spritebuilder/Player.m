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
        self.playerScores = [decoder decodeObjectForKey:@"playerScores"];
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
    [encoder encodeObject:self.playerScores forKey:@"playerScores"];
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
