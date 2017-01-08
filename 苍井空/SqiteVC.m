//
//  ViewController.m
//  01-数据库的简单使用
//
//  Created by apple on 15-3-15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SqiteVC.h"
#import <sqlite3.h>
#import "SqliteTool.h"
#import "Student.h"

@interface SqiteVC ()
@property (nonatomic, assign) sqlite3 *db;
@end
/*
 数据库第一天
 2014年10月11日星期六 上午11:26
 1.sqllite好处
 1> 存储大批量数据,可以精确的读取数据。
 2> 批量读取数据,NSCoding这些都是一次把所有数据读取出来。
 2.数据库怎么存储
 1> 跟excel很像,以表为单位,每个表都是存储不同的数据。 2> 存储学生数据步骤
 • 先要创建表
 • 确定属性(字段) • 插入数据(记录)
 3.数据库专业术语:
 1> name,id这些叫字段
 2> 一行叫做一个记录。 4.利用Navcat工具演示数据库
 1> 创建数据库,取数据库连接名,创建数据库文件,数据库是以文件存 在的。
 2> 连接数据库,双击连接名,会自动创建一个名为main的数据库。
 • table:数据库表
 • view:视图
 2> 创建表格
 3> 添加字段,保存表格,表格名称以t_开头
 • text 字符串
 • integer 整形
 • real 浮点型
 4> 主键:保证数据唯一性,区分相同的数据。 主键:自动增长
 5.sql语句
 1> 为什么要学习sql语句,、以后数据库肯定是运行时创建的,我们不可 能去用户的手机上装个navcat先创建好数据库,在存储。
 2> 想要操作数据库,就要学习sql语句,跟操作ios,学习oc一样。PPT简 介,主要学习增删查改(CRUD) 增加(Create)、读取(Retrieve)(重新得到数 据)、更新(Update)和删除(Delete)
 3> SQL语句特点
 • 不区分大小写 4> SQL语句种类
 • DDL语句(数据定义语句:定义数据格式):创表和删表 creat和drop
 • DML语句(数据操作语句):增删查改 insert,delete,update,select • DQL语句(数据查询语句)
 3> SQL语句特点
 • 不区分大小写 4> SQL语句种类
 • DDL语句(数据定义语句:定义数据格式):创表和删表 creat和drop
 • DML语句(数据操作语句):增删查改 insert,delete,update,select
 • DQL语句(数据查询语句)
 6.DDL语句
 1> 创建表格
 • 数据库表格是唯一的,创建表格的时候加上一句if not exists,不存 在才需求创建,就不会报sql语句错误。
 • 创建没有主键的key 2>删除表格
 • 删除没有主键的key
 • 创建一个有主键的key,primary key,自动增长 autoincrement 7.DML语句
 1> 插入数据
 • 数据库字符串用单引号'
 2> 更新数据 3> 删除数据 4> 条件语句
 8.DQL语句 1> select
 2> 别名,可以不用as,
 • 给数据库取别名的好处:用别名获取字段,有提示。
 3> 计算查询数量count
 4> 排序: 有条件语句,需要放在条件语句后。
 5> limit : limit 0,5 跳过第0个,取5个数据,意味着取前5个数据。这个语 句必须放在查询语句最后面。
 9.通过代码访问数据库
 1> 导入系统自带框架sqlite3
 2> 打开数据库,没有创建数据库,会自动创建,并且返回数据库实例 3>增删改
 4> 查,不能用exec,因为exec执行完就没了,不会返回数据。
 • 查询数据,首先要做一些准备操作,获取stmt句柄,有了句柄就能 拿到数据了
 • 调用step,执行stmt,通过stmt能查询下一条数据
 • stmt:是一行一行往下提取,用while判断是否还有数据,如果没有
 数据,就不会返回SQLITE_ROW.
 • 根据stmt获取每条记录的字段值
 10.数据库的封装
 要变成模型,展示到视图。
 2> 搞个专门的工具类处理数据库的逻辑。 11.模糊查询
 1> 通常开发中,面向模型开发,也就是把模型保存到数据库,取出来也
 • 根据stmt获取每条记录的字段值 10.数据库的封装
 要变成模型,展示到视图。
 2> 搞个专门的工具类处理数据库的逻辑。 11.模糊查询
 • %:通配符表示任意
 1> 搞个搜索框,输入条件,展示数据
 2> 添加按钮,插入100条数据,并且保存到数据库 3> 封装工具类进行模糊查询
 1> 通常开发中,面向模型开发,也就是把模型保存到数据库,取出来也
 
 */
@implementation SqiteVC
// 查询
- (IBAction)select:(id)sender {
    
    
    NSString *sql = @"select * from t_student;";
    
   NSArray *arr = [SqliteTool selectWithSql:sql];
    
    for (Student *s in arr) {
        NSLog(@"%@--%d",s.name,s.age);
    }
    
    
    
}

//改数据
- (IBAction)update:(id)sender {
    NSString *sql = @"update t_student set name = 'aaa' where id = 1;";
    [SqliteTool execWithSql:sql];
}
// 插入数据
- (IBAction)insert:(id)sender {
    
    NSString *sql = @"insert into t_student (name,age) values ('yz',18);";
    [SqliteTool execWithSql:sql];

    
}
//删除数据
- (IBAction)delete:(id)sender {
    NSString *sql = @"delete from t_student;";
    [SqliteTool execWithSql:sql];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    
    // 创建表
    // 第一个参数：数据库实例
    // 第二个参数：执行的数据库语句
    // char **errmsg :提示错误
    NSString *sql = @"create table if not exists t_student (id integer primary key autoincrement,name text,age integer);";
    [SqliteTool execWithSql:sql];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
