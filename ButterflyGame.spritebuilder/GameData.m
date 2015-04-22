//
//  GameData.m
//  ButterflyGame
//
//  Created by Angela Smith on 4/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameData.h"

@implementation GameData

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
        self.gamePlayers = [decoder decodeObjectForKey:@"gamePlayers"];
        self.gameScores = [decoder decodeObjectForKey:@"gameScores"];
        self.gameCenterPlayer = [decoder decodeObjectForKey:@"gameCenterPlayer"];
        self.gameLocalPlayer = [decoder decodeObjectForKey:@"gameLocalPlayer"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.gamePlayers forKey:@"gamePlayers"];
    [encoder encodeObject:self.gameScores forKey:@"gameScores"];
    [encoder encodeObject:self.gameCenterPlayer forKey:@"gameCenterPlayer"];
    [encoder encodeObject:self.gameLocalPlayer forKey:@"gameLocalPlayer"];
}

+(instancetype)loadInstance {
    NSData* decodedData = [NSData dataWithContentsOfFile: [GameData filePath]];
    if (decodedData) {
        GameData* gameData = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        return gameData;
    }
    
    return [[GameData alloc] init];
}

+(NSString*)filePath {
    static NSString* filePath = nil;
    if (!filePath) {
        filePath =
        [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
         stringByAppendingPathComponent:@"gameData"];
    }
    return filePath;
}

-(void)save {
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject: self];
    [encodedData writeToFile:[GameData filePath] atomically:YES];
}

@end
