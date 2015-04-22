//
//  LeaderboardPosition.h
//  ButterflyGame
//
//  Created by Angela Smith on 4/17/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
@interface LeaderboardPosition : NSObject <NSCoding>


@property CCNode* leaderNode;
@property CCLabelTTF* leaderNameLabel;
@property CCLabelTTF* leaderScoreLabel;
@property CCLabelTTF* leaderLevelLabel;
@property NSString* leaderName;
@property Player*   leaderPlayer;
@property NSString* leaderScore;
@property NSString* leaderBoardStop;
@property NSInteger leaderScoreValue;
@property NSString* leaderboardName;
@property NSString* leaderboardRank;
@property BOOL leaderIsCurrentUser;
@property CCButton* leaderShareButton;
@end
