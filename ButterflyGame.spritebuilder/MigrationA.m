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

@implementation MigrationA  {
    CCButton* _stop1;
    CCButton* _stop2;
    CCButton* _stop3;
    
    CCLabelTTF* _scoreLabel;
    CCLabelTTF* _totalScoreLabel;
    NSInteger selectedStop;
    NSArray* journeyStops;
    
}
-(void) onEnter {
    NSLog(@"Migration A Loaded");
    [super onEnter];
    self.levelsArray = [[NSMutableArray alloc] init];
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    _totalScoreLabel.string = @"";
    journeyStops = [[NSArray alloc] initWithObjects:_stop1, _stop2, _stop3, nil];
    selectedStop = 1;
    

    // check if the user has a highest stop saved yet
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:mHighestJourneyAStopUnlocked]) {
        self.highestPlayableStop = [userDefaults integerForKey:mHighestJourneyAStopUnlocked];
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
        [userDefaults synchronize];
    }
    // make sure the available buttons are visable and enabled
    [Utility setActiveButtons:journeyStops withHighestStop:self.highestPlayableStop];
    // get any saved data for the journey
    [self setUpCurrentSavedData];
}


-(void) setUpCurrentSavedData {
    self.totalScore = 0;
    PFQuery *query = [PFQuery queryWithClassName:dClassName];
    [query fromLocalDatastore];
    // find any scores for this journey
    [query whereKey:dJourney equalTo:@"A"];
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
            _totalScoreLabel.string = [NSString stringWithFormat:@"Total Score \n%ld", (long)self.totalScore];
        }
        
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
                //    NSLog(@"Setting button for stop: %ld", (long)stopNum);
                    // set up the button
                    switch ([buttonNum integerValue]) {
                        case 1:
                            //[self setButtonImage:_stop1 forEnergy:energyLevel];
                            [Utility setButtonImage:_stop1 forEnergy:energyLevel];
                            NSLog(@"Setting first button");
                            break;
                        case 2:
                           // [self setButtonImage:_stop2 forEnergy:energyLevel];
                            [Utility setButtonImage:_stop2 forEnergy:energyLevel];
                             NSLog(@"Setting second button");
                            break;
                        case 3:
                            //[self setButtonImage:_stop3 forEnergy:energyLevel];
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

-(void )selectedFirstStop {
    NSLog(@"User selected a stop");
    selectedStop = 1;
    [self setButtonAndStop:_stop1];
}

-(void) setButtonAndStop:(CCButton*) button {
    // unselect all the buttons
    for (CCButton* button in journeyStops) {
        button.selected = false;
    }
    _scoreLabel.string = @"";
    for (PFObject* object in self.levelsArray) {
        if ([object objectForKey:dLevel]) {
            NSInteger stop = [[object objectForKey:dLevel] integerValue];
            if (stop == selectedStop) {
                // get the high score and energy level
                if ([object objectForKey:dHighScore]) {
                    _scoreLabel.string = [NSString stringWithFormat:@"Stop %ld Score \n%@", (long)selectedStop, [object objectForKey:dHighScore]];
                }
                CGFloat energyLevel = [[object objectForKey:dEnergy] floatValue];
                //[self setButtonImage:button forEnergy:energyLevel];
                [Utility setButtonImage:button forEnergy:energyLevel];
            }
        }
    }
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
/*    CCScene* scene = [CCBReader loadAsScene:@"Map"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];*/
    
}

-(void)shouldPlaySelectedLevel {
    [Utility shouldPlaySelectedLevelWithStop:selectedStop andHighestStop:self.highestPlayableStop forJourney:@"A"];
    /*
    // Just load the same game
    CCScene* scene = [CCBReader loadAsScene:@"GameScene"];
    GameScene* gameScene = [[scene children] firstObject];
    gameScene.currentStop = selectedStop;
    NSLog(@"Selected stop: %ld", (long)selectedStop);
    NSLog(@"Hichest stop: %ld", (long)self.highestPlayableStop);
    if (selectedStop == self.highestPlayableStop) {
        gameScene.forUnlock = YES;
        NSLog(@"This is for unlocking");
    }
    gameScene.currentJourney = @"A";
    
    [[CCDirector sharedDirector] replaceScene:scene];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];*/
}

@end