//
//  ViewController.m
//  CMRouter
//
//  Created by caiming on 15/11/18.
//  Copyright © 2015年 caiming. All rights reserved.
//

#import "ViewController.h"
#import "CMRouter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, 88, 44);
    [btn setTitle:@"present" forState:UIControlStateNormal];
    
    [self.view addSubview:btn];
    btn.center = self.view.center;
    [btn addTarget:self action:@selector(onBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onBtnAction
{
    [[CMRouter sharedInstance]showViewController:@"SecondViewController" param:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
