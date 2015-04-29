
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
@property (nonatomic) BOOL currentPlayerSelected;
@property (nonatomic) BOOL usingGameCenterPlayer;


@end
