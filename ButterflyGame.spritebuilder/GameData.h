//
//  GameData.h
//  ButterflyGame
//
//  Created by Angela Smith on 4/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameData : NSObject <NSCoding>

@property (nonatomic, strong) NSMutableArray* gamePlayers;

+(instancetype)sharedGameData;
-(void)save;
@end
