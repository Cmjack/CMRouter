//
//  CMRouter.m
//  CMRouter
//
//  Created by caiming on 15/11/18.
//  Copyright © 2015年 caiming. All rights reserved.
//

#import "CMRouter.h"

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
    
}

- (void)presentController:(NSString *)viewControllerName param:(NSDictionary *)param
{
    UIViewController *vc = [self getObjectWithClassName:viewControllerName];
    
    if (vc) {
        
        [self pressntVController:vc parameters:param animated:YES];
    }

}


/**
 *  返回到当前导航的 类名为(viewControllerName )的 ViewController
 从栈顶开始查找，
 *
 *  @param viewControllerName 返回到ViewController类名
 *  @param param              该ViewController callBack参数
 */
- (void)backToViewController:(NSString *)viewControllerName param:(NSDictionary *)param
{
    UINavigationController *nvc = self.currentNavigationController;
    if (nvc&&nvc.viewControllers.count>1) {
        
        UIViewController *targetVC;
        
        for (NSInteger i = nvc.viewControllers.count-2; i>=0; i--)
        {
            UIViewController *vc = [nvc.viewControllers objectAtIndex:i];
            NSString *className = NSStringFromClass([vc class]);
            
            if ([className isEqualToString:viewControllerName])
            {
                targetVC = vc;
                
                break;

            }
            
        }
        
        if (targetVC)
        {
            [self setObject:targetVC parameters:param];
            [nvc popToViewController:targetVC animated:YES];
            
        }else
        {
            
            [NSException raise:@"not found target vc" format:@"className [%@]",viewControllerName];
            
        }
        
        
        
        
    }else
    {
//        [NSException raise:@"not found target vc" format:@"className [%@]",viewControllerName];
        
        UIViewController *currentController = [self currentController];
        NSLog(@"%@",currentController.presentingViewController);
        

    }
    
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
        [NSException raise:@"The name of the class does not exist" format:@"class name [%@]",className];
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
    if (vc == nil || [vc isKindOfClass:[UINavigationController class]]) return;
    
    [self setObject:vc parameters:parameters];
    
    UIViewController *vc1 = [[self class]visibleViewControllerWithRootViewController:[[self class]visibleViewController]];
    
    [vc1 presentViewController:vc animated:YES completion:^{
        
    }];
}

- (void)setObject:(UIViewController*)viewController parameters:(NSDictionary *)parameters
{
    if (viewController == nil || [viewController isKindOfClass:[UINavigationController class]]) return;
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        // todo 安全性检查 需要完善
        [viewController setValue:obj forKey:key];
    }];
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
    if ([rootViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tbc = (UITabBarController*)rootViewController;
        return [self visibleViewControllerWithRootViewController:tbc.selectedViewController];
    }
    else if ([rootViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nvc = (UINavigationController*)rootViewController;
        return [self visibleViewControllerWithRootViewController:nvc.visibleViewController];
    }
    else if (rootViewController.presentedViewController)
    {
        UIViewController *presentedVC = rootViewController.presentedViewController;
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
