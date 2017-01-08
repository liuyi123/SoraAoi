//
//  FuzzySearchVC.m
//  苍井空
//
//  Created by liuyi on 17/1/8.
//  Copyright © 2017年 liuyi. All rights reserved.
//

#import "FuzzySearchVC.h"
#import "Contact.h"
#import "ContactTool.h"
@interface FuzzySearchVC ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *contacts;
@end

@implementation FuzzySearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
   [self.view addSubview:self.tableView];
  UIBarButtonItem *rightBtn=  [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(insert:)];
    
     self.navigationItem.rightBarButtonItem = rightBtn;
    
    UISearchBar *searchBar=[[UISearchBar alloc]init];
    searchBar.searchBarStyle=UISearchBarStyleMinimal;
    searchBar.delegate=self;
    self.navigationItem.titleView=searchBar;
    
       // self.tableView reg
    
     //   [self.tableView registerNib:[UINib nibWithNibName:@"searchCell" bundle:nil] forCellReuseIdentifier:@"searchCell"];
    
    
    
    // Do any additional setup after loading the view from its nib.
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}
-(NSMutableArray *)contacts{
    if (_contacts==nil) {
        _contacts=[ContactTool contacts];
        
//        if (_contacts == nil) {
//            _contacts = [NSMutableArray array];
//        }

        
    }
    return _contacts;
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    // o  select * from t_contact where name like '%searchText%' or phone like '%searchText%'
    // % 在stringWithFormat中有特殊意思
    // %% == %
    // 输入一个文字，进行模糊查询，查看下名字或者电话是否包含文字
    NSString *sql = [NSString stringWithFormat:@"select * from t_contact where name like '%%%@%%' or phone like '%%%@%%';",searchText,searchText];
    _contacts = (NSMutableArray *)[ContactTool contactWithSql:sql];
    [self.tableView reloadData];
}
- (void)insert:(id)sender {
    
     [self.view endEditing:YES];
    
    NSArray *nameArr = @[@"gogoing",@"duang",@"uzi",@"omg"];
    
    NSString *name = [NSString stringWithFormat:@"%@%d",nameArr[arc4random_uniform(4)],arc4random_uniform(200)];
    NSString *phone = [NSString stringWithFormat:@"%d",arc4random_uniform(10000)+10000];
    Contact *c = [Contact contactWithName:name phone:phone];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.contacts.count inSection:0];
    [self.contacts addObject:c];
    
    [self.tableView reloadData];
    
    //[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    // 存储到数据库里面
    [ContactTool saveWithContact:c];
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.contacts.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"serchCell"];
        
        
    }
    
    
    
    Contact *c=self.contacts[indexPath.row];
    
    cell.textLabel.text=c.name;
    cell.detailTextLabel.text=c.phone;
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView endEditing:YES];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];

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
