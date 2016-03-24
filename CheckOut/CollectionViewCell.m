//
//  CollectionViewCell.m
//  CheckOut
//
//  Created by 杨 on 16/3/24.
//  Copyright © 2016年 杨. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"collect" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(5, 5, 50, 30)];
        [self addSubview:button];
        
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(65, 5, 80, 30)];
        [self addSubview:textField];
        textField.placeholder = @"enter some words";
    }
    return self;
}

@end
