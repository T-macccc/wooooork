//
//  TableViewCell.m
//  CheckOut
//
//  Created by 杨 on 16/3/24.
//  Copyright © 2016年 杨. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"table" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:button];
        button.frame = CGRectMake(83, 5, 50, 30);
        [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        
        UITextField *textfield = [[UITextField alloc]initWithFrame:CGRectMake(150, 5, 80, 30)];
        [self addSubview:textfield];
        textfield.placeholder = @"please enter words";
    }
    return self;
}

- (void)buttonClick{
    NSLog(@"touch");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
   
    
    
    // Configure the view for the selected state
}

@end
