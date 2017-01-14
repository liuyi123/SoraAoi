//
//  ChainVC.m
//  苍井空
//
//  Created by liuyi on 17/1/12.
//  Copyright © 2017年 liuyi. All rights reserved.
//

#import "ChainVC.h"
#import "NSObject+Calculate.h"
@interface ChainVC ()
@end

@implementation ChainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeSystem];
    button.frame=CGRectMake(0, 0, self.view.frame.size.width/2, self.view.frame.size.height/2);
    button.center=self.view.center;
    [button setTitle:@"结果" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(result:) forControlEvents:UIControlEventTouchDragInside];
    
    [self.view addSubview:button];
    

    // Do any additional setup after loading the view.
}
-(void)result:(UIButton*)btn{
    
    
  int reslut= [NSObject ly_makeCalculate:^(CalculateManager *manager) {
        
        NSLog(@"reslu1t1-%d",manager.result);
        manager.add(5).add(3).add(9);
        NSLog(@"reslu1t2-%d",manager.result);
        manager.add(5);
        NSLog(@"reslu1t3-%d",manager.result);
        
        
    }];
    
    NSLog(@"reslu1t---%d",reslut);
    

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
