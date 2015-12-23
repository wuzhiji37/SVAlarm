//
//  AppDelegate.m
//  SVAlarm
//
//  Created by 吴智极 on 15/9/28.
//  Copyright (c) 2015年 吴智极. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    application.applicationIconBadgeNumber = 0;
    
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"alarmArray"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [SVData sharedInstance];
    

    for(UILocalNotification *noti in [SVData sharedInstance].notiArray) {
        NSLog(@"id = %@",[noti.userInfo objectForKey:@"ID"]);
    }
    
    //定位
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest; //控制定位精度,越高耗电量越大。
        _locationManager.distanceFilter = 100; //控制定位服务更新频率。单位是“米”
        [_locationManager requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了
        [_locationManager startUpdatingLocation];
    }
    
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:[NSDate date]
                                              interval:0.04
                                                target:self
                                              selector:@selector(updateTime)
                                              userInfo:nil
                                               repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
    {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.tabBarController = [[MainTabController alloc] init];
    [self.window setRootViewController:self.tabBarController];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation * curLocation = [locations lastObject];
    
    [SVData sharedInstance].latitude = curLocation.coordinate.latitude;
    [SVData sharedInstance].longitude = curLocation.coordinate.longitude;
    NSLog(@"%@",@(curLocation.coordinate.latitude));
    NSLog(@"%@",@(curLocation.coordinate.longitude));
    [SVNetwork getddByUrlPath:@"http://apis.map.qq.com/ws/geocoder/v1"
                       params:[NSString stringWithFormat:@"location=%@,%@&coord_type=%@&get_poi=0&key=%@&output=json",@(curLocation.coordinate.latitude),@(curLocation.coordinate.longitude),@(1),KEY_QQAPI]
                     callBack:^(NSURLResponse *response, NSData *data, NSError *error) {
                         if (!error) {
                             NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                             if (!error) {
                                 [SVData sharedInstance].location = [[dic objectForKey:@"result"] objectForKey:@"ad_info"];
                                 NSLog(@"location A = %@",[SVData sharedInstance].location);
                             } else {
                                 [SVData sharedInstance].location = nil;
                                 NSLog(@"A localizedDescription:%@, code:%@",error.localizedDescription ,@(error.code));
                             }
                         } else {
                             [SVData sharedInstance].location = nil;
                             NSLog(@"B localizedDescription:%@, code:%@",error.localizedDescription ,@(error.code));
                         }
                         [SVData sharedInstance].locationCompDic = [SVDate dicForm];
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"updateLocation" object:nil];
                     }];
    [_locationManager stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [SVData sharedInstance].location = nil;
    [SVData sharedInstance].locationCompDic = [SVDate dicForm];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateLocation" object:nil];
    NSLog(@"error = %@",error.description);
}
- (void)updateTime {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTime" object:nil userInfo:@{@"comp":[SVDate comp]}];
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [_locationManager startUpdatingLocation];
    NSLog(@"%s",__FUNCTION__);
    application.applicationIconBadgeNumber = 0;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [_locationManager stopUpdatingLocation];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [_locationManager startUpdatingLocation];
    NSLog(@"%s",__FUNCTION__);
    application.applicationIconBadgeNumber = 0;
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [_locationManager startUpdatingLocation];
    NSLog(@"%s",__FUNCTION__);
    application.applicationIconBadgeNumber = 0;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [_locationManager stopUpdatingLocation];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
