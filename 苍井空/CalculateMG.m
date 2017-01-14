//
//  CalculateMG.m
//  苍井空
//
//  Created by liuyi on 17/1/14.
//  Copyright © 2017年 liuyi. All rights reserved.
//

#import "CalculateMG.h"

@implementation CalculateMG
+(instancetype)ly_calculate:(int (^)(int result))block{
    
    CalculateMG *mgr=[[CalculateMG alloc]init];
    
    
     mgr.result=block(mgr.result);


    return mgr;
}
@end
