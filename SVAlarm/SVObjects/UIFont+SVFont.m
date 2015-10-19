//
//  UIFont+SVFont.m
//  SVAlarm
//
//  Created by 吴智极 on 15/10/15.
//  Copyright © 2015年 吴智极. All rights reserved.
//

#import "UIFont+SVFont.h"

@implementation UIFont (SVFont)
+ (CGFloat)fontsizeWithSize:(CGSize)size andText:(NSString *)text {
    CGFloat fontsize = 50;
    CGSize tSize;
    do {
        UIFont *font = FONT(fontsize);
        tSize = [text sizeWithAttributes:@{NSFontAttributeName:font}];
        fontsize-=0.5;
    } while (tSize.height>=size.height || tSize.width+10>=size.width);
    return fontsize;
}
@end
