//
//  NSObject+Calculate.h
//  苍井空
//
//  Created by liuyi on 17/1/12.
//  Copyright © 2017年 liuyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalculateManager.h"
@interface NSObject (Calculate)
+(int)ly_makeCalculate:(void(^)(CalculateManager *manager))block;
@end
