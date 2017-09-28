//
//  MainCell.m
//  NT
//
//  Created by Kohn on 14-5-27.
//  Copyright (c) 2014年 Pem. All rights reserved.
//

#import "MainCell.h"

@implementation MainCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //头像
        _Headerphoto = [[UIImageView alloc]initWithFrame:CGRectMake(6, 5, 50, 40)];
        [self.contentView addSubview:_Headerphoto];
    
        //名字
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, 200, 25)];
        _nameLabel.backgroundColor  = [UIColor clearColor];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_nameLabel];
        
        //分割线
        _imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(60, 35, 320-60, 1)];
        [self.contentView addSubview:_imageLine];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (void)setMainCell
{
    
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
