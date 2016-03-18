//
//  Lotuseed.m
//  quancaiji
//
//  Created by 杨 on 16/2/22.
//  Copyright © 2016年 杨. All rights reserved.
//

#import "Lotuseed.h"
#import <objc/runtime.h>
#import "ViewController.h"

#define VERSION @"1.0.0"

@implementation Lotuseed
{
    UITabBar *tabbar;
    NSArray *itemArray;//UITabBarItem数组，含有UITabBarButton的信息
    NSInteger num ;//tabBarItem
}

- (instancetype)init{
    if (self = [super init]) {
        _addTargetArray = [NSMutableArray array];
        _tabBarButtonArray = [NSMutableArray array];
        _viewArray = [NSMutableArray array];
    }
    return self;
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
    if ([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)controller;
        controller = nav.visibleViewController;
        [Lotuseed sharedInstance].hasNavigation = YES;
        
    }
    else if ([controller isKindOfClass:[UITabBarController class]]){
        UITabBarController *tbVC = (UITabBarController *)controller;
        controller = tbVC.childViewControllerForStatusBarHidden;
        if ([controller isKindOfClass:[UINavigationController class]]) {
            UINavigationController *n = (UINavigationController *)controller;
            controller = n.visibleViewController;
        }
        }
    
    if (controller != [Lotuseed sharedInstance].lastVC) {
        
        [Lotuseed sharedInstance].lastVC = controller;
        
        [Lotuseed invokeLotuseed:controller];
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
    if ([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)controller;
        controller = nav.visibleViewController;
        [Lotuseed sharedInstance].hasNavigation = YES;
    }
    else if ([controller isKindOfClass:[UITabBarController class]]){
        UITabBarController *tbVC = (UITabBarController *)controller;
        
        [Lotuseed invokeLotuseed:controller];
        
        controller = tbVC.childViewControllerForStatusBarHidden;
        return;
    }
    
    [Lotuseed sharedInstance].lastVC = controller;
    [Lotuseed sharedInstance].firstVC = controller;
    
    [Lotuseed invokeLotuseed:controller];
}

+ (void)invokeLotuseed:(id)controller{
    
    if ([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController *n = (UINavigationController *)controller;
        controller = n.visibleViewController;
        
    }
    Lotuseed *lotuseed = [Lotuseed new];
    
    [lotuseed severalGetobj:controller];
    if (([Lotuseed sharedInstance].tableView || [Lotuseed
                                                 sharedInstance].collectionView) != 1)
    {
        [lotuseed severalGetChild:controller];
    }
    else{
        [lotuseed gainTableViewAndIndexPath:controller];
    }
    
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *navigationController;
    
    if ([root isKindOfClass:[UINavigationController class]]) {
        navigationController = (UINavigationController *)root;
    }
    else if ([root isKindOfClass:[UITabBarController class]]){
        UITabBarController *tbVC = (UITabBarController *)root;
        NSLog(@"%@",tbVC.childViewControllers);
//        navigationController = tbVC.childViewControllers[0];
        for (int i = 0; i<[tbVC.childViewControllers count]; i++) {
            navigationController = tbVC.childViewControllers[i];
            NSLog(@"%@",navigationController.visibleViewController);
            NSLog(@"%@",controller);
            if (navigationController.visibleViewController == controller) {
                break;
            }
        }
    }
    UINavigationBar *bar = navigationController.navigationBar;
    for (int i = 0; i<[bar.items count]; i++) {
        [[Lotuseed sharedInstance] buttonInvoke:bar.items[i]];
    }
//    NSLog(@"%@",bar.items);
//    for (int i = 0; i < [[bar subviews] count]; i++) {
//        id barSubViews = [bar subviews][i];
//        if ([NSStringFromClass([barSubViews class]) isEqualToString:@"UINavigationButton"]) {
//            [[Lotuseed sharedInstance] buttonInvoke:barSubViews];
//        }
//    }
    
}

+ (void)initialize{
    BOOL backgroundSupported = [Lotuseed isMulitaskingSupported];
    if (backgroundSupported) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addSelector) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewControllerChanged:) name:UITouchPhaseBegan object:nil];
    }
    
    
}

//获取以property存在array里的indexPath;
- (NSArray *)getAllProperties:(id)something{//获取对象的所有属性，不包括属性值
    u_int count;
    objc_property_t *properties = class_copyPropertyList([something class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        const char *propertyName = property_getName(properties[i]);
        [propertiesArray addObject:[NSString stringWithUTF8String:propertyName]];
    }
    
    free(properties);
    return propertiesArray;
}

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
    UITabBarController *TBC = (UITabBarController *)something;
    
    if ([something isKindOfClass:[UITabBarController class]]) {
        something = TBC.childViewControllerForStatusBarHidden;
    }
    if ([something isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)something;
        something = nav.visibleViewController;
    }
    Lotuseed *lotuseed = [Lotuseed new];
    
    NSDictionary *dic = [lotuseed properties_aps:something];
    for (id obj in dic)
    {
        if ([NSStringFromClass([dic[obj] class]) isEqualToString:@"__NSArrayM"] || [NSStringFromClass([dic[obj] class]) isEqualToString:@"__NSArrayI"])
        {
            NSArray *array = dic[obj];
            if (array.count) {
                if ([array[0] class] == [NSIndexPath class])
                {
                    NSLog(@"found NSIndexPath");
                    NSLog(@"%@",array);
                    
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
        for (NSObject *child in [(UIView *)obj subviews])
        {
                [children addObject:child];
        }
    }
    else if ([obj isKindOfClass:[UIViewController class]]){//UIViewController
        UIViewController *viewController = (UIViewController *)obj;
        for (NSObject *child in [viewController childViewControllers])
        {
                [children addObject:child];
        }
        if (viewController.presentedViewController) {
            [children addObject:viewController.presentedViewController];
        }
        
            [children addObject:viewController.view];
    }
//    NSArray *result;
//    if ([class isSubclassOfClass:[UITableViewCell class]]) {
//        result = [children sortedArrayUsingComparator:^NSComparisonResult(UIView *obj1, UIView *obj2) {
//            if (obj2.frame.origin.y > obj1.frame.origin.y) {
//                return NSOrderedAscending;
//            }
//            else if (obj2.frame.origin.y < obj1.frame.origin.y){
//                return NSOrderedDescending;
//            }
//            return NSOrderedSame;
//        }];
//    }else{
//        result = [children copy];
//    }
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

- (void)getChildOfCell:(NSObject *)obj{
    
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
    if ([Lotuseed sharedInstance].tableView) {
        for (int i = 0; i<indexArray.count; i++) {
            id myCell = [[Lotuseed sharedInstance].tableView cellForRowAtIndexPath:indexArray[i]];
            
            [self getChildOfCell:myCell];
        }
    }
    else if ([Lotuseed sharedInstance].collectionView){
        for (int i = 0; i<indexArray.count; i++) {
            id myCell = [[Lotuseed sharedInstance].collectionView cellForItemAtIndexPath:indexArray[i]];
            
            [self getChildOfCell:myCell];
        }
    }

    for (id obj in self.viewArray) {
    
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel *label = obj;
            NSString *name = label.text;
            
            NSLog(@"label:%@",name);
        }
        
        else if ([obj isKindOfClass:[UIImageView class]])
        {
            UIImageView *imageView = obj;
            UIImage *image = imageView.image;
            CGRect imageRect = imageView.frame;
            
            NSLog(@"find imageView:%@",imageView);
        }
        
        else if ([obj isKindOfClass:[UITextField class]])
        {
            UITextField *textField = obj;
            CGRect textFieldRect = textField.frame;
            NSString *text = textField.text;
            
            NSLog(@"find textField:%@,%@",textField,text);
        }
    }
    
}


//添加监控

- (void)SegmentControlInvoke{
    if ([Lotuseed sharedInstance] == nil) {
        NSLog(@"单例为空");
    }
    NSLog(@"touch seg");
}

- (void)tabBarButtonInvoke:(id)sender{
    if ([Lotuseed sharedInstance] == nil) {
        NSLog(@"单例为空");
    }
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UITabBarController *tabBarC = (UITabBarController *)window.rootViewController;
    NSUInteger n = tabBarC.selectedIndex;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[Lotuseed sharedInstance].tabBarButtonArray[n]];
    NSDictionary *dic1 = @{
                   @"path":[Lotuseed getControlPath:sender]
                   };
    
    [dic addEntriesFromDictionary:dic1];
    
    [[Lotuseed new] track:@"UITabBarButton" properties:dic];
}

+ (NSString *)getControlPath:(id)sender{
    NSLog(@"%@",[Lotuseed sharedInstance].firstVC);
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
                UIButton *button = (UIButton *)passSender;
                beforeStr = [NSString stringWithFormat:@"%@(%@)",[passSender class],button.titleLabel.text];
            }
            else{
                beforeStr = NSStringFromClass([passSender class]);
            }
            senderPath = [NSString stringWithFormat:@"%@-%@",beforeStr,[passSender superview].class];
            passSender = [passSender superview];
        }else{
            senderPath = [NSString stringWithFormat:@"%@-%@",senderPath,[passSender superview].class];
            passSender = [passSender superview];
        }
    }
    senderPath = [NSString stringWithFormat:@"%@-%@",senderPath,[[Lotuseed sharedInstance].firstVC class]];
    return senderPath;
}

- (void)buttonInvoke:(UIButton *)sender{
    NSLog(@"%@",sender.class);
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)sender;
        
        //    NSString *title = [button titleForState:UIControlStateNormal];
        //    NSLog(@"title:%@",title);
        NSString *name = button.titleLabel.text;
        
        
        if (name == nil) {
            name = @"";
        }
        NSString *rect = [NSString stringWithFormat:@"%d,%d,%d,%d",(int)button.frame.origin.x,(int)button.frame.origin.y,(int)button.frame.size.width,(int)button.frame.size.height];
        [[Lotuseed sharedInstance] track:@"UIButton" properties:@{
                                                                  @"ButtonName":name,
                                                                  @"ButtonInClass":@"UIButton",
                                                                  @"path":[Lotuseed getControlPath:sender],
                                                                  @"rect":rect
                                                                  }];

    }else if ([NSStringFromClass([sender class]) isEqualToString:@"UIBarButtonItem"]){
        UIBarButtonItem *barButtonItem = (UIBarButtonItem *)sender;
        NSString *name = barButtonItem.title;
        [[Lotuseed sharedInstance] track:@"UIBarButtonItem" properties:@{
                                                                        @"ButtonName":name,
                                                                        @"ButtonInClass":@"UIBarButtonItem",
//                                                                        @"path":[Lotuseed getControlPath:sender]
                                                                         }];
    }else if ([NSStringFromClass([sender class]) isEqualToString:@"UINavigationItem"]){
        UINavigationItem *item = (UINavigationItem *)sender;
        NSString *name = item.title;
        if (name == nil) {
            name = @"";
        }
        [[Lotuseed sharedInstance] track:@"UINavigationItem" properties:@{
                                                                         @"ButtonName":name,
                                                                         @"ButtonInClass":@"UINavigationItem",
                                                                         //                                                                        @"path":[Lotuseed getControlPath:sender]
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
    NSString *rect = [NSString stringWithFormat:@"%d,%d,%d,%d",(int)myTextField.frame.origin.x,(int)myTextField.frame.origin.y,(int)myTextField.frame.size.width,(int)myTextField.frame.size.height];
    
    [[Lotuseed sharedInstance] track:@"UITextField" properties:@{
                                                                @"TextFieldClass":NSStringFromClass([myTextField class]),
                                                                @"placeholder":myTextField.placeholder,
                                                                @"rect":rect,
                                                                @"textFieldLabel":myTextField.text,
                                                                @"path":[Lotuseed getControlPath:sender]
                                                                }];
}

- (void)severalGetobj:(NSObject *)obj{
    NSArray *array = [NSArray array];
    array = [self getChildObj:obj];
    if (array.count != 0) {
        [_addTargetArray addObjectsFromArray:array];
    }
    if (array.count) {
        for (int i = 0; i<array.count; i++) {
            [self severalGetobj:array[i]];
        }
    }
}

- (NSArray *)getChildObj:(NSObject *)obj{
    if ([obj isKindOfClass:[UITabBar class]]){
        tabbar = (UITabBar *)obj;
        itemArray = tabbar.items;
    }
    
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
//    else if ([obj isKindOfClass:NSClassFromString(@"UISegment")]){
//        UISegmentedControl *seg = (UISegmentedControl *)obj;
//        [seg addTarget:seg action:@selector(SegmentControlInvoke) forControlEvents:UIControlEventTouchUpInside];
//    }
    else if ([obj isKindOfClass:[UIToolbar class]]){
        UIToolbar *toolBar = (UIToolbar *)obj;
        for (int i = 0; i<[toolBar.items count]; i++) {
            NSLog(@"%d,%@",i,toolBar.items[i]);
            UIBarItem *item = toolBar.items[i];
        }
    }
    else if ([obj isKindOfClass:[UISegmentedControl class]]){
        UISegmentedControl *s = (UISegmentedControl *)obj;
        [s addTarget:self action:@selector(SegmentControlInvoke) forControlEvents:UIControlEventValueChanged];
    }
    else if ([NSStringFromClass([obj class]) isEqualToString:@"UITabBarButton"]){
        UIButton *button = (UIButton *)obj;
        
        UITabBarItem *item = itemArray[num];
        NSString *name = item.title;
        NSString *class = @"UITabBarButton";
        
        num++;
        
        if (name == nil) {
            name = @"";
        }
        
        [[Lotuseed sharedInstance].tabBarButtonArray addObject:@{
                                                                 @"ButtonName":name,
                                                                 @"ButtonInClass":class,
                                                                 }];
        
        [button addTarget:[Lotuseed sharedInstance] action:@selector(tabBarButtonInvoke:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    else if ([obj isKindOfClass:[UIButton class]]){
        if ([NSStringFromClass([obj class])isEqualToString:@"UINavigationButton"] ) {
            return children;
        }
        [(UIButton *)obj addTarget:[Lotuseed sharedInstance]  action:@selector(buttonInvoke:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else if ([obj isKindOfClass:[UITextField class]]){
        [(UITextField *)obj addTarget:[Lotuseed sharedInstance] action:@selector(textFieldInvoke:) forControlEvents:UIControlEventEditingDidEnd];
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
        NSString *label = [NSString stringWithFormat:@"com.lotuseed.%@.%p",apiToken,self];
        self.serialQueue = dispatch_queue_create([label UTF8String], DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

+ (Lotuseed *)sharedInstance{
    if (sharedInstance == nil) {
        [self new];
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
        [self.eventQueue addObject:e];
    
    NSLog(@"is tracking :%@",e);
}

@end