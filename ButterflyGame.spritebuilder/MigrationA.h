//
//  MigrationA.h
//  ButterflyGame
//
//  Created by Angela Smith on 4/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface MigrationA : CCNode


@property (nonatomic) NSInteger highestPlayableStop;
@property (nonatomic) NSInteger currentPlayableLevel;
@property (nonatomic, strong) NSMutableArray* levelsArray;
@property (nonatomic) BOOL unlockJourney;

@end