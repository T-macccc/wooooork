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
    Lotuseed *myLotuseed;
}

- (instancetype)init{
    if (self = [super init]) {
        _addTargetArray = [NSMutableArray array];
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
    
    Lotuseed *lotuseed = [Lotuseed new];
    
    [lotuseed severalGetobj:controller];
    
    if (([Lotuseed sharedInstance].tableView || [Lotuseed
                                                 sharedInstance].collectionView) != 1)
    {
        [lotuseed severalGetChild:controller];
    }
    else
    {
        [self addObserver:[Lotuseed sharedInstance] forKeyPath:@"lastVC" options:0 context:NULL];
//        [lotuseed gainTableViewAndIndexPath:controller];
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
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)sender;

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