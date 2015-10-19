//
//  SVDate.m
//  SVAlarm
//
//  Created by 吴智极 on 15/10/12.
//  Copyright © 2015年 吴智极. All rights reserved.
//

#import "SVDate.h"

@implementation SVDate
+ (NSDateComponents *)comp {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitNanosecond;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    return comps;
}
+ (NSInteger)hour {
    return [[SVDate comp] hour];
}
+ (NSInteger)minute {
    return [[SVDate comp] minute];
}
+ (NSInteger)second {
    return [[SVDate comp] second];
}
+ (NSInteger)minutesFromHM:(NSString *)time {
    return [[time substringWithRange:NSMakeRange(0, 2)] integerValue]*60+[[time substringWithRange:NSMakeRange(3, 2)] integerValue];
}
+ (CGFloat)minutesOfToday {
    return [[SVDate comp] hour]*60 + [[SVDate comp] minute] + [[SVDate comp] second]/60.0;
}

+ (NSMutableDictionary *)dicForm {
    return [NSMutableDictionary dictionaryWithDictionary:@{@"year":@([[SVDate comp] year]),
                                                           @"month":@([[SVDate comp] month]),
                                                           @"day":@([[SVDate comp] day]),
                                                           @"weekday":@([[SVDate comp] weekday]),
                                                           @"hour":@([SVDate hour]),
                                                           @"minute":@([SVDate minute]),
                                                           @"second":@([SVDate second]),
                                                           @"nanosecond":@([[SVDate comp] nanosecond])}];
}
@end
