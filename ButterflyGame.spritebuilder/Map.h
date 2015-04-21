//
//  Map.h
//  ButterflyGame
//
//  Created by Angela Smith on 3/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "Player.h"
#import "GamePlayer.h"
@interface Map : CCNode


@property (nonatomic) NSInteger highestLevel;
@property (nonatomic, strong) Player* currentPlayer;
@property (nonatomic) BOOL connectedToGameCenter;
//@property (nonatomic, strong) GamePlayer* player;
@end
