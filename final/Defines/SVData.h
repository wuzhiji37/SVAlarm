//
//  SVData.h
//  
//
//  Created by 吴智极 on 15/10/8.
//
//

#import <Foundation/Foundation.h>

@interface SVData : NSObject
{
    NSUserDefaults *userDefaults;
}
@property (nonatomic, strong)       NSMutableArray              *alarmArray;
@property (nonatomic, strong)       NSMutableArray              *notiArray;
@property (nonatomic, strong)       NSString                    *device;
@property (nonatomic, readwrite)    NSInteger                   width;
@property (nonatomic, strong)       NSString                    *os;
@property (nonatomic, readwrite)    CLLocationDegrees           latitude;
@property (nonatomic, readwrite)    CLLocationDegrees           longitude;
@property (nonatomic, strong)       NSMutableDictionary         *location;
@property (nonatomic, strong)       NSMutableDictionary         *locationCompDic;
@property (nonatomic, strong)       NSMutableDictionary         *weather;
@property (nonatomic, strong)       NSMutableDictionary         *weatherCompDic;

- (void)addAlarmInfo:(NSMutableDictionary *)info;
+ (SVData *)sharedInstance;
@end
