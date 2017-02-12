//
//  ReactdDailyDemo.m
//  苍井空
//
//  Created by liuyi on 17/1/24.
//  Copyright © 2017年 liuyi. All rights reserved.
//

#import "ReactdDailyDemo.h"
#import "ReactiveObjC.h"
#import "RedVIew.h"
@interface ReactdDailyDemo ()
@property (weak, nonatomic) IBOutlet RedView *readView;

@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation ReactdDailyDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
//1.代理
-(void)delegate{
    [[RedView rac_signalForSelector:@selector(btnClickTest:)] subscribeNext:^(id x) {
        NSLog(@"控制器知道按钮被点击");
    }];
    
}
//  2.代替KVO
-(void)kvo{
   
    
    [[_readView rac_valuesForKeyPath:@"frame" observer:nil] subscribeNext:^(id  _Nullable x) {
        
        // x: 修改的值
        
        NSLog(@"%@",x);
    }];
    
    

//        [_readView rac_observeKeyPath:@"frame" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
//            //
//            return nil;
//    
//        }];
    
}
//监听事件
-(void)observe{
    
    
        [[_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            NSLog(@"按钮点击了");
        }];
    
}
//代替通知
-(void)notificationCenter{
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
    
            NSLog(@"%@",x);
        }];

}
// 5.监听文本框
-(void)textFields{
    [_textField.rac_textSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
