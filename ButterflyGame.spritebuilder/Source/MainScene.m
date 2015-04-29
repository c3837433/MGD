
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
#import "Utility.h"

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
    // To reset all Game Center achievements
    //[[ABGameKitHelper sharedHelper] resetAchievements];
    
    // Set up the buttons
    mainButtons = [[NSArray alloc] initWithObjects:_loadGameCenterButton, _tutorialButton, _creditsButton, _playersButton, _leaderBoardButton, _achievementButton, nil];
    // search for the matching player name in the local players
    self.playerArray = [[NSMutableArray alloc] initWithArray:[GameData sharedGameData].gamePlayers];
    defaults = [NSUserDefaults standardUserDefaults];
    // Add the listener for the return on whether we connected or not (default set in app delegate)
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(defaultsChanged:)
                   name:NSUserDefaultsDidChangeNotification
                 object:nil];
    
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    animationManager = _mainButterfly.animationManager;
    [animationManager runAnimationsForSequenceNamed:@"FlapFacing"];
    if ([[defaults objectForKey:@"Butterfly.GameCenter.Connected"] isEqualToString:@"NO"]) {
        // make sure the players button is visible
        _playersButton.visible = true;
       // self.connectedToGameCenter = NO;
        NSLog(@"User is not connected to game center");
    }
    // Preload the music
    [[OALSimpleAudio sharedInstance] preloadBg:@"background_music.mp3"];
}

// ON NSUSER DEFAULT CHANGE, CHECK IF WE ARE NOT CONNECTED TO GAME CENTER
- (void)defaultsChanged:(NSNotification *)notification {
    [self setActivePlayer];
}


-(void)setActivePlayer {
    if ([[defaults objectForKey:@"Butterfly.GameCenter.Connected"] isEqualToString:@"NO"]) {
        NSLog(@"User is not connected to game center");
        [GameData sharedGameData].connectedToGameCenter = false;
        [[GameData sharedGameData] save];
        _gameCenterButton.visible = false;
        NSString* localPlayerName = [GameData sharedGameData].gameLocalPlayer.playerName;
        if (![localPlayerName isEqualToString:@""]) {
            NSLog(@"Local player name set");
            [GameData sharedGameData].gameActivePlayer = [GameData sharedGameData].gameLocalPlayer;
            [[GameData sharedGameData] save];
            self.usingGameCenterPlayer = false;
            self.currentPlayerSelected = true;
        } else {
            NSLog(@"Local player name not set");
            self.currentPlayerSelected = false;
        }
        // Hide the game center button
        _gameCenterButton.visible = false;
        self.usingGameCenterPlayer = false;
    } else if ([[defaults objectForKey:@"Butterfly.GameCenter.Connected"] isEqualToString:@"YES"]) {
        [GameData sharedGameData].connectedToGameCenter = true;
        [[GameData sharedGameData] save];
        // Check to make sure we have the game center player set
        NSString* gameCenterPlayerName = [GameData sharedGameData].gameCenterPlayer.playerName;
        if ([gameCenterPlayerName isEqualToString:[GKLocalPlayer localPlayer].alias]) {
            NSLog(@"Game player name: %@", gameCenterPlayerName);
            // Set the active player as the current game center player
            [GameData sharedGameData].gameActivePlayer = [GameData sharedGameData].gameCenterPlayer;
            [GameData sharedGameData].activePlayerConnectedToGameCenter = true;
            NSLog(@"User is connected to game center");
            [[GameData sharedGameData] save];
        } else {
            NSLog(@"Game Center player name not set");
            [self getGameCenterPlayerSetUpforActive:true];
        }
        // Hide the game center button
        _gameCenterButton.visible = true;
        self.usingGameCenterPlayer = true;
        self.currentPlayerSelected = true;
        // Finally, update this players data with game center data
       // [Utility updateGameCenterPlayerWithGameCenterData];
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
    if ([GameData sharedGameData].connectedToGameCenter) {
        NSLog(@"This user is active to game center");
        if (![[GameData sharedGameData].gameCenterPlayer.playerName isEqualToString:[GKLocalPlayer localPlayer].alias]) {
            [self getGameCenterPlayerSetUpforActive:false];
            _gameCenterButton.visible = true;
            _gameCenterButton.title = [GameData sharedGameData].gameCenterPlayer.playerName;
        } else {
            _gameCenterButton.visible = true;
            _gameCenterButton.title = [GameData sharedGameData].gameCenterPlayer.playerName;
        }
    } else {
        _gameCenterButton.visible = false;
        NSLog(@"This user is not active to game center");
    }
    // Get the available players on the device
    if (self.playerArray != nil) {
    NSLog(@"Player array: %@ total:%lu", self.playerArray.description, self.playerArray.count);
       
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

-(void)getGameCenterPlayerSetUpforActive:(BOOL)forActive {
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
        newPlayer.numberOfNectarGathered = 0;
        newPlayer.numberOfSpiderDeaths = 0;
        newPlayer.playerName = [GKLocalPlayer localPlayer].alias;
        // for now set default achievements
        // set default achievements
        newPlayer.completedDeath = false;
        newPlayer.completedJourney1 = false;
        newPlayer.completedJourney2 = false;
        newPlayer.completedJourney3 = false;
        newPlayer.completedJOurney4 = false;
        newPlayer.completedJourney5 = false;
        newPlayer.completedNectar10 = false;
        newPlayer.completedNectar100 = false;
        newPlayer.completedNectar50 = false;
        newPlayer.completedUnlock = false;
        
        [GameData sharedGameData].gameCenterPlayer = newPlayer;
        [[GameData sharedGameData] save];
        if (forActive) {
            [GameData sharedGameData].gameActivePlayer = [GameData sharedGameData].gameCenterPlayer;
            [GameData sharedGameData].activePlayerConnectedToGameCenter = true;
        }
        [[GameData sharedGameData] save];
    }

}

// WHEN USER SWITCHES PLAYERS, MAKE SURE ANY NEW DATA IS SAVED
-(void)updatePlayerArrayWithLocalUsersCurrentData {
    Player* activePlayer = [GameData sharedGameData].gameActivePlayer;
    Player* gameCenterPlayer = [GameData sharedGameData].gameCenterPlayer;
    Player* localPlayer = [GameData sharedGameData].gameLocalPlayer;
    // See if we need to update the game center player
    if ([activePlayer.playerName isEqualToString:gameCenterPlayer.playerName]) {
        NSLog(@"Updating game center player data");
        [GameData sharedGameData].gameCenterPlayer = [GameData sharedGameData].gameActivePlayer;
        [[GameData sharedGameData] save];
    }
    // otherwise see if we need to update a local player
    else if ([activePlayer.playerName isEqualToString:localPlayer.playerName]) {
           NSLog(@"Updating local player data");
        [GameData sharedGameData].gameLocalPlayer = [GameData sharedGameData].gameActivePlayer;
        [[GameData sharedGameData] save];
        if (localPlayer.playerName != nil) {
            //  NSLog(@"Retrieved local player: %@", localPlayer.playerName);
            //  NSLog(@"Player objects: %lu", [GameData sharedGameData].gamePlayers.count);
            for (Player* player in self.playerArray) {
                if ([player.playerName isEqualToString:localPlayer.playerName]) {
                    [self.playerArray removeObject:player];
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
    } else {
        for (Player* player in self.playerArray) {
            if ([player.playerName isEqualToString:activePlayer.playerName]) {
                NSLog(@"Updating active player data");
                [self.playerArray removeObject:player];
                [self.playerArray addObject:[GameData sharedGameData].gameActivePlayer];
                [GameData sharedGameData].gamePlayers = self.playerArray;
                [[GameData sharedGameData] save];
                break;
            }
        }
    }
}


// When the user presses the play button
#pragma mark - NAVIGATION
- (void) startGame {
    CCScene* scene = [CCBReader loadAsScene:@"Map"];
    NSLog(@"Moving to map with player");
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
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
     [[ABGameKitHelper sharedHelper] showAchievements];
}

-(void) shouldOpenLeaderboards {
    CCLOG(@"User clicked leaderboard button");
    NSString* activePlayerName = [GameData sharedGameData].gameActivePlayer.playerName;
    if (![activePlayerName isEqualToString:@""]) {
        NSLog(@"Active player is set");
         CCScene* scene = [CCBReader loadAsScene:@"LocalLeaderboard"];
        NSLog(@"Moving to leaderboard with player");
        CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
        [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
    } else {
        NSLog(@"No player is set");
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
        NSLog(@"USer selected to create a player");
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Enter Player Name" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
    } else if ([selectedPlayerButton.name isEqualToString:@"GameCenter"]) {
        NSLog(@"USer selected the game center player");
        self.currentPlayerSelected = true;
        // close the view
        [GameData sharedGameData].activePlayerConnectedToGameCenter = true;
         [GameData sharedGameData].gameActivePlayer = [GameData sharedGameData].gameCenterPlayer;
        // Update the active player
        [[GameData sharedGameData] save];
        [self shouldClosePlayerView];
    } else {
        NSLog(@"USer selected a local player");
        // Find the current player
        for (Player* player in self.playerArray) {
            // find the matching name
            if ([player.playerName isEqualToString:buttonTitle]) {
                NSLog(@"Found matching player name: %@ for selected name: %@", player.playerName, buttonTitle);
               // self.player = player;
                [GameData sharedGameData].activePlayerConnectedToGameCenter = false;
                 [GameData sharedGameData].gameLocalPlayer = player;
                 [GameData sharedGameData].gameActivePlayer = [GameData sharedGameData].gameLocalPlayer;
                [[GameData sharedGameData] save];
            }
        }
        self.currentPlayerSelected = true;
        // close the view
        [self shouldClosePlayerView];
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
        newPlayer.numberOfNectarGathered = 0;
        newPlayer.numberOfSpiderDeaths = 0;
        // set default achievements
        newPlayer.completedDeath = false;
        newPlayer.completedJourney1 = false;
        newPlayer.completedJourney2 = false;
        newPlayer.completedJourney3 = false;
        newPlayer.completedJOurney4 = false;
        newPlayer.completedJourney5 = false;
        newPlayer.completedNectar10 = false;
        newPlayer.completedNectar100 = false;
        newPlayer.completedNectar50 = false;
        newPlayer.completedUnlock = false;
        
        [self.playerArray addObject:newPlayer];
        [GameData sharedGameData].gamePlayers = self.playerArray;
        // Save the players
        [[GameData sharedGameData] save];
        [GameData sharedGameData].gameLocalPlayer = newPlayer;
        // Save the local player
        [[GameData sharedGameData] save];
        [GameData sharedGameData].activePlayerConnectedToGameCenter = false;
        [GameData sharedGameData].gameActivePlayer = [GameData sharedGameData].gameLocalPlayer;
        // Save the active player
        [[GameData sharedGameData] save];
        self.currentPlayerSelected = true;
        [self shouldClosePlayerView];
    }
}
-(void) shouldClosePlayerView {
    _playerSelectNode.visible = false;
    for (CCButton* button in mainButtons) {
        button.enabled = true;
    }
}

-(void) shouldOpenGameCenter {
    [[ABGameKitHelper sharedHelper] showLeaderboard:@"com.Smith.Angela.ButterflyGame.Scores"];
}


@end
