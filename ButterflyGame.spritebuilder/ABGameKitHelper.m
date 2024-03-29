//
//  ABGameKitHelper.m
//
//  Created by Alexander Blunck on 27.02.12.
//  Fixed for iOS 8 by Carlos Alcala on 25.01.2015.
//  Copyright (c) 2013 Alexander Blunck | Ablfx
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <CommonCrypto/CommonCryptor.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "ABGameKitHelper.h"

@interface ABGameKitHelper () <GKGameCenterControllerDelegate>
@end

@implementation ABGameKitHelper

#pragma mark - Singleton
+(id) sharedHelper
{
    static ABGameKitHelper *sharedHelper = nil;
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{sharedHelper = [[self alloc] init];});
    return sharedHelper;
}



#pragma mark - Initializer
-(id) init
{
    self = [super init];
    if (self)
    {
        [self authenticatePlayer];
    }
    return self;
}



#pragma mark - Authenticate
-(void) authenticatePlayer
{
    GKLocalPlayer *player = [GKLocalPlayer localPlayer];
    
    void (^authBlock)(UIViewController *, NSError *) = ^(UIViewController *viewController, NSError *error) {
        
        if (viewController) {
            [[self topViewController] presentViewController:viewController animated:YES completion:nil];
        }
        
        if ([[GKLocalPlayer localPlayer] isAuthenticated]) {
            // set the NSUserDefault to Connected
            self.authenticated = YES;
            if (ABGAMEKITHELPER_LOGGING) NSLog(@"ABGameKitHelper: Player successfully authenticated.");
            //Report possible cached scores / achievements
            if([self hasConnectivity]){
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                // Change the default
                NSLog(@"Setting default to YES");
                [defaults setObject:@"YES" forKey:@"Butterfly.GameCenter.Connected"];
                [defaults synchronize];
                [self reportCachedAchievements];
                [self reportCachedScores];
            }
        }
        
        if (error) {
            self.authenticated = NO;
            if (ABGAMEKITHELPER_LOGGING) NSLog(@"ABGameKitHelper: ERROR -> Player didn't authenticate");
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            // Change the default
                NSLog(@"Setting default to NO");
            [defaults setObject:@"NO" forKey:@"Butterfly.GameCenter.Connected"];
            [defaults synchronize];
        }
        
    };
    
    //iOS 6.x +
    [player setAuthenticateHandler:authBlock];
}

#pragma mark - GKGameCenterControllerDelegate

-(void) gameCenterViewControllerDidFinish:(GKGameCenterViewController*) gameCenterViewController {
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Leaderboards

//updated iOS7+
-(void) reportScore:(NSUInteger)highScore forLeaderboard:(NSString*)leaderboardId {
     
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:leaderboardId];
    score.value = highScore;
    
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        if (!error) {
            if(![self hasConnectivity]){
                [self cacheScore:score];
            }
            if (ABGAMEKITHELPER_LOGGING) NSLog(@"ABGameKitHelper: Reported score (%lli) to %@ successfully.", score.value, leaderboardId);
        } else {
            [self cacheScore:score];
            if (ABGAMEKITHELPER_LOGGING) NSLog(@"ABGameKitHelper: ERROR -> Reporting score (%lli) to %@ failed, caching...", score.value, leaderboardId);
        }
    }];
}

//updated iOS7+
-(void) showLeaderboard:(NSString*)leaderboardId
{
    GKGameCenterViewController* gameCenterController = [[GKGameCenterViewController alloc] init];
    gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
    gameCenterController.gameCenterDelegate = self;
    
    if (leaderboardId) {
        gameCenterController.leaderboardIdentifier = leaderboardId;
    }
    
    [[self topViewController] presentViewController:gameCenterController animated:YES completion:nil];
}

- (void) showLeaderboards {
    //just display NON-specific leaderboards
    [self showLeaderboard:@""];
}

/**
 * Achievements
 */

#pragma mark - Achievements

//updated iOS7+
-(void) reportAchievement:(NSString*)achievementId percentComplete:(double)percent
{
    if (percent > 100.0f) percent = 100.0f;
    
    //Mark achievement as completed locally
    if (percent == 100) {
        [self saveBool:YES key:achievementId];
    }
    
    GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier:achievementId];
    
    if (achievement) {
        achievement.percentComplete = percent;
        
        [GKAchievement reportAchievements:@[achievement] withCompletionHandler:^(NSError *error) {
            if (!error){
                if(![self hasConnectivity]){
                    [self cacheAchievement:achievement];
                }
                if (ABGAMEKITHELPER_LOGGING) NSLog(@"ABGameKitHelper: Achievement (%@) with %f%% progress reported", achievement.identifier, achievement.percentComplete);
            }
            else
            {
                [self cacheAchievement:achievement];
                if (ABGAMEKITHELPER_LOGGING) NSLog(@"ABGameKitHelper: ERROR -> Reporting achievement (%@) with %f%% progress failed, caching...", achievement.identifier, achievement.percentComplete);
            }
        }];
    }
}

//updated iOS7+
-(void) showAchievements {
    GKGameCenterViewController* gameCenterController = [[GKGameCenterViewController alloc] init];
    gameCenterController.viewState = GKGameCenterViewControllerStateAchievements;
    gameCenterController.gameCenterDelegate = self;
    [[self topViewController] presentViewController:gameCenterController animated:YES completion:nil];
}


-(void) resetAchievements {
    [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error) {
        if (!error) {
            if (ABGAMEKITHELPER_LOGGING) NSLog(@"ABGameKitHelper: Achievements reset successfully.");
        } else {
            if (ABGAMEKITHELPER_LOGGING) NSLog(@"ABGameKitHelper: Failed to reset achievements.");
        }
    }];
}


#pragma mark - Notifications
-(void) showNotification:(NSString*)title message:(NSString*)message identifier:(NSString*)achievementId {
    //Show notification only if it hasn't been achieved yet
    if (![self boolForKey:achievementId]) {
        [GKNotificationBanner showBannerWithTitle:title message:message completionHandler:nil];
    }
}

#pragma mark - Caching
#pragma mark - Caching Scores
-(void) cacheScore:(GKScore*)aScore
{
    //Retrieve cached scores
    NSMutableArray *scores;
    if(![self objectForKey:@"cachedScores"]){
        scores = [NSMutableArray new];
    } else {
        scores = [self objectForKey:@"cachedScores"];
    }
    
    //Add new score to array
    [scores addObject:aScore];
    
    //Save scores to persistant storage
    [self saveObject:scores key:@"cachedScores"];
}

-(void) reportCachedScores
{
    //Retrieve cached scores
    NSMutableArray *scores = [self objectForKey:@"cachedScores"];
    
    if (scores.count == 0) {
        return;
    }
    
    if (ABGAMEKITHELPER_LOGGING) NSLog(@"ABGameKitHelper: Attempting to report %i cached scores...", (int)scores.count);

    //iOS7+ not worry about backward compability
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
        if (!error) {
            [self removeAllCachedScores];
            if (ABGAMEKITHELPER_LOGGING) NSLog(@"ABGameKitHelper: Reported %i cached score(s) successfully.", (int)scores.count);
        } else {
            if (ABGAMEKITHELPER_LOGGING) NSLog(@"ABGameKitHelper: ERROR -> Failed to report %i cached score(s).", (int)scores.count);
        }
    }];
}

-(void) removeCachedScore:(GKScore*)score {
    
    NSMutableArray *scores = [self objectForKey:@"cachedScores"];
    [scores removeObject:score];
    [self saveObject:scores key:@"cachedScores"];
}

-(void) removeAllCachedScores {
    
    [self saveObject:[NSMutableArray new] key:@"cachedScores"];
}


#pragma mark - Caching Achievements
-(void) cacheAchievement:(GKAchievement*)achievement
{
    //Retrieve cached achievements
    NSMutableArray *achievements;
    if(![self objectForKey:@"cachedAchievements"]) {
        achievements = [NSMutableArray new];
    } else {
        achievements = [self objectForKey:@"cachedAchievements"];
    }
    
    //Add new achievment to array
    [achievements addObject:achievement];
    
    //Save achievement to persistant storage
    [self saveObject:achievements key:@"cachedAchievements"];
}

-(void) reportCachedAchievements
{
    //Retrieve cached achievements
    NSMutableArray *achievements = [self objectForKey:@"cachedAchievements"];
    
    if (achievements.count == 0){
        return;
    }
    
    if (ABGAMEKITHELPER_LOGGING) NSLog(@"ABGameKitHelper: Attempting to report %i cached achievements...", (int)achievements.count);
    
    //iOS7+ not worry about backward compability
    [GKAchievement reportAchievements:achievements withCompletionHandler:^(NSError *error) {
        if (!error) {
            [self removeAllCachedAchievements];
            if (ABGAMEKITHELPER_LOGGING) NSLog(@"ABGameKitHelper: Reported %i cached achievement(s) successfully.", (int)achievements.count);
        } else {
            if (ABGAMEKITHELPER_LOGGING) NSLog(@"ABGameKitHelper: ERROR -> Failed to report %i cached achievement(s).", (int)achievements.count);
        }
    }];
}

-(void) removeCachedAchievement:(GKAchievement*)achievement {
    NSMutableArray *achievements = [self objectForKey:@"cachedAchievements"];
    [achievements removeObject:achievement];
    [self saveObject:achievements key:@"cachedAchievements"];
}

-(void) removeAllCachedAchievements {
    [self saveObject:[NSMutableArray new] key:@"cachedAchievements"];
}


#pragma mark - Data Persistance

-(NSString*) filePath {
    
    NSString *fileExt = @".abgk";
    NSString *fileName = [NSString stringWithFormat:@"%@%@", [[self appName] lowercaseString], fileExt];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
    return path;
}

-(NSMutableDictionary*) dataDictionary
{
    NSData *binaryFile = [NSData dataWithContentsOfFile:[self filePath]];
    NSMutableDictionary *dictionary = nil;
    
    if (binaryFile == nil)
    {
        dictionary = [NSMutableDictionary dictionary];
    }
    else
    {
        NSData *decryptedData = [self decryptData:binaryFile withKey:SECRET_KEY];
        dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:decryptedData];
    }
    
    return dictionary;
}

-(void) saveData:(NSData*)data key:(NSString*)key
{
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[self filePath]];
    NSMutableDictionary *tempDic = nil;
    if (fileExists == NO)
    {
        tempDic = [NSMutableDictionary new];
    } else
    {
        tempDic = [self dataDictionary];
    }
    
    [tempDic setObject:data forKey:key];
    
    NSData *dicData = [NSKeyedArchiver archivedDataWithRootObject:tempDic];
    NSData *encryptedData = [self encryptData:dicData withKey:SECRET_KEY];
    [encryptedData writeToFile:[self filePath] atomically:YES];
}

-(NSData*) dataForKey:(NSString*)key
{
    NSMutableDictionary *tempDic = [self dataDictionary];
    NSData *loadedData = [tempDic objectForKey:key];
    
    if (loadedData)
    {
        return loadedData;
    }
    
    return nil;
}

-(void) saveObject:(id<NSCoding>)object key:(NSString*)key
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    [self saveData:data key:key];
}

-(id) objectForKey:(NSString*)key
{
    NSData *data = [self dataForKey:key];
    if (data)
    {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
}

-(void) saveBool:(BOOL)boolean key:(NSString*)key
{
    NSNumber *number = [NSNumber numberWithBool:boolean];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:number];
    [self saveData:data key:key];
}

-(BOOL) boolForKey:(NSString*)key
{
    NSData *data = [self dataForKey:key];
    if (data)
    {
        return [[NSKeyedUnarchiver unarchiveObjectWithData:data] boolValue];
    }
    return NO;
}



#pragma mark - Helper
-(NSString*) appName
{
    NSString *bundlePath = [[[NSBundle mainBundle] bundleURL] lastPathComponent];
    return [[bundlePath stringByDeletingPathExtension] lowercaseString];
}

-(UIViewController*) topViewController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController)
    {
        topController = topController.presentedViewController;
    }
    return topController;
}

-(NSData*) makeCryptedVersionOfData:(NSData*)data withKeyData:(const void*)keyData ofLength:(int) keyLength decrypt:(bool)decrypt
{
	int keySize = kCCKeySizeAES256;
    char key[kCCKeySizeAES256];
	bzero(key, sizeof(key));
	memcpy(key, keyData, keyLength > keySize ? keySize : keyLength);
    
	size_t bufferSize = [data length] + kCCBlockSizeAES128;
	void* buffer = malloc(bufferSize);
    
	size_t dataUsed;
    
	CCCryptorStatus status = CCCrypt(decrypt ? kCCDecrypt : kCCEncrypt,
									 kCCAlgorithmAES128,
									 kCCOptionPKCS7Padding | kCCOptionECBMode,
									 key, keySize,
									 NULL,
									 [data bytes], [data length],
									 buffer, bufferSize,
									 &dataUsed);
    
	switch(status)
	{
		case kCCSuccess:
			return [NSData dataWithBytesNoCopy:buffer length:dataUsed];
		default:
			if (ABGAMEKITHELPER_LOGGING) NSLog(@"ABGameKitHelper: ERROR -> Failed to encrypt!");
	}
    
	free(buffer);
	return nil;
}

- (NSData*) encryptData:(NSData*)data withKey:(NSString*)key
{
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
	return [self makeCryptedVersionOfData:data withKeyData:[keyData bytes] ofLength:(int)[keyData length] decrypt:false];
}

- (NSData*) decryptData:(NSData*)data withKey:(NSString*)key
{
	NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    return [self makeCryptedVersionOfData:data withKeyData:[keyData bytes] ofLength:(int)[keyData length] decrypt:true];
}

#pragma mark - Connectivity Checking
/*
 Connectivity testing code pulled from Apple's Reachability Example: http://developer.apple.com/library/ios/#samplecode/Reachability
 Taken from - http://stackoverflow.com/questions/1083701/how-to-check-for-an-active-internet-connection-on-iphone-sdk
 Leak fixed with CFRelease
 */
-(BOOL) hasConnectivity
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    
    if(reachability != NULL)
    {
        //NetworkStatus retVal = NotReachable;
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachability, &flags))
        {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
            {
                // if target host is not reachable
                CFRelease(reachability);
                return NO;
            }
            
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
            {
                // if target host is reachable and no connection is required then we'll assume (for now) that your on Wi-Fi
                CFRelease(reachability);
                return YES;
            }
            
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) || (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
            {
                // ... and the connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
                {
                    // ... and no [user] intervention is needed
                    CFRelease(reachability);
                    return YES;
                }
            }
            
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
            {
                // ... but WWAN connections are OK if the calling application is using the CFNetwork (CFSocketStream?) APIs.
                CFRelease(reachability);
                return YES;
            }
        }
    }
    //CFRelease(reachability); //Null pointer argument in call to CFRelease
    return NO;
}

@end
