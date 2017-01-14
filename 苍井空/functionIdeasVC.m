//
//  functionIdeasVC.m
//  苍井空
//
//  Created by liuyi on 17/1/14.
//  Copyright © 2017年 liuyi. All rights reserved.
//

#import "functionIdeasVC.h"
#import "CalculateMG.h"
@interface functionIdeasVC ()

@end

@implementation functionIdeasVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
      int result=  [CalculateMG ly_calculate:^int(int result) {
           
            result+=5;
            result*=5;
            return result;
        }].result;

    
    NSLog(@"%d",result);
    
    // Do any additional setup after loading the view from its nib.
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
