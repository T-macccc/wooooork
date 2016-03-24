//
//  Lotuseed.m
//  quancaiji
//
//  Created by 杨 on 16/2/22.
//  Copyright © 2016年 杨. All rights reserved.
//

#import "Lotuseed.h"
#import <objc/runtime.h>

@implementation Lotuseed

- (instancetype)init{
    if (self = [super init]) {
        _viewArray = [NSMutableArray array];
    }
    return self;
}

+ (void)initialize{
    BOOL backgroundSupported = [Lotuseed isMulitaskingSupported];
    if (backgroundSupported) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addSelector) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewControllerChanged:) name:UITouchPhaseBegan object:nil];
    }
}

//自动添加监控
+ (BOOL)isMulitaskingSupported{
    BOOL backgroundSupported = NO;
    
    UIDevice *device = [UIDevice currentDevice];
    if ([device respondsToSelector:@selector(isMultitaskingSupported)]) {
        backgroundSupported = device.multitaskingSupported;
    }
    return backgroundSupported;
}

+ (void)viewControllerChanged:(UIButton *)something{
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (controller.presentedViewController) {
        controller = controller.presentedViewController;
    }
    if (controller != [Lotuseed sharedInstance].lastVC) {
        
        [Lotuseed sharedInstance].lastVC = controller;
        
        [[Lotuseed sharedInstance] invokeLotuseed:controller];
        [[Lotuseed sharedInstance] performSelector:@selector(changeValue:) withObject:controller afterDelay:1.0];
    }
}

- (void)changeValue:(id)something{
    [Lotuseed sharedInstance].firstVC = something;
}

+ (void)addSelector{
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (controller.presentedViewController) {
        controller = controller.presentedViewController;
    }
    
    [[Lotuseed sharedInstance] invokeLotuseed:controller];
    [Lotuseed sharedInstance].lastVC = controller;
    [Lotuseed sharedInstance].firstVC = controller;
}

- (void)invokeLotuseed:(id)controller{

    [self severalGetobj:controller];
    
    if (([Lotuseed sharedInstance].tableView || [Lotuseed
                                                 sharedInstance].collectionView) != 1)
    {
        [self severalGetChild:controller];
    }
    else
    {
        [self addObserver:[Lotuseed sharedInstance] forKeyPath:@"lastVC" options:0 context:NULL];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
        [self gainTableViewAndIndexPath:[Lotuseed sharedInstance].firstVC];
}

//获取以property存在array里的indexPath;
- (NSDictionary *)properties_aps:(id)something{//获取对象的所有属性，及属性值
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount,i;
    objc_property_t *properties = class_copyPropertyList([something class], &outCount);
    for (i = 0; i<outCount; i++) {
        objc_property_t property = properties[i];
        const char *char_f = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [something valueForKey:(NSString *)propertyName];
        if (propertyValue) {
            [props setObject:propertyValue forKey:propertyName];
        }
    }
    free(properties);
    return props;
}

- (void)gainTableViewAndIndexPath:(id)something{//获得IndexPath的array
    
    NSDictionary *dic = [self properties_aps:something];
    for (id obj in dic)
    {
        if ([NSStringFromClass([dic[obj] class]) isEqualToString:@"__NSArrayM"] || [NSStringFromClass([dic[obj] class]) isEqualToString:@"__NSArrayI"])
        {
            NSArray *array = dic[obj];
            if (array.count) {
                if ([array[0] class] == [NSIndexPath class])
                {
                    [self handleTableViewWithIndexArray:array];
                }
            }
            else
            {
                NSLog(@"index array count is 0");
            }
            
        }
    }
    
}

- (NSArray *)getChildrenOfObject:(NSObject *)obj{//自定义控件的处理
    NSMutableArray *children = [NSMutableArray array];
    if ([obj isKindOfClass:[UIWindow class]])
    {//UIWindow
        [children addObject:((UIWindow *)obj).rootViewController];
    }
    else if ([obj isKindOfClass:[UIView class]]){
        [children addObjectsFromArray:[(UIView *)obj subviews]];
    }
    else if ([obj isKindOfClass:[UIViewController class]]){//UIViewController
        UIViewController *viewController = (UIViewController *)obj;
        
        [children addObjectsFromArray:[viewController childViewControllers]];

        if (viewController.presentedViewController) {
            [children addObject:viewController.presentedViewController];
        }
        
            [children addObject:viewController.view];
    }

    return [children copy];
}

- (NSString *)getObjName:(NSObject *)obj
{
    NSString *name;
    
    if ([obj isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)obj;
        name = button.titleLabel.text;
    }
    if ([obj isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)obj;
        name = label.text;
    }else{
        name = NSStringFromClass([obj class]);
    }
    return name;
}

- (void)severalGetChild:(NSObject *)obj{
    
    NSArray *array = [NSArray array];
    array = [self getChildrenOfObject:obj];
    
    if (array.count) {
        for (int i = 0; i<array.count; i++) {
            [self severalGetChildfirstTime:array[i]];
        }
    }
}

- (void)severalGetChildfirstTime:(NSObject *)obj{
    
    NSArray *array = [NSArray array];
    array = [self getChildrenOfObject:obj];

    if (array.count) {
        for (int i = 0; i<array.count; i++)
        {
            [self severalGetChildfirstTime:array[i]];
        }
    }
}

- (void)getChildOfCell:(NSObject *)obj{//cell内的空间遍历
    
    NSArray *array = [NSArray array];
    array = [self getChildrenOfObject:obj];
    
    if (array.count != 0) {
        [_viewArray addObjectsFromArray:array];
    }
    
    if (array.count) {
        for (int i = 0; i<array.count; i++) {
            [self getChildOfCell:array[i]];
        }
    }
}

- (void)handleTableViewWithIndexArray:(NSArray *)indexArray{//indexPath
    NSString *str = @"";
    BOOL run = 0;
    if ([Lotuseed sharedInstance].tableView) {
        for (int i = 0; i<indexArray.count; i++) {
            id myCell = [[Lotuseed sharedInstance].tableView cellForRowAtIndexPath:indexArray[i]];
            
            str = @"tableView";
            [self getChildOfCell:myCell];
        }
    }
    else if ([Lotuseed sharedInstance].collectionView){
        for (int i = 0; i<indexArray.count; i++) {
            id myCell = [[Lotuseed sharedInstance].collectionView cellForItemAtIndexPath:indexArray[i]];
            
            str = @"collectionView";
            [self getChildOfCell:myCell];
        }
    }
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (id obj in self.viewArray) {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton *button = (UIButton *)obj;
            NSString *title = button.titleLabel.text;
            [array addObject:@{
                               @"UIButton":title
                               }];
        }
        else if ([obj isKindOfClass:[UIImageView class]]){}
        
        else if ([obj isKindOfClass:[UITextField class]])
        {
            UITextField *textField = obj;
            NSString *text = textField.text;
            
            [array addObject:@{
                               @"textField":text
                               }];
        }
    }
    
    NSString *pathName = [NSString stringWithFormat:@"%@Path",str];
    NSString *path;
    if ([str isEqualToString:@"tableView"]) {
        path = [Lotuseed getControlPath:[Lotuseed sharedInstance].tableView];
        [Lotuseed sharedInstance].tableView = nil;
        run = 1;
        
    }else if ([str isEqualToString:@"collectionView"]){
        path = [Lotuseed getControlPath:[Lotuseed sharedInstance].collectionView];
        [Lotuseed sharedInstance].collectionView = nil;
        run = 1;
    }
    if (run) {
        [[Lotuseed sharedInstance] track:str properties:@{
                                                          str:array,
                                                          pathName:path
                                                          }];
        [self.viewArray removeAllObjects];
    }
    
}


//添加监控

+ (NSString *)getControlPath:(id)sender{
    
    UIView *view = [[Lotuseed sharedInstance].firstVC view];
    NSString *senderPath = nil;
    BOOL keepOn = 1;
    id passSender = sender;
    while ([passSender superview] != nil && keepOn) {
        if ([passSender superview] == view) {
            keepOn = 0;
        }

        if (senderPath.length == 0) {
            NSString *beforeStr;
            if ([passSender isKindOfClass:[UIButton class]]) {
                beforeStr = [NSString stringWithFormat:@"%@",[passSender class]];
            }
            else{
                beforeStr = NSStringFromClass([passSender class]);
            }
            NSInteger order = [[Lotuseed new] controlGetDistinctId:[passSender superview] withCompareObj:passSender];
            senderPath = [NSString stringWithFormat:@"%@%ld-%@",beforeStr,(long)order,[passSender superview].class];
            passSender = [passSender superview];
        }else{
            NSInteger order = [[Lotuseed new] controlGetDistinctId:[passSender superview] withCompareObj:passSender];
            senderPath = [NSString stringWithFormat:@"%@%ld-%@",senderPath,(long)order,[passSender superview].class];
            passSender = [passSender superview];
        }
    }
    senderPath = [NSString stringWithFormat:@"%@-%@",senderPath,[[Lotuseed sharedInstance].firstVC class]];
    
    return senderPath;
}

- (NSInteger)controlGetDistinctId:(id)obj withCompareObj:(id)origin{
    NSMutableArray *controlArray = [NSMutableArray array];
    NSMutableArray *elementArray = [NSMutableArray array];
    
        [elementArray addObjectsFromArray:[obj subviews]];
    
    for (int i = 0; i<elementArray.count ; i++) {
        id control = elementArray[i];
        if ([control isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)control;
            NSNumber *x = [NSNumber numberWithDouble:label.frame.origin.x];
            NSNumber *y = [NSNumber numberWithDouble:label.frame.origin.y];
            NSNumber *width = [NSNumber numberWithDouble:label.frame.size.width];
            NSNumber *height = [NSNumber numberWithDouble:label.frame.size.height];
            [controlArray addObject:@{
                                      @"x":x,
                                      @"y":y,
                                      @"width":width,
                                      @"height":height,
                                      }];
        }else if ([control isKindOfClass:[UIButton class]]){
            UIButton *button = (UIButton *)control;
            NSNumber *x = [NSNumber numberWithDouble:button.frame.origin.x];
            NSNumber *y = [NSNumber numberWithDouble:button.frame.origin.y];
            NSNumber *width = [NSNumber numberWithDouble:button.frame.size.width];
            NSNumber *height = [NSNumber numberWithDouble:button.frame.size.height];
            [controlArray addObject:@{
                                      @"x":x,
                                      @"y":y,
                                      @"width":width,
                                      @"height":height,
                                      }];
            
        }else if ([control isKindOfClass:[UIView class]]){
            UIView *view = (UIView *)control;
            NSNumber *x = [NSNumber numberWithDouble:view.frame.origin.x];
            NSNumber *y = [NSNumber numberWithDouble:view.frame.origin.y];
            NSNumber *width = [NSNumber numberWithDouble:view.frame.size.width];
            NSNumber *height = [NSNumber numberWithDouble:view.frame.size.height];
            [controlArray addObject:@{
                                      @"x":x,
                                      @"y":y,
                                      @"width":width,
                                      @"height":height,
                                      }];
            
        }else if ([control isKindOfClass:[UITextField class]]){
            UITextField *textField = (UITextField *)control;
            NSNumber *x = [NSNumber numberWithDouble:textField.frame.origin.x];
            NSNumber *y = [NSNumber numberWithDouble:textField.frame.origin.y];
            NSNumber *width = [NSNumber numberWithDouble:textField.frame.size.width];
            NSNumber *height = [NSNumber numberWithDouble:textField.frame.size.height];
            [controlArray addObject:@{
                                      @"x":x,
                                      @"y":y,
                                      @"width":width,
                                      @"height":height,
                                      }];
            
        }
    }
    
    NSInteger index = [elementArray indexOfObject:origin];
    NSInteger order = 0;
    for (int i = 0; i<elementArray.count; i++) {
        if (i == index) {//排序顺序x,y,width,height
            continue;
        }
        if ([controlArray[i][@"x"] doubleValue] < [controlArray[index][@"x"] doubleValue]) {
            order ++;
        }
        else if ([controlArray[i][@"x"] doubleValue] > [controlArray[index][@"x"] doubleValue]){
            continue;
        }
        else{
            if ([controlArray[i][@"y"] doubleValue] < [controlArray[index][@"y"] doubleValue]) {
                order ++;
            }
            else if ([controlArray[i][@"y"] doubleValue] > [controlArray[index][@"y"] doubleValue]){
                continue;
            }else{
                if ([controlArray[i][@"width"] doubleValue] < [controlArray[index][@"width"] doubleValue]) {
                    order ++;
                }
                else if ([controlArray[i][@"width"] doubleValue] > [controlArray[index][@"width"] doubleValue]){
                    continue;
                }
                else{
                    if ([controlArray[i][@"height"] doubleValue] < [controlArray[index][@"height"] doubleValue]) {
                        order ++;
                    }else if ([controlArray[i][@"height"] doubleValue] >[controlArray[index][@"height"] doubleValue]){
                        continue;
                    }
                }
            }
        }
    }
    return order;
}

- (void)buttonInvoke:(UIButton *)sender{
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)sender;

        NSString *name = button.titleLabel.text;
        
        if (name == nil) {
            name = @"";
        }
        [[Lotuseed sharedInstance] track:@"UIButton" properties:@{
                                                                  @"Button":name,
                                                                  @"path":[Lotuseed getControlPath:sender]
                                                                  }];
    }
}

- (void)textFieldInvoke:(UITextField *)sender{
    if ([Lotuseed sharedInstance] == nil) {
        NSLog(@"单例为空");
    }
    if ((UITextField *)sender == nil) {
        NSLog(@"textField为nil");
    }
    UITextField *myTextField = (UITextField *)sender;
    
    [[Lotuseed sharedInstance] track:@"UITextField" properties:@{
                                                                @"placeholder":myTextField.placeholder,
                                                                @"textFieldLabel":myTextField.text,
                                                                @"path":[Lotuseed getControlPath:sender]
                                                                }];
}

- (void)severalGetobj:(NSObject *)obj{
    NSArray *array = [NSArray array];
    array = [self getChildObj:obj];

    if (array.count) {
        for (int i = 0; i<array.count; i++) {
            [self severalGetobj:array[i]];
        }
    }
}

- (NSArray *)getChildObj:(NSObject *)obj{
    
    NSMutableArray *children = [NSMutableArray array];
    if ([obj isKindOfClass:[UIViewController class]]) {
        UIViewController *viewController = (UIViewController *)obj;
        if ([viewController childViewControllers])
        {
            [children addObjectsFromArray:[viewController childViewControllers]];
        }
        if (viewController.presentedViewController)
        {
            [children addObject:viewController.presentedViewController];
        }
        if (viewController.isViewLoaded)
        {
            [children addObject:viewController.view];
        }
    }
    else if ([obj isKindOfClass:[UICollectionView class]]){
        [Lotuseed sharedInstance].collectionView = (UICollectionView *)obj;
    }
    else if ([obj isKindOfClass:[UITableView class]])
    {
        [Lotuseed sharedInstance].tableView = (UITableView *)obj;
    }
    else if ([obj isKindOfClass:[UIButton class]]){
        [(UIButton *)obj addTarget:self action:@selector(buttonInvoke:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else if ([obj isKindOfClass:[UITextField class]]){
        [(UITextField *)obj addTarget:self action:@selector(textFieldInvoke:) forControlEvents:UIControlEventEditingDidEnd];
    }
    else if ([obj isKindOfClass:[UIView class]]){
        [children addObjectsFromArray:[(UIView *)obj subviews]];
    }
    return children;
}

//初始化
static Lotuseed *sharedInstance = nil;

- (instancetype)initWithToken:(NSString *)apiToken launchOptions:(NSDictionary *)launchOptions{
    if (apiToken == nil) {
        apiToken = @"";
    }
    if ([apiToken length] == 0) {
        NSLog(@"%@ warning empty apiToken",self);
    }
    if (self = [self init]) {
        self.apiToken = apiToken;
//        self.serialQueue = dispatch_queue_create([label UTF8String], DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

+ (Lotuseed *)sharedInstance{
    if (sharedInstance == nil) {
        NSLog(@"warning sharedInstance called before sharedInstanceWithToken:");
    }
    return sharedInstance;
}

- (instancetype)initWithToken:(NSString *)apiToken{
    return [self initWithToken:apiToken launchOptions:nil];
}

+ (Lotuseed *)sharedInstanceWithToken:(NSString *)apiToken{
    return [Lotuseed sharedInstanceWithToken:apiToken launchOptions:nil];
}

+ (Lotuseed *)sharedInstanceWithToken:(NSString *)apiToken launchOptions:(NSDictionary *)launchOptions{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super alloc]initWithToken:apiToken launchOptions:launchOptions];
    });
    NSLog(@"shareInstance successful");
    return sharedInstance;
}

//tracking

+ (void)assertPropertyTypes:(NSDictionary *)properties{
    for (id __unused k in properties) {
        NSAssert([k isKindOfClass:[NSString class]], @"%@ properties keys must be NSString/. got:%@ %@",self,[k class],k);
        
        NSAssert([properties[k] isKindOfClass:[NSString class]] ||
                [properties[k] isKindOfClass:[NSNumber class]] ||
                [properties[k] isKindOfClass:[NSNull class]] ||
                [properties[k] isKindOfClass:[NSArray class]] ||
                [properties[k] isKindOfClass:[NSDictionary class]] ||
                [properties[k] isKindOfClass:[NSDate class]] ||
                 [properties[k] isKindOfClass:[NSURL class]], @"%@ properties value must be NSString,NSNumber,NSNull,NSArray,NSDictionary,NSDate or NSURL.got: %@ %@",self,[properties[k] class],properties[k]);
    }
}

- (void)track:(NSString *)event properties:(NSDictionary *)properties{
    if (event == nil || [event length] == 0) {
        NSLog(@"%@ lotuseed track called with empty event parametr. using 'mp_event'",self);
        event = @"mp_event";
    }
    properties = [properties copy];
    [Lotuseed assertPropertyTypes:properties];
    
    double timeInterval = [[NSDate date] timeIntervalSince1970];
    NSNumber *timeSeconds = @(round(timeInterval));//时间戳取整
//    dispatch_async(self.serialQueue, ^{
        NSMutableDictionary *p = [NSMutableDictionary dictionary];
        p[@"token"] = self.apiToken;
        p[@"time"] = timeSeconds;
        if (properties) {
            [p addEntriesFromDictionary:properties];
        }
        NSDictionary *e = @{
                            @"event":event,
                            @"properties":[NSDictionary dictionaryWithDictionary:p]
                            };
    
    NSLog(@"is tracking :%@",e);
}

@end