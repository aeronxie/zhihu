//
//  NSString+Date.h
//  Zhihu
//
//  Created by Fay on 15/12/27.
//  Copyright © 2015年 Fay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Date)
+(NSString *)getDateString:(NSDate *)date;
+(NSString *)getMonthAndDay:(NSDate *)date;
+(NSString *)getDayOfWeek:(NSDate *)date;
+(NSString *)getDetailDate:(NSString *)date;
@end
