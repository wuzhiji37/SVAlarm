//
//  AlarmTableViewCell.h
//  SVAlarm
//
//  Created by 吴智极 on 15/10/19.
//  Copyright © 2015年 吴智极. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmTableViewCell : UITableViewCell {
    UILabel         *_timeLabel;
}
@property (nonatomic, strong)       UIButton            *deleteBtn;
@property (nonatomic, readwrite)    AlarmCellStatus     cellStatus;
- (instancetype)initWithSize:(CGSize)size
                       style:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)cellId;
- (void)setHour:(NSInteger)hour andMinute:(NSInteger)minute;
@end
