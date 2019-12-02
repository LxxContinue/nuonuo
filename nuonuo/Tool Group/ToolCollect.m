//
//  ToolCollect.m
//  nuonuo
//
//  Created by LXX on 2019/12/2.
//  Copyright © 2019年 LXX. All rights reserved.
//

#import "ToolCollect.h"

@implementation UIViewController(netDateDeal)

//  处理发布时间距离现在时间
-(NSString *)processTime:(NSString *)publishTimeStr
{
    NSString *deltaStr = [[NSString alloc] init];
    //设置时间格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *dateNow = [NSDate date];
    NSString *currentTimeStr = [formatter stringFromDate:dateNow];
    //判断年份
    NSString *publishYearStr = [publishTimeStr substringToIndex:4];
    NSInteger publishYear = [publishYearStr integerValue];
    NSString *currentYearStr = [currentTimeStr substringToIndex:4];
    NSInteger currentYear = [currentYearStr integerValue];
    NSInteger detYear = currentYear - publishYear;
    //判断月份
    NSString *publishMonthStr = [publishTimeStr substringWithRange:NSMakeRange(5,2)];
    NSInteger publishMonth = [publishMonthStr integerValue];
    NSString *currentMonthStr = [currentTimeStr substringWithRange:NSMakeRange(5,2)];
    NSInteger currentMonth = [currentMonthStr integerValue];
    NSInteger detMonth = currentMonth - publishMonth;
    if(detMonth < 0) {
        detMonth += 12;
        detYear -= 1;
    }
    //判断日
    NSString *publishDayStr = [publishTimeStr substringWithRange:NSMakeRange(8,2)];
    NSInteger publishDay = [publishDayStr integerValue];
    NSString *currentDayStr = [currentTimeStr substringWithRange:NSMakeRange(8,2)];
    NSInteger currentDay = [currentDayStr integerValue];
    NSInteger detDay = currentDay - publishDay;
    if(detDay < 0) {
        detDay += 30;
        detMonth -= 1;
    }
    //判断小时
    NSString *publishHourStr = [publishTimeStr substringWithRange:NSMakeRange(11,2)];
    NSInteger publishHour = [publishHourStr integerValue];
    NSString *currentHourStr = [currentTimeStr substringWithRange:NSMakeRange(11,2)];
    NSInteger currentHour = [currentHourStr integerValue];
    NSInteger detHour = currentHour - publishHour;
    if(detHour < 0) {
        detHour += 24;
        detDay -= 1;
    }
    //判断分钟
    NSString *publishMinuteStr = [publishTimeStr substringWithRange:NSMakeRange(14,2)];
    NSInteger publishMinute = [publishMinuteStr integerValue];
    NSString *currentMinuteStr = [currentTimeStr substringWithRange:NSMakeRange(14,2)];
    NSInteger currentMinute = [currentMinuteStr integerValue];
    NSInteger detMinute = currentMinute - publishMinute;
    if(detMinute < 0) {
        detMinute += 60;
        detHour -= 1;
    }
    if(detYear > 0)
        deltaStr = [[NSString alloc] initWithFormat:@"%ld年前",(long)detYear];
    else if(detMonth > 0)
        deltaStr = [[NSString alloc] initWithFormat:@"%ld个月前",(long)detMonth];
    else if(detDay > 0)
        deltaStr = [[NSString alloc] initWithFormat:@"%ld天前",(long)detDay];
    else if(detHour > 0)
        deltaStr = [[NSString alloc] initWithFormat:@"%ld小时前",(long)detHour];
    else if(detMinute > 10)
        deltaStr = [[NSString alloc] initWithFormat:@"%ld分钟前",(long)detMinute];
    else    deltaStr = @"刚刚";
    return deltaStr;
}


@end
