//
//  CMRouter.h
//  CMRouter
//
//  Created by caiming on 15/11/18.
//  Copyright © 2015年 caiming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface CMRouter : NSObject

/**
 *  单例 CMRouter
 *
 *  @return 创建一个对象
 */

+ (instancetype)sharedInstance;

/**
 *    windows.rootViewController get or set
 */
@property (nonatomic, strong) UIViewController *rootViewController;


/**
 *  获取当前NavigationController
 *
 *  @return 获取当前NavigationController
 */
- (UINavigationController *)currentNavigationController;



/**
 *  push or present 一个 viewcontroller
 *
 *  @param viewControllerName 将要显示的viewController 的类名
 *  @param param   目标 viewController  需要的参数
 */

- (void)showViewController:(NSString *)viewControllerName param:(NSDictionary *)param;

- (void)presentController:(NSString *)viewControllerName param:(NSDictionary *)param;

/**
 *  返回到当前导航的 类名为(viewControllerName )的 ViewController
    从栈顶开始查找，
 *
 *  @param viewControllerName 返回到ViewController类名
 *  @param param              该ViewController callBack参数
 */
- (void)backToViewController:(NSString *)viewControllerName param:(NSDictionary *)param;

/**
 *  根据className 创建一个对象
 *
 *  @param className
 *
 *  @return 根据className 创建一个对象
 */

- (id)getObjectWithClassName:(NSString *)className;

/**
 *  设置rootController
 *
 *  @param className 类名
 */
- (void)setRootControllerWithClassName:(NSString *)className;


/**
 *  获取当前展示的controller
 *
 *  @return 获取当前展示的controller
 */
- (UIViewController *)currentController;

/**
 *  返回上一级页面 pop or dismisse
 */

- (void)popViewController;

@end
