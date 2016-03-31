//
//  SevenViewController.h
//  CheckOut
//
//  Created by 杨 on 16/3/31.
//  Copyright © 2016年 杨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SevenViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic)UICollectionView *collectionView;
@property (strong, nonatomic)NSMutableArray *indexArray;

@end
