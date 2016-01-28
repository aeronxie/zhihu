//
//  HttpTool.m
//  Zhihu
//
//  Created by Fay on 16/1/3.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import "HttpTool.h"
#import "AFNetworking.h"

@implementation HttpTool

+(void)get:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id json))success failure:(void (^)(NSError *error))failure {
    //显示状态栏的网络指示器
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer.timeoutInterval = 10.0f;
    [mgr GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            failure(error);
        }
    }];

}

@end
