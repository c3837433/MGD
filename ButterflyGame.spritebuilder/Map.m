//
//  Map.m
//  ButterflyGame
//
//  Created by Angela Smith on 3/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Map.h"
#import "Constants.h"
#import "ABGameKitHelper.h"
#import "LeaderboardPosition.h"
#import "MigrationA.h"
#import "MigrationB.h"
#import "MigrationC.h"
#import "MigrationD.h"
#import "MigrationE.h"
#import "Utility.h"
#import <Parse/Parse.h>
#import "GameData.h"

@implementation Map {
    BOOL shouldZoom;
    CCNode* _journeyA;
    CCNode* _mainNode;
    BOOL isZooming;
    CCButton* _JourneyAButton;
    CGPoint nodePostion;
    CCNode* _journey1;
    CCNode* _journey2;
    CCNode* _journey3;
    CCNode* _journey4;
    CCNode* _journey5;
    CCNode* _mapNode;
    NSString* journeyToLoad;
    CGPoint activePoint;
    CCButton* _playButton;
    
    CCLabelTTF* _leaderBoardTitle;
    CCLabelTTF* _leaderName1;
    CCLabelTTF* _leaderName2;
    CCLabelTTF* _leaderName3;
    CCLabelTTF* _leaderScore1;
    CCLabelTTF* _leaderScore2;
    CCLabelTTF* _leaderScore3;
    
    CCNode* _leaderPosition1;
    CCNode* _leaderPosition2;
    CCNode* _leaderPosition3;
    
    NSArray* leaderboardNodeArray;
    NSArray* leaderboardNameArray;
    NSArray* leaderboardScoreArray;
}

// Get this user's highest unlocked journey for the map
-(void) onEnter {
    [super onEnter];

    if (self.connectedToGameCenter) {
        NSLog(@"Map connected through game center who has %ld journeys available", (long)[GameData sharedGameData].gameCenterPlayer.highestJourney);
        self.highestLevel = [GameData sharedGameData].gameCenterPlayer.highestJourney;
    } else {
        NSLog(@"Map loaded with local player who has %ld journeys available", (long)[GameData sharedGameData].gameLocalPlayer.highestJourney);
        self.highestLevel = [GameData sharedGameData].gameLocalPlayer.highestJourney;
    }
    //NSLog(@"current player for map: %@", self.currentPlayer.playerName);
    //self.highestLevel = self.currentPlayer.highestJourney;

    NSLog(@"Number of migrations that should be viewable: %ld", (long)self.highestLevel);
    [self setUpMapviewWithButtons];
}


- (void)didLoadFromCCB {
    shouldZoom = false;
    // set the first journey as default
    journeyToLoad = @"A";
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    // Set up leaderboard array
    leaderboardNodeArray = [[NSArray alloc] initWithObjects:_leaderPosition1,_leaderPosition2, _leaderPosition3, nil];
    leaderboardNameArray = [[NSArray alloc] initWithObjects:_leaderName1,_leaderName2, _leaderName3, nil];
    leaderboardScoreArray = [[NSArray alloc] initWithObjects:_leaderScore1,_leaderScore2, _leaderScore3, nil];
}

-(void) setUpMapviewWithButtons {
    // Create an array of all the journey nodes
    NSArray* journeyNodes = [[NSArray alloc] initWithObjects:_journey1, _journey2, _journey3, _journey4, _journey5, nil];
    for (CCNode* mapNode in journeyNodes) {
        // get the button name
        NSString* nodeName = mapNode.name;
        // Get the last number value
        NSString* nodeNumber = [nodeName substringFromIndex:[nodeName length] - 1];
        // convert to integer
        NSInteger nodeInteger = [nodeNumber integerValue];
        // if this is higher than the current hghest level, hide it
        if (nodeInteger > self.highestLevel) {
           [mapNode setVisible:false];
        }
    }
}
/*
-(void)getTopScoresForFriendsForMigration:(NSString*)journey {
    // set the title
    _leaderBoardTitle.string = [self getLeaderBoardTitleForJourney:journey];
    if (self.connectedToGameCenter) {
        // rehide the leaderboards
        for (CCNode* leaderNode in leaderboardNodeArray) {
            leaderNode.visible = false;
        }
        // get the leaderboard id
        NSString* migration = [NSString stringWithFormat:@"Butterfly.Migration.%@", journey];
        // ButterflyGame.Migration.A.Set
        GKLeaderboard* leaderBoard = [[GKLeaderboard alloc] init];
        leaderBoard.identifier = migration;
        // Get just our friends
        leaderBoard.playerScope = GKLeaderboardPlayerScopeFriendsOnly;
        // and only top three
        leaderBoard.range = NSMakeRange(1, 3);
        if (leaderBoard != nil) {
            NSLog(@"Leaderboard is loading");
            [leaderBoard loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
                if (error != nil) {
                    //Handle error
                    NSLog(@"Errors: %@", error.description);
                }
                else{
                    NSLog(@"Scores %@", scores.description);
                    if (scores != nil) {
                        // and load the scores
                        [self setLeaderboardWithScores:scores];
                    }
                }
            }];
        }
    } else {
        // get top scores for all local users
        NSMutableArray* topScorers =  [Utility getTopThreePlayersScoresForMigration:@"A"];
        [self SetLeaderboardWithPositions:topScorers];
    }
}


-(void)getLocalScoresForJourney {
    PFQuery* topUsersQuery = [PFQuery queryWithClassName:pClassName];
    [topUsersQuery whereKeyExists:pPlayerName];
    [topUsersQuery whereKeyExists:pHighScore];
    [topUsersQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ((!error) && (objects.count >+ 1)) {
            // we have scores
            [self sortAndOrderLocalScores:objects];
        }
    }];

}

-(void) sortAndOrderLocalScores:(NSArray*)scores {
  NSArray* topScores = [Utility getTopThreeScoresForJourney:@"A" withScores:scores];
    NSLog(@"Top scores: %@", topScores.description);
}

-(NSString*) getLeaderBoardTitleForJourney:(NSString*)journey {
    NSString* titleString = @"Migration";
    if ([journey isEqualToString:@"A"]) {
        titleString = @"Prismo Beach Migration";
    } else if ([journey isEqualToString:@"B"]) {
        titleString = @"Ellwood Grove Migration";
    } else if ([journey isEqualToString:@"C"]) {
        titleString = @"El Rosario Migration";
    } else if ([journey isEqualToString:@"D"]) {
        titleString = @"Sierra Chincua Migration";
    } else if ([journey isEqualToString:@"E"]) {
        titleString = @"Yucatan Migration";
    }
    return titleString;
}

-(void)setLocalLeaderboardWithScores:(NSArray*)positions {
    if (positions.count > 0) {
        NSLog(@"We have %lu saved user scores for this migration", (unsigned long)positions.count);
        NSMutableArray* leaderboards = [[NSMutableArray alloc] init];
        for (int i = 0; i < positions.count; i++) {
            LeaderboardPosition* position = [positions objectAtIndex:i];
            LeaderboardPosition* leader = [[LeaderboardPosition alloc] init];
            leader.leaderNode = leaderboardNodeArray[i];
            leader.leaderNameLabel = leaderboardNameArray[i];
            leader.leaderScoreLabel = leaderboardScoreArray[i];
            leader.leaderName = position.leaderName;
            leader.leaderScore = position.leaderScore;
            [leaderboards addObject:leader];
        }
        for (LeaderboardPosition* position in leaderboards) {
            position.leaderNode.visible = true;
            position.leaderNameLabel.string = position.leaderName;
            position.leaderScoreLabel.string = position.leaderScore;
        }
    } else {
        NSLog(@"There are no currently saved scores for this migration");
    }
   


}
-(void)SetLeaderboardWithPositions:(NSArray*)positions {
    NSLog(@"There are no currently saved scores for this migration");
    NSMutableArray* leaderboards = [[NSMutableArray alloc] init];
    for (int i = 0; i < positions.count; i++) {
        LeaderboardPosition* position = positions[i];
        LeaderboardPosition* leader = [[LeaderboardPosition alloc] init];
        leader.leaderNode = leaderboardNodeArray[i];
        leader.leaderNameLabel = leaderboardNameArray[i];
        leader.leaderScoreLabel = leaderboardScoreArray[i];
        leader.leaderName = position.leaderName;
        leader.leaderScore = [NSString stringWithFormat:@"%lu", position.leaderScoreValue];
        [leaderboards addObject:leader];
    }
    for (LeaderboardPosition* position in leaderboards) {
        position.leaderNode.visible = true;
        position.leaderNameLabel.string = position.leaderName;
        position.leaderScoreLabel.string = position.leaderScore;
    }
}

-(void)setLeaderboardWithScores:(NSArray*)scores {
    NSMutableArray* leaderboards = [[NSMutableArray alloc] init];
    for (int i = 0; i < scores.count; i++) {
        GKScore* score = scores[i];
        LeaderboardPosition* leader = [[LeaderboardPosition alloc] init];
        leader.leaderNode = leaderboardNodeArray[i];
        leader.leaderNameLabel = leaderboardNameArray[i];
        leader.leaderScoreLabel = leaderboardScoreArray[i];
        leader.leaderName = score.player.alias;
        leader.leaderScore = score.formattedValue;
        [leaderboards addObject:leader];
    }
    for (LeaderboardPosition* position in leaderboards) {
        position.leaderNode.visible = true;
        position.leaderNameLabel.string = position.leaderName;
        position.leaderScoreLabel.string = position.leaderScore;
    }
}
*/
-(void) touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    // Get the position in the map
    nodePostion = [touch locationInNode:_mapNode];
    // And convert it to percentage
    nodePostion = [_mapNode convertToNodeSpace:nodePostion];
    // Check which one was selected, and set the point for zooming in so long as it is visible on the screen
    if ((CGRectContainsPoint([_journey1 boundingBox], nodePostion)) && (_journey1.visible)) {
        CCLOG(@"User tapped first journey");
        activePoint.x = 1.0 - _journey1.position.x + 0.45;
        activePoint.y = 1.0 - _journey1.position.y - 0.35;
        _playButton.visible = YES;
        //[self getTopScoresForFriendsForMigration:@"A"];
    } else if ((CGRectContainsPoint([_journey2 boundingBox], nodePostion)) && (_journey2.visible)) {
        CCLOG(@"User tapped second journey");
        journeyToLoad = @"B";
        activePoint.x = 1.0 - _journey2.position.x + 0.45;
        activePoint.y = 1.0 - _journey2.position.y - 0.25;
        _playButton.visible = YES;
        //[self getTopScoresForFriendsForMigration:@"B"];
    } else if ((CGRectContainsPoint([_journey3 boundingBox], nodePostion)) && (_journey3.visible)) {
        CCLOG(@"User tapped third journey");
        journeyToLoad = @"C";
        activePoint.x = 1.0 - _journey3.position.x + 0.3;
        activePoint.y = 1.0 - _journey3.position.y - 0.45;
        _playButton.visible = YES;
       // [self getTopScoresForFriendsForMigration:@"C"];
    } else if ((CGRectContainsPoint([_journey4 boundingBox], nodePostion)) && (_journey4.visible)) {
        CCLOG(@"User tapped fourth journey");
        journeyToLoad = @"D";
        activePoint.x = 1.0 - _journey4.position.x - 0.2;
        activePoint.y = 1.0 - _journey4.position.y - 0.2;
        _playButton.visible = YES;
    } else if ((CGRectContainsPoint([_journey5 boundingBox], nodePostion)) && (_journey5.visible)) {
        CCLOG(@"User tapped fifth journey");
        journeyToLoad = @"E";
        activePoint.x = 1.0 - _journey5.position.x - 0.4;
        activePoint.y = 1.0 - _journey5.position.y - 0.45;
        _playButton.visible = YES;
       // [self getTopScoresForFriendsForMigration:@"E"];
    }

}

-(void) shouldPlaySelectedJourney {
    CCActionScaleTo* scale = [CCActionScaleTo actionWithDuration:0.7f scale:3.0f];
    CCAction* move = [CCActionMoveTo actionWithDuration:0.7 position:activePoint];
    [_mapNode runAction:scale];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[move, [CCActionCallFunc actionWithTarget:self selector:@selector(shouldStartJourney)]]];
    // run the sequence
    [_mapNode runAction:sequence];
}


- (void)shouldStartJourney {
    // See which journey to load
    CCScene* scene = [CCBReader loadAsScene:[NSString stringWithFormat:@"Journeys/Migration%@", journeyToLoad]];
    // set the player and session info
    if ([journeyToLoad isEqualToString:@"A"]) {
        MigrationA* migration = [[scene children] firstObject];
        migration.sessionThroughGameCenter = self.connectedToGameCenter;
        //migration.player = self.currentPlayer;
        //migration.player = self.player;
    } else if ([journeyToLoad isEqualToString:@"B"]) {
        MigrationB* migration = [[scene children] firstObject];
        migration.sessionThroughGameCenter = self.connectedToGameCenter;
        // migration.player = self.currentPlayer;
       // migration.player = self.player;
    } else if ([journeyToLoad isEqualToString:@"C"]) {
        MigrationC* migration = [[scene children] firstObject];
        migration.sessionThroughGameCenter = self.connectedToGameCenter;
        // migration.player = self.currentPlayer;
       // migration.player = self.player;
    } else if ([journeyToLoad isEqualToString:@"D"]) {
        MigrationD* migration = [[scene children] firstObject];
        migration.sessionThroughGameCenter = self.connectedToGameCenter;
        // migration.player = self.currentPlayer;
       // migration.player = self.player;
    } else if ([journeyToLoad isEqualToString:@"E"]) {
        MigrationD* migration = [[scene children] firstObject];
        migration.sessionThroughGameCenter = self.connectedToGameCenter;
        // migration.player = self.currentPlayer;
       // migration.player = self.player;
    }
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
    /*
    CCScene* scene = [CCBReader loadAsScene:[NSString stringWithFormat:@"Journeys/Migration%@", journeyToLoad]];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];*/
}


-(void) update:(CCTime)delta {
    
}

-(void) shouldReturnToMain {
    // return to the main menu
    CCScene* scene = [CCBReader loadAsScene:@"MainScene"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:0.8];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}

@end
