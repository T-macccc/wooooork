//
//  ViewController.m
//  CheckOut
//
//  Created by 杨 on 16/3/15.
//  Copyright © 2016年 杨. All rights reserved.
//

#import "ViewController.h"

#import "FourViewController.h"
#import "NextViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    UITextField *textField0;
    UITextField *textField1;
}

- (IBAction)ClickedSSS:(id)sender {
    NSLog(@"swss");
    [self turn];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [textField0 resignFirstResponder];
    [textField1 resignFirstResponder];
}

- (void)turn{
//    FourViewController *four =  [[FourViewController alloc]init];
    NextViewController *next = [NextViewController new];
//
    NSLog(@"VC_self:%@",self);

//    [self.navigationController pushViewController:next animated:YES];
    [self presentViewController:next animated:YES completion:nil];
    NSLog(@"VC_turn");
}

- (void)action0{
    NSLog(@"0");
}

- (void)action1{
    NSLog(@"1");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(turn)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(50, 50, 200, 200)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UIButton *button0 = [UIButton buttonWithType:UIButtonTypeCustom];
    button0.frame = CGRectMake(10, 30, 50, 30);
    [button0 setTitle:@"0" forState:UIControlStateNormal];
    [button0 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [view addSubview:button0];
    
    [button0 addTarget:self action:@selector(turn) forControlEvents:UIControlEventTouchUpInside];
    button0.backgroundColor = [UIColor greenColor];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(70, 30, 50, 30);
    [button1 setTitle:@"1" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [view addSubview:button1];
    [button1 addTarget:self action:@selector(action1) forControlEvents:UIControlEventTouchUpInside];
    [button1 setBackgroundColor:[UIColor greenColor]];
    
    textField0 = [[UITextField alloc]initWithFrame:CGRectMake(0, 60, 100, 30)];
    [view addSubview:textField0];
    textField0.placeholder = @"000000000";
    textField0.backgroundColor = [UIColor grayColor];
    
    textField1 = [[UITextField alloc]initWithFrame:CGRectMake(0, 100, 100, 30)];
    [view addSubview:textField1];
    textField1.placeholder = @"111111111";
    textField1.backgroundColor = [UIColor grayColor];
    
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(50, 270, 100, 100)];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 400, 200, 300)];
    textView.text = @"Now is the time for all good developers to come to serve their country.\n\nNow is the time for all good developers to come to serve their country.";
    [self.view addSubview:textView];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(160, 270, 100, 100)];
    view2.backgroundColor = [UIColor grayColor];
    [self.view addSubview:view2];
    
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myButton setTitle:@"test" forState:UIControlStateNormal];
    myButton.frame = CGRectMake(0, 0, 100, 50);
    [view2 addSubview:myButton];
    myButton.backgroundColor = [UIColor greenColor];
    
    UISwitch *switchButton = [[UISwitch alloc]initWithFrame:CGRectMake(250, 400, 20, 10)];
    [switchButton setOn:YES];
    [self.view addSubview:switchButton];
    
    UIStepper *stepper = [[UIStepper alloc]initWithFrame:CGRectMake(280, 350, 20, 10)];
    stepper.stepValue = 1;
    stepper.minimumValue = 0;
    stepper.maximumValue = 5;
    stepper.value = 2;
    [self.view addSubview:stepper];
    
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(50, 50, 200, 200)];
//    view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:view];
//    
//    UIButton *button0 = [UIButton buttonWithType:UIButtonTypeCustom];
//    button0.frame = CGRectMake(10, 30, 50, 30);
//    [button0 setTitle:@"0" forState:UIControlStateNormal];
//    [button0 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [view addSubview:button0];
//    
//    [button0 addTarget:self action:@selector(turn) forControlEvents:UIControlEventTouchUpInside];
//    button0.backgroundColor = [UIColor greenColor];
//    
//    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    button1.frame = CGRectMake(70, 30, 50, 30);
//    [button1 setTitle:@"1" forState:UIControlStateNormal];
//    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [view addSubview:button1];
//    [button1 addTarget:self action:@selector(action1) forControlEvents:UIControlEventTouchUpInside];
//    [button1 setBackgroundColor:[UIColor greenColor]];
//    
//    textField0 = [[UITextField alloc]initWithFrame:CGRectMake(0, 60, 100, 30)];
//    [view addSubview:textField0];
//    textField0.placeholder = @"000000000";
//    textField0.backgroundColor = [UIColor grayColor];
//    
//    textField1 = [[UITextField alloc]initWithFrame:CGRectMake(0, 100, 100, 30)];
//    [view addSubview:textField1];
//    textField1.placeholder = @"111111111";
//    textField1.backgroundColor = [UIColor grayColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"add" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor brownColor]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(250, 50, 100, 50)];
    [self.view addSubview:button];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
