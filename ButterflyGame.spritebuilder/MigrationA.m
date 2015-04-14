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

@implementation MigrationA  {
    CCButton* _stop1;
    CCButton* _stop2;
    CCButton* _stop3;
    
    CCSpriteFrame* greenDot;
    CCSpriteFrame* redDot;
    CCSpriteFrame* orangeDot;
    CCSpriteFrame* grayDot;
    CCSpriteFrame* greenHLDot;
    CCSpriteFrame* redHLDot;
    CCSpriteFrame* orangeHLDot;
    CCSpriteFrame* grayHLDot;
    CCLabelTTF* _scoreLabel;
    NSInteger selectedStop;
    NSArray* journeyStops;
    
}
-(void) onEnter {
    NSLog(@"Migration A Loaded");
    [super onEnter];
    self.levelsArray = [[NSMutableArray alloc] init];
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    greenDot = [CCSpriteFrame frameWithImageNamed:jGreenDot];
    redDot = [CCSpriteFrame frameWithImageNamed:jRedDot];
    orangeDot = [CCSpriteFrame frameWithImageNamed:jOrangenDot];
    grayDot = [CCSpriteFrame frameWithImageNamed:jUnlocked];
    greenHLDot = [CCSpriteFrame frameWithImageNamed:jGreenHighlighted];
    redHLDot = [CCSpriteFrame frameWithImageNamed:jRedHighlighted];
    orangeHLDot = [CCSpriteFrame frameWithImageNamed:jOrangeHighlighted];
    grayHLDot = [CCSpriteFrame frameWithImageNamed:jUnlockedHighlighted];
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
    [self setActiveButtons];
    // get any saved data for the journey
    [self setUpCurrentSavedData];
}

-(void) setActiveButtons {
    // Create an array of all the journey nodes
    NSArray* buttonArray = [[NSArray alloc] initWithObjects:_stop1, _stop2, _stop3, nil];
    for (CCButton* button in buttonArray) {
        // get the button name
        NSString* buttonName = button.name;
        // Get the last number value
        NSString* buttonNum = [buttonName substringFromIndex:[buttonName length] - 1];
        // convert to integer
        NSInteger buttonInt = [buttonNum integerValue];
        // if this is higher than the current hghest level, hide it
        if (buttonInt <= self.highestPlayableStop) {
            [button setVisible:true];
            button.userInteractionEnabled = true;
            [button setBackgroundSpriteFrame:grayDot forState:CCControlStateNormal];
            [button setBackgroundSpriteFrame:grayHLDot forState:CCControlStateHighlighted];
            [button setBackgroundSpriteFrame:grayHLDot forState:CCControlStateSelected];
        }
    }
}

-(void) setUpCurrentSavedData {
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
                [self setUpStop:object];
            }
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
                            [self setButtonImage:_stop1 forEnergy:energyLevel];
                            NSLog(@"Setting first button");
                            break;
                        case 2:
                            [self setButtonImage:_stop2 forEnergy:energyLevel];
                             NSLog(@"Setting second button");
                            break;
                        case 3:
                            [self setButtonImage:_stop3 forEnergy:energyLevel];
                             NSLog(@"Setting third button");
                            break;
                        default:
                            break;
                    }
                }
                
            }
        }
}

-(void) setButtonImage:(CCButton*)button forEnergy:(CGFloat)energy {
    NSLog(@"selected stop energy level: %f", energy);
    if (energy > .5) {
        // green image
         NSLog(@"button should be green");
        [button setBackgroundSpriteFrame:greenDot forState:CCControlStateNormal];
        [button setBackgroundSpriteFrame:greenHLDot forState:CCControlStateHighlighted];
        [button setBackgroundSpriteFrame:greenHLDot forState:CCControlStateSelected];
    } else if (energy > .3) {
        // orange image
         NSLog(@"button should be orange");
        [button setBackgroundSpriteFrame:orangeDot forState:CCControlStateNormal];
        [button setBackgroundSpriteFrame:orangeHLDot forState:CCControlStateHighlighted];
        [button setBackgroundSpriteFrame:orangeHLDot forState:CCControlStateSelected];
    } else if (energy > 0) {
        // red
         NSLog(@"button should be red");
        [button setBackgroundSpriteFrame:redDot forState:CCControlStateNormal];
        [button setBackgroundSpriteFrame:redHLDot forState:CCControlStateHighlighted];
        [button setBackgroundSpriteFrame:redHLDot forState:CCControlStateSelected];
    } else {
        // dark grey
         NSLog(@"button should be grey");
        [button setBackgroundSpriteFrame:grayDot forState:CCControlStateNormal];
        [button setBackgroundSpriteFrame:grayHLDot forState:CCControlStateHighlighted];
        [button setBackgroundSpriteFrame:grayHLDot forState:CCControlStateSelected];
    }

}

-(void )selectedFirstStop {
    NSLog(@"User selected a stop");
    selectedStop = 1;
    [self setButtonAndStop:_stop1];
}

-(void) setButtonAndStop:(CCButton*) button {
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
                [self setButtonImage:button forEnergy:energyLevel];
            }
        }
    }
}


-(void) selectedSecondStop {
    selectedStop = 2;
    [self setButtonAndStop:_stop2];
}

-(void) selectedThirdStop {
    selectedStop = 3;
    [self setButtonAndStop:_stop3];
}


-(void)shouldReturnToMap {
    // Return to the main map
    CCScene* scene = [CCBReader loadAsScene:@"Map"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
    
}

-(void)shouldPlaySelectedLevel {
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
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}

@end