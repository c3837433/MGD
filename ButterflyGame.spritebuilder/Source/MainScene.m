
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
#import "GameData.h"
#import "GameScore.h"
#import "LocalLeaderboard.h"


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
    CCButton* _leaderBoardButton;
    CCButton* _achievementButton;
    NSUserDefaults* defaults;
    CCButton* _gameCenterButton;
    
    CCButton* _tutorialButton;
    CCButton* _creditsButton;
    CCButton* _loadGameCenterButton;
    NSArray* mainButtons;
    
}

#pragma mark - LOAD AND UNLOAD
//Once the game file loads, allow user interaction so the player can view the game scene
- (void)didLoadFromCCB {
    
    mainButtons = [[NSArray alloc] initWithObjects:_loadGameCenterButton, _tutorialButton, _creditsButton, _playersButton, _leaderBoardButton, _achievementButton, nil];
    
    if (!self.returnFromMap) {
        NSLog(@"Not returning from map");
        // Fresh load, set defaults
        self.currentPlayerSelected = NO;
        self.connectedToGameCenter = YES;
    }

    self.selectedNonGameCenterPlayer = false;
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
        // Hide the game center button
        _gameCenterButton.visible = false;
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


#pragma  mark - LOCAL PLAYER SELECTION TO CHOOSE A NEW PLAYER
-(void) shouldOpenPlayerView {
    // disable the remaining buttons
    for (CCButton* button in mainButtons) {
        button.enabled = false;
    }
    // If we are switching users, update the saved data with the local user's current data
    [self updatePlayerArrayWithLocalUsersCurrentData];
    if (self.connectedToGameCenter) {
        // Set up game center player
        [self getGameCenterPlayerSetUp];
        _gameCenterButton.visible = true;
        _gameCenterButton.title = [GKLocalPlayer localPlayer].alias;
    } else {
        _gameCenterButton.visible = false;
    }
    // Get the available players on the device
    if (self.playerArray != nil) {
        //NSLog(@"Player array: %@ total:%lu", self.playerArray.description, self.playerArray.count);
       
        if (self.playerArray.count >= 1) {
          //  NSLog(@"We have saved players");
            NSArray* buttonArray = [[NSArray alloc] initWithObjects:_playerOneButton, _playerTwoButton, _playerThreeButton, _playerFourButton, nil];
            for (int i = 0; i < self.playerArray.count; i++) {
                CCButton* button = buttonArray[i];
                Player* player = self.playerArray[i];
            //    NSLog(@"Player name: %@", player.playerName);
                button.title = player.playerName;
            }
        }
    }
    _playerSelectNode.visible = true;
}

-(void)getGameCenterPlayerSetUp {
    Player* gameCenterPlayer = [GameData sharedGameData].gameCenterPlayer;
    if (![gameCenterPlayer.playerName isEqualToString:[GKLocalPlayer localPlayer].alias]) {
        // set this as a new player
        Player* newPlayer = [[Player alloc] init];
       // NSLog(@"Need to create a new game center player");
        newPlayer.gameCenterPlayer = true;
        newPlayer.highestAStop = 1;
        newPlayer.highestBStop = 1;
        newPlayer.highestCStop = 1;
        newPlayer.highestDStop = 1;
        newPlayer.highestEStop = 1;
        newPlayer.highestJourney = 1;
        newPlayer.playerName = [GKLocalPlayer localPlayer].alias;
        [GameData sharedGameData].gameCenterPlayer = newPlayer;
        [[GameData sharedGameData] save];
    }

}

// WHEN USER SWITCHES PLAYERS, MAKE SURE ANY NEW DATA IS SAVED
-(void)updatePlayerArrayWithLocalUsersCurrentData {
    Player* localPlayer = [GameData sharedGameData].gameLocalPlayer;
    if (localPlayer.playerName != nil) {
      //  NSLog(@"Retrieved local player: %@", localPlayer.playerName);
        // search for the matching player name in the local players
        self.playerArray = [[NSMutableArray alloc] initWithArray:[GameData sharedGameData].gamePlayers];
      //  NSLog(@"Player objects: %lu", [GameData sharedGameData].gamePlayers.count);
        for (Player* player in self.playerArray) {
            if ([player.playerName isEqualToString:localPlayer.playerName]) {
        //        NSLog(@"Found local player in player array: %@", player.playerName);
                [self.playerArray removeObject:player];
          //      NSLog(@"Player objects: %lu", self.playerArray.count);
                break;
            }
        }
        // add the current local player back to the player array
        [self.playerArray addObject:localPlayer];
        NSLog(@"Player objects: %lu", self.playerArray.count);
        [GameData sharedGameData].gamePlayers = self.playerArray;
        NSLog(@"Player objects: %lu", [GameData sharedGameData].gamePlayers.count);
        [[GameData sharedGameData] save];
        NSLog(@"Player objects: %lu", [GameData sharedGameData].gamePlayers.count);
    }
}


// When the user presses the play button
#pragma mark - NAVIGATION
- (void) startGame {
    // if we are not connected to game center make sure we have a current player
    if (!self.currentPlayerSelected) {
        if (self.connectedToGameCenter) {
            NSLog(@"Starting with current game center player");
            [self getGameCenterPlayerSetUp];
            CCScene* scene = [CCBReader loadAsScene:@"Map"];
            Map* map = [[scene children] firstObject];
            map.connectedToGameCenter = self.connectedToGameCenter;
            CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
            [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
        } else {
            NSLog(@"Trying to start game without player, loading player view");
            [self shouldOpenPlayerView];
        }
    }
    else {
        CCScene* scene = [CCBReader loadAsScene:@"Map"];
        Map* map = [[scene children] firstObject];
        map.connectedToGameCenter = self.connectedToGameCenter;
        if (self.connectedToGameCenter && self.selectedNonGameCenterPlayer) {
            //[GameData sharedGameData].gameCenterPlayer = self.gameCenterPlayer;
            map.connectedToGameCenter = false;
            [GameData sharedGameData].gameLocalPlayer = self.player;
            NSLog(@"Connected to game center, but playing with local player");
        } else if (!self.connectedToGameCenter){
            NSLog(@"playing with local player");
            [GameData sharedGameData].gameLocalPlayer = self.player;
        } else {
            NSLog(@"playing with game center player");
            
        }
        
        NSLog(@"Moving to map with player");
        CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
        [[CCDirector sharedDirector] presentScene:scene withTransition:transition];

    }
}

-(void)shouldStartTutorial {
    [animationManager setPaused:YES];
    // Switch to the tutorial
    CCScene* scene = [CCBReader loadAsScene:@"Tutorial"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}

-(void) shouldOpenCredits {
    [animationManager setPaused:YES];
    // Switch to the credits
    CCScene* scene = [CCBReader loadAsScene:@"Credits"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}

-(void) shouldOpenAchievements {
    CCLOG(@"User clicked achievements button");
}

-(void) shouldOpenLeaderboards {
    CCLOG(@"User clicked leaderboard button");
    if (self.currentPlayerSelected) {
        CCScene* scene = [CCBReader loadAsScene:@"LocalLeaderboard"];
        LocalLeaderboard* leaderboard = [[scene children] firstObject];
        leaderboard.currentPlayer = self.player;
        NSLog(@"Moving to map with player");
        CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
        [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
    } else {
        // have user select a player first
        [self shouldOpenPlayerView];
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
    } else if ([selectedPlayerButton.name isEqualToString:@"GameCenter"]) {
        self.currentPlayerSelected = true;
        // close the view
        [self shouldClosePlayerView];
        self.selectedNonGameCenterPlayer = false;
        self.player = [GameData sharedGameData].gameCenterPlayer;
    } else {
        // Find the current player
        for (Player* player in self.playerArray) {
            // find the matching name
            if ([player.playerName isEqualToString:buttonTitle]) {
                NSLog(@"Found matching player name: %@ for selected name: %@", player.playerName, buttonTitle);
                self.player = player;
            }
        }
        self.currentPlayerSelected = true;
        // close the view
        [self shouldClosePlayerView];
        if (self.connectedToGameCenter) {
            self.selectedNonGameCenterPlayer = true;
        }
    }
    
}

// WHEN USER SELECTS AN EMPTY SLOT CREATE A NEW PLAYER
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString* enteredText = [[alertView textFieldAtIndex:0] text];
    if (![enteredText isEqualToString:@""]) {
        NSLog(@"Creating a new player for user entered name: %@", enteredText);
        // Create a new player
        Player* newPlayer = [[Player alloc] init];
        newPlayer.playerName = enteredText;
        newPlayer.gameCenterPlayer = false;
        newPlayer.highestAStop = 1;
        newPlayer.highestBStop = 1;
        newPlayer.highestCStop = 1;
        newPlayer.highestDStop = 1;
        newPlayer.highestEStop = 1;
        newPlayer.highestJourney = 1;
        [self.playerArray addObject:newPlayer];
        [GameData sharedGameData].gamePlayers = self.playerArray;
        [[GameData sharedGameData] save];
        self.player = newPlayer;
        NSLog(@"Game data:%@", newPlayer.description);
        NSLog(@"Total players: %lu", [GameData sharedGameData].gamePlayers.count);
        NSLog(@"Current Player:%@", self.player.playerName);

        self.currentPlayerSelected = true;
        [self shouldClosePlayerView];
        if (self.connectedToGameCenter) {
            self.selectedNonGameCenterPlayer = true;
        }
    }
}
-(void) shouldClosePlayerView {
    _playerSelectNode.visible = false;
    for (CCButton* button in mainButtons) {
        button.enabled = true;
    }
}

-(void) shouldOpenGameCenter {
    if (self.connectedToGameCenter) {
        // load game center
        [[ABGameKitHelper sharedHelper] showLeaderboard:@"com.Smith.Angela.ButterflyGame.Scores"];
    }
}

@end
