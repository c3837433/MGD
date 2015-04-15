//
//  Utility.h
//  ButterflyGame
//
//  Created by Angela Smith on 4/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

// Set button image
+ (void) setButtonImage:(CCButton*)button forEnergy:(CGFloat)energy;
+ (void) setActiveButtons:(NSArray*)buttonArray withHighestStop:(NSInteger) highestStop;


// Navigation
+ (void)shouldReturnToMap;
+ (void)shouldPlaySelectedLevelWithStop:(NSInteger)selectedStop andHighestStop:(NSInteger)highestStop forJourney:(NSString*)journey;
@end
