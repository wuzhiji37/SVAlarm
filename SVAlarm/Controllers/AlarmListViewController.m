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

- (instancetype)init {
    self = [super init];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _alarmArray = [SVData sharedInstance].alarmArray;
        if ([[SVData sharedInstance].device isEqualToString:@"iphone"]) {
            cellHeight = 80;
            cellWidth = 80;
            if ([SVData sharedInstance].width == 320) {

            } else {
                
            }
            
        } else if ([[SVData sharedInstance].device isEqualToString:@"ipad"]) {
            cellHeight = 150;
            cellWidth = 150;
        } else {
            cellHeight = 80;
            cellWidth = 80;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showAlarmTV];
    [self showAlarmSettingView];
    [self addRecognizers];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    cellStatus = AlarmCellStatusNormal;
    selectRow = 0;
    _alarmArray = [SVData sharedInstance].alarmArray;
    [_alarmTV reloadData];
}
- (void)showAlarmTV {
    _alarmTV = [[UITableView alloc] init];
    _alarmTV.transform = CGAffineTransformMakeRotation(-M_PI_2);
    _alarmTV.frame =CGRectMake(0, 20, WIDTH(self.view), cellHeight);
    NSLog(@"_alarmTV %@",NSStringFromCGRect(_alarmTV.frame));
    _alarmTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _alarmTV.delegate = self;
    _alarmTV.dataSource = self;
    _alarmTV.backgroundColor = RGBW(1);
    [self.view addSubview:_alarmTV];
}
- (void)showAlarmSettingView {
    _alarmSettingView = [[UIView alloc] initWithFrame:CGRectMake(0, FrameBelow(_alarmTV), WIDTH(self.view), HEIGHT(self.view)-FrameBelow(_alarmTV)-49)];
    _alarmSettingView.backgroundColor = RGBB(0.05);
    _alarmSettingView.layer.borderColor = RGBO(1).CGColor;
    _alarmSettingView.layer.borderWidth = 2;
    [self.view addSubview:_alarmSettingView];
}
- (void)addRecognizers {
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressTV:)];
    longPress.minimumPressDuration = 1;
    [_alarmTV addGestureRecognizer:longPress];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [_alarmSettingView addGestureRecognizer:tap];
}
- (void)tapView:(UITapGestureRecognizer *)gesture {
    cellStatus = AlarmCellStatusNormal;
    [_alarmTV reloadData];
}
- (void)longPressTV:(UILongPressGestureRecognizer *)gesture {
    cellStatus = AlarmCellStatusEditing;
    [_alarmTV reloadData];
}

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
    [cell.deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (selectRow == indexPath.row) {
        UIColor *color = RGBRandom;
        cell.backgroundColor = color;
        _alarmSettingView.backgroundColor = color;
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
- (void)deleteClick:(UIButton *)btn {
    NSUInteger row = [objc_getAssociatedObject(btn, @"row") unsignedIntegerValue];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[_alarmArray objectAtIndex:row]];
    [SVAlarm deleteAlarmFromDic:dic];
    _alarmArray = [SVData sharedInstance].alarmArray;
    [_alarmTV reloadData];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
