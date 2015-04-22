//
//  MigrationA.m
//  ButterflyGame
//
//  Created by Angela Smith on 4/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "MigrationA.h"
#import "Constants.h"
#import "GameScene.h"
#import <Parse/Parse.h>
#import "Utility.h"
#import "GameData.h"

@implementation MigrationA  {
    CCButton* _stop1;
    CCButton* _stop2;
    CCButton* _stop3;
    
    CCLabelTTF* _scoreLabel;
    NSInteger selectedStop;
    NSArray* journeyStops;
    
}


-(void) onEnter {
    
    //NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"Migration A Loaded");
    [super onEnter];
    self.levelsArray = [[NSMutableArray alloc] init];
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;

    journeyStops = [[NSArray alloc] initWithObjects:_stop1, _stop2, _stop3, nil];

    if (self.sessionThroughGameCenter) {
        self.highestPlayableStop = [GameData sharedGameData].gameCenterPlayer.highestAStop;
        selectedStop = self.highestPlayableStop;
        if (self.unlockJourney) {
            // need to unlock another stop on the map
            if (self.highestPlayableStop < 3) {
                self.highestPlayableStop ++;
                [GameData sharedGameData].gameCenterPlayer.highestAStop ++;
            } else {
                if (self.highestPlayableStop == 3) {
                    // unlock the next journey
                    [GameData sharedGameData].gameCenterPlayer.highestJourney = 2;
                }
            }
            self.unlockJourney = false;
        }
        [Utility setActiveButtons:journeyStops withHighestStop:self.highestPlayableStop];
        // get any saved data for the journey
        //[self setUpCurrentSavedData];
        [self setUpCurrentDataFromLocalLEaderboard];
        [[GameData sharedGameData] save];
    } else {
        self.highestPlayableStop = [GameData sharedGameData].gameLocalPlayer.highestAStop;
        selectedStop = self.highestPlayableStop;
        if (self.unlockJourney) {
            // need to unlock another stop on the map
            if (self.highestPlayableStop < 3) {
                self.highestPlayableStop ++;
                [GameData sharedGameData].gameLocalPlayer.highestAStop ++;
            } else {
                if (self.highestPlayableStop == 3) {
                    // unlock the next journey
                    [GameData sharedGameData].gameLocalPlayer.highestJourney = 2;
                }
            }
            self.unlockJourney = false;
        }
        [Utility setActiveButtons:journeyStops withHighestStop:self.highestPlayableStop];
        // get any saved data for the journey
        [self setUpCurrentDataFromLocalLEaderboard];
        [[GameData sharedGameData] save];
        [Utility updateLocalPlayersDataWithUserData];
    }
    /*
    if (self.sessionThroughGameCenter) {
        // check if the user has a highest stop saved yet
        if ([userDefaults objectForKey:mHighestJourneyAStopUnlocked]) {
            self.highestPlayableStop = [userDefaults integerForKey:mHighestJourneyAStopUnlocked];
            // set the selected stop to the previous so the user sees the score they just recieved
            selectedStop = self.highestPlayableStop;
            if (self.unlockJourney) {
                // need to unlock another stop on the map
                if (self.highestPlayableStop < 3) {
                    self.highestPlayableStop ++;
                    [userDefaults setInteger:self.highestPlayableStop forKey:mHighestJourneyAStopUnlocked];
                    [userDefaults synchronize];
                } else {
                    if (self.highestPlayableStop == 3) {
                        // unlock the next journey
                        [userDefaults setInteger:2 forKey:mHighestJourneyUnlocked];
                        [userDefaults synchronize];
                    }
                }
                self.unlockJourney = false;
            }
        } else {
            // set the default
            [userDefaults setInteger:1 forKey:mHighestJourneyAStopUnlocked];
            self.highestPlayableStop = 1;
            selectedStop = 1;
            [userDefaults synchronize];
        }
        // make sure the available buttons are visable and enabled
        [Utility setActiveButtons:journeyStops withHighestStop:self.highestPlayableStop];
        // get any saved data for the journey
        [self setUpCurrentSavedData];
    } else {
        // get the current players info
        self.highestPlayableStop = self.player.highestAStop;
        selectedStop = self.highestPlayableStop;
        if (self.unlockJourney) {
            // need to unlock another stop on the map
            if (self.highestPlayableStop < 3) {
                self.highestPlayableStop ++;
                // update the current high stop
                [Utility increasePlayerJourney:self.player forStop:1];
                // UPDATE
                //[Utility updatePlayer:self.player forJourney:@"A" andStop:self.highestPlayableStop];
            } else {
                if (self.highestPlayableStop == 3) {
                    [Utility increasePlayerJourney:self.player toJourney:2];
                    // unlock the next journey
                // UPDATE
                    
                    //    [Utility updatePlayersHighestJOurney:self.player highestJOurney:2];
                    //[userDefaults setInteger:2 forKey:mHighestJourneyUnlocked];
                    //[userDefaults synchronize];
                }
            }
            self.unlockJourney = false;
        }
        // make sure the available buttons are visable and enabled
        [Utility setActiveButtons:journeyStops withHighestStop:self.highestPlayableStop];
        // get any saved data for the journey
        [self setUpCurrentDataFromLocalLEaderboard];
    
    }*/
}


/*
-(void)findScoreForStop:(NSInteger) stop andButton:(CCButton*)button {
    
    NSArray* scores = [GameData sharedGameData].gameScores;
    NSLog(@"scores found: %lu %@", scores.count, scores.description);
    for (GameScore* score in scores) {
        // set up the label
        NSLog(@"Score journey: %@ stop:%lu", score.gameJourney, score.gameStop);
        if (([score.gameJourney isEqualToString:@"A"]) && (score.gameStop == stop)) {
            _scoreLabel.string = [NSString stringWithFormat:@"Stop %ld Score \n%ld", score.gameStop, (long)score.gameScore];
            [Utility setButtonImage:button forEnergy:score.gameEnergy];
        }
    }
}
*/
/*
// set data for game center
-(void) setUpCurrentSavedData {
     NSLog(@"Loading score from Game Center for current user");
    self.totalScore = 0;
    PFQuery *query = [PFQuery queryWithClassName:pClassName];
    [query fromLocalDatastore];
    // find any scores for this journey
    [query whereKey:pJourney equalTo:@"A"];
   // [query whereKey:dPlayer equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects) {
            for (PFObject* object in objects) {
                NSLog(@"%@", object.description);
                [self.levelsArray addObject:object];
                NSInteger score = [[object objectForKey:pHighScore] integerValue];
                self.totalScore = self.totalScore + score;
                [self setUpStop:object];
            }
            _totalScoreLabel.string = [NSString stringWithFormat:@"Total Score \n%ld", (long)self.totalScore];
        }
        
    }];
}
*/
// set data for local leaderboard
-(void)setUpCurrentDataFromLocalLEaderboard {
    NSLog(@"Loading score from local leaderboard for current user");
    // get the current stop score for the selected stop
   //GameScore* score = [Utility getSelectedGameScoreForJourneyStop:@"A" andStop:selectedStop];
    if (self.sessionThroughGameCenter) {
        [self getTopScoreForStop:selectedStop andPlayer:[GameData sharedGameData].gameCenterPlayer];
    } else {
        [self getTopScoreForStop:selectedStop andPlayer:[GameData sharedGameData].gameLocalPlayer];
    }
}

-(void)setUpLocalStop:(GameScore*)stop {
    // loop through the stop buttons
    for (CCButton* mapButton in journeyStops) {
        // get the button name
        NSString* bName = mapButton.name;
        // Get the last number value
        NSString* buttonNum = [bName substringFromIndex:[bName length] - 1];
        // if there is a stop that matches a button
        if (stop.gameStop == [buttonNum integerValue]) {
            //    NSLog(@"Setting button for stop: %ld", (long)stopNum);
            // set up the button
            switch ([buttonNum integerValue]) {
                case 1:
                    [Utility setButtonImage:_stop1 forEnergy:stop.gameEnergy];
                    NSLog(@"Setting first button");
                    break;
                case 2:
                    [Utility setButtonImage:_stop2 forEnergy:stop.gameEnergy];
                    NSLog(@"Setting second button");
                    break;
                case 3:
                    [Utility setButtonImage:_stop3 forEnergy:stop.gameEnergy];
                    NSLog(@"Setting third button");
                    break;
                default:
                    break;
            }
        }
        // currently select the highest playable stop
        mapButton.selected = ([buttonNum integerValue] == self.highestPlayableStop) ? true : false;
    }
}
/*
-(void) setUpStop:(PFObject*)stop {

        // if it has a level stop number
        if ([stop objectForKey:pStop]) {
            // get it and the current energy level
            NSInteger stopNum = [[stop objectForKey:pStop] integerValue];
            NSLog(@"Stop number: %ld", (long)stopNum);
            if (stopNum == selectedStop) {
                // set this button to selected and set the high score
                _scoreLabel.string = [NSString stringWithFormat:@"Stop %ld Score \n%@", (long)selectedStop, [stop objectForKey:pHighScore]];
                NSLog(@"This high score: %@", [stop objectForKey:pHighScore]);
            }
            CGFloat energyLevel = [[stop objectForKey:pEnergy] floatValue];
             NSLog(@"This energy level: %f", energyLevel);
            // loop through the stop buttons
            for (CCButton* mapButton in journeyStops) {
                // get the button name
                NSString* bName = mapButton.name;
                // Get the last number value
                NSString* buttonNum = [bName substringFromIndex:[bName length] - 1];
                // if there is a stop that matches a button
                if (stopNum == [buttonNum integerValue]) {
                //    NSLog(@"Setting button for stop: %ld", (long)stopNum);
                    // set up the button
                    switch ([buttonNum integerValue]) {
                        case 1:
                            [Utility setButtonImage:_stop1 forEnergy:energyLevel];
                            NSLog(@"Setting first button");
                            break;
                        case 2:
                            [Utility setButtonImage:_stop2 forEnergy:energyLevel];
                             NSLog(@"Setting second button");
                            break;
                        case 3:
                            [Utility setButtonImage:_stop3 forEnergy:energyLevel];
                             NSLog(@"Setting third button");
                            break;
                        default:
                            break;
                    }
                }
                // currently select the highest playable stop
                mapButton.selected = ([buttonNum integerValue] == self.highestPlayableStop) ? true : false;

            }

        }
}
*/

-(void)getTopScoreForStop: (NSInteger)stop andPlayer:(Player*)player {
    NSArray* scores = [GameData sharedGameData].gameScores;
    NSLog(@"scores found: %lu %@", scores.count, scores.description);
    for (GameScore* score in scores) {
        // set up the label
        NSLog(@"Score journey: %@ stop:%lu", score.gameJourney, score.gameStop);
        if (([score.gameJourney isEqualToString:@"A"]) && (score.gameStop == stop) && ([score.gamePlayer isEqual:player])) {
            _scoreLabel.string = [NSString stringWithFormat:@"Stop %ld Score \n%ld", score.gameStop, (long)score.gameScore];
            [self setUpLocalStop:score];
        }
    }

}
-(void)getPlayersStopScore:(NSInteger) stop andButton:(CCButton*)button forPlayer:(Player*)player {
    NSArray* scores = [GameData sharedGameData].gameScores;
    NSLog(@"scores found: %lu %@", scores.count, scores.description);
    for (GameScore* score in scores) {
        // set up the label
        NSLog(@"Score journey: %@ stop:%lu", score.gameJourney, score.gameStop);
        if (([score.gameJourney isEqualToString:@"A"]) && (score.gameStop == stop) && ([score.gamePlayer isEqual:player])) {
            _scoreLabel.string = [NSString stringWithFormat:@"Stop %ld Score \n%ld", score.gameStop, (long)score.gameScore];
            [Utility setButtonImage:button forEnergy:score.gameEnergy];
        }
    }
}

-(void) setButtonAndStop:(CCButton*) button {
    NSLog(@"User selected stop: %ld", selectedStop);
     _scoreLabel.string = [NSString stringWithFormat:@"Stop %ld", selectedStop];
    // unselect all the buttons
    for (CCButton* button in journeyStops) {
        button.selected = false;
    }
    if (self.sessionThroughGameCenter) {
        [self getPlayersStopScore:selectedStop andButton:button forPlayer:[GameData sharedGameData].gameCenterPlayer];
    } else {
        [self getPlayersStopScore:selectedStop andButton:button forPlayer:[GameData sharedGameData].gameLocalPlayer];
    }

    //_scoreLabel.string = [self get]
    /*
    if (self.sessionThroughGameCenter) {
        NSLog(@"Getting migration a stop score from Parse");
        for (PFObject* object in self.levelsArray) {
            if ([object objectForKey:pStop]) {
                NSInteger stop = [[object objectForKey:pStop] integerValue];
                if (stop == selectedStop) {
                    // get the high score and energy level
                    if ([object objectForKey:pHighScore]) {
                        _scoreLabel.string = [NSString stringWithFormat:@"Stop %ld Score \n%@", (long)selectedStop, [object objectForKey:pHighScore]];
                    }
                    CGFloat energyLevel = [[object objectForKey:pEnergy] floatValue];
                    // Update the button
                    [Utility setButtonImage:button forEnergy:energyLevel];
                }
            }
        }

    } else {
        NSLog(@"Getting migration stop score from file.");
        // get the score from utility
       // [self findScoreForStop:selectedStop andButton:button];
        //NSString* scoreString = [Utility getSelectedStopScoreForJourneyStop:@"A" andStop:selectedStop];
        //_scoreLabel.string = scoreString;
        //NSLog(@"score: %@",  scoreString);
    }*/
}

-(void )selectedFirstStop {
    selectedStop = 1;
    [self setButtonAndStop:_stop1];
}

-(void) selectedSecondStop {
    if (self.highestPlayableStop >= 2) {
        selectedStop = 2;
        [self setButtonAndStop:_stop2];
    }
    
}

-(void) selectedThirdStop {
    if (self.highestPlayableStop >= 3) {
        selectedStop = 3;
        [self setButtonAndStop:_stop3];
    }
}


-(void)shouldReturnToMap {
    // Return to the main map
    [Utility shouldReturnToMap];
}

-(void)shouldPlaySelectedLevel {
    // Set the migration level to return to, selected stop to play and highest stop for unlocking and play stop
   // [Utility shouldPlaySelectedLevelWithStop:selectedStop andHighestStop:self.highestPlayableStop forJourney:@"A"];
    [Utility shouldPlaySelectedLevelStop:selectedStop andHighestStop:self.highestPlayableStop forJourney:@"A" withPlayer:self.player andConnection:self.sessionThroughGameCenter];
}

@end