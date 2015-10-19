//
//  AlarmListViewController.m
//  final
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
    _alarmTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH(self.view), HEIGHT(self.view)-49-64)];
    _alarmTV.delegate = self;
    _alarmTV.dataSource = self;
    _alarmTV.backgroundColor = RGBB(0.1);
    [self.view addSubview:_alarmTV];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = @"AlarmTableViewCell";
    AlarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[AlarmTableViewCell alloc] initWithSize:CGSizeMake(tableView.bounds.size.width, 50) style:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [NSString stringWithFormat:@"%@",indexPath];
    NSLog(@"cell = %@",_alarmArray[0]);
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
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
