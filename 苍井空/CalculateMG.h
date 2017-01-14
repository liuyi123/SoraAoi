//
//  CalculateMG.h
//  苍井空
//
//  Created by liuyi on 17/1/14.
//  Copyright © 2017年 liuyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculateMG : NSObject

@property (nonatomic, assign) int result;
+(instancetype)ly_calculate:(int (^)(int result))block;
@end
