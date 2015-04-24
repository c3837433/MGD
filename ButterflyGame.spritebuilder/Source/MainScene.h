
//  ButterflyGame
//
//  Created by Angela Smith on 3/4/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//
#import "Player.h"
#import "GamePlayer.h"
#import "GameData.h"

@interface MainScene : CCNode

@property (nonatomic) NSInteger boardsChecked;
@property (nonatomic, strong) NSMutableArray* playerArray;
//@property (nonatomic) BOOL connectedToGameCenter;
//@property (nonatomic) BOOL selectedNonGameCenterPlayer;
@property (nonatomic) BOOL currentPlayerSelected;
@property (nonatomic) BOOL usingGameCenterPlayer;
//@property (nonatomic) BOOL returnFromMap;
//@property (nonatomic, strong) Player* player;
//@property (nonatomic, strong) Player* gameCenterPlayer;
//@property (nonatomic) BOOL getUserForLeaderbaord;
//@property (nonatomic, strong) GamePlayer* currentPlayer;
@end
