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

@interface Utility : NSObject

// SET UP MAP BUTTONS
+ (void) setButtonImage:(CCButton*)button forEnergy:(CGFloat)energy;
+ (void) setActiveButtons:(NSArray*)buttonArray withHighestStop:(NSInteger) highestStop;


// Navigation
//+ (void)shouldReturnToMap;
//+ (void)shouldPlaySelectedLevelWithStop:(NSInteger)selectedStop andHighestStop:(NSInteger)highestStop forJourney:(NSString*)journey;
+(void)shouldPlaySelectedLevelStop:(NSInteger)selectedStop andHighestStop:(NSInteger)highestStop forJourney:(NSString*)journey withPlayer:(Player*)player andConnection:(BOOL)isConnected;
// Local Leaderboard
/*
+ (void) updatePlayer:(Player*)player forJourney:(NSString*)journey andStop:(NSInteger)stop;
+ (void) updatePlayersHighestJOurney:(Player*)player highestJOurney:(NSInteger)journey;
+ (NSMutableArray*)getPlayerArray;
+ (NSMutableArray*)getGameScores;
+ (NSString*) getMigrationJourneyTotalScoreForJourney:(NSString*)journey;
+ (NSString*) getSelectedStopScoreForJourneyStop:(NSString*)journey andStop:(NSInteger) stop;
+ (NSArray*) getTopThreeScoresForJourney:(NSString*)journey withScores:(NSArray*)scores;
+ (GameScore*) getSelectedGameScoreForJourneyStop:(NSString*)journey andStop:(NSInteger) stop;

+(void)increasePlayerJourney:(Player*) player toJourney:(NSInteger)journey;
+(void)increasePlayerJourney:(Player*) player forStop:(NSInteger)stop;
+(NSMutableArray*) getTopThreePlayersScoresForMigration:(NSString*)journey;*/

@end
