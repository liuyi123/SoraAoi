//
//  Persons.h
//  苍井空
//
//  Created by liuyi on 17/1/14.
//  Copyright © 2017年 liuyi. All rights reserved.
//

#import "NSObject+KVO.h"

#import <objc/message.h>

#import "XMGKVONotifying_Person.h"


NSString *const observerKey = @"observer";

@implementation NSObject (KVO)
// 监听某个对象的属性
// 谁调用就监听谁
- (void)xmg_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    
    /*
     // 1.自定义NSKVONotifying_Person子类
     // 2.重写setName,在内部恢复父类做法,通知观察者
     // 3.如何让外界调用自定义Person类的子类方法,修改当前对象的isa指针,指向NSKVONotifying_Person
     */
    
    // 把观察者保存到当前对象
    objc_setAssociatedObject(self, (__bridge const void *)(observerKey), observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 修改对象isa指针
    object_setClass(self, [XMGKVONotifying_Person class]);
    
}
@end
