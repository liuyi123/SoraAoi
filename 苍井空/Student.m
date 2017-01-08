//
//  Student.m
//  01-数据库的简单使用
//
//  Created by apple on 15-3-15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "Student.h"

@implementation Student

+ (instancetype)studentWithName:(NSString *)name age:(int)age
{
    Student *s = [[self alloc] init];
    
    s.name = name;
    s.age = age;
    
    return s;
}

@end
