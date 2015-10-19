//
//  NSString+SVString.m
//  final
//
//  Created by 吴智极 on 15/10/16.
//  Copyright © 2015年 吴智极. All rights reserved.
//

#import "NSString+SVString.h"

@implementation NSString (SVString)
- (NSString *)transformToMandarinWithMark:(BOOL)mark {
    if (self && [self length]) {
        NSMutableString *ms = [[NSMutableString alloc] initWithString:self];
        CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO);
        if (!mark) {
            CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO);
        }
        return ms;
    }
    return @"";
}
@end
