//
//  AlarmTableViewCell.m
//  final
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
    }
    return self;
}
@end
