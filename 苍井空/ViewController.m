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
#import "FriendsCircleTVC.h"
#import "XMGPageView.h"
#import "ChainVC.h"
#import "functionIdeasVC.h"
#import "ReactiveObjC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    XMGPageView *pageView = [XMGPageView pageView];
    //pageView.center = self.view.center;
        pageView.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height/3);
    pageView.imageNames = @[@"SoraAoi01.jpg",@"SoraAoi02.jpg",@"SoraAoi03.jpg",@"SoraAoi04.jpg",@"SoraAoi05.jpg"];
    [self.view addSubview:pageView];
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
- (IBAction)pushFriendsCircleTVC:(id)sender {
    FriendsCircleTVC *friendsCircleTVC=[[FriendsCircleTVC alloc]init];
    
    [self.navigationController pushViewController:friendsCircleTVC animated:YES];
    
}
- (IBAction)pushChainVC {
    
    ChainVC *chainVC=[[ChainVC alloc]init];
    
    [self.navigationController pushViewController:chainVC animated:YES];
    
}
- (IBAction)pushfunctionIdeasVC {
    
   functionIdeasVC *vc= [[functionIdeasVC alloc]init];
    
 
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
