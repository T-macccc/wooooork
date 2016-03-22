//
//  NextViewController.m
//  CheckOut
//
//  Created by 杨 on 16/3/15.
//  Copyright © 2016年 杨. All rights reserved.
//

#import "NextViewController.h"

#import "ThirdViewController.h"

@implementation NextViewController

- (void)turn{
    ThirdViewController *thirdVC = [ThirdViewController new];
    
//    [self.navigationController pushViewController:thirdVC animated:YES];
    [self presentViewController:thirdVC animated:YES completion:nil];
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
    [_indexPathArray addObject:indexPath];
    
    //    TraverseViewC *tra = [[TraverseViewC alloc]init];
    //    [tra handleTableView:self];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
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
    return cell;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor cyanColor];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"third" style:UIBarButtonItemStylePlain target:self action:@selector(turn)];
    
    self.navigationItem.leftBarButtonItem = leftButton;
    
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
    [button setTitle:@"turn" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(turn) forControlEvents:UIControlEventTouchUpInside];
     }

@end
