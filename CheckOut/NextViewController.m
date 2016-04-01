//
//  NextViewController.m
//  CheckOut
//
//  Created by 杨 on 16/3/15.
//  Copyright © 2016年 杨. All rights reserved.
//

#import "NextViewController.h"

#import "ThirdViewController.h"
#import "FourViewController.h"

#import "TableViewCell.h"
#import <objc/runtime.h>

@implementation NextViewController

- (void)print{
    NSLog(@"just i can");
}

- (void)turn1{
    ThirdViewController *thirdVC = [ThirdViewController new];
    FourViewController *four = [FourViewController new];
    
    [self.navigationController pushViewController:four animated:YES];
//    [self presentViewController:four animated:YES completion:nil];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return [_titleArray objectAtIndex:section];
            break;
        case 1:
            return [_titleArray objectAtIndex:section];
            break;
            
        default:
            break;
    }
    return @"Unknow";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return [_dataArray1 count];
            break;
        case 1:
            return [_dataArray2 count];
            break;
            
        default:
            return 0;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"indexPathArray:%@",_indexPathArray);
//    [_indexPathArray addObject:indexPath];
    NSLog(@"nextViewController:%ld,%ld",(long)indexPath.row,(long)indexPath.section);
    NSLog(@"Next TableVIew did Select");
    //    TraverseViewC *tra = [[TraverseViewC alloc]init];
    //    [tra handleTableView:self];
    [self print];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TableViewCell alloc]initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
    }
    switch (indexPath.section) {
        case 0:
            [[cell textLabel] setText:[_dataArray1 objectAtIndex:indexPath.row]];
            break;
            
        case 1:
            [[cell textLabel] setText:[_dataArray2 objectAtIndex:indexPath.row]];
            break;
            
        default:
            [[cell textLabel] setText:@"Unknow"];
            break;
    }
    return (UITableViewCell *)cell;
}

//- (void)LSD_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"tableView 替换");
//    [self LSD_tableView:tableView didSelectRowAtIndexPath:indexPath];
//}

- (void)turn{
    NSLog(@"i'm turning");
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor cyanColor];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"third" style:UIBarButtonItemStylePlain target:self action:@selector(turn1)];
    
    self.navigationItem.rightBarButtonItem = leftButton;
    
    _dataTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    
    [_dataTable setDelegate:self];
    [_dataTable setDataSource:self];
    [self.view addSubview:_dataTable];
    
    _dataArray1 = [[NSMutableArray alloc]initWithObjects:@"China",@"American",@"English", nil];
    _dataArray2 = [[NSMutableArray alloc]initWithObjects:@"Yellow",@"Black",@"White", nil];
    _titleArray = [[NSMutableArray alloc]initWithObjects:@"country",@"race", nil];
    _indexPathArray = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(200, 400, 100, 50)];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"turn1" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(turn) forControlEvents:UIControlEventTouchUpInside];
    
//        NSString *className = @"NextViewController";
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            Class class = NSClassFromString(@"NextViewController");
//            
//            SEL originalSelector = @selector(tableView:didSelectRowAtIndexPath:);
//            SEL swizzleSelector = @selector(LSD_tableView:didSelectRowAtIndexPath:);
//            
//            Method originalMethod = class_getInstanceMethod(class, originalSelector);
//            Method swizzleMethod = class_getInstanceMethod(class, swizzleSelector);
//            
//            BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
//            if (didAddMethod) {
//                class_replaceMethod(class, swizzleSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//            }else{
//                method_exchangeImplementations(originalMethod, swizzleMethod);
//            }
//        });

     }

@end
