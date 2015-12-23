//
//  SVData.m
//  
//
//  Created by 吴智极 on 15/10/8.
//
//

#import "SVData.h"

@implementation SVData
+ (SVData *)sharedInstance {
    static SVData *sharedDataInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedDataInstance = [[self alloc] init];
    });
    return sharedDataInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        userDefaults = [NSUserDefaults standardUserDefaults];
        self.alarmArray = [[NSMutableArray alloc] initWithArray:[userDefaults objectForKey:@"alarmArray"]];
        [self sortAlarmArray];
        NSLog(@"self.alarmArray = %@",self.alarmArray);
        self.notiArray = [[NSMutableArray alloc] initWithArray:[[UIApplication sharedApplication] scheduledLocalNotifications]];
        NSLog(@"self.notiArray = %@",self.notiArray);
        
        _latitude = [[userDefaults objectForKey:@"latitude"] doubleValue];
        _longitude = [[userDefaults objectForKey:@"longitude"] doubleValue];
        _location = [[NSMutableDictionary alloc] initWithDictionary:[userDefaults objectForKey:@"location"]];
        
        _locationCompDic = [[NSMutableDictionary alloc] initWithDictionary:[userDefaults objectForKey:@"locationCompDic"]];
        
        NSLog(@"weather = %@",[userDefaults objectForKey:@"weather"]);
        _weather = [[NSMutableDictionary alloc] initWithDictionary:[userDefaults objectForKey:@"weather"]];
        _weatherCompDic = [[NSMutableDictionary alloc] initWithDictionary:[userDefaults objectForKey:@"weatherCompDic"]];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            self.device = @"iphone";
        } else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.device = @"ipad";
        } else {
            self.device = @"idontknow";
        }
        
        self.width = WIDTH_SCREEN;
    }
    return self;
}
- (void)synchronizeAlarmArray {
    [self sortAlarmArray];
    [userDefaults setObject:_alarmArray forKey:@"alarmArray"];
    [userDefaults synchronize];
}
- (void)addAlarmInfo:(NSMutableDictionary *)info {
    [_alarmArray addObject:info];
    [self synchronizeAlarmArray];
}
- (void)changeAlarmInfo:(NSMutableDictionary *)info {
    for (int i = 0; i<self.alarmArray.count; i++) {
        NSMutableDictionary *dic = [self.alarmArray objectAtIndex:i];
        if ([[dic objectForKey:@"ID"] isEqualToString:[info objectForKey:@"ID"]]) {
            [_alarmArray replaceObjectAtIndex:i withObject:info];
            break;
        }
    }
    [self synchronizeAlarmArray];
}
- (void)deleteAlarmInfo:(NSMutableDictionary *)info {
    for (int i = 0; i<self.alarmArray.count; i++) {
        NSMutableDictionary *dic = [self.alarmArray objectAtIndex:i];
        if ([[dic objectForKey:@"ID"] isEqualToString:[info objectForKey:@"ID"]]) {
            [_alarmArray removeObjectAtIndex:i];
            break;
        }
    }
    [self synchronizeAlarmArray];
}
- (void)sortAlarmArray {
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.alarmArray];
    if (tempArray.count > 1) {
        for (int i = 0; i<tempArray.count-1; i++) {
            for (int j = i+1; j<tempArray.count; j++) {
                NSMutableDictionary *dicA = [tempArray objectAtIndex:i];
                NSInteger minutesA = [[dicA objectForKey:@"hour"] integerValue] * 60 + [[dicA objectForKey:@"minute"] integerValue];
                NSMutableDictionary *dicB = [tempArray objectAtIndex:j];
                NSInteger minutesB = [[dicB objectForKey:@"hour"] integerValue] * 60 + [[dicB objectForKey:@"minute"] integerValue];
                
                if (minutesA > minutesB) {
                    [tempArray exchangeObjectAtIndex:i withObjectAtIndex:j];
                }
            }
        }
    }
    NSLog(@"sort array : %@",tempArray);
    _alarmArray = tempArray;
}
- (void)setLatitude:(CLLocationDegrees)latitude {
    _latitude = latitude;
    [userDefaults setObject:@(_latitude) forKey:@"latitude"];
    [userDefaults synchronize];
}
- (void)setLongitude:(CLLocationDegrees)longitude {
    _longitude = longitude;
    [userDefaults setObject:@(_longitude) forKey:@"longitude"];
    [userDefaults synchronize];
}
- (void)setLocation:(NSMutableDictionary *)location {
    _location = [[NSMutableDictionary alloc] initWithDictionary:location];
    if (![_location objectForKey:@"city"]) {
        [_location setValue:@"上海市" forKey:@"city"];
    }
    [userDefaults setObject:_location forKey:@"location"];
    [userDefaults synchronize];
}
- (void)setLocationCompDic:(NSMutableDictionary *)locationCompDic {
    _locationCompDic = [[NSMutableDictionary alloc] initWithDictionary:locationCompDic];
    [userDefaults setObject:_locationCompDic forKey:@"locationCompDic"];
    [userDefaults synchronize];
}

- (void)setWeather:(NSMutableDictionary *)weather {
    _weather = [[NSMutableDictionary alloc] initWithDictionary:weather];
    if (![_weather objectForKey:@"sunrise"]) {
        [_weather setObject:@"06:00" forKey:@"sunrise"];
    }
    if (![_weather objectForKey:@"sunset"]) {
        [_weather setObject:@"18:00" forKey:@"sunset"];
    }
    [userDefaults setObject:_weather forKey:@"weather"];
    [userDefaults synchronize];
}
- (void)setWeatherCompDic:(NSMutableDictionary *)weatherCompDic {
    _weatherCompDic = [[NSMutableDictionary alloc] initWithDictionary:weatherCompDic];
    [userDefaults setObject:_weatherCompDic forKey:@"weatherCompDic"];
    [userDefaults synchronize];
}

@end
