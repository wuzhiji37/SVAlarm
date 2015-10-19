//
//  AppDelegate.h
//  final
//
//  Created by 吴智极 on 15/9/28.
//  Copyright (c) 2015年 吴智极. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainTabController *tabBarController;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

