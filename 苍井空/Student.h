//
//  Student.h
//  01-数据库的简单使用
//
//  Created by apple on 15-3-15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int age;

+ (instancetype)studentWithName:(NSString *)name age:(int)age;

@end
