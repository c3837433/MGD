//
//  GameData.h
//  ButterflyGame
//
//  Created by Angela Smith on 4/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
@interface GameData : NSObject <NSCoding>

@property (nonatomic, strong) NSArray* gamePlayers;
@property (nonatomic, strong) Player* gameCenterPlayer;
@property (nonatomic, strong) Player* gameLocalPlayer;
@property (nonatomic, strong) NSArray* gameScores;

+(instancetype)sharedGameData;
-(void)save;
@end
