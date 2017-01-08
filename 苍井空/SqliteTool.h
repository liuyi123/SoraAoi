//
//  SqliteTool.h
//  01-数据库的简单使用
//
//  Created by apple on 15-3-15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SqliteTool : NSObject
// 插入。删除，修改
+ (void)execWithSql:(NSString *)sql;
+ (NSArray *)selectWithSql:(NSString *)sql;

@end
