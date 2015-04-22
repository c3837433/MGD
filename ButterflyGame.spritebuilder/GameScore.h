//
//  GameScore.h
//  ButterflyGame
//
//  Created by Angela Smith on 4/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

@interface GameScore : NSObject <NSCoding>


@property Player*   gamePlayer;
//@property NSString* gamePlayerName;
@property NSInteger gameStop;
@property NSString* gameJourney;
@property NSInteger gameScore;
//@property NSString* gameLeaderboardName;
@property CGFloat gameEnergy;

-(void)save;
+ (instancetype)sharedGameData;

@end
