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
#import "GameData.h"
#import "Player.h"
#import "Score.h"


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


// Load the game scene
+(void)shouldPlaySelectedLevelStop:(NSInteger)selectedStop andHighestStop:(NSInteger)highestStop forJourney:(NSString*)journey withPlayer:(Player*)player  {
    // Just load the same game
    CCScene* scene = [CCBReader loadAsScene:@"GameScene"];
    GameScene* gameScene = [[scene children] firstObject];
    gameScene.currentStop = selectedStop;
    //gameScene.player = player;
    //gameScene.sessionConnectedToGC = isConnected;
    if (selectedStop == highestStop) {
        gameScene.forUnlock = YES;
        NSLog(@"This is for unlocking");
    }
    gameScene.currentJourney = journey;
    
    [[CCDirector sharedDirector] replaceScene:scene];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}

+(void) updateGameCenterPlayerWithGameCenterData {
    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error) {
        if (error == nil) {
            for (GKAchievement* achievement in achievements) {
                NSLog(@"gathering achievement: %@ data", achievement.identifier);
                if ([achievement.identifier isEqualToString:@"Butterfly.Unlock.First.Level"]) {
                    [self updateUnlockAchievement:achievement];
                } else if ([achievement.identifier isEqualToString:@"Butterfly.Gather.A"]) {
                    [self updateGatherTen:achievement];
                } else if ([achievement.identifier isEqualToString:@"Butterfly.Gather.B"]) {
                    [self updateGatherFifty:achievement];
                } else if ([achievement.identifier isEqualToString:@"Butterfly.Gather.C"]) {
                    [self updateGatherOneHundred:achievement];
                } else if ([achievement.identifier isEqualToString:@"Butterfly.Completion.A"]) {
                    [self updateCompleteJourneyA:achievement];
                } else if ([achievement.identifier isEqualToString:@"Butterfly.Completion.B"]) {
                    [self updateCompleteJourneyB:achievement];
                } else if ([achievement.identifier isEqualToString:@"Butterfly.Completion.C"]) {
                    [self updateCompleteJourneyC:achievement];
                } else if ([achievement.identifier isEqualToString:@"Butterfly.Completion.D"]) {
                    [self updateCompleteJourneyD:achievement];
                } else if ([achievement.identifier isEqualToString:@"Butterfly.Completion.E"]) {
                    [self updateCompleteJourneyE:achievement];
                } else if ([achievement.identifier isEqualToString:@"Butterfly.Death"]) {
                    [self updateEnemyKills:achievement];
                }
            }
               NSLog(@"Saving active player data with game center player data");
            // When done updating the active player data, save that data to the game center player
            [GameData sharedGameData].gameCenterPlayer = [GameData sharedGameData].gameActivePlayer;
            [[GameData sharedGameData] save];
        }
    }];

}

// ACHIEVEMENT 1 UNLOCK FIRST STOP
+(void) updateUnlockAchievement:(GKAchievement*)achievement {
    if (achievement != nil) {
        [GameData sharedGameData].gameActivePlayer.completedUnlock = (achievement.percentComplete == 100.0) ? true : false;
        [[GameData sharedGameData] save];
    }
}

// ACHIEVEMENTS 2-4 GATHER 10 - 100 NECTAR
+(void) updateGatherTen:(GKAchievement*)achievement {
    if (achievement != nil) {
           NSLog(@"Updating gather ten with %f complete", achievement.percentComplete);
        if (achievement.percentComplete == 100.0) {
            [GameData sharedGameData].gameActivePlayer.completedNectar10 = true;
            [[GameData sharedGameData] save];
        } else {
            if (achievement.percentComplete > 0.0) {
                [GameData sharedGameData].gameActivePlayer.numberOfNectarGathered = achievement.percentComplete /10;
            }
            [GameData sharedGameData].gameActivePlayer.completedNectar10 = false;
            [[GameData sharedGameData] save];
        }

    }
}

+(void) updateGatherFifty:(GKAchievement*)achievement {
    if (achievement != nil) {
          NSLog(@"Updating gather fifty with %f complete", achievement.percentComplete);
        if (achievement.percentComplete == 100.0) {
            [GameData sharedGameData].gameActivePlayer.completedNectar50 = true;
            [[GameData sharedGameData] save];
        } else {
            if (achievement.percentComplete > 0.0) {
                [GameData sharedGameData].gameActivePlayer.numberOfNectarGathered = achievement.percentComplete /2;
            }
            [GameData sharedGameData].gameActivePlayer.completedNectar50 = false;
            [[GameData sharedGameData] save];
        }
    }
}

+(void) updateGatherOneHundred:(GKAchievement*)achievement {
    if (achievement != nil) {
          NSLog(@"Updating gather one hundred with %f complete", achievement.percentComplete);
        if (achievement.percentComplete == 100.0) {
            [GameData sharedGameData].gameActivePlayer.completedNectar100 = true;
        } else {
            if (achievement.percentComplete > 0.0) {
                [GameData sharedGameData].gameActivePlayer.numberOfNectarGathered = achievement.percentComplete;
            }
            [GameData sharedGameData].gameActivePlayer.completedNectar100 = false;
        }
        [[GameData sharedGameData] save];
    }
}
// ACHIEVEMENTS 5-9 COMPLETE JOURNEYS 1-5
+(void) updateCompleteJourneyA:(GKAchievement*)achievement {
    if (achievement != nil) {
          NSLog(@"Updating journey a with %f complete", achievement.percentComplete);
        if (achievement.percentComplete == 100.0) {
            [GameData sharedGameData].gameActivePlayer.completedJourney1 = true;
            [GameData sharedGameData].gameActivePlayer.highestJourney = 2;
            [GameData sharedGameData].gameActivePlayer.highestAStop = 3;
        } else {
            [GameData sharedGameData].gameActivePlayer.completedJourney1 = false;
            [GameData sharedGameData].gameActivePlayer.highestJourney = 1;
            if (achievement.percentComplete == 33) {
                [GameData sharedGameData].gameActivePlayer.highestAStop = 2;
            } else if (achievement.percentComplete == 66) {
                [GameData sharedGameData].gameActivePlayer.highestAStop = 3;
            } else {
                [GameData sharedGameData].gameActivePlayer.highestAStop = 1;
            }
        }
        [[GameData sharedGameData] save];
    }
}

+(void) updateCompleteJourneyB:(GKAchievement*)achievement {
    if (achievement != nil) {
          NSLog(@"Updating journey b with %f complete", achievement.percentComplete);
        if (achievement.percentComplete == 100.0) {
            [GameData sharedGameData].gameActivePlayer.completedJourney2 = true;
            [GameData sharedGameData].gameActivePlayer.highestJourney = 3;
            [GameData sharedGameData].gameActivePlayer.highestBStop = 3;
        } else {
            [GameData sharedGameData].gameActivePlayer.completedJourney2 = false;
            if (achievement.percentComplete == 33) {
                [GameData sharedGameData].gameActivePlayer.highestBStop = 2;
            } else if (achievement.percentComplete == 66) {
                [GameData sharedGameData].gameActivePlayer.highestBStop = 3;
            } else {
                [GameData sharedGameData].gameActivePlayer.highestBStop = 1;
            }

        }
        [[GameData sharedGameData] save];
    }
}

+(void) updateCompleteJourneyC:(GKAchievement*)achievement {
    if (achievement != nil) {
          NSLog(@"Updating journey c with %f complete", achievement.percentComplete);
        if (achievement.percentComplete == 100.0) {
            [GameData sharedGameData].gameActivePlayer.completedJourney3 = true;
            [GameData sharedGameData].gameActivePlayer.highestJourney = 4;
            [GameData sharedGameData].gameActivePlayer.highestCStop = 4;
        } else {
            [GameData sharedGameData].gameActivePlayer.completedJourney3 = false;
            if (achievement.percentComplete == 25) {
                [GameData sharedGameData].gameActivePlayer.highestCStop = 2;
            } else if (achievement.percentComplete == 50) {
                [GameData sharedGameData].gameActivePlayer.highestCStop = 3;
            } else if (achievement.percentComplete == 75) {
                [GameData sharedGameData].gameActivePlayer.highestCStop = 4;
            } else {
                [GameData sharedGameData].gameActivePlayer.highestCStop = 1;
            }

        }
        [[GameData sharedGameData] save];
    }
}

+(void) updateCompleteJourneyD:(GKAchievement*)achievement {
    if (achievement != nil) {
          NSLog(@"Updating journey d with %f complete", achievement.percentComplete);
        if (achievement.percentComplete == 100.0) {
            [GameData sharedGameData].gameActivePlayer.completedJOurney4 = true;
            [GameData sharedGameData].gameActivePlayer.highestJourney = 5;
            [GameData sharedGameData].gameActivePlayer.highestCStop = 4;
        } else {
            [GameData sharedGameData].gameActivePlayer.completedJOurney4 = false;
            if (achievement.percentComplete == 25) {
                [GameData sharedGameData].gameActivePlayer.highestDStop = 2;
            } else if (achievement.percentComplete == 50) {
                [GameData sharedGameData].gameActivePlayer.highestDStop = 3;
            } else if (achievement.percentComplete == 75) {
                [GameData sharedGameData].gameActivePlayer.highestDStop = 4;
            } else {
                [GameData sharedGameData].gameActivePlayer.highestDStop = 1;
            }
        }
        [[GameData sharedGameData] save];
    }
}

+(void) updateCompleteJourneyE:(GKAchievement*)achievement {
    if (achievement != nil) {
          NSLog(@"Updating journey e with %f complete", achievement.percentComplete);
        if (achievement.percentComplete == 100.0) {
            [GameData sharedGameData].gameActivePlayer.completedJourney5 = true;
            [GameData sharedGameData].gameActivePlayer.highestJourney = 5;
            [GameData sharedGameData].gameActivePlayer.highestCStop = 5;
        } else {
            [GameData sharedGameData].gameActivePlayer.completedJourney5 = false;
            if (achievement.percentComplete == 20) {
                [GameData sharedGameData].gameActivePlayer.highestEStop = 2;
            } else if (achievement.percentComplete == 40) {
                [GameData sharedGameData].gameActivePlayer.highestEStop = 3;
            } else if (achievement.percentComplete == 60) {
                [GameData sharedGameData].gameActivePlayer.highestEStop = 4;
            } else if (achievement.percentComplete == 80) {
                [GameData sharedGameData].gameActivePlayer.highestEStop = 5;
            } else {
                [GameData sharedGameData].gameActivePlayer.highestEStop = 1;
            }

        }
        [[GameData sharedGameData] save];
    }
}


// ACHIEVEMENT 10 DIE 10 TIMES
+(void) updateEnemyKills:(GKAchievement*)achievement {
    if (achievement != nil) {
          NSLog(@"Updating enemy kills with %f complete", achievement.percentComplete);
        if (achievement.percentComplete == 100.0) {
            [GameData sharedGameData].gameActivePlayer.completedDeath = true;
            [GameData sharedGameData].gameActivePlayer.numberOfSpiderDeaths = 10;
            [[GameData sharedGameData] save];
        } else {
            if (achievement.percentComplete > 0.0) {
                [GameData sharedGameData].gameActivePlayer.numberOfSpiderDeaths = achievement.percentComplete / 10;
            }
            [GameData sharedGameData].gameActivePlayer.completedDeath = false;
            [[GameData sharedGameData] save];
        }
    }
}

@end
