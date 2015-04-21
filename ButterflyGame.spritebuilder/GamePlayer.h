//
//  GamePlayer.h
//  ButterflyGame
//
//  Created by Angela Smith on 4/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Parse/Parse.h>

@interface GamePlayer : PFObject  <PFSubclassing>

+ (NSString *)parseClassName;
@property (nonatomic, strong) NSString* gamePlayerName;
@property (nonatomic, assign) NSInteger highestJourney;
@property (nonatomic, assign) NSInteger highestAStop;
@property (nonatomic, assign) NSInteger highestBStop;
@property (nonatomic, assign) NSInteger highestCStop;
@property (nonatomic, assign) NSInteger highestDStop;
@property (nonatomic, assign) NSInteger highestEStop;




@end
