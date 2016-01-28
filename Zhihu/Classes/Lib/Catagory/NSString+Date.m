//
//  NSString+Date.m
//  Zhihu
//
//  Created by Fay on 15/12/27.
//  Copyright © 2015年 Fay. All rights reserved.
//

#import "NSString+Date.h"

@implementation NSString (Date)
+(NSString *)getDateString:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *newString = [formatter stringFromDate:date];
    return newString;
}

+(NSString *)getMonthAndDay:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM月dd日"];
    NSString *newString = [formatter stringFromDate:date];
    return newString;
}

+(NSString *)getDayOfWeek:(NSDate *)date {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitWeekday;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    return [weekdays objectAtIndex:comps.weekday];
}

+(NSString *)getDetailDate:(NSString *)date {
    
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc]init];
    [dataFormatter setDateFormat:@"yyyyMMdd"];
    NSDate *newDate = [dataFormatter dateFromString:date];
    [dataFormatter setDateFormat:@"MM月dd日 EEEE"];
    return  [dataFormatter stringFromDate:newDate];
}
@end
