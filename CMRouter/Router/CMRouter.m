//
//  CMRouter.m
//  CMRouter
//
//  Created by caiming on 15/11/18.
//  Copyright © 2015年 caiming. All rights reserved.
//

#import "CMRouter.h"
#import <objc/runtime.h>

@implementation CMRouter

#pragma mark - CMRouter_public

+ (instancetype)sharedInstance
{
    static CMRouter *router = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!router) {
            router = [[self alloc] init];
        }
    });
    
    return router;
}

- (UINavigationController *)currentNavigationController
{
    UINavigationController *nvc = [[self class] expectedVisibleNavigationController];
    return nvc;
}

- (void)showViewController:(NSString *)viewControllerName param:(NSDictionary *)param
{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        
        UINavigationController *nvc = [[self class] expectedVisibleNavigationController];
        
        UIViewController *vc = [self getObjectWithClassName:viewControllerName];
        
        if (vc) {
            
            if (nvc) {
                
                [self pushViewController:vc parameters:param atNavigationController:nvc animated:YES];
                
            }else
            {
                [self pressntVController:vc parameters:param animated:YES];
            }
        }
        
    });
}

/**
 *  push or present 一个 viewcontroller
 *
 *  param viewControllerName 将要显示的viewController 的类名
 *  param param   目标 viewController  需要的参数
 */

- (void)showViewControllers:(NSArray<NSString*> *)viewControllerNames params:(NSArray<NSDictionary *>*)params
{
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        
        UINavigationController *nvc = [[self class] expectedVisibleNavigationController];
        NSMutableArray *controllers = nvc.viewControllers.mutableCopy;
        NSInteger i=0;
        for (NSString *viewControllerName in viewControllerNames) {
            
            UIViewController *vc = [self getObjectWithClassName:viewControllerName];
            [vc setHidesBottomBarWhenPushed:YES];
            NSDictionary *param = [params objectAtIndex:i];
            [self setObject:vc parameters:param];
            [controllers addObject:vc];
            
            i++;
        }
        
        if (controllers.count>0) {
            
            [nvc setViewControllers:controllers animated:YES];
            
        }
    });
    
    
}

/**
 *  push or present 一个 viewcontroller
 *
 *  param RouterModel
 */


- (void)showViewControllerWithRouterModel:(RouterModel*)model
{
    [self showViewController:model.className param:model.param];
}

- (void)presentControllerWithControllerName:(NSString *)viewControllerName param:(NSDictionary *)param
{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        
        UIViewController *vc = [self getObjectWithClassName:viewControllerName];
        
        if (vc) {
            
            [self pressntVController:vc parameters:param animated:YES];
        }
        
    });
    
    
}

/**
 *  present 一个 viewcontroller
 *
 *  param RouterModel
 *
 */


- (void)presentControllerWithRouterModel:(RouterModel*)model
{
    [self presentControllerWithControllerName:model.className param:model.param];
}

- (void)presentController:(UIViewController *)controller param:(NSDictionary *)param
{
    [self pressntVController:controller parameters:param animated:YES];
    
}

//- (void)presentController:(NSString *)viewControllerName param:(NSDictionary *)param
//{
//    UIViewController *vc = [self getObjectWithClassName:viewControllerName];
//
//    if (vc) {
//
//        [self pressntVController:vc parameters:param animated:YES];
//    }
//
//}


/**
 *  返回到当前导航的 类名为(viewControllerName )的 ViewController
 从栈顶开始查找，
 *
 *  @param viewControllerName 返回到ViewController类名
 *  @param param              该ViewController callBack参数
 */
- (BOOL)backToViewController:(NSString *)viewControllerName param:(NSDictionary *)param
{
    return  [self backToViewController:viewControllerName param:param animation:YES];
}

/**
 *  返回到当前导航的 类名为(viewControllerName )的 ViewController
 从栈顶开始查找，
 *
 *  @param viewControllerName 返回到ViewController类名
 *  @param param              该ViewController callBack参数
 */


- (BOOL)backToViewController:(NSString *)viewControllerName param:(NSDictionary *)param animation:(BOOL)animation
{
    __block UIViewController *targetVC;
    
    UINavigationController *nvc = self.currentNavigationController;
    if (nvc&&nvc.viewControllers.count>1) {
        
        
        for (NSInteger i = nvc.viewControllers.count-2; i>=0; i--)
        {
            UIViewController *vc = [nvc.viewControllers objectAtIndex:i];
            if (vc) {
                
                NSString *className = NSStringFromClass([vc class]);
                
                if ([className isEqualToString:viewControllerName])
                {
                    targetVC = vc;
                    
                    break;
                    
                }
                
            }
            
        }
        
        if (targetVC)
        {
            [self setObject:targetVC parameters:param];
            [nvc popToViewController:targetVC animated:animation];
            
            
        }else
        {
            
            //                [NSException raise:@"not found target vc" format:@"className [%@]",viewControllerName];
            
        }
        
    }else
    {
        
    }
    return targetVC != nil;;
    
}

- (id)getObjectWithClassName:(NSString *)className
{
    UIViewController *vc = nil;
    if (className) {
        
        vc = [NSClassFromString(className) new];
    }
    return vc;
}

- (void)setRootControllerWithClassName:(NSString *)className
{
    UIViewController *vc = [self getObjectWithClassName:className];
    if (vc) {
        
        self.rootViewController = vc;
    }else
    {
        //        [NSException raise:@"The name of the class does not exist" format:@"class name [%@]",className];
    }
}

- (void)popViewController
{
    UIViewController *currentController = [self currentController];
    if (currentController.presentingViewController) {
        
        [currentController dismissViewControllerAnimated:YES completion:nil];
        
    }else
    {
        [currentController.navigationController popViewControllerAnimated:YES];
    }
    
}

/**
 *  返回上一级页面 pop or dismisse
 */

- (void)popViewControllerWithAnimation:(BOOL)anmation
{
    UIViewController *currentController = [self currentController];
    if (currentController.presentingViewController) {
        
        [currentController dismissViewControllerAnimated:anmation completion:nil];
        
    }else
    {
        [currentController.navigationController popViewControllerAnimated:anmation];
    }
    
}

/**
 *  返回上一级页面 pop or dismisse
 */

- (void)popViewControllerWithParam:(NSDictionary *)param
{
    
    
    UINavigationController *nvc = self.currentNavigationController;
    if (nvc.viewControllers.count>1&&param)
    {
        UIViewController *targetVC = [nvc.viewControllers objectAtIndex:nvc.viewControllers.count-2];
        if (targetVC) {
            [self setObject:targetVC parameters:param];
        }
    }
    [self popViewController];
    
}

/**
 *  移除多个controller  count viewcontroller 的数量
 */

- (void)removeViewController:(NSInteger)count
{
    UIViewController *currentController = [self currentController];
    if (currentController.presentingViewController) {
        
        [currentController dismissViewControllerAnimated:YES completion:nil];
        
    }else
    {
        if (count<currentController.navigationController.viewControllers.count)
        {
            
            NSInteger index = currentController.navigationController.viewControllers.count - count-1;
            UIViewController *vc = currentController.navigationController.viewControllers[index];
            [currentController.navigationController popToViewController:vc animated:YES];
            
        }else
        {
            [currentController.navigationController popToRootViewControllerAnimated:YES];
            
        }
        
    }
}


- (void)removeControllers:(NSInteger)count
{
    
    UINavigationController *nvc = [self currentNavigationController];
    if ([nvc isKindOfClass:[UINavigationController class]])
    {
        if (nvc.viewControllers.count>count)
        {
            NSMutableArray *array = nvc.viewControllers.mutableCopy;
            [array removeObjectsInRange:NSMakeRange(nvc.viewControllers.count-count, count)];
            nvc.viewControllers = array.copy;
        }
    }
    
}


/**
 *  返回到根视图控制器
 */
- (void)popToRootViewController
{
    UIViewController *currentController = [self currentController];
    if (currentController.presentingViewController) {
        
        [currentController dismissViewControllerAnimated:YES completion:nil];
        
    }else
    {
        [currentController.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (UIViewController *)currentController
{
    return  [[self class] visibleViewControllerWithRootViewController:self.rootViewController];
}


#pragma mark - CMRouter_private

- (void)pushViewController:(UIViewController *)viewController parameters:(NSDictionary *)parameters atNavigationController:(UINavigationController *)navigationController animated:(BOOL)animated
{
    if (viewController == nil || [viewController isKindOfClass:[UINavigationController class]] || navigationController == nil) return;
    
    [self setObject:viewController parameters:parameters];
    
    [viewController setHidesBottomBarWhenPushed:YES];
    [navigationController pushViewController:viewController animated:animated];
    
}

- (void)pressntVController:(UIViewController *)vc parameters:(NSDictionary *)parameters animated:(BOOL)animated
{
    if (vc == nil) return;
    
    [self setObject:vc parameters:parameters];
    
    UIViewController *vc1 = [[self class]visibleViewControllerWithRootViewController:[[self class]visibleViewController]];
    
    [vc1 presentViewController:vc animated:animated completion:^{
        
    }];
}

- (void)setObject:(UIViewController*)viewController parameters:(NSDictionary *)parameters
{
    if (viewController == nil || [viewController isKindOfClass:[UINavigationController class]]) return;
    
    NSArray *properties = [self getAllPropertiesWithObject:viewController.class];
    
    NSArray *superClassProperties = [self getAllPropertiesWithObject:viewController.superclass];
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            // todo 安全性检查 需要完善
            
            if ([superClassProperties containsObject:key])
            {
                [viewController setValue:obj forKey:key];
            }
            
            if ([properties containsObject:key]) {
                
                [viewController setValue:obj forKey:key];
            }
            
        }];
    }
    
}

- (NSArray *)getAllPropertiesWithObject:(Class)class
{
    u_int count;
    objc_property_t *properties  =class_copyPropertyList(class, &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertiesArray;
}


+ (UINavigationController *)expectedVisibleNavigationController
{
    UIViewController *vc = [self visibleViewControllerWithRootViewController:[UIApplication sharedApplication].delegate.window.rootViewController];
    
    UINavigationController *nvc = (UINavigationController *)([vc isKindOfClass:[UINavigationController class]] ? vc : vc.navigationController);
    
    return nvc;
}

+ (UIViewController *)visibleViewController
{
    UIViewController *vc = [self visibleViewControllerWithRootViewController:[UIApplication sharedApplication].delegate.window.rootViewController];
    return vc;
}


+ (UIViewController*)visibleViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    NSLog(@"%@",rootViewController);
    if ([rootViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tbc = (UITabBarController*)rootViewController;
        return [self visibleViewControllerWithRootViewController:tbc.selectedViewController];
    }
    else if ([rootViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nvc = (UINavigationController*)rootViewController;
        return [self visibleViewControllerWithRootViewController:nvc.viewControllers.lastObject];
    }
    else if (rootViewController.presentedViewController)
    {
        UIViewController *presentedVC = rootViewController.presentedViewController;
        if ([presentedVC isKindOfClass:[UIAlertController class]]) {
            return rootViewController;
        }
        return [self visibleViewControllerWithRootViewController:presentedVC];
    }
    else
    {
        return rootViewController;
    }
}

#pragma mark - getter / setter
- (void)setRootViewController:(UIViewController *)rootViewController
{
    [UIApplication sharedApplication].delegate.window.rootViewController = rootViewController;
    [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
}

- (UIViewController *)rootViewController
{
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}

@end


@implementation RouterModel



@end
