//
//  MainTabController.m
//  
//
//  Created by 吴智极 on 15/10/8.
//
//

#import "MainTabController.h"
#import "AlarmViewController.h"
#import "AlarmListNavigationController.h"
@interface MainTabController ()

@end

@implementation MainTabController
- (instancetype)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = RGBW(1);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocation) name:@"updateLocation" object:nil];
        
        
        AlarmViewController *alarmVC = [[AlarmViewController alloc] init];
        alarmVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"闹钟" image:IMAGE(@"") tag:0];
        
        AlarmListNavigationController *alarmListNVC = [[AlarmListNavigationController alloc] init];
        alarmListNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"闹钟List" image:IMAGE(@"") tag:1];
        
        [self setViewControllers:@[alarmVC,alarmListNVC]];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getInfo];
}
- (void)updateLocation {
    NSString *city = [[SVData sharedInstance].location objectForKey:@"city"];
    NSLog(@"city = %@",city);
    city = [city substringToIndex:city.length-1];
    NSLog(@"city = %@",city);
    if (!city) {
        return;
    }
    [SVNetwork getddByUrlPath:@"http://apis.baidu.com/apistore/weatherservice/recentweathers"
                       params:[NSString stringWithFormat:@"cityname=%@",city]
                    headerKey:@"apikey"
                  headerValue:KEY_BAIDUAPI
                     callBack:^(NSURLResponse *response, NSData *data, NSError *error) {
                         if (error) {
                             NSLog(@"Httperror: %@%@", error.localizedDescription, @(error.code));
                         } else {
                             NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                             NSLog(@"w-dic1 = %@",dic);
                             if (![dic objectForKey:@"retData"]) {
                                 [dic setObject:@{} forKey:@"retData"];
                             }
                             [SVData sharedInstance].weather = [dic objectForKey:@"retData"];
                             [SVData sharedInstance].weatherCompDic = [SVDate dicForm];
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"updateWeather" object:nil];
                             NSLog(@"w-dic2 = %@",[SVData sharedInstance].weather);
                         }
                     }];
}
- (void)getInfo {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
