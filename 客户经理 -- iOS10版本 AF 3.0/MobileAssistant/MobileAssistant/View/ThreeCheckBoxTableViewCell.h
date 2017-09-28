//
//  ThreeCheckBoxTableViewCell.h
//  MobileAssistant
//
//  Created by 张晓烨 on 15/12/22.
//  Copyright © 2015年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ThreeCheckBoxTableViewCell;

@protocol ThreeCheckBoxTableViewCellDelegate <NSObject>

@optional

- (void)ThreecheckBoxTableViewCell:(ThreeCheckBoxTableViewCell *)cell checkDidChanged:(int)selectedIndex;

@end

@interface ThreeCheckBoxTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (assign, nonatomic) int selectedIndex; /*选中按钮索引*/
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id<ThreeCheckBoxTableViewCellDelegate> delegate;
@property (strong, nonatomic) NSArray *selectArray;

- (void)setSelectDataWithArray:(NSArray *)array;

- (void)setSelectBtnIndex:(int)index;

@end
