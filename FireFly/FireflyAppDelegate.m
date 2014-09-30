/*
 FireflyAppDelegate.m
 
 Håkon Knutzen, Robin, ifi, UIO 2014
 
 */

#import "FireflyAppDelegate.h"
#import "Puredata.h"

@implementation FireflyAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    Puredata *pd = [Puredata sharedPuredata];
    [pd.audioController setActive:NO];
    [[UIApplication sharedApplication] setIdleTimerDisabled: NO];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    Puredata *pd = [Puredata sharedPuredata];
    [pd.audioController setActive:YES];
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[UIApplication sharedApplication] setIdleTimerDisabled: NO];
    Puredata *pd = [Puredata sharedPuredata];
    [pd.audioController setActive:NO];
    [PdBase closeFile:@"newFirefly.pd"];
    [PdBase setDelegate:nil];
    pd.audioController=nil;
    
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
