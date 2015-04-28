//
//  Constants.h
//  ButterflyGame
//
//  Created by Angela Smith on 4/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark JOURNEY DEFINITIONS

#define jGreenDot  @"mapAssets/green.png"
#define jGreenHighlighted  @"mapAssets/greenHL.png"
#define jRedDot  @"mapAssets/red.png"
#define jRedHighlighted  @"mapAssets/redHL.png"
#define jOrangenDot  @"mapAssets/orange.png"
#define jOrangeHighlighted  @"mapAssets/orangeHL.png"
#define jLockedDot  @"mapAssets/locked.png"
#define jUnlocked  @"mapAssets/unfinish.png"
#define jUnlockedHighlighted  @"mapAssets/unfinishHL.png"

#pragma mark PARSE DATASTORE DEFINITIONS
#define pClassName @"GameStop"
#define pStop @"stop"
#define pJourney @"journey"
#define pHighScore @"highScore"
#define pEnergy @"energy"
#define pPlayerName @"playerName"

#pragma  mark ACHIEVEMENTS IMAGES
#define aUnlock = @"menuAssets/aUnlock.png"
#define aNectar = @"menuAssets/aNectar.png"
#define aCompletion = @"menuAssets/aCompletion.png"
#define aDeath = @"menuAssets/aDeath.png"

#pragma mark MAP LEVEL DEFAULTS
extern NSString* const mHighestJourneyUnlocked;
extern NSString* const mHighestJourneyAStopUnlocked;
extern NSString* const mHighestJourneyBStopUnlocked;
extern NSString* const mHighestJourneyCStopUnlocked;
extern NSString* const mHighestJourneyDStopUnlocked;
extern NSString* const mHighestJourneyEStopUnlocked;


#pragma mark Game Center
extern NSString* const gLeaderBoardTotal;
extern NSString* const gLeaderBoardMigrationA;
extern NSString* const gLeaderBoardMigrationB;
extern NSString* const gLeaderBoardMigrationC;
extern NSString* const gLeaderBoardMigrationD;
extern NSString* const gLeaderBoardMigrationE;

extern NSString* const dLocalPlayerArray;
extern NSString* const dLocalScoresArray;
extern NSString* const dLocalCurrentPlayer;