//
//  ThirdViewController.m
//  CheckOut
//
//  Created by 杨 on 16/3/15.
//  Copyright © 2016年 杨. All rights reserved.
//

#import "ThirdViewController.h"

#import "FiveViewController.h"

@implementation ThirdViewController
- (IBAction)ClickButton:(id)sender {
    NSLog(@"third");
    UIButton *button = (UIButton *)sender;
    button.backgroundColor = [UIColor yellowColor];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    FiveViewController *vc = [FiveViewController new];
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
