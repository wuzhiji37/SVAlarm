//
//  SVDate.h
//  SVAlarm
//
//  Created by 吴智极 on 15/10/12.
//  Copyright © 2015年 吴智极. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVDate : NSObject
+ (NSDateComponents *)comp;
+ (NSInteger)hour;
+ (NSInteger)minute;
+ (NSInteger)second;
+ (NSInteger)minutesFromHM:(NSString *)time;
+ (CGFloat)minutesOfToday;

+ (NSMutableDictionary *)dicForm;
@end
