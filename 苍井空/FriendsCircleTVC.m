//
//  FriendsCircleTVC.m
//  苍井空
//
//  Created by liuyi on 17/1/9.
//  Copyright © 2017年 liuyi. All rights reserved.
//

#import "FriendsCircleTVC.h"
#import "XMGStatus.h"
#import "MJExtension.h"
#import "XMGStatusCell.h"
@interface FriendsCircleTVC ()
/** 所有的微博数据 */
@property (nonatomic, strong) NSArray *statuses;
@end

@implementation FriendsCircleTVC

- (NSArray *)statuses
{
    if (!_statuses) {
        _statuses = [XMGStatus mj_objectArrayWithFilename:@"statuses.plist"];
    }
    return _statuses;
}

NSString *ID = @"status";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    self.tableView.rowHeight = 250;
    [self.tableView registerClass:[XMGStatusCell class] forCellReuseIdentifier:ID];
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statuses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 访问缓存池
    XMGStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 传递模型数据
    cell.status = self.statuses[indexPath.row];
    return cell;
}

#pragma mark - 代理方法
// 得出方案:在这个方法返回之前就要计算cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    XMGStatus *status = self.statuses[indexPath.row];
    
    CGFloat space = 10;
    /** 图像 */
    CGFloat iconX = space;
    CGFloat iconY = space;
    CGFloat iconWH = 30;
    CGRect iconImageViewFrame = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /** 正文 */
    CGFloat textX = iconX;
    CGFloat textY = CGRectGetMaxY(iconImageViewFrame) + space;
    CGFloat textW = [UIScreen mainScreen].bounds.size.width - 2 * space;
    NSDictionary *textAtt = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
    // 最大宽度是textW,高度不限制
    CGSize textSize = CGSizeMake(textW, MAXFLOAT);
    CGFloat textH = [status.text boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textAtt context:nil].size.height;
    CGRect text_LabelFrame = CGRectMake(textX, textY, textW, textH);
    
    CGFloat cellHeight = 0;
    /** 配图 */
    if (status.picture) { // 有配图
        CGFloat pictureWH = 100;
        CGFloat pictureX = iconX;
        CGFloat pictureY = CGRectGetMaxY(text_LabelFrame) + space;
        CGRect pictureImageViewFrame = CGRectMake(pictureX, pictureY, pictureWH, pictureWH);
        cellHeight = CGRectGetMaxY(pictureImageViewFrame) + space;
    } else {
        cellHeight = CGRectGetMaxY(text_LabelFrame) + space;
    }
    
    return cellHeight;
}

@end
