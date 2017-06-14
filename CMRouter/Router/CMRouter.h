//
//  CMRouter.h
//  CMRouter
//
//  Created by caiming on 15/11/18.
//  Copyright © 2015年 caiming. All rights reserved.
//

//bug: Snapshotting a view that has not been rendered results in an empty snapshot. Ensure your view has been rendered at least once before snapshotting or snapshot after screen updates

//clean build/kakatrip.build/Debug-iphonesimulator/Dev.build
//infer -- xcodebuild -workspace kakatrip.xcworkspace -scheme Dev

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface RouterModel : NSObject

//viewControllerName 将要显示的viewController 的类名
@property(nonatomic,copy)NSString *className;
//目标 viewController  需要的参数
@property(nonatomic,copy)NSDictionary *param;

@end

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
 *  push or present 一个 viewcontroller
 *
 *  @param viewControllerNames 将要显示的viewController 的类名
 *  @param params   目标 viewController  需要的参数
 */

- (void)showViewControllers:(NSArray<NSString*> *)viewControllerNames params:(NSArray<NSDictionary *>*)params;


/**
 *  push or present 一个 viewcontroller
 *
 *  param model
 */


- (void)showViewControllerWithRouterModel:(RouterModel*)model;


/**
 *  present 一个 viewcontroller
 *
 *  @param viewControllerName 将要显示的viewController 的类名
 *  @param param   目标 viewController  需要的参数
 */


- (void)presentControllerWithControllerName:(NSString *)viewControllerName param:(NSDictionary *)param;


/**
 *  present 一个 viewcontroller
 *
 *  param RouterModel
 *
 */


- (void)presentControllerWithRouterModel:(RouterModel*)model;

/**
 *  present 一个 viewcontroller
 *
 *  param  将要显示的viewController
 *  @param param   目标 viewController  需要的参数
 */

- (void)presentController:(UIViewController *)controller param:(NSDictionary *)param;


/**
 *  返回到当前导航的 类名为(viewControllerName )的 ViewController
 从栈顶开始查找，
 *
 *  @param viewControllerName 返回到ViewController类名
 *  @param param              该ViewController callBack参数
 */


- (BOOL)backToViewController:(NSString *)viewControllerName param:(NSDictionary *)param;


/**
 *  返回到当前导航的 类名为(viewControllerName )的 ViewController
 从栈顶开始查找，
 *
 *  @param viewControllerName 返回到ViewController类名
 *  @param param              该ViewController callBack参数
 */


- (BOOL)backToViewController:(NSString *)viewControllerName param:(NSDictionary *)param animation:(BOOL)animation;



/**
 *  根据className 创建一个对象
 *
 *  parame：className
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

/**
 *  返回上一级页面 pop or dismisse
 */

- (void)popViewControllerWithAnimation:(BOOL)anmation;

/**
 *  返回上一级页面 pop or dismisse
 */

- (void)popViewControllerWithParam:(NSDictionary *)param;


/**
 *  移除多个controller  count viewcontroller 的数量
 */

- (void)removeViewController:(NSInteger)count;

/**
 *  返回到根视图控制器
 */
- (void)popToRootViewController;

- (void)removeControllers:(NSInteger)count;

- (void)setObject:(UIViewController*)viewController parameters:(NSDictionary *)parameters;

@end




