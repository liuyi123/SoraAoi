//
//  RACSignalDemo.m
//  苍井空
//
//  Created by liuyi on 17/1/24.
//  Copyright © 2017年 liuyi. All rights reserved.
//

#import "RACSignalDemo.h"
#import "ReactiveObjC.h"
#import "RedView.h"
#import "Flag.h"
@interface RACSignalDemo ()
@property (weak, nonatomic) IBOutlet RedView *redView;
@end

@implementation RACSignalDemo

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view, typically from a nib.
    [_redView.btnClickSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];

    
    
}
//1.RACSignal****************************************
-(void)RACSignalDemo1{
    // RACSignal:有数据产生的时候,就使用RACSignal
    
    // RACSignal使用步骤: 1.创建信号  2.订阅信号 3.发送信号
    
    RACDisposable *(^didSubscribe)(id<RACSubscriber> subscriber) = ^RACDisposable *(id<RACSubscriber> subscriber) {
        // didSubscribe调用:只要一个信号被订阅就会调用
        // didSubscribe作用:发送数据
        NSLog(@"信号被订阅");
        // 3.发送数据
        [subscriber sendNext:@1];
        
        return nil;
    };
    
    // 1.创建信号(冷信号)
    RACSignal *signal = [RACSignal createSignal:didSubscribe];
    
    // 2.订阅信号(热信号)
    [signal subscribeNext:^(id x) {
        
        // nextBlock调用:只要订阅者发送数据就会调用
        // nextBlock作用:处理数据,展示到UI上面
        
        // x:信号发送的内容
        NSLog(@"%@",x);
    }];
    
    // 只要订阅者调用sendNext,就会执行nextBlock
    // 只要订阅RACDynamicSignal,就会执行didSubscribe
    // 前提条件是RACDynamicSignal,不同类型信号的订阅,处理订阅的事情不一样

}
//2.RACSignal****************************************
-(void)RACSignalDemo2{
    // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber ) {
        
        //        _subscriber = subscriber;
        
        // 3.发送信号
        [subscriber sendNext:@"123"];
        
        return [RACDisposable disposableWithBlock:^{
            // 只要信号取消订阅就会来这
            // 清空资源
            NSLog(@"信号被取消订阅了");
        }];
    }];
    
    // 2.订阅信号
    RACDisposable *disposable = [signal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
    // 1.创建订阅者,保存nextBlock
    // 2.订阅信号
    
    // 默认一个信号发送数据完毕们就会主动取消订阅.
    // 只要订阅者在,就不会自动取消信号订阅
    // 取消订阅信号
    [disposable dispose];
    
}
//3.RACSubject****************************************
- (void)RACSubject
{
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 2.订阅信号
    
    // 不同信号订阅的方式不一样
    // RACSubject处理订阅:仅仅是保存订阅者
    [subject subscribeNext:^(id x) {
        NSLog(@"订阅者一接收到数据:%@",x);
    }];
    
    // 3.发送数据
    [subject sendNext:@1];
    
    //    [subject subscribeNext:^(id x) {
    //        NSLog(@"订阅二接收到数据:%@",x);
    //    }];
    // 保存订阅者
    
    
    // 底层实现:遍历所有的订阅者,调用nextBlock
    
    // 执行流程:
    
    // RACSubject被订阅,仅仅是保存订阅者
    // RACSubject发送数据,遍历所有的订阅,调用他们的nextBlock
}

- (void)RACReplaySubject
{
    // 1.创建信号
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    // 2.订阅信号
    [subject subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    // 遍历所有的值,拿到当前订阅者去发送数据
    
    // 3.发送信号
    [subject sendNext:@1];
    //    [subject sendNext:@1];
    // RACReplaySubject发送数据:
    // 1.保存值
    // 2.遍历所有的订阅者,发送数据
    
    
    // RACReplaySubject:可以先发送信号,在订阅信号
}
//集合****************************************
- (void)dict
{
    
    // 字典
    NSDictionary *dict = @{@"account":@"aaa",@"name":@"xmg",@"age":@18};
    
    // 转换成集合
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        //       NSString *key = x[0];
        //        NSString *value = x[1];
        //        NSLog(@"%@ %@",key,value);
        
        // RACTupleUnpack:用来解析元组
        // 宏里面的参数,传需要解析出来的变量名
        // = 右边,放需要解析的元组
        RACTupleUnpack(NSString *key,NSString *value) = x;
        
        NSLog(@"%@ %@",key,value);
    }];
}

- (void)arr
{
    // 数组
    NSArray *arr = @[@"213",@"321",@1];
    
    // RAC集合
    //    RACSequence *sequence = arr.rac_sequence;
    //
    //    // 把集合转换成信号
    //    RACSignal *signal = sequence.signal;
    //
    //    // 订阅集合信号,内部会自动遍历所有的元素发出来
    //    [signal subscribeNext:^(id x) {
    //        NSLog(@"%@",x);
    //    }];
    
    [arr.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

- (void)tuple
{
    // 元组
    RACTuple *tuple = [RACTuple tupleWithObjectsFromArray:@[@"213",@"321",@1]];
    NSString *str = tuple[0];
    
    NSLog(@"%@",str);
    
}
//字典转模型
-(void)dicWtthModel{
    
    // 解析plist文件
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
    NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
    
    //    NSMutableArray *arr = [NSMutableArray array];
    //    [dictArr.rac_sequence.signal subscribeNext:^(NSDictionary *x) {
    //        Flag *flag = [Flag flagWithDict:x];
    //        [arr addObject:flag];
    //    }];
    
    // 高级用法
    // 会把集合中所有元素都映射成一个新的对象
    NSArray *arr = [[dictArr.rac_sequence map:^id(NSDictionary *value) {
        // value:集合中元素
        // id:返回对象就是映射的值
        return [Flag flagWithDict:value];
    }] array];
    
    NSLog(@"%@",arr);
    

    
}
//集合****************************************

@end
