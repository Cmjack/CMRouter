//
//  RootTBC.m
//  CMRouter
//
//  Created by caiming on 15/11/18.
//  Copyright © 2015年 caiming. All rights reserved.
//

#import "RootTBC.h"

@interface RootTBC ()

@end

@implementation RootTBC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSubviews];
}

- (void)initSubviews
{
    UIViewController *vc1 = [[CMRouter sharedInstance]getObjectWithClassName:@"FirstViewController"];
    UIViewController *vc2 = [[CMRouter sharedInstance]getObjectWithClassName:@"SecondViewController"];
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:vc2];
    
    self.viewControllers = @[vc1,nvc];
    [vc1 setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"first" image:nil selectedImage:nil]];
    [nvc setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"second" image:nil selectedImage:nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
