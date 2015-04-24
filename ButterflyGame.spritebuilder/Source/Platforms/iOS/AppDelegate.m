/*
 * SpriteBuilder: http://www.spritebuilder.org
 *
 * Copyright (c) 2012 Zynga Inc.
 * Copyright (c) 2013 Apportable Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "cocos2d.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "CCBuilderReader.h"
#import "GamePlayer.h"
#import "Score.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "ABGameKitHelper.h"

@implementation AppController


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // settting the default
    NSLog(@"Setting default to YES");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // Assume we can connect, and it will change if we cannot
    [defaults setObject:@"YES" forKey:@"Butterfly.GameCenter.Connected"];
    [defaults synchronize];
    
    // Configure Cocos2d with the options set in SpriteBuilder
    NSString* configPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Published-iOS"]; // TODO: add support for Published-Android support
    configPath = [configPath stringByAppendingPathComponent:@"configCocos2d.plist"];
    
    NSMutableDictionary* cocos2dSetup = [NSMutableDictionary dictionaryWithContentsOfFile:configPath];
    
    [GamePlayer registerSubclass];
    [Score registerSubclass];
    [Parse enableLocalDatastore];
    // Initialize Parse.
    [Parse setApplicationId:@"i2oHPIVzpVlU0I6qu0KCOgfxS0DnY1iIrjzDWT2o"
                  clientKey:@"A8GZq0OpyAfMi3UOr3TOqEVkgWR7FunVV1H6Nezd"];
    if (![PFUser currentUser]) {
        [PFAnonymousUtils logInWithBlock:^(PFUser *user, NSError *error) {
            if (!error) {
                NSLog(@"Logged in user anonymously");
            }
        }];
    }
    // Note: this needs to happen before configureCCFileUtils is called, because we need apportable to correctly setup the screen scale factor.
#ifdef APPORTABLE
    if([cocos2dSetup[CCSetupScreenMode] isEqual:CCScreenModeFixed])
        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenAspectFitEmulationMode];
    else
        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenScaledAspectFitEmulationMode];
#endif
    
    // Configure CCFileUtils to work with SpriteBuilder
    [CCBReader configureCCFileUtils];
    
    // Do any extra configuration of Cocos2d here (the example line changes the pixel format for faster rendering, but with less colors)
    //[cocos2dSetup setObject:kEAGLColorFormatRGB565 forKey:CCConfigPixelFormat];
    
    
    // attempt to connect to game center
    [ABGameKitHelper sharedHelper];
    
    [self setupCocos2dWithOptions:cocos2dSetup];

    return YES;
    
}


-(NSUInteger)supportedInterfaceOrientations {

    return UIInterfaceOrientationMaskLandscapeLeft;
} 

- (CCScene*) startScene {
    return [CCBReader loadAsScene:@"MainScene"];
}



@end
