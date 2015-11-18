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

/**
 *  根据className 创建一个对象
 *
 *  @param className
 *
 *  @return 根据className 创建一个对象
 */

- (id)getObjectWithClassName:(NSString *)className;


@end