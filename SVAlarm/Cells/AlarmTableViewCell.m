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
        [self createViews];
    }
    return self;
}
- (void)createViews {
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, HEIGHT(self))];
    _timeLabel.font = FONT([UIFont fontsizeWithSize:_timeLabel.bounds.size andText:@"00:00"]);
    [self addSubview:_timeLabel];
    
    _statusSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(WIDTH(self)-61, (HEIGHT(self)-31)/2, 51, 31)];
    [self addSubview:_statusSwitch];
}
- (void)setHour:(NSInteger)hour andMinute:(NSInteger)minute {
    _timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)hour,(long)minute];
}

@end
