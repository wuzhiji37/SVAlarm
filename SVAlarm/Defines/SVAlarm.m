//
//  SVAlarm.m
//  SVAlarm
//
//  Created by 吴智极 on 15/10/19.
//  Copyright © 2015年 吴智极. All rights reserved.
//

#import "SVAlarm.h"

@implementation SVAlarm
+ (void)addAlarmWithDic:(NSMutableDictionary *)dic isNew:(BOOL)isNew {
    NSMutableDictionary *tDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    UILocalNotification *noti = [[UILocalNotification alloc] init];
    if (noti) {
        NSLog(@"dic = %@",tDic);
        NSInteger hour = [[tDic objectForKey:@"hour"] integerValue];
        NSInteger minute = [[tDic objectForKey:@"minute"] integerValue];
        [tDic setObject:@"1" forKey:@"status"];
        
        NSDateComponents *comp = [[NSDateComponents alloc] init];
        NSDateComponents *compNow = [SVDate comp];
        [comp setYear:[compNow year]];
        [comp setMonth:[compNow month]];
        [comp setDay:[compNow day]];
        [comp setHour:hour];
        [comp setMinute:minute];
        [comp setSecond:0];
        NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *date = [cal dateFromComponents:comp];
        NSLog(@"date0 = %@",date);
        while ([date timeIntervalSinceDate:[NSDate date]]<=0) {
            date = [date dateByAddingTimeInterval:24*60*60];
            NSLog(@"date = %@",date);
        }
        noti.fireDate = date;
        noti.repeatInterval = NSCalendarUnitDay;
        noti.timeZone=[NSTimeZone defaultTimeZone];
        noti.applicationIconBadgeNumber = 1;
        noti.soundName= UILocalNotificationDefaultSoundName;
        noti.alertBody=@"通知内容";//提示信息 弹出提示框
        noti.alertAction = @"打开";  //提示框按钮
        noti.userInfo = tDic;
        NSLog(@"noti = %@",noti);
        [[UIApplication sharedApplication] scheduleLocalNotification:noti];
        if (isNew) {
            [[SVData sharedInstance] addAlarmInfo:tDic];
        } else {
            [[SVData sharedInstance] changeAlarmInfo:tDic];
        }
        
    }
    
}
+ (void)cancelAlarmFromDic:(NSMutableDictionary *)dic {
    NSMutableDictionary *tDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [tDic setObject:@"0" forKey:@"status"];
    for(UILocalNotification *noti in [[UIApplication sharedApplication] scheduledLocalNotifications])
    {
        NSLog(@"noti :%@",noti.userInfo);
        NSLog(@"tDic :%@",tDic);
        if ([[noti.userInfo objectForKey:@"ID"] isEqualToString:[tDic objectForKey:@"ID"]]) {
            [[SVData sharedInstance] changeAlarmInfo:tDic];
            [[UIApplication sharedApplication] cancelLocalNotification:noti];
            break;
        }
    }
}
+ (void)changeAlarmFromDic:(NSMutableDictionary *)dic toDic:(NSMutableDictionary *)newdic {
    
}
+ (void)deleteAlarmFromDic:(NSMutableDictionary *)dic {
    NSMutableDictionary *tDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    for(UILocalNotification *noti in [[UIApplication sharedApplication] scheduledLocalNotifications])
    {
        NSLog(@"noti :%@",noti.userInfo);
        NSLog(@"tDic :%@",tDic);
        if ([[noti.userInfo objectForKey:@"ID"] isEqualToString:[tDic objectForKey:@"ID"]]) {
            [[SVData sharedInstance] deleteAlarmInfo:tDic];
            [[UIApplication sharedApplication] cancelLocalNotification:noti];
            break;
        }
    }
}
@end
