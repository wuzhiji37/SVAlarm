//
//  SVNetwork.m
//  SVAlarm
//
//  Created by 吴智极 on 15/10/10.
//  Copyright © 2015年 吴智极. All rights reserved.
//

#import "SVNetwork.h"

@implementation SVNetwork


#pragma mark ios请求方式
//ios自带的get请求方式
+ (void)getddByUrlPath:(NSString *)path
                params:(NSString *)params
              callBack:(CallBack)callback {
    [self getddByUrlPath:path
                  params:params
               headerKey:nil
             headerValue:nil
                callBack:callback];
}
+ (void)getddByUrlPath:(NSString *)path
                params:(NSString *)params
             headerKey:(NSString *)headerKey
           headerValue:(NSString *)headerValue
              callBack:(CallBack)callback {
    if (params) {
        path = [path stringByAppendingString:[NSString stringWithFormat:@"?%@",params]];
    }
    NSLog(@"url:%@",path);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL(UTF8(path))];
    [request setHTTPMethod: @"GET"];
    if (headerKey && headerValue) {
        [request addValue:headerValue forHTTPHeaderField:headerKey];
    }
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (callback) {
                                   callback(response,data,error);
                               }
                           }];
}
//ios自带的post请求方式
+ (void)postddByUrlPath:(NSString *)path
                 params:(NSMutableDictionary*)params
               callBack:(CallBack)callback {
    NSLog(@"url:%@",path);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL(UTF8(path))];
    [request setHTTPMethod:@"POST"];
    NSError* error;
    if ([NSJSONSerialization isValidJSONObject:params]) {
        [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error]];
        if (error) {
            callback(nil, nil, error);
        } else {
            [NSURLConnection sendAsynchronousRequest: request
                                               queue: [NSOperationQueue mainQueue]
                                   completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                                       if (callback) {
                                           callback(response,data,error);
                                       }
                                   }];
        }
    } else {
        error = [NSError errorWithDomain:@"invalid json params" code:-100 userInfo:nil];
        callback(nil, nil, error);
    }
}
@end
