//
//  SlidableAppDelegate.m
//  SlideOutMenu
//
//  Created by CocoaPods on 12/17/2014.
//  Copyright (c) 2014 rashaad ramdeen. All rights reserved.
//

#import "ExampleAppDelegate.h"
#import "SlidableViewController.h"
#import "CustomMenuViewController.h"

@implementation ExampleAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *greenVC = (UINavigationController *)[mainStoryBoard instantiateViewControllerWithIdentifier:@"greenVC"];
    //this title will be used for the menu link
    [greenVC setTitle:@"Green Link"];
    
    UINavigationController *blueVC = (UINavigationController *)[mainStoryBoard instantiateViewControllerWithIdentifier:@"blueVC"];
    //this title will be used for the menu link
    [blueVC setTitle:@"Blue Link"];
    
    UINavigationController *tableVC = (UINavigationController *)[mainStoryBoard instantiateViewControllerWithIdentifier:@"tableVC"];
    //this title will be used for the menu link
    [tableVC setTitle:@"Table Link"];
    
    UINavigationController *mapVC = (UINavigationController *)[mainStoryBoard instantiateViewControllerWithIdentifier:@"mapVC"];
    //this title will be used for the menu link
    [mapVC setTitle:@"Map Link"];
    
    CustomMenuViewController *customMVC = (CustomMenuViewController *)[mainStoryBoard instantiateViewControllerWithIdentifier:@"customMenu"];
    
    //our slidable menu controller
    SlidableViewController *slidableVC = [[SlidableViewController alloc] initWithViewControllers:@[greenVC, blueVC, tableVC, mapVC] andMenuViewController:customMVC];
    
    self.window.rootViewController = slidableVC;
    
    [self.window makeKeyAndVisible];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
