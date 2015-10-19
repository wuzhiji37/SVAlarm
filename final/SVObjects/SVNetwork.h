//
//  SVNetwork.h
//  final
//
//  Created by 吴智极 on 15/10/10.
//  Copyright © 2015年 吴智极. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVNetwork : NSObject

typedef void (^CallBack)(NSURLResponse *response, NSData *data, NSError *error);

+ (void)getddByUrlPath:(NSString *)path
                params:(NSString *)params
              callBack:(CallBack)callback;
+ (void)getddByUrlPath:(NSString *)path
                params:(NSString *)params
             headerKey:(NSString *)headerKey
           headerValue:(NSString *)headerValue
              callBack:(CallBack)callback;
+ (void)postddByUrlPath:(NSString *)path
                 params:(NSDictionary*)params
               callBack:(CallBack)callback;
@end
