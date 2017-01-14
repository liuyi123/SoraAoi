//
//  Persons.m
//  苍井空
//
//  Created by liuyi on 17/1/14.
//  Copyright © 2017年 liuyi. All rights reserved.
//

#import "XMGKVONotifying_Person.h"

#import <objc/message.h>
extern NSString *const observerKey ;
@implementation XMGKVONotifying_Person
- (void)setName:(NSString *)name
{
    [super setName:name];
    
    // 通知观察者调用observeValueForKeyPath
    // 需要把观察者保存到当前对象
    // 获取观察者
   id obsetver = objc_getAssociatedObject(self, observerKey);
    
    [obsetver observeValueForKeyPath:@"name" ofObject:self change:nil context:nil];
    
}
@end
