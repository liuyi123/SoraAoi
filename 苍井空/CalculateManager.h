//
//  CalculateManager.h
//  苍井空
//
//  Created by liuyi on 17/1/12.
//  Copyright © 2017年 liuyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculateManager : NSObject
@property (nonatomic, assign) int result;

-(CalculateManager *(^)(int))add;
@end
