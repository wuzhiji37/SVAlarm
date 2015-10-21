//
//  AlarmTableViewCell.m
//  SVAlarm
//
//  Created by 吴智极 on 15/10/19.
//  Copyright © 2015年 吴智极. All rights reserved.
//

#import "AlarmTableViewCell.h"

@implementation AlarmTableViewCell
- (instancetype)initWithSize:(CGSize)size
                       style:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)cellId {
    self = [super initWithStyle:style reuseIdentifier:cellId];
    if (self) {
        self.bounds = CGRectMake(0, 0, size.width, size.height);
        _cellStatus = AlarmCellStatusNormal;
        [self createViews];
    }
    return self;
}
- (void)createViews {
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, HEIGHT(self)/4, WIDTH(self), HEIGHT(self)/2)];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = FONT([UIFont fontsizeWithSize:_timeLabel.bounds.size andText:@"00:00"]);
    [self.contentView addSubview:_timeLabel];
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.frame = CGRectMake(0, HEIGHT(self)/4*3, WIDTH(self), HEIGHT(self)/4);
    _deleteBtn.backgroundColor = RGBB(0.1);
    [self.contentView addSubview:_deleteBtn];
}
- (void)drawRect:(CGRect)rect {
    NSLog(@"draw");
}
- (void)setHour:(NSInteger)hour andMinute:(NSInteger)minute {
    _timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)hour,(long)minute];
}
- (void)setCellStatus:(AlarmCellStatus)cellStatus {
        if (cellStatus == AlarmCellStatusNormal) {
            _deleteBtn.hidden = YES;
        } else {
            _deleteBtn.hidden = NO;
        }
        _cellStatus = cellStatus;
}
@end
