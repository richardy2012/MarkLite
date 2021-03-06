//
//  AppDelegate.m
//  MarkLite
//
//  Created by zhubch on 11/3/15.
//  Copyright (c) 2015 zhubch. All rights reserved.
//

#import "AppDelegate.h"
#import "Configure.h"
#import "FileManager.h"
#import "TabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)gotoStartPage
{
    [[TabBarController currentViewContoller].navigationController popToRootViewControllerAnimated:YES];
    [TabBarController currentViewContoller].selectedIndex = 0;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UITabBar appearance] setTintColor:kTintColor];
    [[UINavigationBar appearance] setTintColor:kTitleColor];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:22/255.0 green:174/255.0 blue:235/255.0 alpha:1]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSFontAttributeName:[UIFont systemFontOfSize:18],
                                                           NSForegroundColorAttributeName:kTitleColor
                                                           }];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString *path = url.path;
    NSString *name = [path componentsSeparatedByString:@"/"].lastObject;
    NSData *content = [NSData dataWithContentsOfURL:url];
    FileManager *fm = [FileManager sharedManager];
    [fm createFile:name Content:content];
    Item *i = [[Item alloc]init];
    i.open = YES;
    i.path = name;
    [fm.root addChild:i];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"收到新文件:%@",name] message:@"" delegate:nil cancelButtonTitle:@"忽略" otherButtonTitles:@"打开", nil];
    alert.clickedButton = ^(NSInteger buttonIndex,UIAlertView *alert){
        if (buttonIndex == 1) {
            fm.currentItem = i;
            if (kDevicePhone) {
                [self gotoStartPage];
                [[TabBarController currentViewContoller].selectedViewController performSegueWithIdentifier:@"edit" sender:nil];
            }
        }
    };
    [alert show];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[FileManager sharedManager].root archive];
    [[Configure sharedConfigure] saveToFile];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[FileManager sharedManager].root archive];
    [[Configure sharedConfigure] saveToFile];
}

@end
