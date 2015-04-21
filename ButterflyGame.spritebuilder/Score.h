//
//  Score.h
//  ButterflyGame
//
//  Created by Angela Smith on 4/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Parse/Parse.h>
#import "GamePlayer.h"


@interface Score : PFObject <PFSubclassing>

+ (NSString *)parseClassName;
@property (nonatomic, strong) GamePlayer* gamePlayer;
@property (nonatomic, assign) NSInteger scoreStop;
@property (nonatomic, strong) NSString* scoreJourney;
@property (nonatomic, assign) NSInteger stopHighScore;
@property (nonatomic, assign) CGFloat scoreEnergy;

@end
