//
//  SVCircleControl.m
//  final
//
//  Created by 吴智极 on 15/10/8.
//  Copyright © 2015年 吴智极. All rights reserved.
//

#import "SVCircleControl.h"

@implementation SVCircleControl
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBW(0);
        
        _center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        self.layer.cornerRadius = self.bounds.size.height/2;
        self.layer.masksToBounds = YES;
        
        [self setMaxvalue:100 andMinvalue:0 withStep:1];
        _angle = -M_PI_2;
        self.value = 37;
        _handleLineWidth = 2;
        _circleLineWidth = 5;
        _handleRadius = 20;
        _circleRadius = self.bounds.size.width / 2 - _handleRadius - _handleLineWidth/2;
        _backColor = [UIColor grayColor];
        _foreColor = [UIColor blackColor];
        _needAnimation = NO;
        _timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:0.5 target:self selector:@selector(refreshView) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    return self;
}
- (void)refreshView {
    if (_needAnimation) {
        _angle += _newAngle - _oldAngle;
        _angle = _angle< -M_PI_2 ? -M_PI_2 :_angle;
        _needAnimation = NO;
        [self setNeedsDisplay];
    }
}
- (void)setValue:(NSInteger)value {
    if (value > self.maxValue) {
        value = self.minValue;
    }
    CGFloat angle = [self angleFromValue:value];
    if (value != _value || ( angle != _angle && !_needAnimation) ) {
        _value = value;
        _newAngle = angle;
        _oldAngle = _angle;
        _needAnimation = YES;
    }
//    NSLog(@"value1 = %@",@(self.value));
//    NSLog(@"angle1 = %@",@(self.angle));
}
- (void)setAngle:(CGFloat)angle {
    self.value = [self valueFromAngle:angle];
//    NSLog(@"value2 = %@",@(self.value));
//    NSLog(@"angle2 = %@",@(self.angle));
}
- (void)setHandleLineWidth:(CGFloat)handleLineWidth {
    _handleLineWidth = handleLineWidth;
    _circleRadius = self.bounds.size.width / 2 - _handleRadius - handleLineWidth/2;
}
- (void)setHandleRadius:(CGFloat)handleRadius {
    _handleRadius = handleRadius;
    _circleRadius = self.bounds.size.width / 2 - handleRadius - _handleLineWidth/2;
    NSLog(@"_handleRadius = %@",@(_handleRadius));
    NSLog(@"_circleRadius = %@",@(_circleRadius));
}
- (void)setMaxvalue:(NSInteger)maxvalue andMinvalue:(NSInteger)minvalue withStep:(NSInteger)step {
    if (maxvalue > minvalue && (maxvalue - minvalue) % step == 0) {
        _maxValue = maxvalue-step;
        _minValue = minvalue;
        _step = step;
        _stepCount = (maxvalue-minvalue)/step;
        _stepAngle = M_PIx2 / _stepCount;
    }
}

#pragma mark - Maths
- (CGFloat)angleFromValue:(NSInteger)value {
    CGFloat angle = ((value-self.minValue)/self.step)*_stepAngle - M_PI_2;
    return angle< -M_PI_2 ? -M_PI_2 :angle;
}
- (NSInteger)valueFromAngle:(CGFloat)angle {
    NSInteger value = lround(floor((angle + M_PI_2)/_stepAngle))*self.step+self.minValue;
    while (value < self.minValue) value += self.maxValue+self.step-self.minValue;
    while (value > self.maxValue+self.step) value -= self.maxValue+self.step-self.minValue;
    return value;
}
- (CGFloat)angleFromPoint:(CGPoint)point {
    CGFloat angle = atan2(point.y - _center.y, point.x - _center.x);
    return angle>-M_PI ? angle:-M_PI;
}
- (CGPoint)pointFromAngle:(CGFloat)angle{
    CGPoint point = CGPointMake(_center.x + _circleRadius * cos(angle), _center.y + _circleRadius * sin(angle));
    return point;
}

- (CGFloat)distanceBetweenPoint:(CGPoint)pointA andPoint:(CGPoint)pointB {
    CGFloat distance = sqrt((pointA.x-pointB.x)*(pointA.x-pointB.x)+(pointA.y-pointB.y)*(pointA.y-pointB.y));
//    NSLog(@"dis = %@",@(distance));
    return distance;
}
#pragma mark - UIControl
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGFloat distance = [self distanceBetweenPoint:point andPoint:_center];
    if (fabs(distance - _circleRadius)<=_handleRadius+_handleLineWidth/2) {
        return YES;
    } else {
//        NSLog(@"%@,%@",@[@(point.x),@(point.y)],@[@(_center.x),@(_center.y)]);
        return NO;
    }
}
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super beginTrackingWithTouch:touch withEvent:event];
    CGPoint point = [touch locationInView:self];
    [self clickHandleToPoint:point];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super continueTrackingWithTouch:touch withEvent:event];
    CGPoint point = [touch locationInView:self];
    [self moveHandleToPoint:point];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}
- (void)clickHandleToPoint:(CGPoint)point{
    NSLog(@"click");
    _angle = [self angleFromPoint:point];
    _value = [self valueFromAngle:_angle];

    [self setNeedsDisplay];
}
- (void)moveHandleToPoint:(CGPoint)point{
    NSLog(@"move");
    _angle = [self angleFromPoint:point];
    _value = [self valueFromAngle:_angle];
    NSLog(@"%@ %@",@(_angle),@(_value));
    [self setNeedsDisplay];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.layer.shouldRasterize = YES;
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);

    //1.绘制灰色的背景
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2, _circleRadius, 0, M_PIx2, 0);
    [self.backColor setStroke];
    CGContextSetLineWidth(context, .2);
    CGContextSetLineCap(context, kCGLineCapButt);
    CGContextDrawPath(context, kCGPathStroke);
    
    //2.绘制进度
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2, _circleRadius, -M_PI_2, _angle, 0);
    [self.foreColor setStroke];
    CGContextSetLineWidth(context, _circleLineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextDrawPath(context, kCGPathStroke);
    
    //3.绘制拖动小块
    CGPoint handleCenter =  [self pointFromAngle:_angle];
    CGContextAddArc(context, handleCenter.x, handleCenter.y, _handleRadius, 0, M_PIx2, 0);
    [self.foreColor setStroke];
    CGContextSetLineWidth(context, _handleLineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextDrawPath(context, kCGPathStroke);
    
    //4.绘制小块内部空白
    CGContextAddArc(context, handleCenter.x, handleCenter.y, (_handleRadius - _handleLineWidth/2)/2 , 0, M_PIx2, 0);
    [[UIColor whiteColor] setStroke];
    CGContextSetLineWidth(context, _handleRadius - _handleLineWidth/2);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextDrawPath(context, kCGPathStroke);
    
    //5.绘制值
    CGContextSetLineWidth(context, 1.0);
    CGFloat r,g,b,a;
    [self.foreColor getRed:&r green:&g blue:&b alpha:&a];
//    NSLog(@"%@",@[@(r),@(g),@(b)]);
    CGContextSetRGBFillColor (context, r*255, g*255, b*255, a);
    UIFont  *font = [UIFont systemFontOfSize:_handleRadius];
    
    CGSize size = [[@(self.value) stringValue] sizeWithAttributes:@{NSFontAttributeName:font}];
    
    [[@(self.value) stringValue] drawInRect:CGRectMake(handleCenter.x-size.width/2, handleCenter.y-size.height/2, size.width, size.height)
                             withAttributes:@{NSFontAttributeName:font}];
    
}

@end
