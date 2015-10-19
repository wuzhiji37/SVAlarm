//
//  AlarmListViewController.h
//  final
//
//  Created by 吴智极 on 15/10/14.
//  Copyright © 2015年 吴智极. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_alarmTV;
    NSArray     *_alarmArray;
}
@end
