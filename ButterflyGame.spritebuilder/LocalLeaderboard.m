//
//  LocalLeaderboard.m
//  ButterflyGame
//
//  Created by Angela Smith on 4/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "LocalLeaderboard.h"
#import "GameData.h"
#import "LeaderboardPosition.h"
#import "GameScore.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "AppDelegate.h"
#import "MainScene.h"

@implementation LocalLeaderboard {
    CCNode* _position1;
    CCNode* _position2;
    CCNode* _position3;
    CCNode* _position4;
    CCNode* _position5;
    
    CCButton* _share1;
    CCButton* _share2;
    CCButton* _share3;
    CCButton* _share4;
    CCButton* _share5;

    CCLabelTTF* _score1;
    CCLabelTTF* _score2;
    CCLabelTTF* _score3;
    CCLabelTTF* _score4;
    CCLabelTTF* _score5;
    
    CCLabelTTF* _leaderName1;
    CCLabelTTF* _leaderName2;
    CCLabelTTF* _leaderName3;
    CCLabelTTF* _leaderName4;
    CCLabelTTF* _leaderName5;
    
    CCLabelTTF* _gameStop1;
    CCLabelTTF* _gameStop2;
    CCLabelTTF* _gameStop3;
    CCLabelTTF* _gameStop4;
    CCLabelTTF* _gameStop5;
    
    NSArray* positionArray;
    NSArray* shareArray;
    NSArray* scoreArray;
    NSArray* playerArray;
    NSArray* stopArray;
    
    CCButton* _myScoresButton;
    CCButton* _allScoresButton;
    NSMutableArray* allScores;
    NSMutableArray* boardScores;
}

-(void)onEnter {
    [super onEnter];
    // Set up the table arrays
    positionArray = [[NSArray alloc] initWithObjects:_position1, _position2, _position3, _position4, _position5, nil];
    shareArray = [[NSArray alloc] initWithObjects:_share1, _share2, _share3, _share4, _share5, nil];
    scoreArray = [[NSArray alloc] initWithObjects:_score1, _score2, _score3, _score4, _score5, nil];
    playerArray = [[NSArray alloc] initWithObjects:_leaderName1, _leaderName2, _leaderName3, _leaderName4, _leaderName5, nil];
    stopArray = [[NSArray alloc] initWithObjects:_gameStop1, _gameStop2, _gameStop3, _gameStop4, _gameStop5, nil];
    // Get all the scores
    allScores = [[NSMutableArray alloc] initWithArray:[GameData sharedGameData].gameScores];
    boardScores = [[NSMutableArray alloc] init];
    self.currentPlayer = [GameData sharedGameData].gameActivePlayer;
    // set up the current players scores
    [self shouldLoadPlayerScores];
    
}

-(void)shouldLoadPlayerScores {
    _myScoresButton.selected = true;
    _allScoresButton.selected = false;
    
     NSMutableArray* leaderScores = [[NSMutableArray alloc] init];
     if (allScores.count >+ 1) {
     //NSLog(@"We have %lu scores", allScores.count);
     // sort by score
     for (GameScore* score in allScores) {
         if ([score.gamePlayer.playerName isEqualToString:self.currentPlayer.playerName]) {
             LeaderboardPosition* positionScore = [[LeaderboardPosition alloc] init];
             positionScore.leaderScore = [NSString stringWithFormat:@"%lu", score.gameScore];
             positionScore.leaderScoreValue = score.gameScore;
             positionScore.leaderName = score.gamePlayer.playerName;
             positionScore.leaderBoardStop = [self getNameForJourney:score.gameJourney andStop:score.gameStop];
             [leaderScores addObject:positionScore];
         }
        }
     }
     NSArray* sortedArray = [self sortLeaderboards:leaderScores];

    // set sorted positions in leaderboard
    [self setScoresInLeaderboard:sortedArray];
}

-(void)shouldLoadAllScores {
    _myScoresButton.selected = false;
    _allScoresButton.selected = true;
    NSMutableArray* leaderScores = [[NSMutableArray alloc] init];
    if (allScores.count >+ 1) {
        NSLog(@"We have %lu scores", allScores.count);
        // sort by score
        for (GameScore* score in allScores) {
            LeaderboardPosition* positionScore = [[LeaderboardPosition alloc] init];
            positionScore.leaderScore = [NSString stringWithFormat:@"%lu", score.gameScore];
            positionScore.leaderScoreValue = score.gameScore;
            positionScore.leaderName = score.gamePlayer.playerName;
            positionScore.leaderBoardStop = [self getNameForJourney:score.gameJourney andStop:score.gameStop];
            [leaderScores addObject:positionScore];
        }
    }
    NSArray* sortedArray = [self sortLeaderboards:leaderScores];
    // set sorted positions in leaderboard
    [self setScoresInLeaderboard:sortedArray];
}

-(NSArray*) sortLeaderboards:(NSMutableArray*)leaders {
   // NSLog(@"Finished loading leaders: %@", leaders.description);
    
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"leaderScoreValue" ascending:NO];
    [leaders sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
    //NSLog(@"Sorted array count: %lu", (unsigned long)playersTopScores.count);
    // now reduce to top five
    if (leaders.count > 5) {
      //  NSLog(@"Returning top 5 scores");
        return [leaders subarrayWithRange:NSMakeRange(0, 5)];
    } else {
      //  NSLog(@"returning 0-3 scores");
        return leaders;
    }
}

-(NSString*)getNameForJourney:(NSString*)journey andStop:(NSInteger)stop {
    NSString* journeyName = @"";
    if ([journey isEqualToString:@"A"]) {
        journeyName = @"Prismo Beach";
    } else if ([journey isEqualToString:@"B"]) {
        journeyName = @"Ellwood";
    } else if ([journey isEqualToString:@"C"]) {
        journeyName = @"El Rosario";
    } else if ([journey isEqualToString:@"D"]) {
        journeyName = @"Sierra Chincua";
    } else if ([journey isEqualToString:@"E"]) {
        journeyName = @"Yucatan";
    }
    return [NSString stringWithFormat:@"%@ %lu", journeyName, stop];
}


// Set the local scores in the leaderboard
-(void)setScoresInLeaderboard:(NSArray*)positions {
    // rehide all current ones
    for (CCNode* positionNode in positionArray) {
        positionNode.visible = false;
    }
   // NSLog(@"Setting %lu positions", positions.count);
    [boardScores removeAllObjects];
   // NSLog(@"LEaderboards: %lu", (unsigned long)leaderboards.count);
    for (int i = 0; i < positions.count; i++) {
       // NSLog(@"Setting position: %u", i);
        LeaderboardPosition* position = positions[i];
        LeaderboardPosition* leader = [[LeaderboardPosition alloc] init];
        leader.leaderNode = positionArray[i];
        leader.leaderNameLabel = playerArray[i];
        leader.leaderScoreLabel = scoreArray[i];
        leader.leaderShareButton = shareArray[i];
        leader.leaderLevelLabel = stopArray[i];
        // set the share button visibility
        if ([position.leaderName isEqualToString:self.currentPlayer.playerName]) {
            leader.leaderIsCurrentUser = true;
            //NSLog(@"This is the current user, show share button");
            [self setButtonVisibility:shareArray[i] visibility:true];
        } else {
            leader.leaderIsCurrentUser = false;
           // NSLog(@"This is not the current user, hide share button");
            [self setButtonVisibility:shareArray[i] visibility:false];
        }
        leader.leaderName = position.leaderName;
        leader.leaderScore = [NSString stringWithFormat:@"%lu", position.leaderScoreValue];
        leader.leaderBoardStop = position.leaderBoardStop;
        leader.leaderShareButton = position.leaderShareButton;
        [boardScores addObject:leader];
    }
    for (LeaderboardPosition* position in boardScores) {
        position.leaderNode.visible = true;
        position.leaderNameLabel.string = position.leaderName;
        position.leaderScoreLabel.string = position.leaderScore;
        position.leaderLevelLabel.string = position.leaderBoardStop;
    }
}
-(void)setButtonVisibility:(CCButton*)button visibility:(BOOL)visibility {
    button.visible = visibility;
}

-(void)shouldReturnToMain {
    // return to the main menu
    CCScene* scene = [CCBReader loadAsScene:@"MainScene"];
    MainScene* mainScene = [[scene children] firstObject];
    // stop it from needing to get a selected player
    mainScene.currentPlayerSelected = true;
    //mainScene.returnFromMap = true;
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}

-(void)shouldShareScore:(id)sender {
    NSLog(@"User wants to share this score");
    // Get the score from the selected score
    CCButton* sendingButton = sender;
    LeaderboardPosition* position = [[LeaderboardPosition alloc] init];
    NSString* buttonName = sendingButton.name;
    if ([buttonName isEqualToString:@"share1"]) {
        // get the values from that position
        position = boardScores[0];
    } else if ([buttonName isEqualToString:@"share2"]) {
        // get the values from that position
        position = boardScores[1];
    } else if ([buttonName isEqualToString:@"share3"]) {
        // get the values from that position
        position = boardScores[2];
    } else if ([buttonName isEqualToString:@"share4"]) {
        // get the values from that position
        position = boardScores[3];
    } else if ([buttonName isEqualToString:@"share5"]) {
        // get the values from that position
        position = boardScores[4];
    }
    NSLog(@"User: %@ wants to share: %@ score: %@", position.leaderName, position.leaderScore, position.leaderBoardStop);
    [self postToFacebook:position];
}

// Post to Facebook
- (void)postToFacebook:(LeaderboardPosition*)position {
  
    // See if we have access to facebook
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        // Get access to the controller
        AppController* appController = (((AppController*)[UIApplication sharedApplication].delegate));
        // And create the compose view
        SLComposeViewController* composeView = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        // set completion handler
        [composeView setCompletionHandler:^(SLComposeViewControllerResult result) {
            NSString* message = (result == SLComposeViewControllerResultDone) ? @"Post was successful" : @"Post was canceled";
            NSLog(@"%@", message);
            [appController.navController dismissViewControllerAnimated:YES completion:Nil];
        }];

        // Get the message
        NSString* message = [NSString stringWithFormat:@"I scored %@ points on Monarch Migration's %@!", position.leaderScore, position.leaderBoardStop];
        [composeView setInitialText:message];
        // Add a generic link to itunes
        [composeView addURL:[NSURL URLWithString:@"http://www.itunes.com"]];
        
        // show the compose view
        [appController.navController presentViewController:composeView animated:YES completion:Nil];
        
    } else {
        NSLog(@"Unable to connect to facebook");
        [[[UIAlertView alloc] initWithTitle:@"On no!" message:@"We are unable to share your score. Please check your Facebook account is logged in and try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
}

@end
