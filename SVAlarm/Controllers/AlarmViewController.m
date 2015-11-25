//
//  AlarmViewController.m
//
//
//  Created by 吴智极 on 15/10/8.
//
//

#import "AlarmViewController.h"
#import "AlarmTableViewCell.h"

#define COLOR_A_X       135
#define COLOR_A_Y       206
#define COLOR_A_Z       250

#define COLOR_B_X       0
#define COLOR_B_Y       0
#define COLOR_B_Z       139

#define ORANGE_1        RGB(160, 85, 32)
#define ORANGE_2        RGB(200, 85, 32)
#define ORANGE_3        RGB(240, 85, 32)

@implementation AlarmViewController {
    
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.view.backgroundColor = [self backcolorForMinute:[SVDate minutesOfToday]];
        [self addNotification];
        [self addTimer];
    }
    return self;
}
- (void)initProperty {
    needUpdate = YES;
    canUpdateWeather = NO;
    isDay = YES;
    _alarmArray = [SVData sharedInstance].alarmArray;
    circleState = SVCircleStateNormal;
    alarmStatus = AlarmStatusNormal;
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
        cellHeight = 80;
        cellWidth = 80;
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
        
        cellHeight = 150;
        cellWidth = 150;
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
        
        cellHeight = 80;
        cellWidth = 80;
    }
    circleLen = MIN(WIDTH(self.view)-40, HEIGHT(self.view)-cellHeight-60);
}
#pragma mark - Notification
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTime:) name:@"updateTime" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWeatherSun) name:@"updateWeather" object:nil];
}
- (void)updateTime:(NSNotification *)noti {
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithDictionary:noti.userInfo];
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
                        options:UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionAllowUserInteraction
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
    
    NSMutableDictionary *weatherTodayDic = [weather objectForKey:@"today"];
    if (weatherTodayDic && _secondControl.alpha == 1) {
        [self setWeatherViewHidden:NO];
    }
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
- (void)addTimer {
    _timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:1 target:self selector:@selector(startUpdate) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}
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
    [self initProperty];
    [self showCircleView];
    [self showWeatherView];
    [self showAlarmAddView];
    [self showAlarmTV];
    [self showAlarmSettingView];
    [self addRecognizer];
}
- (void)showCircleView {
    NSLog(@"%@,%@,%@",@(hourRadius),@(hourCircleLineWidth),@(hourHandleLineWidth));
    _circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, circleLen, circleLen)];
    _circleView.center = self.view.center;
    [self.view addSubview:_circleView];
    
    CGFloat hourX = 5;
    CGFloat hourWidth = WIDTH(_circleView)-2*hourX;
    _hourControl = [[SVCircleControl alloc] initWithFrame:CGRectMake(hourX, hourX, hourWidth, hourWidth)];
    _hourControl.backgroundColor = RGBB(0.1);
    [_hourControl setMaxvalue:24 andMinvalue:0 withStep:1];
    _hourControl.circleLineWidth = hourCircleLineWidth;
    _hourControl.handleLineWidth = hourHandleLineWidth;
    _hourControl.handleRadius = hourRadius;
    [_hourControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [_circleView addSubview:_hourControl];
    
    CGFloat minuteX = hourX+hourRadius*2+hourHandleLineWidth+2;
    CGFloat minuteWidth = WIDTH(_circleView)-2*minuteX;
    
    _minuteControl = [[SVCircleControl alloc] initWithFrame:CGRectMake(minuteX, minuteX, minuteWidth, minuteWidth)];
    _minuteControl.backgroundColor = RGBB(0.1);
    [_minuteControl setMaxvalue:60 andMinvalue:0 withStep:1];
    _minuteControl.circleLineWidth = minuteCircleLineWidth;
    _minuteControl.handleLineWidth = minuteHandleLineWidth;
    _minuteControl.handleRadius = minuteRadius;
    [_minuteControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [_circleView addSubview:_minuteControl];
    
    CGFloat secondX = minuteX+minuteRadius*2+minuteHandleLineWidth+2;
    CGFloat secondWidth = WIDTH(_circleView)-2*secondX;
    
    _secondControl = [[SVCircleControl alloc] initWithFrame:CGRectMake(secondX, secondX, secondWidth, secondWidth)];
    _secondControl.backgroundColor = RGBB(0.1);
    [_secondControl setMaxvalue:60 andMinvalue:0 withStep:1];
    _secondControl.circleLineWidth = secondCircleLineWidth;
    _secondControl.handleLineWidth = secondHandleLineWidth;
    _secondControl.handleRadius = secondRadius;
    _secondControl.userInteractionEnabled = NO;
    [_circleView addSubview:_secondControl];
    
    _hourControl.foreColor = ORANGE_1;
    _minuteControl.foreColor = ORANGE_2;
    _secondControl.foreColor = ORANGE_3;
    
    //    NSLog(@"%@,%@,%@",NSStringFromCGRect(_hourControl.frame),NSStringFromCGRect(_minuteControl.frame),NSStringFromCGRect(_secondControl.frame));
    alarmBase = WIDTH(_secondControl)/30;
}
- (void)showWeatherView {
    CGFloat weatherIVWidth = alarmBase*12;
    CGFloat weatherIVX = (WIDTH(_circleView)-weatherIVWidth)/2;
    _weatherIV = [[UIImageView alloc] initWithFrame: CGRectMake(weatherIVX, weatherIVX, weatherIVWidth, weatherIVWidth)];
    _weatherIV.layer.cornerRadius = weatherIVWidth/2;
    _weatherIV.layer.masksToBounds = YES;
    _weatherIV.alpha = 0;
    [_circleView addSubview:_weatherIV];
    
    CGFloat weatherLabel_refreshWidth = alarmBase*15;
    CGFloat weatherLabel_refreshHeight = alarmBase*3;
    CGFloat weatherLabel_refreshX = (WIDTH(_circleView)-weatherLabel_refreshWidth)/2;
    CGFloat weatherLabel_refreshY = ORIGIN_Y(_secondControl)+alarmBase*4;
    _weatherLabel_refresh = [[UILabel alloc] initWithFrame:CGRectMake(weatherLabel_refreshX, weatherLabel_refreshY, weatherLabel_refreshWidth, weatherLabel_refreshHeight)];
    _weatherLabel_refresh.textAlignment = NSTextAlignmentCenter;
    _weatherLabel_refresh.textColor = ORANGE_2;
    _weatherLabel_refresh.numberOfLines = 2;
    _weatherLabel_refresh.alpha = 0;
    [_circleView addSubview:_weatherLabel_refresh];
    
    CGFloat weatherLabel_nowWidth = alarmBase*18;
    CGFloat weatherLabel_nowHeight = alarmBase*4;
    CGFloat weatherLabel_nowX = (WIDTH(_circleView)-weatherLabel_nowWidth)/2;
    CGFloat weatherLabel_nowY = FrameBelow(_secondControl)-alarmBase*11;
    _weatherLabel_now = [[UILabel alloc] initWithFrame:CGRectMake(weatherLabel_nowX, weatherLabel_nowY, weatherLabel_nowWidth, weatherLabel_nowHeight)];
    _weatherLabel_now.textAlignment = NSTextAlignmentCenter;
    _weatherLabel_now.textColor = ORANGE_2;
    _weatherLabel_now.numberOfLines = 1;
    _weatherLabel_now.alpha = 0;
    [_circleView addSubview:_weatherLabel_now];
    
    CGFloat weatherLabel_temperWidth = alarmBase*16;
    CGFloat weatherLabel_temperHeight = alarmBase*3;
    CGFloat weatherLabel_temperX = (WIDTH(_circleView)-weatherLabel_temperWidth)/2;
    CGFloat weatherLabel_temperY = FrameBelow(_secondControl)-alarmBase*8;
    _weatherLabel_temper = [[UILabel alloc] initWithFrame:CGRectMake(weatherLabel_temperX, weatherLabel_temperY, weatherLabel_temperWidth, weatherLabel_temperHeight)];
    _weatherLabel_temper.textAlignment = NSTextAlignmentCenter;
    _weatherLabel_temper.textColor = ORANGE_2;
    _weatherLabel_temper.numberOfLines = 1;
    _weatherLabel_temper.alpha = 0;
    [_circleView addSubview:_weatherLabel_temper];
    
    [self updateWeatherInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWeatherInfo) name:@"updateWeather" object:nil];
}
- (void)showAlarmAddView {
    CGFloat alarmBtn_addWidth = alarmBase*12;
    CGFloat alarmBtn_addX = (WIDTH(_circleView)-alarmBtn_addWidth)/2;
    _alarmBtn_add = [UIButton buttonWithType:UIButtonTypeCustom];
    _alarmBtn_add.frame = CGRectMake(alarmBtn_addX, alarmBtn_addX, alarmBtn_addWidth, alarmBtn_addWidth);
    _alarmBtn_add.layer.cornerRadius = alarmBtn_addWidth/2;
    _alarmBtn_add.layer.masksToBounds = YES;
    NSString *alarmTitle_add = @"添加闹钟";
    [_alarmBtn_add setTitle:alarmTitle_add forState:UIControlStateNormal];
    _alarmBtn_add.titleLabel.font = FONT([UIFont fontsizeWithSize:_alarmBtn_add.frame.size andText:alarmTitle_add]);
    [_alarmBtn_add setBackgroundColor:[UIColor redColor]];
    [_alarmBtn_add addTarget:self action:@selector(addAlarmClick:) forControlEvents:UIControlEventTouchUpInside];
    _alarmBtn_add.alpha = 0;
    _alarmBtn_add.userInteractionEnabled = NO;
    [_circleView addSubview:_alarmBtn_add];
    
    CGFloat alarmBtn_cancelWidth = alarmBase*6;
    CGFloat alarmBtn_cancelX = (WIDTH(_circleView)-alarmBtn_cancelWidth)/2;
    CGFloat alarmBtn_cancelY = ORIGIN_Y(_secondControl)+alarmBase*1;
    _alarmBtn_cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    _alarmBtn_cancel.frame = CGRectMake(alarmBtn_cancelX, alarmBtn_cancelY, alarmBtn_cancelWidth, alarmBtn_cancelWidth);
    _alarmBtn_cancel.layer.cornerRadius = alarmBtn_cancelWidth/2;
    _alarmBtn_cancel.layer.masksToBounds = YES;
    NSString *alarmTitle_cancel = @"取消";
    [_alarmBtn_cancel setTitle:alarmTitle_cancel forState:UIControlStateNormal];
    _alarmBtn_cancel.titleLabel.font = FONT([UIFont fontsizeWithSize:_alarmBtn_cancel.frame.size andText:alarmTitle_cancel]);
    [_alarmBtn_cancel setBackgroundColor:[UIColor redColor]];
    [_alarmBtn_cancel addTarget:self action:@selector(cancelAlarmClick) forControlEvents:UIControlEventTouchUpInside];
    _alarmBtn_cancel.alpha = 0;
    _alarmBtn_cancel.userInteractionEnabled = NO;
    [_circleView addSubview:_alarmBtn_cancel];
}

- (void)showAlarmTV {
    _alarmTV = [[UITableView alloc] init];
    _alarmTV.transform = CGAffineTransformMakeRotation(-M_PI_2);
    _alarmTV.frame =CGRectMake(0, -cellHeight, WIDTH(self.view), cellHeight);
    NSLog(@"_alarmTV %@",NSStringFromCGRect(_alarmTV.frame));
    _alarmTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _alarmTV.delegate = self;
    _alarmTV.dataSource = self;
    _alarmTV.backgroundColor = RGBW(1);
    [self.view addSubview:_alarmTV];
}
- (void)showAlarmSettingView {
    _alarmSettingView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT(_alarmTV)+20, WIDTH(self.view), HEIGHT(self.view)-HEIGHT(_alarmTV)-20)];
    _alarmSettingView.backgroundColor = RGBB(0.05);
    _alarmSettingView.layer.borderColor = RGBO(1).CGColor;
    _alarmSettingView.layer.borderWidth = 2;
    _alarmSettingView.hidden = YES;
    [self.view insertSubview:_alarmSettingView belowSubview:_circleView];
}

#pragma mark - Gesture
- (void)addRecognizer {
    _swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeFrom:)];
    _swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    _swipeDown.delegate = self;
    [self.view addGestureRecognizer:_swipeDown];
    
    _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressTV:)];
    _longPress.minimumPressDuration = 1;
    [_alarmTV addGestureRecognizer:_longPress];
    
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSettingView:)];
    [self.view addGestureRecognizer:_tap];
    
    _swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeFrom:)];
    _swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    _swipeDown.delegate = self;
    [self.view addGestureRecognizer:_swipeUp];
    
    [_swipeDown requireGestureRecognizerToFail:_swipeUp];
    [_swipeUp requireGestureRecognizerToFail:_tap];
}
- (void)swipeFrom:(UISwipeGestureRecognizer *)gesture {
    if (gesture.direction == UISwipeGestureRecognizerDirectionDown) {
        [self changeAlarmState:AlarmStatusSet];
    } else {
        [self changeAlarmState:AlarmStatusNormal];
    }
    
}
- (void)tapSettingView:(UITapGestureRecognizer *)gesture {
    cellStatus = AlarmCellStatusNormal;
    _alarmArray = [SVData sharedInstance].alarmArray;
    [_alarmTV reloadData];
}
- (void)longPressTV:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        cellStatus = AlarmCellStatusEditing;
        _alarmArray = [SVData sharedInstance].alarmArray;
        [_alarmTV reloadData];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:self.view];
    double dis = distance(point, _circleView.center);
    NSLog(@"dis = %@",@(dis));
    if (dis  < HEIGHT(_hourControl)/2 && dis > HEIGHT(_secondControl)/2) {
        
        return NO;
    } else {
        NSLog(@"touchPoint = %@",NSStringFromCGPoint(point));
        NSLog(@"_circleView.center = %@",NSStringFromCGPoint(_circleView.center));
        return YES;
    }
}
- (void)changeAlarmState:(AlarmStatus)status {
    alarmStatus = status;
    switch (status) {
        case AlarmStatusNormal:
        {
            needUpdate = YES;
            [self setSecondControlHidden:NO];
            [self setWeatherViewHidden:NO];
            [self setAlarmViewHidden:YES];
            
            CGRect alarmTVFrame = _alarmTV.frame;
            alarmTVFrame.origin.y = -HEIGHT(_alarmTV);
            CGRect circleFrame = _circleView.frame;
            circleFrame.origin.y = (HEIGHT(self.view)-circleLen)/2;
            [UIView animateWithDuration:0.5
                                  delay:0
                                options:UIViewAnimationOptionLayoutSubviews
                             animations:^{
                                 _alarmTV.frame = alarmTVFrame;
                                 _circleView.frame = circleFrame;
                             } completion:^(BOOL finished) {
                                 _alarmSettingView.hidden = YES;
                                 
                             }];
        }
            break;
        case AlarmStatusAdd:
        {
            needUpdate = NO;
            [self setSecondControlHidden:YES];
            [self setWeatherViewHidden:YES];
            [self setAlarmViewHidden:NO];
        }
            break;
        case AlarmStatusSet:
        {
            
            CGRect alarmTVFrame = _alarmTV.frame;
            alarmTVFrame.origin.y = 20;
            CGRect circleFrame = _circleView.frame;
            circleFrame.origin.y = (HEIGHT(self.view)+cellHeight+20-circleLen)/2;
            [UIView animateWithDuration:0.5
                                  delay:0
                                options:UIViewAnimationOptionLayoutSubviews
                             animations:^{
                                 _alarmTV.frame = alarmTVFrame;
                                 _circleView.frame = circleFrame;
                             } completion:^(BOOL finished) {
                                 _alarmSettingView.hidden = NO;
                                 _alarmArray = [SVData sharedInstance].alarmArray;
                                 [_alarmTV reloadData];
                                 
                                 if (_alarmArray.count > 0) {
                                     needUpdate = NO;
                                     [self setSecondControlHidden:YES];
                                     [self setWeatherViewHidden:YES];
                                     [self setAlarmViewHidden:YES];
                                 } else {
                                     [self changeAlarmState:AlarmStatusNormal];
                                 }
                             }];

        }
            break;
        default:
            break;
    }
}
#pragma mark - Actions
- (void)valueChanged:(SVCircleControl *)control {
    NSLog(@"%s alarmStatus=%@",__FUNCTION__,@(alarmStatus));

    if (alarmStatus == AlarmStatusNormal) {
        [self changeAlarmState:AlarmStatusAdd];
    } else if (alarmStatus == AlarmStatusSet) {
        [self changeAlarmState:AlarmStatusChange];
    }
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
                             _alarmBtn_cancel.alpha = 0;
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
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat:@"%u",arc4random()] forKey:@"ID"];
    [dic setObject:@(_hourControl.value) forKey:@"hour"];
    [dic setObject:@(_minuteControl.value) forKey:@"minute"];
    [dic setObject:@(1) forKey:@"repeat"];
    [dic setObject:@"1" forKey:@"status"];
    
    [SVAlarm addAlarmWithDic:dic isNew:YES];
    
    [self changeAlarmState:AlarmStatusNormal];
}

- (void)cancelAlarmClick {
    [self changeAlarmState:AlarmStatusNormal];
}
- (void)deleteAlarmClick:(UIButton *)btn {
    NSUInteger row = [objc_getAssociatedObject(btn, @"row") unsignedIntegerValue];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[_alarmArray objectAtIndex:row]];
    [SVAlarm deleteAlarmFromDic:dic];
    _alarmArray = [SVData sharedInstance].alarmArray;
    [_alarmTV reloadData];
    if (_alarmArray.count == 0) {
        [self changeAlarmState:AlarmStatusNormal];
    }
}
- (void)alarmRefresh {
    cellStatus = AlarmCellStatusNormal;
    selectRow = 0;
    _alarmArray = [SVData sharedInstance].alarmArray;
    [_alarmTV reloadData];
}
#pragma mark - Tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _alarmArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellWidth;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = @"AlarmTableViewCell";
    NSMutableDictionary *dic = [_alarmArray objectAtIndex:indexPath.row];
    
    AlarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[AlarmTableViewCell alloc] initWithSize:CGSizeMake(cellWidth, cellHeight) style:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setHour:[[dic objectForKey:@"hour"] integerValue] andMinute:[[dic objectForKey:@"minute"] integerValue]];
    if ([[dic objectForKey:@"status"] integerValue] == 0) {
        
    } else {
        
    }
    objc_setAssociatedObject(cell.deleteBtn, @"row", @(indexPath.row), OBJC_ASSOCIATION_COPY_NONATOMIC);
    [cell.deleteBtn addTarget:self action:@selector(deleteAlarmClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (selectRow == indexPath.row) {
        UIColor *color = RGBRandom;
        cell.backgroundColor = color;
        _alarmSettingView.backgroundColor = [color colorWithAlphaComponent:0.05];
    } else {
        cell.backgroundColor = RGBW(1);
    }
    cell.cellStatus = cellStatus;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (selectRow != indexPath.row) {
        selectRow = indexPath.row;
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [tableView reloadData];
    }
}
#pragma mark - Touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    NSLog(@"%@",NSStringFromCGPoint(point));
    //    NSLog(@"class %@",NSStringFromClass([touch.view class]));
    //    NSLog(@"class 2 %@",[self.view hitTest:point withEvent:event]);
}
@end
