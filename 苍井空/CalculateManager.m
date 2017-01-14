//
//  CalculateManager.m
//  苍井空
//
//  Created by liuyi on 17/1/12.
//  Copyright © 2017年 liuyi. All rights reserved.
//

#import "CalculateManager.h"

@implementation CalculateManager
-(CalculateManager *(^)(int))add{

    return ^(int value){
        _result += value;
        
        return self;
        
    };
    
  
    
    /*
     CalculateManager *(^block)(int value)=^(int value){
     
     _result+=value;
       return self;
     };
     
     
     return block;
     */
}
@end
