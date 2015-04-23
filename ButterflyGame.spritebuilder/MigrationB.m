//
//  MigrationB.m
//  ButterflyGame
//
//  Created by Angela Smith on 4/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "MigrationB.h"
#import "Constants.h"
#import "Utility.h"
#import <Parse/Parse.h>
#import "Map.h"
#import "GameData.h"

@implementation MigrationB  {
    CCButton* _stop1;
    CCButton* _stop2;
    CCButton* _stop3;
    
    CCLabelTTF* _scoreLabel;
    NSInteger selectedStop;
    NSArray* journeyStops;
   // CCLabelTTF* _totalScoreLabel;
    
}

-(void) onEnter {
    NSLog(@"Migration B Loaded");
    [super onEnter];
    self.levelsArray = [[NSMutableArray alloc] init];
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    journeyStops = [[NSArray alloc] initWithObjects:_stop1, _stop2, _stop3, nil];
    
    // SET UP AVAILABLE BUTTONS BASED ON CURRENT GAME CENTER PLAYERS UNLOCKED STOPS
    if (self.sessionThroughGameCenter) {
        NSLog(@"Migration a connected through game center");
        self.highestPlayableStop = [GameData sharedGameData].gameCenterPlayer.highestBStop;
        selectedStop = self.highestPlayableStop;
        if (self.unlockJourney) {
            // need to unlock another stop on the map
            if (self.highestPlayableStop < 3) {
                NSLog(@"increasing game center player available stops");
                self.highestPlayableStop ++;
                [GameData sharedGameData].gameCenterPlayer.highestBStop ++;
                [[GameData sharedGameData] save];
                
            } else if (self.highestPlayableStop == 3) {
                NSLog(@"increasing game center player available journeys");
                // unlock the next journey
                [GameData sharedGameData].gameCenterPlayer.highestJourney = 3;
                [[GameData sharedGameData] save];
            }
            
            self.unlockJourney = false;
        }
        [Utility setActiveButtons:journeyStops withHighestStop:self.highestPlayableStop];
        for (int i = 1; i < self.highestPlayableStop; i++) {
            // get the highest saved energy level and score for this stop
            GameScore* score = [self getTopEnergyForStop:i andPlayer:[GameData sharedGameData].gameCenterPlayer];
            CCButton* stopButton = journeyStops[i-1];
            NSLog(@"Stop: %u  score stop: %ld Top energy: %fl", i, (long)score.gameStop, score.gameEnergy);
            [Utility setButtonImage:stopButton forEnergy:score.gameEnergy];
        }
        // Finally, set up for the selected stop
        [self getTopScoreForStop:selectedStop andPlayer:[GameData sharedGameData].gameCenterPlayer];
        // SAME FOR LOCAL PLAYER
    } else {
        NSLog(@"Migration a connected loaded with local player");
        self.highestPlayableStop = [GameData sharedGameData].gameLocalPlayer.highestBStop;
        selectedStop = self.highestPlayableStop;
        if (self.unlockJourney) {
            // need to unlock another stop on the map
            if (self.highestPlayableStop < 3) {
                NSLog(@"increasing local player available stops");
                self.highestPlayableStop ++;
                [[GameData sharedGameData] save];
                [GameData sharedGameData].gameLocalPlayer.highestBStop ++;
            } else if (self.highestPlayableStop == 3) {
                // unlock the next journey
                [GameData sharedGameData].gameLocalPlayer.highestJourney = 3;
                NSLog(@"increasing local player available journeys");
                [[GameData sharedGameData] save];
            }
            self.unlockJourney = false;
        }
        [Utility setActiveButtons:journeyStops withHighestStop:self.highestPlayableStop];
        for (int i = 1; i < self.highestPlayableStop; i++) {
            // get the highest saved energy level and score for this stop
            GameScore* score = [self getTopEnergyForStop:i andPlayer:[GameData sharedGameData].gameLocalPlayer];
            CCButton* stopButton = journeyStops[i-1];
            NSLog(@"Stop: %u  score stop: %ld Top energy: %fl", i, (long)score.gameStop, score.gameEnergy);
            [Utility setButtonImage:stopButton forEnergy:score.gameEnergy];
        }
        // Finally, set up for the selected stop
        [self getTopScoreForStop:selectedStop andPlayer:[GameData sharedGameData].gameLocalPlayer];
    }
}



#pragma mark - SET UP SELECTED STOP ON LOAD
-(void)getTopScoreForStop: (NSInteger)stop andPlayer:(Player*)player {
    NSArray* scores = [GameData sharedGameData].gameScores;
    NSLog(@"scores found: %lu %@", scores.count, scores.description);
    for (GameScore* score in scores) {
        // set up the label
       // NSLog(@"Score journey: %@ stop:%lu", score.gameJourney, score.gameStop);
        if (([score.gameJourney isEqualToString:@"B"]) && (score.gameStop == stop) && ([score.gamePlayer isEqual:player])) {
            _scoreLabel.string = [NSString stringWithFormat:@"Stop %ld Score \n%ld", score.gameStop, (long)score.gameScore];
            // set the button
            [self setUpLocalStop:score];
        }
    }
}

// Get the selected button to display correctly on load
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


#pragma mark - GET STOP SCORES
-(void)getPlayersStopScore:(NSInteger) stop andButton:(CCButton*)button forPlayer:(Player*)player {
    NSArray* scores = [GameData sharedGameData].gameScores;
    NSLog(@"scores found: %lu %@", scores.count, scores.description);
    for (GameScore* score in scores) {
        // set up the label
        //NSLog(@"Score journey: %@ stop:%lu", score.gameJourney, score.gameStop);
        if (([score.gameJourney isEqualToString:@"B"]) && (score.gameStop == stop) && ([score.gamePlayer isEqual:player])) {
            _scoreLabel.string = [NSString stringWithFormat:@"Stop %ld Score \n%ld", score.gameStop, (long)score.gameScore];
            [Utility setButtonImage:button forEnergy:score.gameEnergy];
        }
    }
}


// GET THE TOP ENERGY SCORE FOR BUTTON COLOR
-(GameScore*)getTopEnergyForStop:(NSInteger)stop andPlayer:(Player*)player {
    NSArray* scores = [GameData sharedGameData].gameScores;
    NSLog(@"scores found: %lu %@", scores.count, scores.description);
    GameScore* topScore = [[GameScore alloc] init];
    topScore.gameEnergy = 0.0;
    for (GameScore* score in scores) {
        // set up the label
        //NSLog(@"Score journey: %@ stop:%lu", score.gameJourney, score.gameStop);
        if (([score.gameJourney isEqualToString:@"B"]) && (score.gameStop == stop) && ([score.gamePlayer isEqual:player])) {
            if (score.gameEnergy > topScore.gameEnergy) {
                topScore = score;
            }
        }
    }
    return topScore;
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
}

#pragma  marl - BUTTON ACTIONS
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



#pragma mark - NAVIGATION
-(void)shouldReturnToMap {
    // Return to map scene
    CCScene* scene = [CCBReader loadAsScene:@"Map"];
    Map* map = [[scene children] firstObject];
    // send the connection property back
    map.connectedToGameCenter = self.sessionThroughGameCenter;
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
    
}

-(void)shouldPlaySelectedLevel {
    // Set the migration level to return to, selected stop to play and highest stop for unlocking and play stop
    [Utility shouldPlaySelectedLevelStop:selectedStop andHighestStop:self.highestPlayableStop forJourney:@"B" withPlayer:self.player andConnection:self.sessionThroughGameCenter];
}

@end
