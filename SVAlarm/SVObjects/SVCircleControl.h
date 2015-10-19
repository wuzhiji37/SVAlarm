//
//  SVCircleControl.h
//  SVAlarm
//
//  Created by 吴智极 on 15/10/8.
//  Copyright © 2015年 吴智极. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVCircleControl : UIControl {
    CGPoint     _center;

    NSInteger   _stepCount;
    CGFloat     _stepAngle;
    
    NSTimer     *_timer;
    CGFloat     _newAngle;
    CGFloat     _oldAngle;
    BOOL        _needAnimation;
}
@property (nonatomic, readonly)     NSInteger   maxValue;
@property (nonatomic, readonly)     NSInteger   minValue;
@property (nonatomic, readonly)     NSInteger   step;
@property (nonatomic, readwrite)    NSInteger   value;
@property (nonatomic, readwrite)    CGFloat     angle;

@property (nonatomic, readwrite)    CGFloat     handleRadius;
@property (nonatomic, readonly)     CGFloat     circleRadius;
@property (nonatomic, readwrite)    CGFloat     handleLineWidth;
@property (nonatomic, readwrite)    CGFloat     circleLineWidth;

@property (nonatomic, strong)       UIColor     *backColor;
@property (nonatomic, strong)       UIColor     *foreColor;
- (void)setMaxvalue:(NSInteger)maxvalue andMinvalue:(NSInteger)minvalue withStep:(NSInteger)step;
@end
