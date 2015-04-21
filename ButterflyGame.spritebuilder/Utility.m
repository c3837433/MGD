//
//  Utility.m
//  ButterflyGame
//
//  Created by Angela Smith on 4/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Utility.h"
#import "GameScene.h"
#import "Constants.h"
#import "LeaderboardPosition.h"

@implementation Utility

#pragma mark - BUTTON METHODS
+ (void) setButtonImage:(CCButton*)button forEnergy:(CGFloat)energy {

    NSLog(@"selected stop energy level: %f", energy);
    if (energy > .5) {
        // green image
        NSLog(@"button should be green");
        [button setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:jGreenDot] forState:CCControlStateNormal];
        [button setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:jGreenHighlighted] forState:CCControlStateHighlighted];
        [button setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:jGreenHighlighted] forState:CCControlStateSelected];
    } else if (energy > .3) {
        // orange image
        NSLog(@"button should be orange");
        [button setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:jOrangenDot] forState:CCControlStateNormal];
        [button setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:jOrangeHighlighted] forState:CCControlStateHighlighted];
        [button setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:jOrangeHighlighted] forState:CCControlStateSelected];
    } else if (energy > 0) {
        // red
        NSLog(@"button should be red");
        [button setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:jRedDot] forState:CCControlStateNormal];
        [button setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:jRedHighlighted] forState:CCControlStateHighlighted];
        [button setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:jRedHighlighted] forState:CCControlStateSelected];
    } else {
        // dark grey
        NSLog(@"button should be grey");
        [button setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:jUnlocked] forState:CCControlStateNormal];
        [button setBackgroundSpriteFrame: [CCSpriteFrame frameWithImageNamed:jUnlockedHighlighted] forState:CCControlStateHighlighted];
        [button setBackgroundSpriteFrame: [CCSpriteFrame frameWithImageNamed:jUnlockedHighlighted] forState:CCControlStateSelected];
    }
    [button setSelected:true];
    
}


+ (void) setActiveButtons:(NSArray*)buttonArray withHighestStop:(NSInteger) highestStop {
    // Create an array of all the journey nodes
    for (CCButton* button in buttonArray) {
        // get the button name
        NSString* buttonName = button.name;
        // Get the last number value
        NSString* buttonNum = [buttonName substringFromIndex:[buttonName length] - 1];
        // convert to integer
        NSInteger buttonInt = [buttonNum integerValue];
        // if this is higher than the current hghest level, hide it
        if (buttonInt <= highestStop) {
            [button setVisible:true];
            button.userInteractionEnabled = true;
            [button setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:jUnlocked] forState:CCControlStateNormal];
            [button setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:jUnlockedHighlighted] forState:CCControlStateHighlighted];
            [button setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:jUnlockedHighlighted] forState:CCControlStateSelected];
        }
    }
}


+ (void)shouldReturnToMap  {
    // Return to the main map
    CCScene* scene = [CCBReader loadAsScene:@"Map"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
    
}

+(void)shouldPlaySelectedLevelStop:(NSInteger)selectedStop andHighestStop:(NSInteger)highestStop forJourney:(NSString*)journey withPlayer:(Player*)player andConnection:(BOOL)isConnected {
    // Just load the same game
    CCScene* scene = [CCBReader loadAsScene:@"GameScene"];
    GameScene* gameScene = [[scene children] firstObject];
    gameScene.currentStop = selectedStop;
    gameScene.player = player;
    gameScene.sessionConnectedToGC = isConnected;
    //NSLog(@"Selected stop: %ld", (long)selectedStop);
    //NSLog(@"Hichest stop: %ld", (long)self.highestPlayableStop);
    if (selectedStop == highestStop) {
        gameScene.forUnlock = YES;
        NSLog(@"This is for unlocking");
    }
    gameScene.currentJourney = journey;
    
    [[CCDirector sharedDirector] replaceScene:scene];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}

+(NSMutableArray*)getPlayerArray {
    NSMutableArray* playerArray;
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSData* playerData = [userDefaults objectForKey:dLocalPlayerArray];
    if (playerData != nil) {
        NSArray* dataArray = [NSKeyedUnarchiver unarchiveObjectWithData:playerData];
        if (dataArray != nil)
            playerArray = [[NSMutableArray alloc] initWithArray:dataArray];
        else
            playerArray = [[NSMutableArray alloc] init];
    }
    return playerArray;
}

+(void) updatePlayer:(Player*)player forJourney:(NSString*)journey andStop:(NSInteger)stop {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray* playerArray =  [self getPlayerArray];
     NSLog(@"Player array in utility:%@", playerArray.description);
    for (Player* thisPlayer in playerArray) {
        if (thisPlayer.playerName == player.playerName) {
            NSLog(@"Found player");
            // remove the previous player
            [playerArray removeObject:thisPlayer];
            // update this player
            if ([journey isEqualToString:@"A"]) {
                thisPlayer.highestAStop = stop;
            } else if ([journey isEqualToString:@"B"]) {
                thisPlayer.highestBStop = stop;
            } else if ([journey isEqualToString:@"C"]) {
                thisPlayer.highestCStop = stop;
            } else if ([journey isEqualToString:@"D"]) {
                thisPlayer.highestDStop = stop;
            } else if ([journey isEqualToString:@"E"]) {
                thisPlayer.highestEStop = stop;
            }
            NSLog(@"updating player");
            [playerArray addObject:thisPlayer];
            // resave the array
            NSData* playerData = [NSKeyedArchiver archivedDataWithRootObject:playerArray];
            [userDefaults setObject:playerData forKey:dLocalPlayerArray];
            [userDefaults synchronize];
        }
    }
}

+(void) updatePlayersHighestJOurney:(Player*)player highestJOurney:(NSInteger)journey {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray* playerArray =  [self getPlayerArray];
    for (Player* thisPlayer in playerArray) {
        if (thisPlayer == player) {
            // update this player
            thisPlayer.highestJourney = journey;
            // remove the previous player
            [playerArray removeObject:thisPlayer];
            [playerArray addObject:player];
            // resave the array
            NSData* playerData = [NSKeyedArchiver archivedDataWithRootObject:playerArray];
            [userDefaults setObject:playerData forKey:dLocalPlayerArray];
            [userDefaults synchronize];
        }
    }
}

+(NSMutableArray*)getGameScores {
    NSMutableArray* scoreArray;
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSData* scoreData = [userDefaults objectForKey:dLocalScoresArray];
    if (scoreData != nil) {
        NSArray* dataArray = [NSKeyedUnarchiver unarchiveObjectWithData:scoreData];
        if (dataArray != nil)
            scoreArray = [[NSMutableArray alloc] initWithArray:dataArray];
        else
            scoreArray = [[NSMutableArray alloc] init];
    }
    NSLog(@"Score array: %@", scoreArray.description);
    return scoreArray;
}

+(NSString*) getMigrationJourneyTotalScoreForJourney:(NSString*)journey {
    // get all scores
    NSMutableArray* scores = [self getGameScores];
    NSInteger stopScore = 0;
    for (GameScore* score in scores) {
        if ([score.gameJourney isEqualToString:journey]) {
            stopScore = stopScore + score.gameScore;
        }
    }
    NSLog(@"Total Score: %ld", (long)stopScore);
    return [NSString stringWithFormat:@"Total Score \n%ld", (long)stopScore];
}

+(NSString*) getSelectedStopScoreForJourneyStop:(NSString*)journey andStop:(NSInteger) stop {
    // get all scores
    //NSMutableArray* scores = [self getGameScores];
    NSMutableArray* scoreArray;
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSData* scoreData = [userDefaults objectForKey:dLocalScoresArray];
    if (scoreData != nil) {
        NSLog(@"We found score data");
        NSArray* dataArray = [NSKeyedUnarchiver unarchiveObjectWithData:scoreData];
        NSLog(@"Array returned: %@ count: %lu", dataArray.description, (unsigned long)dataArray.count);
        if (dataArray != nil)
            scoreArray = [[NSMutableArray alloc] initWithArray:dataArray];
        else
            scoreArray = [[NSMutableArray alloc] init];
    } else {
        NSLog(@"There is no score data...");
    }
    NSLog(@"Score array: %@ with total: %lu", scoreArray.description, (unsigned long)scoreArray.count);
    //return scoreArray;
    NSInteger stopScore = 0;
    for (GameScore* score in scoreArray) {
        if ([score.gameJourney isEqualToString:journey]) {
            if (score.gameStop == stop) {
                stopScore = score.gameScore;
                NSLog(@"Stop score: %lu", (unsigned long)stopScore);
            }
        }
    }
    NSLog(@"Stop %ld Score \n%ld", stop, (long)stopScore);
    return [NSString stringWithFormat:@"Stop %ld Score \n%ld", stop, (long)stopScore];
}

+(GameScore*) getSelectedGameScoreForJourneyStop:(NSString*)journey andStop:(NSInteger) stop {
    // get all scores
    NSMutableArray* scores = [self getGameScores];
    GameScore* selectedScore = [[GameScore alloc] init];
    for (GameScore* score in scores) {
        if ([score.gameJourney isEqualToString:journey]) {
            if (score.gameStop == stop) {
                selectedScore = score;
                return score;
            }
        }
    }
    return nil;
}

+(NSArray*) getTopThreeScoresForJourney:(NSString*)journey {
    NSLog(@"Getting top three leaderboard scores");
    // Get the players
    NSMutableArray* journeyPlayers = [self getPlayerArray];
    // and all the scores
    NSMutableArray* allScores = [self getGameScores];
    NSMutableArray* journeyScores = [[NSMutableArray alloc] init];
    for (Player* eachPlayer in journeyPlayers) {
        LeaderboardPosition* position = [[LeaderboardPosition alloc] init];
        // set the name
        position.leaderName = eachPlayer.playerName;
        NSLog(@"Setting name: %@", position.leaderName);
        // get their scores for this journey
        // limit to the ones for this journey
        NSInteger stopScore = 0;
        for (GameScore* score in allScores) {
            if ([score.gameJourney isEqualToString:journey]) {
                stopScore = stopScore + score.gameScore;
            }
        }
        // and the score
        position.leaderScore = [NSString stringWithFormat:@"%ld", (long)stopScore];
        NSLog(@"Setting score: %@", position.leaderScore);
        [journeyScores addObject:position];
    }
    // order scores
    journeyScores = [self sortLeaderboards:journeyScores];
    // finally reduce to top three
    if (journeyScores.count > 3) {
        NSLog(@"Returning top 3 scores");
         return [journeyScores subarrayWithRange:NSMakeRange(0, 3)];
    } else {
        NSLog(@"returning 0-3 scores");
        return journeyScores;
    }
}

+(NSMutableArray*) sortLeaderboards:(NSMutableArray*)allScores {
    
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"leaderScoreValue" ascending:NO];
    [allScores sortUsingDescriptors:[NSArray arrayWithObject:sorter]];

    for (LeaderboardPosition* position in allScores) {
        NSLog(@"Sorted Score: %@", position.leaderScore);
    }
    return allScores;
}

@end
