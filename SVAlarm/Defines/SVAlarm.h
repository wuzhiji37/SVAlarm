//
//  SVAlarm.h
//  SVAlarm
//
//  Created by 吴智极 on 15/10/19.
//  Copyright © 2015年 吴智极. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVAlarm : NSObject
+ (void)addAlarmWithDic:(NSMutableDictionary *)dic isNew:(BOOL)isNew;
+ (void)cancelAlarmFromDic:(NSMutableDictionary *)dic;
+ (void)changeAlarmFromDic:(NSMutableDictionary *)dic;
+ (void)deleteAlarmFromDic:(NSMutableDictionary *)dic;
@end
