//
//  ReactAdvancedVC.m
//  
//
//  Created by liuyi on 17/2/12.
//
//

#import "ReactAdvancedVC.h"
#import "ReactiveObjC.h"
#import "RACStream.h"
#import "MBProgressHUD+XMG.h"
#import "LoginViewModel.h"
@interface ReactAdvancedVC ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *label;


@property (weak, nonatomic) IBOutlet UITextField *accountFiled;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (nonatomic, strong) LoginViewModel *loginVM;

@end

@implementation ReactAdvancedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    }
//
-(void)demo1{

    // 包装元组
    RACTuple *tuple = RACTuplePack(@1,@2);
     NSLog(@"%@",tuple[0]);
    
  

    

}
- (void)RAC
{
    // 监听文本框内容
    //    [_textField.rac_textSignal subscribeNext:^(id x) {
    //
    //        _label.text = x;
    //    }];
    
    // 用来给某个对象的某个属性绑定信号,只要产生信号内容,就会把内容给属性赋值
    RAC(_label,text) = _textField.rac_textSignal;
}

- (void)liftSelector
{
    // 当一个界面有多次请求时候,需要保证全部都请求完成,才搭建界面
    
    // 请求热销模块
    RACSignal *hotSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // 请求数据
        // AFN
        NSLog(@"请求数据热销模块");
        
        [subscriber sendNext:@"热销模块的数据"];
        
        return nil;
    }];
    
    // 请求最新模块
    RACSignal *newSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 请求数据
        NSLog(@"请求最新模块");
        
        [subscriber sendNext:@"最新模块数据"];
        
        return nil;
    }];
    
    // 数组:存放信号
    // 当数组中的所有信号都发送数据的时候,才会执行Selector
    // 方法的参数:必须跟数组的信号一一对应
    // 方法的参数;就是每一个信号发送的数据
    [self rac_liftSelector:@selector(updateUIWithHotData:newData:) withSignalsFromArray:@[hotSignal,newSignal]];
}

- (void)updateUIWithHotData:(NSString *)hotData newData:(NSString *)newData
{
    // 拿到请求的数据
    NSLog(@"更新UI %@ %@",hotData,newData);
}

/*
 每次订阅不要都请求一次,指向请求一次,每次订阅只要拿到数据
 
 不管订阅多少次信号,就会请求一次
 RACMulticastConnection:必须要有信号
 
 1.创建信号
 2.把信号转换成连接类
 3.订阅连接类的信号
 4.连接

 */


- (void)subject
{
    RACSubject *subject = [RACSubject subject];
    
    [subject subscribeNext:^(id x) {
        
        NSLog(@"1:%@",x);
        
    }];
    [subject subscribeNext:^(id x) {
        
        NSLog(@"2:%@",x);
        
    }];
    
    [subject sendNext:@1];
}

- (void)connect1
{
    
    // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // didSubscribe什么时候来:连接类连接的时候
        NSLog(@"发送热门模块的请求");
        [subscriber sendNext:@"热门模块的数据"];
        
        return nil;
    }];
    // 2.把信号转换成连接类
    // 确定源信号的订阅者RACSubject
    //    RACMulticastConnection *connection = [signal publish];
    RACMulticastConnection *connection = [signal multicast:[RACReplaySubject subject]];
    
    // 3.订阅连接类信号
    [connection.signal subscribeNext:^(id x) {
        
        // nextBlock:发送数据就会来
        NSLog(@"订阅者1:%@",x);
        
    }];
    
    // 4.连接
    [connection connect];
    
}

- (void)requestBug
{
    // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSLog(@"发送热门模块的请求");
        
        // 3.发送数据
        [subscriber sendNext:@1];
        
        return nil;
    }];
    
    // 2.订阅信号
    [signal subscribeNext:^(id x) {
        NSLog(@"订阅者一%@",x);
    }];
    
    [signal subscribeNext:^(id x) {
        
        NSLog(@"订阅者二%@",x);
    }];
    
}

/*
 
 
 */
-(void)demo2{
    // 当前命令内部发送数据完成,一定要主动发送完成
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        // input:执行命令传入参数
        // Block调用:执行命令的时候就会调用
        NSLog(@"%@",input);
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            // 发送数据
            [subscriber sendNext:@"执行命令产生的数据"];
            
            // 发送完成
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
    
    // 监听事件有没有完成
    [command.executing subscribeNext:^(id x) {
        if ([x boolValue] == YES) { // 当前正在执行
            NSLog(@"当前正在执行");
        }else{
            // 执行完成/没有执行
            NSLog(@"执行完成/没有执行");
        }
    }];
    
    
    // 2.执行命令
    [command execute:@1];

}
- (void)switchToLatest
{
    
    // 创建信号中信号
    RACSubject *signalOfSignals = [RACSubject subject];
    RACSubject *signalA = [RACSubject subject];
    RACSubject *signalB = [RACSubject subject];
    
    // 订阅信号
    //    [signalOfSignals subscribeNext:^(RACSignal *x) {
    //        [x subscribeNext:^(id x) {
    //            NSLog(@"%@",x);
    //        }];
    //    }];
    // switchToLatest:获取信号中信号发送的最新信号
    [signalOfSignals.switchToLatest subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // 发送信号
    [signalOfSignals sendNext:signalA];
    
    [signalA sendNext:@1];
    [signalB sendNext:@"BB"];
    [signalA sendNext:@"11"];
}

- (void)executionSignals
{
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        // input:执行命令传入参数
        // Block调用:执行命令的时候就会调用
        NSLog(@"%@",input);
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            // 发送数据
            [subscriber sendNext:@"执行命令产生的数据"];
            
            return nil;
        }];
    }];
    
    // 订阅信号
    // 注意:必须要在执行命令前,订阅
    // executionSignals:信号源,信号中信号,signalOfSignals:信号:发送数据就是信号
    //    [command.executionSignals subscribeNext:^(RACSignal *x) {
    //
    //        [x subscribeNext:^(id x) {
    //            NSLog(@"%@",x);
    //        }];
    //
    //    }];
    
    // switchToLatest获取最新发送的信号,只能用于信号中信号
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    // 2.执行命令
    [command execute:@1];
}
- (void)command
{
    // RACCommand:处理事件
    // RACCommand:不能返回一个空的信号
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        // input:执行命令传入参数
        // Block调用:执行命令的时候就会调用
        NSLog(@"%@",input);
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            // 发送数据
            [subscriber sendNext:@"执行命令产生的数据"];
            
            return nil;
        }];
    }];
    
    // 如何拿到执行命令中产生的数据
    // 订阅命令内部的信号
    // 1.方式一:直接订阅执行命令返回的信号
    // 2.方式二:
    
    // 2.执行命令
    RACSignal *signal = [command execute:@1];
    
    // 3.订阅信号
    [signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
}
/*
 
 
 */
-(void)demo3{
     /*
     // 1.创建信号
     RACSubject *subject = [RACSubject subject];
     
     // 2.绑定信号
     RACSignal *bindSignal = [subject bind:^RACStreamBindBlock{
     // block调用时刻:只要绑定信号被订阅就会调用
     
     
     return ^RACSignal *(id value, BOOL *stop){
     // block调用:只要源信号发送数据,就会调用block
     // block作用:处理源信号内容
     // value:源信号发送的内容
     
     NSLog(@"接收到原信号的内容:%@",value);
     
     value = [NSString stringWithFormat:@"xmg:%@",value];
     // 返回信号,不能传nil,返回空信号[RACSignal empty]
     return [RACReturnSignal return:value];
     };
     }];
     
     // 3.订阅绑定信号
     [bindSignal subscribeNext:^(id x) {
     // blcok:当处理完信号发送数据的时候,就会调用这个Block
     NSLog(@"接收到绑定信号处理完的信号%@",x);
     }];
     
     // 4.发送数据
     [subject sendNext:@"123"];
     
     */
 
}
/*
 
 */
-(void)demo4{
    // flattenMap:用于信号中信号
    
    RACSubject *signalOfsignals = [RACSubject subject];
    
    RACSubject *signal = [RACSubject subject];
    
    // 订阅信号
    //    [signalOfsignals subscribeNext:^(RACSignal *x) {
    //
    //        [x subscribeNext:^(id x) {
    //            NSLog(@"%@",x);
    //        }];
    //
    //    }];
    
    //    RACSignal *bindSignal = [signalOfsignals flattenMap:^RACStream *(id value) {
    //        // value:源信号发送内容
    //        return value;
    //    }];
    //
    //    [bindSignal subscribeNext:^(id x) {
    //
    //        NSLog(@"%@",x);
    //    }];

    
    
    
//    [[signalOfsignals flattenMap:^RACStream *(id value) {
//        return value;
//        
//    }] subscribeNext:^(id x) {
//        
//        NSLog(@"%@",x);
//        
//    }];
//    
//    // 发送信号
//    [signalOfsignals sendNext:signal];
//    [signal sendNext:@"213"];

    
}


/**/

- (void)map
{
    // @"123"
    // @"xmg:123"
    
    // 创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 绑定信号
    RACSignal *bindSignal = [subject map:^id(id value) {
        // 返回的类型,就是你需要映射的值
        return [NSString stringWithFormat:@"xmg:%@",value];
        
    }];
    
    // 订阅绑定信号
    [bindSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:@"123"];
    [subject sendNext:@"321"];
}

- (void)flattenMap
{
    
    /*
     
     // 创建信号
     RACSubject *subject = [RACSubject subject];
     
     // 绑定信号
     
     
     RACSignal *bindSignal = [subject flattenMap:^RACStream *(id value) {
     // block:只要源信号发送内容就会调用
     // value:就是源信号发送内容
     
     value = [NSString stringWithFormat:@"xmg:%@",value];
     
     // 返回信号用来包装成修改内容值
     return [RACReturnSignal return:value];
     
     }];
     
     // flattenMap中返回的是什么信号,订阅的就是什么信号
     
     // 订阅信号
     [bindSignal subscribeNext:^(id x) {
     
     NSLog(@"%@",x);
     }];
     
     
     // 发送数据
     [subject sendNext:@"123"];
     
     
     */
 }
/*
 
 
 */
-(void)demo5{
    // 组合
    // 组合哪些信号
    // reduce:聚合
    
    // reduceBlock参数:根组合的信号有关,一一对应
    RACSignal *comineSiganl = [RACSignal combineLatest:@[_accountFiled.rac_textSignal,_pwdField.rac_textSignal] reduce:^id(NSString *account,NSString *pwd){
        // block:只要源信号发送内容就会调用,组合成新一个值
        NSLog(@"%@ %@",account,pwd);
        // 聚合的值就是组合信号的内容
        
        return @(account.length && pwd.length);
    }];
    
    // 订阅组合信号
    //    [comineSiganl subscribeNext:^(id x) {
    //        _loginBtn.enabled = [x boolValue];
    //    }];
    
    RAC(_loginBtn,enabled) = comineSiganl;

}
// 任意一个信号请求完成都会订阅到
- (void)merge
{
    // 创建信号A
    RACSubject *signalA = [RACSubject subject];
    
    // 创建信号B
    RACSubject *signalB = [RACSubject subject];
    
    // 组合信号
    RACSignal *mergeSiganl = [signalA merge:signalB];
    
    // 订阅信号
    [mergeSiganl subscribeNext:^(id x) {
        // 任意一个信号发送内容都会来这个block
        NSLog(@"%@",x);
    }];
    
    // 发送数据
    [signalB sendNext:@"下部分"];
    [signalA sendNext:@"上部分"];
}

- (void)then
{
    // 创建信号A
    RACSignal *siganlA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        NSLog(@"发送上部分请求");
        // 发送信号
        [subscriber sendNext:@"上部分数据"];
        
        // 发送完成
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    // 创建信号B
    RACSignal *siganlB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        NSLog(@"发送下部分请求");
        // 发送信号
        [subscriber sendNext:@"下部分数据"];
        
        return nil;
    }];
    
    // 创建组合信号
    // then:忽悠掉第一个信号所有值
    RACSignal *thenSiganl = [siganlA then:^RACSignal *{
        // 返回信号就是需要组合的信号
        return siganlB;
    }];
    
    // 订阅信号
    [thenSiganl subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
}

- (void)concat
{
    // 组合
    // concat:皇上,皇太子
    // 创建信号A
    RACSignal *siganlA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        NSLog(@"发送上部分请求");
        // 发送信号
        [subscriber sendNext:@"上部分数据"];
        
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    RACSignal *siganlB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        NSLog(@"发送下部分请求");
        // 发送信号
        [subscriber sendNext:@"下部分数据"];
        
        return nil;
    }];
    
    // concat:按顺序去连接
    // 注意:concat,第一个信号必须要调用sendCompleted
    // 创建组合信号
    RACSignal *concatSignal = [siganlA concat:siganlB];
    
    // 订阅组合信号
    [concatSignal subscribeNext:^(id x) {
        
        // 既能拿到A信号的值,又能拿到B信号的值
        NSLog(@"%@",x);
        
    }];
    
}
/*
 
 
 */
-(void)demo6{
    // skip;跳跃几个值
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];
    
    [[subject skip:2] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
    [subject sendNext:@"3"];


}

- (void)distinctUntilChanged
{
    // distinctUntilChanged:如果当前的值跟上一个值相同,就不会被订阅到
    
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];
    
    [[subject distinctUntilChanged] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
    [subject sendNext:@"2"];
}

- (void)take
{
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];
    
    RACSubject *signal = [RACSubject subject];
    
    // take:取前面几个值
    // takeLast:取后面多少个值.必须要发送完成
    // takeUntil:只要传入信号发送完成或者发送任意数据,就不能在接收源信号的内容
    [[subject takeUntil:signal] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:@"1"];
    
    //    [signal sendNext:@1];
    //    [signal sendCompleted];
    [signal sendError:nil];
    
    [subject sendNext:@"2"];
    [subject sendNext:@"3"];
    
}

- (void)ignore
{
    
    // ignore:忽略一些值
    // ignoreValues:忽略所有的值
    
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 2.忽略一些
    RACSignal *ignoreSignal = [subject ignoreValues];
    
    // 3.订阅信号
    [ignoreSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    // 4.发送数据
    [subject sendNext:@"13"];
    [subject sendNext:@"2"];
    [subject sendNext:@"44"];
    
}
- (void)filter
{
    // 只有当我们文本框的内容长度大于5,才想要获取文本框的内容
    [[_textField.rac_textSignal filter:^BOOL(id value) {
        // value:源信号的内容
        return  [value length] > 5;
        // 返回值,就是过滤条件,只有满足这个条件,才能能获取到内容
        
    }] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
}
/*
 
 
 */

/*
 
 
 */
-(void)demo7{
    // 1.处理文本框业务逻辑
    RACSignal *loginEnableSiganl = [RACSignal combineLatest:@[_accountFiled.rac_textSignal,_pwdField.rac_textSignal] reduce:^id(NSString *account,NSString *pwd){
        return @(account.length && pwd.length);
    }];
    
    // 设置按钮能否点击
    RAC(_loginBtn,enabled) = loginEnableSiganl;
    
    
    // 创建登录命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        // block:执行命令就会调用
        // block作用:事件处理
        // 发送登录请求
        NSLog(@"发送登录请求");
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                // 发送数据
                [subscriber sendNext:@"请求登录的数据"];
                [subscriber sendCompleted];
            });
            
            return nil;
            
        }];
    }];
    
    // 获取命令中信号源
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    // 监听命令执行过程
    [[command.executing skip:1] subscribeNext:^(id x) {
        
        if ([x boolValue] == YES) {
            // 正在执行
            NSLog(@"正在执行");
            // 显示蒙版
        
            [MBProgressHUD showMessage:@"正在登录ing.."];
            
        }else{
            // 执行完成
            // 隐藏蒙版
            [MBProgressHUD hideHUD];
            
            NSLog(@"执行完成");
        }
        
    }];
    
    
    // 监听登录按钮点击
    [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"点击登录按钮");
        // 处理登录事件
        [command execute:nil];
        
    }];
    
    
}
/*
 
 
 */
- (LoginViewModel *)loginVM
{
    if (_loginVM == nil) {
        _loginVM = [[LoginViewModel alloc] init];
    }
    
    return _loginVM;
}

-(void)MVVM{
    
    [self bindViewModel];
    
    [self loginEvent];

}
// 绑定viewModel
- (void)bindViewModel
{
    // 1.给视图模型的账号和密码绑定信号
    RAC(self.loginVM, account) = _accountFiled.rac_textSignal;
    RAC(self.loginVM, pwd) = _pwdField.rac_textSignal;
}
// 登录事件
- (void)loginEvent
{
    // 1.处理文本框业务逻辑
    // 设置按钮能否点击
    RAC(_loginBtn,enabled) = self.loginVM.loginEnableSiganl;
    
    
    // 2.监听登录按钮点击
    [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        // 处理登录事件
        [self.loginVM.loginCommand execute:nil];
        
    }];
    
}

@end
