//
//  FMDBVC.m
//  苍井空
//
//  Created by liuyi on 17/1/8.
//  Copyright © 2017年 liuyi. All rights reserved.
//

#import "FMDBVC.h"
#import "FMDB.h"
@interface FMDBVC ()
@property (nonatomic, strong) FMDatabase *db;
@end

@implementation FMDBVC
/*
 数据库第二天
 2014年10月13日星期一 上午8:48
 1.外键约束
 1> 建立两张表的联系
 2> 以微博为例,每个数据模型都建立一张表,微博表和用户表
 3> 微博表应该有个字段 述这条微博是哪个用户发的
 4> 微博添加一个用户id字段,但是这个字段不严谨,可以为空,而且id 可以是用户表中不存在的id.
 5> 应该用外键建立两个表之间的联系,外键是某个表的字段是另外一个 表的主键。
 6> 外键加在一对多的表,学生和班级,一个班级对应多个学生,在学生 表添加外键
 7> sql语句创建学生表
 8> 建立外键的表,不能轻易删除
 2.表连接查询
 1> 同时查询两个表中的数据,同时查学生姓名和班级名称
 ○ 必须取别名,来区分相同名字的字段
 ○ 需要精确查找,只查找有联系的数据,用where过滤。 2> 查询某个班级的所有学生
 ○ 直接通过id查询
 ○ 嵌套查询,先通过班级名称查询id,在根据id查询学生 ○ 表连接查询,利用两个表之间的联系,查询数据
 3.FMDB:处理数据库的框架 好处:
 1> 用OC开发,避免c语言,简化开发。 2> FMDB的更新包含增删改
 ○ 插入数据的占位符是?,这个是数据库的占位符,不能用%d,%@,这 些,数据库是不识别的。
 ○ FMDB的占位符只能是对象。
 ○ 用占位符?就不需要给text类型字段的值添加''单引号,会自动添加.
 ○ 用占位符?进行模糊查询,%不需要转义,因为%在stringWithFormat
 才有特殊函数,在普通字符串常量没有特殊含义,就不需要转义. 3> FMDB有专门做查询的方法,会返回一个结果集
 4> 这个结果集是一个指针,默认不指向任何结果,只有调用next才会去 指向下一条记录
 5> 注意数据库多线程安全问题,可能会导致同一时间同时操作一个数
 据,为了避免这个问题,一般都使用多线程安全的FMDB数据库实例。
 6> 不涉及修改数据,就不需要考虑多线程,离线缓存就不需要用多线程 4.数据库多线程和事物:
 4> 这个结果集是一个指针,默认不指向任何结果,只有调用next才会去
 指向下一条记录
 5> 注意数据库多线程安全问题,可能会导致同一时间同时操作一个数
 据,为了避免这个问题,一般都使用多线程安全的FMDB数据库实例。
 6> 不涉及修改数据,就不需要考虑多线程,离线缓存就不需要用多线程 4.数据库多线程和事物:
 ○ FMDB会帮我们创建一个线程安全的数据库实例,并且自动打开, 查看源码。
 ○ GCD里面是线程安全的,在里面访问数据会自动加锁。
 1> 银行取钱存钱例子,同时取钱和存钱,操作一个数据,可能会造成数 据不对。
 2> 这时候需要通过多线程管理,给线程加锁。
 3> 事务:把有联系的业务逻辑划分到一个事务里,比如转账,比如必须 两个同时修改成功,才能 交。
 ○ 注意:即使不 交事务,也会修改成功,需要判断操作有没有执行 对,如果发现事务里有一个操作不对,就主动回滚。
 ○ 注意把操作放在事务里,并不会自动有一个操作失败就会主动回 滚,需要我们自己处理,否则就会有有些执行,有些没执行。
 5.微博离线缓存
 ○ 把微博数据缓存起来,下次就不用重新加载。
 1> 离线缓存业务逻辑,先从数据库取,取不到再去发送请求。
 2> 在微博工具类做判断,微博工具类有个专门 供微博数据的方法,在 这里先从数据库里取,没有取到就去加载。
 3> 搞个专门处理数据库的业务类。
 ○ 好处:业务逻辑清晰
 ○ 以后换框架了,直接改这个类。
 ○ 在initial方法创建数据库,不需要用多线程。 ○ 数据库文件存储到cache文件夹。
 4> 创建表格,分析字段
 ○ id ̇主键
 ○ idStr微博id对应请求参数,根据他才能准确查找微博数据,字段约
 束不为空,唯一。
 ○ accessToken获取令牌-保证一个用户对应一个客户端对应请求参
 数,能找到对应用户的微博数据。
 ○ dict微博数据
 ○ 数据库字段技巧:用请求参数,请求结果,作为字段,保证通过某
 个字段能查到结果。 5> 数据库业务逻辑
 ○  供保存微博数据的方法
 ○  供获取微博数据的方法。
 ○ 获取微博数据的方法,需要判断sinceID和maxID有没有值,有值才
 6> 在获取到新的数据,记得存储到数据库 6.清空图片缓存和计算缓存尺寸
 需要根据idstr去查找。
 • 用SDwebImage有个管理缓存的单例
 ○
 ○  供获取微博数据的方法。
 ○ 获取微博数据的方法,需要判断sinceID和maxID有没有值,有值才
 6> 在获取到新的数据,记得存储到数据库 6.清空图片缓存和计算缓存尺寸
 • 用SDwebImage有个管理缓存的单例
 • 清空图片缓存
 • [[SDImageCache sharedImageCache] clearDisk];
 • 计算缓存尺寸
 • [[SDImageCache sharedImageCache] getSize]
 7.计算缓存文件尺寸的底层实现
 • 文件夹获取的文件尺寸不准确,需要遍历所有文件,把文件夹里所有文
 件的尺寸加起来算出文件夹尺寸。
 • 判断路径是否存在
 • 判断路径是否是文件夹
 • 如果是文件夹,就遍历所有的子路径,把所有子路径的尺寸加起来
 需要根据idstr去查找。
 
 */
//查询
- (IBAction)select:(id)sender {
    
    FMResultSet *result =  [_db executeQuery:@"select * from t_contact"];
    
    // 从结果集里面往下找
    while ([result next]) {
        NSString *name = [result stringForColumn:@"name"];
        NSString *phone = [result stringForColumn:@"phone"];
        NSLog(@"%@--%@",name,phone);
    }
    
}
//改
- (IBAction)update:(id)sender {
    // FMDB？，只能是对象，不能是基本数据类型，如果是int类型，就包装成NSNumber
    BOOL flag = [_db executeUpdate:@"update t_contact set name = ?",@"abc"];
    if (flag) {
        NSLog(@"success");
    }else{
        NSLog(@"failure");
    }
}
//插入
- (IBAction)insert:(id)sender {
    // ?:表示数据库里面的占位符
    BOOL flag = [_db executeUpdate:@"insert into t_contact (name,phone) values (?,?)",@"oooo",@"21321321"];
    if (flag) {
        NSLog(@"success");
    }else{
        NSLog(@"failure");
    }
    
}
//删除
- (IBAction)delete:(id)sender {
    BOOL flag = [_db executeUpdate:@"delete from t_contact;"];
    if (flag) {
        NSLog(@"success");
    }else{
        NSLog(@"failure");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    // 拼接文件名
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"contact.sqlite"];
    // 创建一个数据库的实例,仅仅在创建一个实例，并会打开数据库
    FMDatabase *db = [FMDatabase databaseWithPath:filePath];
    _db = db;
    // 打开数据库
    BOOL flag = [db open];
    if (flag) {
        NSLog(@"打开成功");
    }else{
        NSLog(@"打开失败");
    }
    
    // 创建数据库表
    // 数据库操作：插入，更新，删除都属于update
    // 参数：sqlite语句
    BOOL flag1 = [db executeUpdate:@"create table if not exists t_contact (id integer primary key autoincrement,name text,phone text);"];
    if (flag1) {
        NSLog(@"创建成功");
    }else{
        NSLog(@"创建失败");
        
    }
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
