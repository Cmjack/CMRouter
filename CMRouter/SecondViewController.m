//
//  SecondViewController.m
//  CMRouter
//
//  Created by caiming on 15/11/18.
//  Copyright © 2015年 caiming. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:self action:@selector(onBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"push" forState:UIControlStateNormal];
    button.frame = CGRectMake(20, 60, 88, 44);
    [self.view addSubview:button];
}

- (void)onBtnAction
{
    [[CMRouter sharedInstance]showViewController:@"Second1ViewController" param:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
