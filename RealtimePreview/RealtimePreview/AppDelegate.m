//
//  AppDelegate.m
//  VVPlayground
//
//  Created by isaced on 2018/2/6.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "SettingsViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[MainViewController alloc] initWithStyle:UITableViewStyleGrouped]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // Nav
    [[UINavigationBar appearance] setTintColor:[UIColor darkGrayColor]];
    
    return YES;
}

- (void)reloadWindow {
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[MainViewController alloc] initWithStyle:UITableViewStyleGrouped]];
}

@end

