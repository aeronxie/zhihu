//
//  HttpTool.h
//  Zhihu
//
//  Created by Fay on 16/1/3.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HttpTool : NSObject

+(void)get:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

@end
