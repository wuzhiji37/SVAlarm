//
//  TestViewController.m
//  SVAlarm
//
//  Created by 吴智极 on 15/10/21.
//  Copyright © 2015年 吴智极. All rights reserved.
//

#import "TestViewController.h"
#define     isLeap(year)    (((year%4==0&&year%100!=0)||year%400==0)?1:0)
int days[12] = {31,28,31,30,31,30,31,31,30,31,30,31};
@interface TestViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@end
@implementation TestViewController {
    UIPickerView *picker;
    NSCalendar *calendar;
    NSDate *startDate;
    NSDate *endDate;
    NSDate *selectedDate;
    UIFont *font;
    UIColor *fontColor;
    NSDateComponents *selectedDateComponets;
    
    UIPickerView *picker1;
    UIPickerView *picker2;
    UIPickerView *picker3;
    NSInteger   startYear;
    NSInteger   startMonth;
    NSInteger   startDay;
    NSInteger   startDays;
    NSInteger   endYear;
    NSInteger   endMonth;
    NSInteger   endDay;
    NSInteger   endDays;
    NSInteger   selectedYear;
    NSInteger   selectedMonth;
    NSInteger   selectedDay;
}
- (void)viewDidLoad {
    calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    startDate = [[NSDate alloc] initWithTimeIntervalSince1970:0];
    startYear = 1970; startMonth = 1; startDay = 1;
    startDays = startYear * 10000 + startMonth * 100 + startDay;
    endDate = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    endYear = [[SVDate comp] year]; endMonth = [[SVDate comp] month]; endDay = [[SVDate comp] day];
    endDays = endYear * 10000 + endMonth * 100 + endDay;
    
    selectedDate = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    
    selectedYear = startYear; selectedMonth = startMonth; selectedDay = startDay;
    font = FONT(18);
    fontColor = [UIColor blackColor];
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 100, 100);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(showPicker) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 300, 300)];
    picker.delegate = self;
    picker.dataSource = self;
    picker.layer.borderColor = [UIColor grayColor].CGColor;
    picker.layer.borderWidth = 2;
    [self.view addSubview:picker];
    
    picker1 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 600, 100, 300)];
    picker1.delegate = self;
    picker1.dataSource = self;
    [self.view addSubview:picker1];
    picker2 = [[UIPickerView alloc] initWithFrame:CGRectMake(100, 600, 100, 300)];
    picker2.delegate = self;
    picker2.dataSource = self;
    [self.view addSubview:picker2];
    picker3 = [[UIPickerView alloc] initWithFrame:CGRectMake(200, 600, 100, 300)];
    picker3.delegate = self;
    picker3.dataSource = self;
    [self.view addSubview:picker3];
    NSLog(@"subviews = %@",[UIPickerView appearance].subviews);
//    id obj = [picker.subviews objectAtIndex:2];
//    NSLog(@"obj = %@",NSStringFromClass([obj class]));
//    view.backgroundColor = [UIColor yellowColor];
}
- (void)showPicker {
    picker.hidden = !picker.hidden;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == picker) {
        return 3;
    } else {
        return 1;
    }
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == picker) {
        switch (component) {
            case 0:
            {
                NSDateComponents *startCpts = [calendar components:NSCalendarUnitYear fromDate:startDate];
                NSDateComponents *endCpts = [calendar components:NSCalendarUnitYear fromDate:endDate];
                return [endCpts year] - [startCpts year] + 1;
            }
                break;
            case 1: // 第二栏为月份
                return 12;
            case 2: { // 第三栏为对应月份的天数
                NSRange dayRange = [calendar rangeOfUnit:NSCalendarUnitDay
                                                  inUnit:NSCalendarUnitMonth
                                                 forDate:selectedDate];
                NSLog(@"current month: %ld, day number: %lu", (long)[[calendar components:NSCalendarUnitMonth fromDate:selectedDate] month], (unsigned long)dayRange.length);
                return dayRange.length;
            }
            default:
                return 0;
        }
    } else if (pickerView == picker1) {
        return endYear-startYear+1;
    } else if (pickerView == picker2) {
        return 12;
    } else {
        if (selectedMonth == 2) {
            return days[selectedMonth-1]+isLeap(selectedYear);
        } else {
            return days[selectedMonth-1];
        }
        
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 100;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50;
}
- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view
{
    
    UILabel *dateLabel = (UILabel *)view;
    if (!dateLabel) {
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        [dateLabel setFont:font];
        [dateLabel setTextColor:fontColor];
        [dateLabel setBackgroundColor:[RGBRandom colorWithAlphaComponent:0.3]];
    }
    if (pickerView == picker) {
    switch (component) {
        case 0: {
            NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:startDate];
            NSString *currentYear = [NSString stringWithFormat:@"%ld", [components year] + row];
            [dateLabel setText:currentYear];
            dateLabel.textAlignment = NSTextAlignmentCenter;
            break;
        }
        case 1: { // 返回月份可以用DateFormatter，这样可以支持本地化
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.locale = [NSLocale currentLocale];
            NSArray *monthSymbols = [formatter monthSymbols];
            [dateLabel setText:[monthSymbols objectAtIndex:row]];
            dateLabel.textAlignment = NSTextAlignmentCenter;
            break;
        }
        case 2: {
            NSRange dateRange = [calendar rangeOfUnit:NSCalendarUnitDay
                                                    inUnit:NSCalendarUnitMonth
                                                   forDate:selectedDate];
            NSString *currentDay = [NSString stringWithFormat:@"%02lu", (row + 1) % (dateRange.length + 1)];
            [dateLabel setText:currentDay];
            dateLabel.textAlignment = NSTextAlignmentCenter;
            break;
        }
        default:
            break;
    }
    } else if (pickerView == picker1) {
        NSString *currentYear = [NSString stringWithFormat:@"%ld年", startYear + row];
        [dateLabel setText:currentYear];
        dateLabel.textAlignment = NSTextAlignmentCenter;
    } else if (pickerView == picker2) {
        NSString *currentMonth = [NSString stringWithFormat:@"%ld月", row+1];
        [dateLabel setText:currentMonth];
        dateLabel.textAlignment = NSTextAlignmentCenter;
    } else {
        NSString *currentDay = [NSString stringWithFormat:@"%ld日", row+1];
        [dateLabel setText:currentDay];
        dateLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return dateLabel;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    if (pickerView == picker) {
        switch (component) {
            case 0: {
                NSDateComponents *indicatorComponents = [calendar components:NSCalendarUnitYear fromDate:startDate];
                NSInteger year = [indicatorComponents year] + row;
                NSDateComponents *targetComponents = [calendar components:unitFlags fromDate:selectedDate];
                [targetComponents setYear:year];
                selectedDateComponets = targetComponents;
                [pickerView selectRow:0 inComponent:1 animated:YES];
                break;
            }
            case 1: {
                NSDateComponents *targetComponents = [calendar components:unitFlags fromDate:selectedDate];
                [targetComponents setMonth:row + 1];
                selectedDateComponets = targetComponents;
                [pickerView selectRow:0 inComponent:2 animated:YES];
                break;
            }
            case 2: {
                NSDateComponents *targetComponents = [calendar components:unitFlags fromDate:selectedDate];
                [targetComponents setDay:row + 1];
                selectedDateComponets = targetComponents;
                break;
            }
            default:
                break;
        }
        [pickerView reloadAllComponents];
    } else if (pickerView == picker1) {
        selectedYear = startYear + row;
        if (selectedYear*10000 + selectedMonth*100 + selectedDay < startDays) {
            selectedYear = startYear;
            selectedMonth = startMonth;
            selectedDay = startDay;
            [picker1 reloadAllComponents];
            [picker2 reloadAllComponents];
            [picker3 reloadAllComponents];
            [picker1 selectRow:selectedYear-startYear inComponent:0 animated:YES];
            [picker2 selectRow:selectedMonth-1 inComponent:0 animated:YES];
            [picker3 selectRow:selectedDay-1 inComponent:0 animated:YES];
        } else if (selectedYear*10000 + selectedMonth*100 + selectedDay > endDays) {
            selectedYear = endYear;
            selectedMonth = endMonth;
            selectedDay = endDay;
            [picker1 reloadAllComponents];
            [picker2 reloadAllComponents];
            [picker3 reloadAllComponents];
            [picker1 selectRow:selectedYear-startYear inComponent:0 animated:YES];
            [picker2 selectRow:selectedMonth-1 inComponent:0 animated:YES];
            [picker3 selectRow:selectedDay-1 inComponent:0 animated:YES];
        } else {
            [picker2 reloadAllComponents];
            [picker3 reloadAllComponents];
            [picker2 selectRow:selectedMonth-1 inComponent:0 animated:YES];
            [picker3 selectRow:selectedDay-1 inComponent:0 animated:YES];
        }
    } else if (pickerView == picker2) {
        selectedMonth = row+1;
        if (selectedYear*10000 + selectedMonth*100 + selectedDay < startDays) {
            selectedYear = startYear;
            selectedMonth = startMonth;
            selectedDay = startDay;
            [picker1 reloadAllComponents];
            [picker2 reloadAllComponents];
            [picker3 reloadAllComponents];
            [picker1 selectRow:selectedYear-startYear inComponent:0 animated:YES];
            [picker2 selectRow:selectedMonth-1 inComponent:0 animated:YES];
            [picker3 selectRow:selectedDay-1 inComponent:0 animated:YES];
        } else if (selectedYear*10000 + selectedMonth*100 + selectedDay > endDays) {
            selectedYear = endYear;
            selectedMonth = endMonth;
            selectedDay = endDay;
            [picker1 reloadAllComponents];
            [picker2 reloadAllComponents];
            [picker3 reloadAllComponents];
            [picker1 selectRow:selectedYear-startYear inComponent:0 animated:YES];
            [picker2 selectRow:selectedMonth-1 inComponent:0 animated:YES];
            [picker3 selectRow:selectedDay-1 inComponent:0 animated:YES];
        } else {
            [picker3 reloadAllComponents];
            [picker3 selectRow:selectedDay-1 inComponent:0 animated:YES];
        }
    } else {
        selectedDay = row+1;
        if (selectedYear*10000 + selectedMonth*100 + selectedDay < startDays) {
            selectedYear = startYear;
            selectedMonth = startMonth;
            selectedDay = startDay;
            [picker1 reloadAllComponents];
            [picker2 reloadAllComponents];
            [picker3 reloadAllComponents];
            [picker1 selectRow:selectedYear-startYear inComponent:0 animated:YES];
            [picker2 selectRow:selectedMonth-1 inComponent:0 animated:YES];
            [picker3 selectRow:selectedDay-1 inComponent:0 animated:YES];
        } else if (selectedYear*10000 + selectedMonth*100 + selectedDay > endDays) {
            selectedYear = endYear;
            selectedMonth = endMonth;
            selectedDay = endDay;
            [picker1 reloadAllComponents];
            [picker2 reloadAllComponents];
            [picker3 reloadAllComponents];
            [picker1 selectRow:selectedYear-startYear inComponent:0 animated:YES];
            [picker2 selectRow:selectedMonth-1 inComponent:0 animated:YES];
            [picker3 selectRow:selectedDay-1 inComponent:0 animated:YES];
        } else {
            [picker3 reloadAllComponents];
            [picker3 selectRow:selectedDay-1 inComponent:0 animated:YES];
        }
    }
    
    // 注意，这一句不能掉，否则选择后每一栏的数据不会重载，其作用与UITableView中的reloadData相似
}
@end
