//
//  SVCalculate.mm
//  SVAlarm
//
//  Created by 吴智极 on 15/10/21.
//  Copyright © 2015年 吴智极. All rights reserved.
//

#include "SVCalculate.h"
double distance(CGPoint point1, CGPoint point2) {
    return sqrt((point1.x-point2.x)*(point1.x-point2.x)+(point1.y-point2.y)*(point1.y-point2.y));
}
