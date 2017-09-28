//
//  NIDropDown.h
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NIDropDown;

@protocol NIDropDownDelegate <NSObject>
- (void)niDropDownDelegateMethod:(NIDropDown *)sender didSelectIndex:(int)index;
@end

@interface NIDropDown : UIView <UITableViewDelegate, UITableViewDataSource>
{
    NSString *animationDirection;
    UIImageView *imgView;
}

@property (nonatomic, weak) id <NIDropDownDelegate> delegate;
@property (nonatomic, copy) NSString *animationDirection;

-(void)hideDropDown:(UIButton *)b;
- (id)showDropDown:(UIButton *)b height:(CGFloat *)height titleArr:(NSArray *)arr imgArr:(NSArray *)imgArr direction:(NSString *)direction;
@end
