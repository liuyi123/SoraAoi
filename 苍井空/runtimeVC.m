//
//  runtimeVC.m
//  苍井空
//
//  Created by liuyi on 17/1/8.
//  Copyright © 2017年 liuyi. All rights reserved.
//

#import "runtimeVC.h"
#import <objc/message.h>
#import "Person.h"
#import "NSObject+Property.h"
#import "StatusItem.h"
#import "NSObject+Model.h"
@interface runtimeVC ()

@end

@implementation runtimeVC
// 类方法本质:类对象调用[NSObject class]
// id:谁发送消息
// SEL:发送什么消息
// ((NSObject *(*)(id, SEL))(void *)objc_msgSend)([NSObject class], @selector(alloc));
// xcode6之前,苹果运行使用objc_msgSend.而且有参数提示
// xcode6苹果不推荐我们使用runtime

// 解决消息机制方法提示步骤
// 查找build setting -> 搜索msg
// 最终生成消息机制,编译器做的事情
// 最终代码,需要把当前代码重新编译,用xcode编译器,clang
// clang -rewrite-objc main.m 查看最终生成代码

/*
 内容5大区
 1.栈 2.堆 3.静态区 4.常量区 5.方法区
 1.栈:不需要手动管理内存,自动管理
 2.堆,需要手动管理内存,自己去释放
 */

/*
 runtime:方法都是有前缀,谁的事情谁开头
 
 开发中使用场景:
 需要用到runtime,消息机制
 1.装逼
 2.不得不用runtime消息机制,可以帮我调用私有方法.
 */
- (void)viewDidLoad {
    /*
     Person *p = objc_msgSend(objc_getClass("Person"), sel_registerName("alloc"));
     p = [p init];
     
     p = objc_msgSend(p, sel_registerName("init"));
     
     调用eat
     [p eat];
     
     objc_msgSend(p, @selector(eat));
     objc_msgSend(p, @selector(run:),20);
     
     面试:
     方法调用流程
     怎么去调用eat方法 ,对象方法:类对象的方法列表 类方法:元类中方法列表
     1.通过isa去对应的类中查找
     2.注册方法编号
     3.根据方法编号去查找对应方法
     4.找到只是最终函数实现地址,根据地址去方法区调用对应函数
     
     */

    
    
    [super viewDidLoad];
    
    [self changMethod];
    
    [self DynamicMethod];
    
    [self DynamicAttribute];
    
    [self transformation];
    
    
    
    // Do any additional setup after loading the view.
}
/*
 Runtime(交换方法):只要想修改系统的方法实现
 
 需求:
 
 比如说有一个项目,已经开发了2年,忽然项目负责人添加一个功能,每次UIImage加载图片,告诉我是否加载成功
 
 // 给系统的imageNamed添加功能,只能使用runtime(交互方法)
 // 1.给系统的方法添加分类
 // 2.自己实现一个带有扩展功能的方法
 // 3.交互方法,只需要交互一次,
 
 // 1.自定义UIImage
 
 // 2.UIImage添加分类
 
 弊端:
 1.每次使用,都需要导入
 2.项目大了,没办法实现
 
 */

-(void)changMethod{
    // imageNamed => xmg_imageNamed 交互这两个方法实现
    UIImage *image = [UIImage imageNamed:@"1.png"];
    
}
/*
 Runtime(动态添加方法):OC都是懒加载机制,只要一个方法实现了,就会马上添加到方法列表中.
 app:免费版,收费版
 QQ,微博,直播等等应用,都有会员机制
 
 美团有个面试题?有没有使用过performSelector,什么时候使用?动态添加方法的时候使用过?怎么动态添加方法?用runtime?为什么要动态添加方法?
 */
-(void)DynamicMethod{
    
    //    _cmd:当前方法的方法编号
    
    Person *p = [[Person alloc] init];
    
    // 执行某个方法
    //    [p performSelector:@selector(eat)];
    
    [p performSelector:@selector(run:) withObject:@10];

}
/*
 动态添加属性:什么时候需要动态添加属性
 
 开发场景
 给系统的类添加属性的时候,可以使用runtime动态添加属性方法
 
 本质:动态添加属性,就是让某个属性与对象产生关联
 
 需求:让一个NSObject类 保存一个字符串
 
 runtime一般都是针对系统的类
 */
-(void)DynamicAttribute{
    
    NSObject *objc = [[NSObject alloc] init];
    
    objc.name = @"123";
    
    NSLog(@"%@",objc.name);
    
}
//字典转模型
-(void)transformation{

    // 获取文件全路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"status.plist" ofType:nil];
    
    // 文件全路径
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    // 设计模型,创建属性代码 => dict
    //    [dict[@"user"] createPropertyCode];
    
    // 字典转模型:KVC,MJExtension
    StatusItem *item = [StatusItem modelWithDict:dict];
    
    NSLog(@"%@",item.user);

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
