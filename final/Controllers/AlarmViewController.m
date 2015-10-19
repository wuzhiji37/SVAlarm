//
//  AlarmViewController.m
//
//
//  Created by 吴智极 on 15/10/8.
//
//

#import "AlarmViewController.h"

#define DIFF            (WIDTH(self.view)/21)
#define COLOR_A_X       135
#define COLOR_A_Y       206
#define COLOR_A_Z       250

#define COLOR_B_X       0
#define COLOR_B_Y       0
#define COLOR_B_Z       139
@implementation AlarmViewController {
    
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        needUpdate = YES;
        canUpdateWeather = NO;
        NSLog(@"width = %@",@(self.view.frame.size.width));
        
        
        
        self.view.backgroundColor = [self backcolorForMinute:[SVDate minutesOfToday]];
        [self addNotifications];
        [self addTimer];
    }
    return self;
}
- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTime:) name:@"updateTime" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWeatherSun) name:@"updateWeather" object:nil];
}

- (void)addTimer {
    _timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:1 target:self selector:@selector(startUpdate) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}
#pragma mark - Notifications
- (void)updateTime:(NSNotification *)noti {
    NSDictionary *userinfo = noti.userInfo;
    NSDateComponents *comp = (NSDateComponents *)[userinfo objectForKey:@"comp"];
    if (needUpdate) {
        //        NSLog(@"comp = %@",comp);
        _hourControl.value = [comp hour];
        _minuteControl.value = [comp minute];
        _secondControl.value = [comp second];
        //NSLog(@"%@:%@:%@",@(hourControl.value),@(minuteControl.value),@(secondControl.value));
    }
    
}
- (void)updateWeatherSun {
    CGFloat nowM = _hourControl.value*60 + _minuteControl.value + _secondControl.value/60.0;
    //    NSLog(@"sun %@",@(nowM));
    [UIView animateWithDuration:.5
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.view.backgroundColor = [self backcolorForMinute:nowM];
                     }
                     completion:^(BOOL finished) {
                         canUpdateWeather = YES;
                     }];
}
- (void)updateWeatherInfo {
    NSMutableDictionary *weather = [SVData sharedInstance].weather;
    NSMutableDictionary *weatherCompDic = [SVData sharedInstance].weatherCompDic;
    NSLog(@"weather = %@",weather);
    NSLog(@"weatherCompDic = %@",weatherCompDic);
    _weatherLabel_refresh.text = [NSString stringWithFormat:@"%@\n更新于%@月%@日 %02d:%02d",
                                  [weather objectForKey:@"city"],
                                  [weatherCompDic objectForKey:@"month"],
                                  [weatherCompDic objectForKey:@"day"],
                                  [[weatherCompDic objectForKey:@"hour"] intValue],
                                  [[weatherCompDic objectForKey:@"minute"] intValue]];
    _weatherLabel_refresh.font = FONT([UIFont fontsizeWithSize:_weatherLabel_refresh.frame.size andText:_weatherLabel_refresh.text]);
    
    NSDictionary *weatherTodayDic = [weather objectForKey:@"today"];
    NSString *weatherStr = [weatherTodayDic objectForKey:@"type"];
//    weatherStr = @"暴雨";
    NSString *weatherPinyin = [[weatherStr transformToMandarinWithMark:NO] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *imageUrlStr = [NSString stringWithFormat:@"http://php.weather.sina.com.cn/images/yb3/180_180/%@_%d.png", weatherPinyin, isDay?0:1];
    NSLog(@"image = %@",imageUrlStr);
    [_weatherIV sd_setImageWithURL:URL(UTF8(imageUrlStr))
                  placeholderImage:nil
                           options:SDWebImageHighPriority
                         completed:nil];
    
    _weatherLabel_now.text = [NSString stringWithFormat:@"%@",[weatherTodayDic objectForKey:@"curTemp"]];
    _weatherLabel_now.font = FONT([UIFont fontsizeWithSize:_weatherLabel_now.frame.size andText:_weatherLabel_now.text]);
    _weatherLabel_temper.text = [NSString stringWithFormat:@"今日温度:%@ ~ %@",[weatherTodayDic objectForKey:@"lowtemp"],[weatherTodayDic objectForKey:@"hightemp"]];
    _weatherLabel_temper.font = FONT([UIFont fontsizeWithSize:_weatherLabel_temper.frame.size andText:_weatherLabel_temper.text]);
    
}
#pragma mark - Timer
- (void)startUpdate {
    if (canUpdateWeather) {
        [self updateWeatherSun];
    }
}
- (UIColor *)backcolorForMinute:(CGFloat)thisM {
    if ([SVData sharedInstance].weather && thisM>=0) {
        NSString *sunrise = [[SVData sharedInstance].weather objectForKey:@"sunrise"] ;
        NSInteger sunriseM = [SVDate minutesFromHM:sunrise];
        NSString *sunset = [[SVData sharedInstance].weather objectForKey:@"sunset"] ;
        NSInteger sunsetM = [SVDate minutesFromHM:sunset];
        
        if (thisM > sunriseM+60 && thisM < sunsetM-60) {
            isDay = YES;
        } else {
            isDay = NO;
        }
        if (thisM < sunriseM-60 || thisM > sunsetM+60) {
            return RGB(COLOR_B_X, COLOR_B_Y, COLOR_B_Z);
        } else if (thisM > sunriseM+60 && thisM < sunsetM-60) {
            return RGB(COLOR_A_X, COLOR_A_Y, COLOR_A_Z);
        } else if (thisM >= sunriseM-60 && thisM <= sunriseM+60) {
            return RGB(COLOR_B_X+(COLOR_A_X-COLOR_B_X)/120.0*(thisM-sunriseM+60),
                       COLOR_B_Y+(COLOR_A_Y-COLOR_B_Y)/120.0*(thisM-sunriseM+60),
                       COLOR_B_Z+(COLOR_A_Z-COLOR_B_Z)/120.0*(thisM-sunriseM+60));
        } else if (thisM >= sunsetM-60 && thisM <= sunsetM+60) {
            return RGB(COLOR_A_X-(COLOR_A_X-COLOR_B_X)/120.0*(thisM-sunsetM+60),
                       COLOR_A_Y-(COLOR_A_Y-COLOR_B_Y)/120.0*(thisM-sunsetM+60),
                       COLOR_A_Z-(COLOR_A_Z-COLOR_B_Z)/120.0*(thisM-sunsetM+60));
        } else {
            NSLog(@"sun error %@,%@,%@",@(sunriseM),@(sunsetM),@(thisM));
            return RGB((COLOR_A_X+COLOR_B_X)/2.0,
                       (COLOR_A_Y+COLOR_B_Y)/2.0,
                       (COLOR_A_Z+COLOR_B_Z)/2.0);
        }
    } else {
        return RGB((COLOR_A_X+COLOR_B_X)/2.0,
                   (COLOR_A_Y+COLOR_B_Y)/2.0,
                   (COLOR_A_Z+COLOR_B_Z)/2.0);
    }
}
- (UIColor *)forecolorForMinute:(CGFloat)thisM {
    UIColor *backColor = [self backcolorForMinute:thisM];
    CGFloat h,s,b,a;
    [backColor getHue:&h saturation:&s brightness:&b alpha:&a];
    return HSBA(30, s*100, b*100, a);
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createCircleControl];
    [self createWeatherView];
    [self createAlarmView];
}
- (void)createCircleControl {
    if ([[SVData sharedInstance].device isEqualToString:@"iphone"]) {
        if ([SVData sharedInstance].width == 320) {
            hourRadius = 15;
            hourCircleLineWidth = 3;
            hourHandleLineWidth = 3;
            minuteRadius = 12;
            minuteCircleLineWidth = 2;
            minuteHandleLineWidth = 2;
            secondRadius = 10;
            secondCircleLineWidth = 1;
            secondHandleLineWidth = 1;
            
        } else {
            hourRadius = 25;
            hourCircleLineWidth = 3;
            hourHandleLineWidth = 3;
            minuteRadius = 15;
            minuteCircleLineWidth = 2;
            minuteHandleLineWidth = 2;
            secondRadius = 10;
            secondCircleLineWidth = 1;
            secondHandleLineWidth = 1;
            
        }
        
    } else if ([[SVData sharedInstance].device isEqualToString:@"ipad"]) {
        hourRadius = 40;
        hourCircleLineWidth = 8;
        hourHandleLineWidth = 5;
        minuteRadius = 30;
        minuteCircleLineWidth = 5;
        minuteHandleLineWidth = 3;
        secondRadius = 20;
        secondCircleLineWidth = 3;
        secondHandleLineWidth = 2;
    } else {
        hourRadius = 25;
        hourCircleLineWidth = 8;
        hourHandleLineWidth = 5;
        minuteRadius = 15;
        minuteCircleLineWidth = 5;
        minuteHandleLineWidth = 3;
        secondRadius = 10;
        secondCircleLineWidth = 3;
        secondHandleLineWidth = 2;
    }
    
    NSLog(@"%@,%@,%@",@(hourRadius),@(hourCircleLineWidth),@(hourHandleLineWidth));
    _hourControl = [[SVCircleControl alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view)-10, WIDTH(self.view)-10)];
    _hourControl.center = self.view.center;
    _hourControl.backgroundColor = RGBB(0.1);
    [_hourControl setMaxvalue:24 andMinvalue:0 withStep:1];
    _hourControl.circleLineWidth = hourCircleLineWidth;
    _hourControl.handleLineWidth = hourHandleLineWidth;
    _hourControl.handleRadius = hourRadius;
    [_hourControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_hourControl];
    
    _minuteControl = [[SVCircleControl alloc] initWithFrame:CGRectMake(0, 0, WIDTH(_hourControl)-hourRadius*4-hourHandleLineWidth*2-5, WIDTH(_hourControl)-hourRadius*4-hourHandleLineWidth*2-5)];
    _minuteControl.backgroundColor = RGBB(0.1);
    _minuteControl.center = self.view.center;
    [_minuteControl setMaxvalue:60 andMinvalue:0 withStep:1];
    _minuteControl.circleLineWidth = minuteCircleLineWidth;
    _minuteControl.handleLineWidth = minuteHandleLineWidth;
    _minuteControl.handleRadius = minuteRadius;
    [_minuteControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_minuteControl];
    
    _secondControl = [[SVCircleControl alloc] initWithFrame:CGRectMake(0, 0, WIDTH(_minuteControl)-minuteRadius*4-minuteHandleLineWidth*2-5, WIDTH(_minuteControl)-minuteRadius*4-minuteHandleLineWidth*2-5)];
    _secondControl.backgroundColor = RGBB(0.1);
    _secondControl.center = self.view.center;
    [_secondControl setMaxvalue:60 andMinvalue:0 withStep:1];
    _secondControl.circleLineWidth = secondCircleLineWidth;
    _secondControl.handleLineWidth = secondHandleLineWidth;
    _secondControl.handleRadius = secondRadius;
    _secondControl.userInteractionEnabled = NO;
    [self.view addSubview:_secondControl];
    
    _hourControl.foreColor = RGBA(160, 85, 32, 1);
    _minuteControl.foreColor = RGBA(200, 85, 32, 1);
    _secondControl.foreColor = RGBA(240, 85, 32, 1);
    
    //    NSLog(@"%@,%@,%@",NSStringFromCGRect(_hourControl.frame),NSStringFromCGRect(_minuteControl.frame),NSStringFromCGRect(_secondControl.frame));
    alarmBase = WIDTH(_secondControl)/30;
}
- (void)createWeatherView {
    _weatherIV = [[UIImageView alloc] init];
    _weatherIV.bounds = CGRectMake(0, 0, alarmBase*12, alarmBase*12);
    _weatherIV.center = self.view.center;
    _weatherIV.layer.cornerRadius = HEIGHT(_weatherIV)/2;
    _weatherIV.layer.masksToBounds = YES;
    [self.view addSubview:_weatherIV];
    
    _weatherLabel_refresh = [[UILabel alloc] init];
    _weatherLabel_refresh.bounds = CGRectMake(0, 0, alarmBase*15, alarmBase*3);
    CGFloat weatherLabelCenter_refresh = self.view.center.y - HEIGHT(_secondControl)/2 + (alarmBase*4+HEIGHT(_weatherLabel_refresh)/2);
    _weatherLabel_refresh.center = CGPointMake(self.view.center.x, weatherLabelCenter_refresh);
    _weatherLabel_refresh.textAlignment = NSTextAlignmentCenter;
    _weatherLabel_refresh.textColor = RGBA(200, 85, 32, 1);
    _weatherLabel_refresh.numberOfLines = 2;
    [self.view addSubview:_weatherLabel_refresh];
    
    _weatherLabel_now = [[UILabel alloc] init];
    _weatherLabel_now.bounds = CGRectMake(0, 0, alarmBase*18, alarmBase*4);
    CGFloat weatherLabelCenter_now = self.view.center.y + HEIGHT(_secondControl)/2 - (alarmBase*7+HEIGHT(_weatherLabel_now)/2);
    _weatherLabel_now.center = CGPointMake(self.view.center.x, weatherLabelCenter_now);
    _weatherLabel_now.textAlignment = NSTextAlignmentCenter;
    _weatherLabel_now.textColor = RGBA(200, 85, 32, 1);
    _weatherLabel_now.numberOfLines = 1;
    [self.view addSubview:_weatherLabel_now];
    
    
    _weatherLabel_temper = [[UILabel alloc] init];
    _weatherLabel_temper.bounds = CGRectMake(0, 0, alarmBase*16, alarmBase*3);
    CGFloat weatherLabelCenter_temper = self.view.center.y + HEIGHT(_secondControl)/2 - (alarmBase*3+HEIGHT(_weatherLabel_temper)/2);
    _weatherLabel_temper.center = CGPointMake(self.view.center.x, weatherLabelCenter_temper);
    _weatherLabel_temper.textAlignment = NSTextAlignmentCenter;
    _weatherLabel_temper.textColor = RGBA(200, 85, 32, 1);
    _weatherLabel_temper.numberOfLines = 1;
    [self.view addSubview:_weatherLabel_temper];
    
    [self updateWeatherInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWeatherInfo) name:@"updateWeather" object:nil];
}
- (void)createAlarmView {
    _alarmBtn_add = [UIButton buttonWithType:UIButtonTypeCustom];
    _alarmBtn_add.bounds = CGRectMake(0, 0, alarmBase*12, alarmBase*12);
    _alarmBtn_add.center = self.view.center;
    _alarmBtn_add.layer.cornerRadius = HEIGHT(_alarmBtn_add)/2;
    _alarmBtn_add.layer.masksToBounds = YES;
    NSString *alarmTitle_add = @"添加闹钟";
    [_alarmBtn_add setTitle:alarmTitle_add forState:UIControlStateNormal];
    _alarmBtn_add.titleLabel.font = FONT([UIFont fontsizeWithSize:_alarmBtn_add.frame.size andText:alarmTitle_add]);
    [_alarmBtn_add setBackgroundColor:[UIColor redColor]];
    [_alarmBtn_add addTarget:self action:@selector(addAlarmClick:) forControlEvents:UIControlEventTouchUpInside];
    _alarmBtn_add.alpha = 0;
    _alarmBtn_add.userInteractionEnabled = NO;
    [self.view addSubview:_alarmBtn_add];
    
    _alarmBtn_cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    _alarmBtn_cancel.bounds = CGRectMake(0, 0, alarmBase*6, alarmBase*6);
    CGFloat alarmCenterY_cancel = self.view.center.y - HEIGHT(_secondControl)/2 + (alarmBase*1+HEIGHT(_alarmBtn_cancel)/2);
    _alarmBtn_cancel.center = CGPointMake(self.view.center.x, alarmCenterY_cancel);
    _alarmBtn_cancel.layer.cornerRadius = HEIGHT(_alarmBtn_cancel)/2;
    _alarmBtn_cancel.layer.masksToBounds = YES;
    NSString *alarmTitle_cancel = @"取消";
    [_alarmBtn_cancel setTitle:alarmTitle_cancel forState:UIControlStateNormal];
    _alarmBtn_cancel.titleLabel.font = FONT([UIFont fontsizeWithSize:_alarmBtn_cancel.frame.size andText:alarmTitle_cancel]);
    [_alarmBtn_cancel setBackgroundColor:[UIColor redColor]];
    [_alarmBtn_cancel addTarget:self action:@selector(cancelAlarmClick) forControlEvents:UIControlEventTouchUpInside];
    _alarmBtn_cancel.alpha = 0;
    _alarmBtn_cancel.userInteractionEnabled = NO;
    [self.view addSubview:_alarmBtn_cancel];
}

#pragma mark - Actions
- (void)valueChanged:(SVCircleControl *)control {
    needUpdate = NO;
    [self setSecondControlHidden:YES];
    [self setWeatherViewHidden:YES];
    [self setAlarmViewHidden:NO];
}
- (void)setSecondControlHidden:(BOOL)hidden {
    if (hidden) {
        if (_secondControl.alpha == 1) {
            [UIView animateWithDuration:.5
                             animations:^{
                                 _secondControl.alpha = 0;
                             }];
        }
    } else {
        if (_secondControl.alpha == 0) {
            [UIView animateWithDuration:.5
                             animations:^{
                                 _secondControl.alpha = 1;
                             }];
        }
    }
}
- (void)setWeatherViewHidden:(BOOL)hidden {
    if (hidden) {
        [UIView animateWithDuration:.5
                         animations:^{
                             _weatherIV.alpha = 0;
                             _weatherLabel_refresh.alpha = 0;
                             _weatherLabel_now.alpha = 0;
                             _weatherLabel_temper.alpha = 0;
                         }];
    } else {
        [UIView animateWithDuration:.5
                         animations:^{
                             _weatherIV.alpha = 1;
                             _weatherLabel_refresh.alpha = 1;
                             _weatherLabel_now.alpha = 1;
                             _weatherLabel_temper.alpha = 1;
                         }];
    }
}
- (void)setAlarmViewHidden:(BOOL)hidden {
    if (hidden) {
        _alarmBtn_add.userInteractionEnabled = NO;
        _alarmBtn_cancel.userInteractionEnabled = NO;
        [UIView animateWithDuration:.5
                         animations:^{
                             _alarmBtn_add.alpha = 0;
                             _alarmBtn_cancel.alpha =0;
                         }];
    } else {
        [UIView animateWithDuration:.5
                         animations:^{
                             _alarmBtn_add.alpha = 1;
                             _alarmBtn_cancel.alpha = 1;
                         } completion:^(BOOL finished) {
                             _alarmBtn_add.userInteractionEnabled = YES;
                             _alarmBtn_cancel.userInteractionEnabled = YES;
                         }];
    }
}




- (void)addAlarmClick:(UIButton *)btn {
    NSLog(@"add %@:%@",@(_hourControl.value),@(_minuteControl.value));
    UILocalNotification *noti = [[UILocalNotification alloc] init];
    if (noti) {
        NSInteger hour = _hourControl.value;
        NSInteger minute = _minuteControl.value;
        

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
        u_int32_t random = arc4random();
        NSMutableDictionary *info = [NSMutableDictionary dictionaryWithObject:@(random) forKey:@"ID"];
        [info setObject:@(hour) forKey:@"hour"];
        [info setObject:@(minute) forKey:@"minute"];
        [info setObject:@(1) forKey:@"repeat"];
        noti.userInfo = info;
        NSLog(@"noti = %@",noti);
        //        [[UIApplication sharedApplication] scheduleLocalNotification:noti];
        //
        [[SVData sharedInstance] addAlarmInfo:info];
    }
    needUpdate = YES;
    [self setSecondControlHidden:NO];
    [self setWeatherViewHidden:NO];
    [self setAlarmViewHidden:YES];
}

- (void)cancelAlarmClick {
    needUpdate = YES;
    [self setSecondControlHidden:NO];
    [self setWeatherViewHidden:NO];
    [self setAlarmViewHidden:YES];
}
#pragma mark - Touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    //    NSLog(@"%@",NSStringFromCGPoint(point));
    //    NSLog(@"class %@",NSStringFromClass([touch.view class]));
    //    NSLog(@"class 2 %@",[self.view hitTest:point withEvent:event]);
}
@end
