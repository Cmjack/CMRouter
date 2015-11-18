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
    UINavigationController *nvc = [[self class] __expectedVisibleNavigationController];
    return nvc;
}

- (void)showViewController:(NSString *)viewControllerName param:(NSDictionary *)param
{
    UINavigationController *nvc = [[self class] __expectedVisibleNavigationController];
    
    UIViewController *vc = [self getObjectWithClassName:viewControllerName];
    
    if (vc) {
        
        if (nvc) {
            
            [self __pushViewController:vc parameters:param atNavigationController:nvc animated:YES];
            
        }else
        {
            [self __pressntVController:vc parameters:param animated:YES];
        }
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
    
}



#pragma mark - CMRouter_private

- (void)__pushViewController:(UIViewController *)viewController parameters:(NSDictionary *)parameters atNavigationController:(UINavigationController *)navigationController animated:(BOOL)animated
{
    if (viewController == nil || [viewController isKindOfClass:[UINavigationController class]] || navigationController == nil) return;
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        // todo 安全性检查
        [viewController setValue:obj forKey:key];
    }];
    [viewController setHidesBottomBarWhenPushed:YES];
    [navigationController pushViewController:viewController animated:animated];
}

- (void)__pressntVController:(UIViewController *)vc parameters:(NSDictionary *)parameters animated:(BOOL)animated
{
    if (vc == nil || [vc isKindOfClass:[UINavigationController class]]) return;
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        // todo 安全性检查
        [vc setValue:obj forKey:key];
    }];
    
    UIViewController *vc1 = [[self class]__visibleViewControllerWithRootViewController:[[self class]__visibleViewController]];
    
    [vc1 presentViewController:vc animated:YES completion:^{
        
    }];
}


+ (UINavigationController *)__expectedVisibleNavigationController
{
    UIViewController *vc = [self __visibleViewControllerWithRootViewController:[UIApplication sharedApplication].delegate.window.rootViewController];
    
    UINavigationController *nvc = (UINavigationController *)([vc isKindOfClass:[UINavigationController class]] ? vc : vc.navigationController);
    
    return nvc;
}

+ (UIViewController *)__visibleViewController
{
    UIViewController *vc = [self __visibleViewControllerWithRootViewController:[UIApplication sharedApplication].delegate.window.rootViewController];
    return vc;
}


+ (UIViewController*)__visibleViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tbc = (UITabBarController*)rootViewController;
        return [self __visibleViewControllerWithRootViewController:tbc.selectedViewController];
    }
    else if ([rootViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nvc = (UINavigationController*)rootViewController;
        return [self __visibleViewControllerWithRootViewController:nvc.visibleViewController];
    }
    else if (rootViewController.presentedViewController)
    {
        UIViewController *presentedVC = rootViewController.presentedViewController;
        return [self __visibleViewControllerWithRootViewController:presentedVC];
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
