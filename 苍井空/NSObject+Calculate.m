//
//  NSObject+Calculate.m
//  苍井空
//
//  Created by liuyi on 17/1/12.
//  Copyright © 2017年 liuyi. All rights reserved.
//

#import "NSObject+Calculate.h"

@implementation NSObject (Calculate)
+(int)ly_makeCalculate:(void(^)(CalculateManager *manager))block{
    
    CalculateManager *mgr=[[CalculateManager alloc]init];
   
    
    block(mgr);
    
    return mgr.result;
}
@end
