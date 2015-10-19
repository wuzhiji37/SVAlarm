//
//  AlarmListNavigationController.m
//  SVAlarm
//
//  Created by 吴智极 on 15/10/19.
//  Copyright © 2015年 吴智极. All rights reserved.
//

#import "AlarmListNavigationController.h"
#import "AlarmListViewController.h"
@implementation AlarmListNavigationController
- (instancetype)init {
    AlarmListViewController *alarmListNVC = [[AlarmListViewController alloc] init];
    return [self initWithRootViewController:alarmListNVC];
}
@end
