//
//  Utility.h
//  ButterflyGame
//
//  Created by Angela Smith on 4/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
#import "GameScore.h"
#import <Parse/Parse.h>
#import "ABGameKitHelper.h"

@interface Utility : NSObject

// SET UP MAP BUTTONS
+ (void) setButtonImage:(CCButton*)button forEnergy:(CGFloat)energy;
+ (void) setActiveButtons:(NSArray*)buttonArray withHighestStop:(NSInteger) highestStop;

+(void)shouldPlaySelectedLevelStop:(NSInteger)selectedStop andHighestStop:(NSInteger)highestStop forJourney:(NSString*)journey withPlayer:(Player*)player;
+(void) updateGameCenterPlayerWithGameCenterData;
@end
