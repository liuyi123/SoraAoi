//
//  ResponseIdeaVC.m
//  苍井空
//
//  Created by liuyi on 17/1/14.
//  Copyright © 2017年 liuyi. All rights reserved.
//

#import "ResponseIdeaVC.h"

#import "Persons.h"

#import "NSObject+KVO.h"
@interface ResponseIdeaVC ()
@property (nonatomic, strong) Persons *p;
@end

@implementation ResponseIdeaVC
/*
 1.ReactiveCocoa简介
 
 ReactiveCocoa（简称为RAC）,是由Github开源的一个应用于iOS和OS开发的新框架,Cocoa是苹果整套框架的简称，因此很多苹果框架喜欢以Cocoa结尾。
 
 2.ReactiveCocoa作用
 
 在我们iOS开发过程中，当某些事件响应的时候，需要处理某些业务逻辑,这些事件都用不同的方式来处理。
 比如按钮的点击使用action，ScrollView滚动使用delegate，属性值改变使用KVO等系统提供的方式。
 其实这些事件，都可以通过RAC处理
 ReactiveCocoa为事件提供了很多处理方法，而且利用RAC处理事件很方便，可以把要处理的事情，和监听的事情的代码放在一起，这样非常方便我们管理，就不需要跳到对应的方法里。非常符合我们开发中高聚合，低耦合的思想。
 3.编程思想
 
 在开发中我们也不能太依赖于某个框架，否则这个框架不更新了，导致项目后期没办法维护，比如之前Facebook提供的Three20框架，在当时也是神器，但是后来不更新了，也就没什么人用了。因此我感觉学习一个框架，还是有必要了解它的编程思想。
 
 编程思想的由来：在开发中我们会遇见各种各样的需求，经常会思考如何快速的完成这些需求，这样就会慢慢形成快速完成这些需求的思想。
 
 先简单介绍下目前咱们已知的编程思想。
 
 3.1 面向过程：处理事情以过程为核心，一步一步的实现。
 
 3.2 面向对象：万物皆对象
 
 3.3 链式编程思想：是将多个操作（多行代码）通过点号(.)链接在一起成为一句代码,使代码可读性好。a(1).b(2).c(3)
 
 链式编程特点：方法的返回值是block,block必须有返回值（本身对象），block参数（需要操作的值）
 
 代表：masonry框架。
 
 练习一:模仿masonry，写一个加法计算器，练习链式编程思想。
 
 3.4 响应式编程思想：不需要考虑调用顺序，只需要知道考虑结果，类似于蝴蝶效应，产生一个事件，会影响很多东西，这些事件像流一样的传播出去，然后影响结果，借用面向对象的一句话，万物皆是流。
 
 代表：KVO运用。
 
 练习二:KVO底层实现。
 
 3.5 函数式编程思想：是把操作尽量写成一系列嵌套的函数或者方法调用。
 
 函数式编程本质:就是往方法中传入Block,方法中嵌套Block调用，把代码聚合起来管理
 函数式编程特点：每个方法必须有返回值（本身对象）,把函数或者Block当做参数,block参数（需要操作的值）block返回值（操作结果）
 
 代表：ReactiveCocoa。
 
 练习三:用函数式编程实现，写一个加法计算器,并且加法计算器自带判断是否等于某个值.
 
 4.ReactiveCocoa编程思想
 
 ReactiveCocoa结合了几种编程风格：
 
 函数式编程（Functional Programming）
 
 响应式编程（Reactive Programming）
 
 所以，你可能听说过ReactiveCocoa被描述为函数响应式编程（FRP）框架。
 
 以后使用RAC解决问题，就不需要考虑调用顺序，直接考虑结果，把每一次操作都写成一系列嵌套的方法中，使代码高聚合，方便管理。
 
 5.如何导入ReactiveCocoa框架
 
 通常都会使用CocoaPods（用于管理第三方框架的插件）帮助我们导入。
 
 PS:CocoaPods教程（http://code4app.com/article/cocoapods-install-usage）
 
 练习四:创建一个新的工程，演示下，框架的导入。
 
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // KVO底层实现
    // 1.自定义NSKVONotifying_Person子类
    // 2.重写setName,在内部恢复父类做法,通知观察者
    // 3.如何让外界调用自定义Person类的子类方法,修改当前对象的isa指针,指向NSKVONotifying_Person
    
    Persons *p = [[Persons alloc] init];
    
    // 监听name属性有没有改变
    [p xmg_addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    //    [p addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    
    _p = p;
    
}

- (void)KVO
{
    /*
     响应式编程思想
     a,b,c
     
     c = a + b;
     
     a = 2;
     
     b = 3;
     
     */
    
    Persons *p = [[Persons alloc] init];
    
    // 监听name属性有没有改变
    [p addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    
    _p = p;
    
    // KVO怎么实现
    // KVO的本质就是监听一个对象有没有调用set方法
    // 重写这个方法
    
    // 监听方法本质:并不需要修改方法的实现,仅仅想判断下有没有调用
    
}

// 只要p.name一改变就会调用
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSLog(@"%@",_p.name);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    static int i = 0;
    i++;
    _p.name = [NSString stringWithFormat:@"%d",i];
    //    _p -> _name = [NSString stringWithFormat:@"%d",i];
}

@end
