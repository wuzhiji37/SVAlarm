//
//  AlarmViewController.h
//  
//
//  Created by 吴智极 on 15/10/8.
//
//

#import <UIKit/UIKit.h>

@interface AlarmViewController : UIViewController
{
    NSTimer         *_timer;
    BOOL            needUpdate;
    BOOL            canUpdateWeather;
    BOOL            isDay;
    
    SVCircleControl *_hourControl;
    SVCircleControl *_minuteControl;
    SVCircleControl *_secondControl;
    
    CGFloat         hourRadius;
    CGFloat         minuteRadius;
    CGFloat         secondRadius;
    
    CGFloat         hourCircleLineWidth;
    CGFloat         minuteCircleLineWidth;
    CGFloat         secondCircleLineWidth;
    
    CGFloat         hourHandleLineWidth;
    CGFloat         minuteHandleLineWidth;
    CGFloat         secondHandleLineWidth;
    
    CGFloat         alarmBase;
    
    UILabel         *_weatherLabel_refresh;
    UIImageView     *_weatherIV;
    UILabel         *_weatherLabel_now;
    UILabel         *_weatherLabel_temper;
    
    
    UIButton        *_alarmBtn_add;
    UIButton        *_alarmBtn_cancel;
}
@end
