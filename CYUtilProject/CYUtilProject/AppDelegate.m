//
//  AppDelegate.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 10/13/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "AppDelegate.h"

#import "CYShare.h"
#import "CYIPUtils.h"

#import "UIImage+CYScale.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    int a = 245;
    int b = 1234;
    const int c = 23;
    const int *p = &a;
    p = &b;
    
    int *q = &c;
    *q = 203;
    
    NSLog(@"aaa = %d", *p);
    NSLog(@"%d", *q);
    NSLog(@"%d", c);
    NSLog(@"%.0f", 2.56);
    NSLog(@"%.0f", 2.46);

    NSLog(@"IP Address : %@", [CYIPUtils IPAddress]);

    [CYShare registerWechatAppId:@"wx891f8f3380cba5e9"];
    [CYShare registerQQAppId:@"1104237169"];
    [CYShare registerWeiboAppKey:@"3180958896"];
    
    UIImage *bg = [[UIImage imageNamed:@"common_navigation_background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 0, 2, 0)];
    [[UINavigationBar appearance] setBackgroundImage:bg
                                       forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor],
                                                            NSFontAttributeName : [UIFont systemFontOfSize:17.f]}];

    UITabBarController *tabBar = (UITabBarController *)self.window.rootViewController;

    UIImage *image = [[UIImage imageNamed:@"tab_origin"] cy_imageByScaleToSize:CGSizeMake(28, 28)];
    NSLog(@"%zu", CGImageGetWidth(image.CGImage));
    tabBar.viewControllers[0].tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  tag:0];
    tabBar.viewControllers[1].tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[[UIImage imageNamed:@"tab_1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:1];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [CYShare handleOpenURL:url];
}

@end
