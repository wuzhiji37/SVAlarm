//
//  AlarmListViewController.m
//  SVAlarm
//
//  Created by 吴智极 on 15/10/14.
//  Copyright © 2015年 吴智极. All rights reserved.
//

#import "AlarmListViewController.h"
#import "AlarmTableViewCell.h"
@implementation AlarmListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _alarmArray = [SVData sharedInstance].alarmArray;
    NSLog(@"_alarmArray = %@",_alarmArray);
    cellHeight = 50;
    _alarmTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH(self.view), MIN(_alarmArray.count * cellHeight, HEIGHT(self.view)-49-64))];
    _alarmTV.delegate = self;
    _alarmTV.dataSource = self;
    _alarmTV.backgroundColor = RGBB(0.1);
    [self.view addSubview:_alarmTV];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _alarmArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = @"AlarmTableViewCell";
    NSMutableDictionary *dic = [_alarmArray objectAtIndex:indexPath.row];
    
    AlarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[AlarmTableViewCell alloc] initWithSize:CGSizeMake(tableView.bounds.size.width, 50) style:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setHour:[[dic objectForKey:@"hour"] integerValue] andMinute:[[dic objectForKey:@"minute"] integerValue]];
    if ([[dic objectForKey:@"status"] integerValue] == 0) {
        [cell.statusSwitch setOn:NO animated:NO];
    } else {
        [cell.statusSwitch setOn:YES animated:NO];
    }
    [cell.statusSwitch addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventValueChanged];
    objc_setAssociatedObject(cell.statusSwitch, @"dic", dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return cell;
}
- (void)changeStatus:(UISwitch *)sw {
    NSMutableDictionary *dic = objc_getAssociatedObject(sw, @"dic");
    if (sw.isOn) {
        NSLog(@"on");
        [SVAlarm addAlarmWithDic:dic isNew:NO];
    } else {
        NSLog(@"off");
        [SVAlarm cancelAlarmFromDic:dic];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    _alarmArray = [SVData sharedInstance].alarmArray;
    _alarmTV.frame = CGRectMake(0, 64, WIDTH(self.view), MIN(_alarmArray.count * cellHeight, HEIGHT(self.view)-49-64));
    [_alarmTV reloadData];
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
