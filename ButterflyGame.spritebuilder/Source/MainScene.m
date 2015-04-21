
//  ButterflyGame
//
//  Created by Angela Smith on 3/4/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "ABGameKitHelper.h"
#import "LeaderboardPosition.h"
#import "Constants.h"
#import "Map.h"
#import "GamePlayer.h"
@implementation MainScene {

    CCSprite* _mainButterfly;
    CCAnimationManager* animationManager;
    NSMutableArray* playersTopScores;
    CCNode* _playerSelectNode;
    CCButton* _playerOneButton;
    CCButton* _playerTwoButton;
    CCButton* _playerThreeButton;
    CCButton* _playerFourButton;
    CCButton* selectedPlayerButton;
    CCButton* _playersButton;
    NSUserDefaults* defaults;
    
    
}

#pragma  mark - LOCAL PLAYER SELECTION
-(void) shouldOpenPlayerView {
    /*
    self.playerArray = [[NSMutableArray alloc] init];
    // Search local data store for all players saved on the device
    PFQuery* playerQuery = [GamePlayer query];
    [playerQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self.playerArray removeAllObjects];
            if (objects.count > 0) {
                NSLog(@"We have saved players");
                NSArray* buttonArray = [[NSArray alloc] initWithObjects:_playerOneButton, _playerTwoButton, _playerThreeButton, _playerFourButton, nil];
                for (int i = 0; i < objects.count; i++) {
                    CCButton* button = buttonArray[i];
                    GamePlayer* player = objects[i];
                    button.title = player.gamePlayerName;
                    [self.playerArray addObject:player];
                }
            }
        }
    }];
    _playerSelectNode.visible = true;*/
    self.playerArray = [[NSMutableArray alloc] initWithArray:[GameData sharedGameData].gamePlayers];
    // see if we have a current player set
    /*NSString* currentPlayer = [defaults objectForKey:dLocalCurrentPlayer];
    if ((currentPlayer != nil) && ([currentPlayer isEqualToString:@""])) {
        NSLog(@"current player: %@", currentPlayer);
    }*/
    // Get the available players on the device
    if (self.playerArray != nil) {
        
    }
    /*
    NSData* playerData = [defaults objectForKey:dLocalPlayerArray];
    if (playerData != nil) {
        NSArray* dataArray = [NSKeyedUnarchiver unarchiveObjectWithData:playerData];
        if (dataArray != nil)
            self.playerArray = [[NSMutableArray alloc] initWithArray:dataArray];
        else
            self.playerArray = [[NSMutableArray alloc] init];
    }*/
    
    // see if we have player data saved
    //NSData* playerData = [defaults objectForKey:dLocalPlayerArray];
    //self.playerArray = [NSKeyedUnarchiver unarchiveObjectWithData:playerData];
    NSLog(@"Player array: %@", self.playerArray.description);
    for (Player* player in self.playerArray) {
        NSLog(@"Player: %@", player.description);
    }
    if (self.playerArray > 0) {
        NSLog(@"We have saved players");
        NSArray* buttonArray = [[NSArray alloc] initWithObjects:_playerOneButton, _playerTwoButton, _playerThreeButton, _playerFourButton, nil];
        for (int i = 0; i < self.playerArray.count; i++) {
            CCButton* button = buttonArray[i];
            Player* player = self.playerArray[i];
            button.title = player.playerName;
        }
    }
    _playerSelectNode.visible = true;

}

//Once the game file loads, allow user interaction so the player can view the game scene
- (void)didLoadFromCCB {
    self.connectedToGameCenter = YES;
    self.currentPlayerSelected = NO;
    defaults = [NSUserDefaults standardUserDefaults];
    // Add the listener for the return on whether we connected or not (default set in app delegate)
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(defaultsChanged:)
                   name:NSUserDefaultsDidChangeNotification
                 object:nil];
    // attempt to connect to game center
    [ABGameKitHelper sharedHelper];
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    animationManager = _mainButterfly.animationManager;
    [animationManager runAnimationsForSequenceNamed:@"FlapFacing"];
    if ([[defaults objectForKey:@"Butterfly.GameCenter.Connected"] isEqualToString:@"NO"]) {
        // make sure the players button is visible
        _playersButton.visible = true;
        self.connectedToGameCenter = NO;
        NSLog(@"User is not connected to game center");
    }
    // Preload the music
    //[[OALSimpleAudio sharedInstance] preloadBg:@"background_music.mp3"];
}

// ON NSUSER DEFAULT CHANGE, CHECK IF WE ARE NOT CONNECTED TO GAME CENTER
- (void)defaultsChanged:(NSNotification *)notification {
    // Get the user defaults
    if ([[defaults objectForKey:@"Butterfly.GameCenter.Connected"] isEqualToString:@"NO"]) {
        // make sure the players button is visible
        _playersButton.visible = true;
        self.connectedToGameCenter = NO;
        NSLog(@"User is not connected to game center");
    }
}

// REMOVE NOTIFICATION LISTENER
-(void) onExit {
    [super onExit];
    // remove the notification center listener
    NSLog(@"removing the game center listener");
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:NSUserDefaultsDidChangeNotification object:nil];
}

/*
-(void) pullLeaderBoardInfo {
    GKLeaderboardSet* leaderBoardSet = [[GKLeaderboardSet alloc] init];
    leaderBoardSet.identifier = @"Butterfly.All.Stops";
    // Get just our friends
    //leaderBoard.playerScope = GKLeaderboardPlayerScopeFriendsOnly;
    // and only top three
    //leaderBoard.range = NSMakeRange(1, 3);
    playersTopScores = [[NSMutableArray alloc] init];
    if (leaderBoardSet != nil) {
        //NSLog(@"Leaderboards are loading");
        [leaderBoardSet loadLeaderboardsWithCompletionHandler:^(NSArray *leaderboards, NSError *error) {
            if (leaderboards != nil) {
                [self getLeaderBoardScores:leaderboards];
            }
        }];
    }
}

-(void)getLeaderBoardScores:(NSArray*)leaderboards {
    //NSLog(@"There are %lu leaderboards to check", (unsigned long)leaderboards.count);
    self.boardsChecked = 0;
    [playersTopScores removeAllObjects];
    for (GKLeaderboard* leaderboard in leaderboards) {
        leaderboard.playerScope = GKLeaderboardPlayerScopeFriendsOnly ;
        leaderboard.timeScope = GKLeaderboardTimeScopeAllTime;
        //leaderboard.timeScope = GKLeaderboardTimeScopeWeek;
        
        [leaderboard loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
            GKScore* playerScore = leaderboard.localPlayerScore;
            self.boardsChecked ++;
            if (playerScore != nil) {
                LeaderboardPosition* positionScore = [[LeaderboardPosition alloc] init];
                positionScore.leaderScore = playerScore.formattedValue;
                positionScore.leaderScoreValue = playerScore.value;
                positionScore.leaderboardRank = [NSString stringWithFormat:@"%ld", (long)playerScore.rank];
                positionScore.leaderboardName = playerScore.leaderboardIdentifier;
                [playersTopScores addObject:positionScore];
                //NSLog(@"The local player's score: %@", playerScore.description);
                //NSLog(@"The position score: %@", positionScore.description);
            }
            if (self.boardsChecked == leaderboards.count) {
                [self sortLeaderboards];
            }

        }];
    }
}

-(void) sortLeaderboards {
    //NSLog(@"Finished loading boards: %@", playersTopScores.description);
    //for (LeaderboardPosition* position in playersTopScores) {
        //NSLog(@"Score: %@", position.leaderScore);
    //}
    
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"leaderScoreValue" ascending:NO];
    [playersTopScores sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
    //NSLog(@"Sorted array count: %lu", (unsigned long)playersTopScores.count);
    for (LeaderboardPosition* position in playersTopScores) {
        NSLog(@"Sorted Score: %@", position.leaderScore);
    }
}
*/
// When the user presses the play button
- (void) startGame {
    // if we are not connected to game center make sure we have a current player
    if ((!self.connectedToGameCenter) && (!self.currentPlayerSelected)) {
        NSLog(@"Trying to start game without player, loading player view");
        // load the player selection anyway
        [self shouldOpenPlayerView];
    } else {
        NSLog(@"Opening map, getting player");
        CCScene* scene = [CCBReader loadAsScene:@"Map"];
        Map* map = [[scene children] firstObject];
        map.connectedToGameCenter = self.connectedToGameCenter;
        if (!self.connectedToGameCenter) {
            map.currentPlayer = self.player;
            //map.player = self.currentPlayer;
            NSLog(@"Setting current player to selected player");
        } else {
            // see if we have a current player with this alias
            /*
            for (GamePlayer* player in self.playerArray) {
                if ([player.gamePlayerName isEqualToString:[GKLocalPlayer localPlayer].alias]) {
                    NSLog(@"Found a previous game center player named: %@", [GKLocalPlayer localPlayer].alias);
                    map.player = player;
                }
            }
            if (map.player == nil) {
                NSLog(@"No game center player found, creating a new one named: %@", [GKLocalPlayer localPlayer].alias);
                // create a new player with this alias
                GamePlayer* newPlayer = [GamePlayer object];
                newPlayer.gamePlayerName = [GKLocalPlayer localPlayer].alias;
                newPlayer.highestJourney = 1;
                newPlayer.highestAStop = 1;
                newPlayer.highestBStop = 1;
                newPlayer.highestCStop = 1;
                newPlayer.highestDStop = 1;
                newPlayer.highestEStop = 1;
                [newPlayer pinInBackground];
                [self.playerArray addObject:newPlayer];
                map.player = newPlayer;

            } */
        }
        NSLog(@"Moving to map with player");
        CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
        [[CCDirector sharedDirector] presentScene:scene withTransition:transition];

    }
}

-(void)shouldStartTutorial {
    [animationManager setPaused:YES];
    // Switch to the game scene
    CCScene* scene = [CCBReader loadAsScene:@"Tutorial"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];


}

-(void) shouldOpenCredits {
    [animationManager setPaused:YES];
    // Switch to the game scene
    CCScene* scene = [CCBReader loadAsScene:@"Credits"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];

}

-(void) shouldOpenAchievements {
    CCLOG(@"User clicked achievements button");
}

-(void) shouldOpenLeaderboards {
    CCLOG(@"User clicked leaderboard button");
    if (self.connectedToGameCenter) {
        // load game center
        [[ABGameKitHelper sharedHelper] showLeaderboard:@"com.Smith.Angela.ButterflyGame.Scores"];
        // search all leaderbaords for top score
        //[self pullLeaderBoardInfo];
    } else {
        // load the local leaderboard
        NSLog(@"Need to load the local leaderboard");

    }
}

#pragma  mark - Player select methods
-(void)selectedPlayerButton:(id)sender {
    selectedPlayerButton = (CCButton*)sender;
    NSString* buttonTitle = selectedPlayerButton.title;
        NSLog(@"User selected button with title: %@", buttonTitle);
    if ([buttonTitle isEqualToString:@"Add Player"]) {
        // create a new player
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Enter Player Name" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
    } else {
        // Set the current player
        /*
        for (GamePlayer* player in self.playerArray) {
            // find the matching name
            if ([player.gamePlayerName isEqualToString:buttonTitle]) {
                NSLog(@"Found matching player name: %@ for selected name: %@", player.gamePlayerName, buttonTitle);
                self.currentPlayer = player;
            }
        }*/
        for (Player* player in self.playerArray) {
            // find the matching name
            if ([player.playerName isEqualToString:buttonTitle]) {
                NSLog(@"Found matching player name: %@ for selected name: %@", player.playerName, buttonTitle);
                self.player = player;
            }
        }
        [defaults setObject:buttonTitle forKey:dLocalCurrentPlayer];
        [defaults synchronize];
        self.currentPlayerSelected = true;
        // close the view
        _playerSelectNode.visible = false;
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString* enteredText = [[alertView textFieldAtIndex:0] text];
    if (![enteredText isEqualToString:@""]) {
        NSLog(@"Creating a new player for user entered name: %@", enteredText);
        selectedPlayerButton.title = enteredText;
        // Create a new player
        
        Player* newPlayer = [[Player alloc] init];
        //GamePlayer* newPlayer = [GamePlayer object];
        newPlayer.playerName = enteredText;
        newPlayer.highestJourney = 1;
        newPlayer.highestAStop = 1;
        newPlayer.highestBStop = 1;
        newPlayer.highestCStop = 1;
        newPlayer.highestDStop = 1;
        newPlayer.highestEStop = 1;
        //[newPlayer pinInBackground];
        // add this player to the array
        [self.playerArray addObject:newPlayer];
        [[GameData sharedGameData].gamePlayers addObject:newPlayer];
        [[GameData sharedGameData] save];
        // save this player object to the defaults
        //NSData* playerData = [NSKeyedArchiver archivedDataWithRootObject:self.playerArray];
        //[defaults setObject:playerData forKey:dLocalPlayerArray];
        //[defaults synchronize];
        self.currentPlayerSelected = true;
        _playerSelectNode.visible = false;
        self.player = newPlayer;
        
    }
}
-(void) shouldClosePlayerView {
    _playerSelectNode.visible = false;
}

@end
