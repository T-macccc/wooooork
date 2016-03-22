//
//  Lotuseed.h
//  quancaiji
//
//  Created by 杨 on 16/2/22.
//  Copyright © 2016年 杨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Lotuseed.h"

@interface Lotuseed : NSObject

@property (nonatomic, copy) NSString *apiToken;;
@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, strong) NSMutableArray *eventQueue;

@property (nonatomic, strong)NSMutableArray *addTargetArray;
@property (nonatomic, strong)NSMutableArray *viewArray;
@property (nonatomic, strong)NSMutableArray *tabBarButtonArray;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)id lastVC;
@property (nonatomic, strong)id firstVC;
@property (nonatomic, assign)BOOL hasNavigation;
@property (nonatomic, strong)UIBarButtonItem *buttonItem;

- (instancetype)initWithToken:(NSString *)apiToken launchOptions:(NSDictionary *)launchOptions;

+ (Lotuseed *)sharedInstance;
+ (Lotuseed *)sharedInstanceWithToken:(NSString *)apiToken;

@end