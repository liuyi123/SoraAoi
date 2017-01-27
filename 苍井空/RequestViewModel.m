//
//  RequestViewModel.m
//  ReactiveCocoa
//
//  Created by xiaomage on 15/10/26.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "RequestViewModel.h"

#import "AFNetworking.h"

#import "Book.h"

@implementation RequestViewModel

- (instancetype)init
{
    if (self = [super init]) {
        
        [self setUp];
    }
    return self;
    
}


- (void)setUp
{
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        // 执行命令
        // 发送请求
        
        // 创建信号
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            
            AFHTTPSessionManager *afHttpSessionManager = [AFHTTPSessionManager manager];
            
            NSDictionary *params = @{
                                     @"q":@"美女"
                                     };
            [afHttpSessionManager GET:@"https://api.douban.com/v2/book/search" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"get success:%@",responseObject);
                //回调是在主线程中，可以直接更新UI
                        NSArray *dictArr = responseObject[@"books"];
                
                        NSArray *modelArr = [[dictArr.rac_sequence map:^id(id value) {
                
                                    return [Book bookWithDict:value];
                                }] array];
                
                       [subscriber sendNext:modelArr];
                NSLog(@"%@", [NSThread currentThread]); ///<: 0x14e27e80>{number = 1, name = main}
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"get failure:%@",error);
            }];
            
            
            


            
            return nil;
        }];
        
        
        return signal;
    }];
}

@end
