//
//  AlarmListViewController.h
//  SVAlarm
//
//  Created by 吴智极 on 15/10/14.
//  Copyright © 2015年 吴智极. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AlarmListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView         *_alarmTV;
    UIView              *_alarmSettingView;
    NSArray             *_alarmArray;
    NSInteger           cellHeight;
    NSInteger           cellWidth;
    AlarmCellStatus     cellStatus;
    NSUInteger          selectRow;
}
@end
