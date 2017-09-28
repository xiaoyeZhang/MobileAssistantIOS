//
//  Bless_informationViewController.h
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/7.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Bless_informationDelegate <NSObject>

- (void)successBless_informationdelegate:(NSDictionary *)successdelegate;

@end

@interface Bless_informationViewController : XYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSString *type_id;
@property (copy, nonatomic) NSString *Title;
@property (weak, nonatomic) id<Bless_informationDelegate>delegate;

@property (strong, nonatomic) NSArray *telArr;
@end
