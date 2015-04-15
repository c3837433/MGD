//
//  MigrationD.m
//  ButterflyGame
//
//  Created by Angela Smith on 4/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "MigrationD.h"
#import "Constants.h"
#import "Utility.h"
#import <Parse/Parse.h>

@implementation MigrationD {
    CCButton* _stop1;
    CCButton* _stop2;
    CCButton* _stop3;
    CCButton* _stop4;
    
    CCLabelTTF* _scoreLabel;
    NSInteger selectedStop;
    NSArray* journeyStops;
    CCLabelTTF* _totalScoreLabel;
    
}

-(void) onEnter {
    NSLog(@"Migration D Loaded");
    [super onEnter];
    self.levelsArray = [[NSMutableArray alloc] init];
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    _totalScoreLabel.string = @"";
    journeyStops = [[NSArray alloc] initWithObjects:_stop1, _stop2, _stop3, _stop4, nil];
    selectedStop = 1;
    
    
    // check if the user has a highest stop saved yet
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:mHighestJourneyDStopUnlocked]) {
        self.highestPlayableStop = [userDefaults integerForKey:mHighestJourneyDStopUnlocked];
        if (self.unlockJourney) {
            // need to unlock another stop on the map
            if (self.highestPlayableStop < 4) {
                self.highestPlayableStop ++;
                [userDefaults setInteger:self.highestPlayableStop forKey:mHighestJourneyDStopUnlocked];
                [userDefaults synchronize];
            } else {
                if (self.highestPlayableStop == 4) {
                    // unlock the next journey
                    [userDefaults setInteger:5 forKey:mHighestJourneyUnlocked];
                    [userDefaults synchronize];
                }
            }
            self.unlockJourney = false;
        }
    } else {
        // set the default
        [userDefaults setInteger:1 forKey:mHighestJourneyDStopUnlocked];
        self.highestPlayableStop = 1;
        [userDefaults synchronize];
    }
    // make sure the available buttons are visable and enabled
    [Utility setActiveButtons:journeyStops withHighestStop:self.highestPlayableStop];
    // get any saved data for the journey
    [self setUpCurrentSavedData];
}


-(void) setUpCurrentSavedData {
    PFQuery *query = [PFQuery queryWithClassName:dClassName];
    [query fromLocalDatastore];
    // find any scores for this journey
    [query whereKey:dJourney equalTo:@"D"];
    // [query whereKey:dPlayer equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects) {
            for (PFObject* object in objects) {
                NSLog(@"%@", object.description);
                [self.levelsArray addObject:object];
                NSInteger score = [[object objectForKey:dHighScore] integerValue];
                self.totalScore = self.totalScore + score;
                [self setUpStop:object];
            }
        }
        _totalScoreLabel.string = [NSString stringWithFormat:@"Total Score \n%ld", (long)self.totalScore];

        
    }];
    
}

-(void) setUpStop:(PFObject*)stop {
    
    // if it has a level stop number
    if ([stop objectForKey:dLevel]) {
        // get it and the current energy level
        NSInteger stopNum = [[stop objectForKey:dLevel] integerValue];
        NSLog(@"Stop number: %ld", (long)stopNum);
        if (stopNum == selectedStop) {
            // set this button to selected and set the high score
            _scoreLabel.string = [stop objectForKey:dHighScore];
            NSLog(@"This high score: %@", [stop objectForKey:dHighScore]);
        }
        CGFloat energyLevel = [[stop objectForKey:dEnergy] floatValue];
        NSLog(@"This energy level: %f", energyLevel);
        // loop through the stop buttons
        for (CCButton* mapButton in journeyStops) {
            // get the button name
            NSString* bName = mapButton.name;
            // Get the last number value
            NSString* buttonNum = [bName substringFromIndex:[bName length] - 1];
            // if there is a stop that matches a button
            if (stopNum == [buttonNum integerValue]) {
                // set up the button
                switch ([buttonNum integerValue]) {
                    case 1:
                        [Utility setButtonImage:_stop1 forEnergy:energyLevel];
                        break;
                    case 2:
                        [Utility setButtonImage:_stop2 forEnergy:energyLevel];
                        break;
                    case 3:
                        [Utility setButtonImage:_stop3 forEnergy:energyLevel];
                        break;
                    case 4:
                        [Utility setButtonImage:_stop4 forEnergy:energyLevel];
                        break;
                    default:
                        break;
                }
            }
            mapButton.selected = ([buttonNum integerValue] == self.highestPlayableStop) ? true : false;
        }
    }
}


-(void) setButtonAndStop:(CCButton*) button {
    // unselect all the buttons
    for (CCButton* button in journeyStops) {
        button.selected = false;
    }
    // set the correct data for the score
    _scoreLabel.string = @"High Score";
    for (PFObject* object in self.levelsArray) {
        if ([object objectForKey:dLevel]) {
            NSInteger stop = [[object objectForKey:dLevel] integerValue];
            if (stop == selectedStop) {
                // get the high score and energy level
                if ([object objectForKey:dHighScore]) {
                    _scoreLabel.string = [object objectForKey:dHighScore];
                }
                CGFloat energyLevel = [[object objectForKey:dEnergy] floatValue];
                // set the current button selected
                [Utility setButtonImage:button forEnergy:energyLevel];
            }
        }
    }
}

// When the user selects a stop, adjust the screen to display it's data and set the button to highlighted
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

-(void) selectedFourthStop {
    if (self.highestPlayableStop >=4) {
        selectedStop = 4;
        [self setButtonAndStop:_stop4];
    }
}




-(void)shouldReturnToMap {
    // Return to the main map
    [Utility shouldReturnToMap];
}

-(void)shouldPlaySelectedLevel {
    [Utility shouldPlaySelectedLevelWithStop:selectedStop andHighestStop:self.highestPlayableStop forJourney:@"D"];
}

@end
