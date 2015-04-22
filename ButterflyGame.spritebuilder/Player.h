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
//@property (nonatomic, strong) NSMutableArray* playerScores;
-(void)save;
+ (instancetype)sharedGameData;
@end
