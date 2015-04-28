//
//  Player.h
//  ButterflyGame
//
//  Created by Angela Smith on 4/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject  <NSCoding>

@property (nonatomic, strong) NSString* playerName;
@property (nonatomic) NSInteger highestJourney;
@property (nonatomic) NSInteger highestAStop;
@property (nonatomic) NSInteger highestBStop;
@property (nonatomic) NSInteger highestCStop;
@property (nonatomic) NSInteger highestDStop;
@property (nonatomic) NSInteger highestEStop;
@property (nonatomic, assign) BOOL gameCenterPlayer;
@property (nonatomic) NSInteger numberOfSpiderDeaths;
@property (nonatomic) NSInteger numberOfNectarGathered;
//@property (nonatomic, strong) NSMutableArray* playerScores;

// Player Achievements
@property (nonatomic, assign) BOOL completedUnlock;
@property (nonatomic, assign) BOOL completedNectar10;
@property (nonatomic, assign) BOOL completedNectar50;
@property (nonatomic, assign) BOOL completedNectar100;
@property (nonatomic, assign) BOOL completedJourney1;
@property (nonatomic, assign) BOOL completedJourney2;
@property (nonatomic, assign) BOOL completedJourney3;
@property (nonatomic, assign) BOOL completedJOurney4;
@property (nonatomic, assign) BOOL completedJourney5;
@property (nonatomic, assign) BOOL completedDeath;

-(void)save;
+ (instancetype)sharedGameData;
@end
