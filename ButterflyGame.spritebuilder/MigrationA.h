//
//  MigrationA.h
//  ButterflyGame
//
//  Created by Angela Smith on 4/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "Player.h"

@interface MigrationA : CCNode


@property (nonatomic) NSInteger highestPlayableStop;
@property (nonatomic) NSInteger currentPlayableLevel;
@property (nonatomic, strong) NSMutableArray* levelsArray;
@property (nonatomic) BOOL unlockJourney;
@property (nonatomic) NSInteger totalScore;
@property (nonatomic) BOOL sessionThroughGameCenter;
@property (nonatomic, strong) Player* player;
@property (nonatomic, strong) NSMutableArray* playerArray;

@end
