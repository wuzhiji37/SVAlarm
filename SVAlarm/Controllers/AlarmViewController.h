//
//  AlarmViewController.h
//  
//
//  Created by 吴智极 on 15/10/8.
//
//

#import <UIKit/UIKit.h>
typedef enum {
    SVCircleStateNormal = 0,
    SVCircleStateSetting = 1
} SVCircleState;
@interface AlarmViewController : UIViewController
<UIGestureRecognizerDelegate,
UITableViewDelegate,
UITableViewDataSource>
{
    UISwipeGestureRecognizer        *_swipeDown;
    UISwipeGestureRecognizer        *_swipeUp;
    UILongPressGestureRecognizer    *_longPress;
    UITapGestureRecognizer          *_tap;
    NSTimer                     *_timer;
    BOOL                        needUpdate;
    BOOL                        canUpdateWeather;
    BOOL                        isDay;
    
    CGFloat                     circleLen;
    UIView                      *_circleView;
    SVCircleControl             *_hourControl;
    SVCircleControl             *_minuteControl;
    SVCircleControl             *_secondControl;
    SVCircleControl             *_alarmHourControl;
    SVCircleControl             *_alarmMinuteControl;
    
    CGFloat                     hourRadius;
    CGFloat                     minuteRadius;
    CGFloat                     secondRadius;
    
    CGFloat                     hourCircleLineWidth;
    CGFloat                     minuteCircleLineWidth;
    CGFloat                     secondCircleLineWidth;
    
    CGFloat                     hourHandleLineWidth;
    CGFloat                     minuteHandleLineWidth;
    CGFloat                     secondHandleLineWidth;
    
    CGFloat                     alarmBase;
    
    UILabel                     *_weatherLabel_refresh;
    UIImageView                 *_weatherIV;
    UILabel                     *_weatherLabel_now;
    UILabel                     *_weatherLabel_temper;
    
    
    UIButton                    *_alarmBtn_add;
    UIButton                    *_alarmBtn_cancel;
    
    UITableView                 *_alarmTV;
    UIView                      *_alarmSettingView;
    NSArray                     *_alarmArray;
    NSInteger                   cellHeight;
    NSInteger                   cellWidth;
    AlarmCellStatus             cellStatus;
    NSUInteger                  selectRow;
    
    SVCircleState               circleState;
}
@end
