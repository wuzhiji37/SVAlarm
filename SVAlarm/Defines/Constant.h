//
//  Constant.h
//  SVAlarm
//
//  Created by 吴智极 on 15/10/8.
//  Copyright (c) 2015年 吴智极. All rights reserved.
//

#ifndef SVAlarm_Constant_h
#define SVAlarm_Constant_h
#define SVLog(fmt,...)              NSLog((@"\n%s[Line %d]\n" fmt ), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#define WINDOW                      ((AppDelegate *)[UIApplication sharedApplication].delegate).window

#define WIDTH_SCREEN                ([UIScreen mainScreen].bounds.size.width)
#define HEIGHT_SCREEN               ([UIScreen mainScreen].bounds.size.height)
#define WIDTH(a)                    ((a).frame.size.width)
#define HEIGHT(a)                   ((a).frame.size.height)
#define ORIGIN_X(a)                 ((a).frame.origin.x)
#define ORIGIN_Y(a)                 ((a).frame.origin.y)
#define FrameAfter(a)               ((a).frame.size.width+((a).frame.origin.x))
#define FrameBelow(a)               ((a).frame.size.height+((a).frame.origin.y))
#define CGRectZeroBelow(a)          CGRectMake(0, FrameBelow(a), 0, 0)

#define RGBW(a)                     [UIColor colorWithRed:255 green:255 blue:255 alpha:(a)]
#define RGBB(a)                     [UIColor colorWithRed:0 green:0 blue:0 alpha:(a)]
#define RGBO(x)                     [UIColor colorWithRed:(x)/255.0 green:(x)/255.0 blue:(x)/255.0 alpha:1]
#define RGBA(r,g,b,a)               [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define RGB(r,g,b)                  RGBA((r),(g),(b),1)

#define HSBA(h,s,b,a)               [UIColor colorWithHue:(h)/360.0 saturation:(s)/100.0 brightness:(b)/100.0 alpha:(a)]
#define HSB(h,s,b)                  HSBA((h),(s),(b),1)

#define IMAGE(image)                [UIImage imageNamed:(image)]
#define INDEX(i,j)                  [NSIndexPath indexPathForRow:(j) inSection:(i)]
#define URL(url)                    [NSURL URLWithString:url]
#define UTF8(string)                [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
#define FONT(f)                     [UIFont systemFontOfSize:(f)];

#define M_PIx2                      6.28318530717958647692528676655900576
#define KEY_QQAPI                   @"ZS7BZ-4PYR4-IAGU5-XFP6C-GVN7F-FVFAR"
#define KEY_BAIDUAPI                @"2445ff7227559111a9867d432e52af0f"

typedef enum {
    SVAlarmModeOnce = 0,
    SVAlarmMode0    = 1<<0,
    SVAlarmMode1    = 1<<1,
    SVAlarmMode2    = 1<<2,
    SVAlarmMode3    = 1<<3,
    SVAlarmMode4    = 1<<4,
    SVAlarmMode5    = 1<<5,
    SVAlarmMode6    = 1<<6,
}SVAlarmMode;


#endif
