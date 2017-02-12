//
//  MVVMDemo.m
//  苍井空
//
//  Created by liuyi on 17/1/24.
//  Copyright © 2017年 liuyi. All rights reserved.
//

#import "MVVMDemo.h"
#import "ReactiveObjC.h"
#import "RequestViewModel.h"
#import "Book.h"
@interface MVVMDemo ()
@property (nonatomic, strong) RequestViewModel *requestVM;
@property(nonatomic,strong)NSArray *datas;
@end

@implementation MVVMDemo
- (RequestViewModel *)requestVM
{
    if (_requestVM == nil) {
        _requestVM = [[RequestViewModel alloc] init];
    }
    return _requestVM;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setup];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)setup{
    // 发送请求
    RACSignal *signal = [self.requestVM.requestCommand execute:nil];
    
    __weak __typeof__(self) weakSelf = self;
    [signal subscribeNext:^(id x) {
        // 模型数组
        _datas=x;
        //  Book *book = x[0];
        NSLog(@"book-%@",x);
        [weakSelf.tableView reloadData];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cars";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
  
    
    if (cell==nil) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
       
    }
    
    Book *book=self.datas[indexPath.row];
    cell.textLabel.text=book.title;
    
    return cell;
}
/*
    MVVM
 
 */

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
