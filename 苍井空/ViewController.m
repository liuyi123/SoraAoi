//
//  ViewController.m
//  苍井空
//
//  Created by liuyi on 17/1/4.
//  Copyright © 2017年 liuyi. All rights reserved.
//

#import "ViewController.h"
#import "SqiteVC.h"
#import "FuzzySearchVC.h"
#import "CarsVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor yellowColor];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)pusSqlite:(id)sender {
    SqiteVC *sqlVC=[[SqiteVC alloc]init];
    
    [self.navigationController pushViewController:sqlVC animated:YES];
    
}
- (IBAction)pushSearchVC:(id)sender {
    FuzzySearchVC *SearchVC=[[FuzzySearchVC alloc]init];
    
    [self.navigationController pushViewController:SearchVC animated:YES];
    
}
- (IBAction)pushCarsVC:(id)sender {
    CarsVC *carsVC=[[CarsVC alloc]init];
    
    [self.navigationController pushViewController:carsVC animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
