//
//  AppDelegate.m
//  CustomEditMenuObjC
//
//  Created by JingShao on 4/4/25.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Create the window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Create and set the root view controller
    ViewController *viewController = [[ViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    // Set the navigation controller as the root of the window
    self.window.rootViewController = navigationController;
    
    // Make the window visible
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
