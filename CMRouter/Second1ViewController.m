//
//  Second1ViewController.m
//  CMRouter
//
//  Created by caiming on 15/11/24.
//  Copyright © 2015年 caiming. All rights reserved.
//

#import "Second1ViewController.h"

@interface Second1ViewController ()

@end

@implementation Second1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:self action:@selector(onBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"push1" forState:UIControlStateNormal];
    button.frame = CGRectMake(20, 60, 88, 44);
    [self.view addSubview:button];
    
    
}

- (void)onBtnAction
{
    [[CMRouter sharedInstance]showViewController:@"DetailViewController" param:nil];
//    [[CMRouter sharedInstance]presentController:@"DetailViewController" param:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
//    UITableView *v;
//    CATransform3D transform = CATransform3DMakeTranslation(0.0f, 0.0f, -15.0f);
//    transform = CATransform3DRotate(transform, (CGFloat)M_PI + 0.4f, 0.0f, 0.0f, 1.0f);
//    transform = CATransform3DRotate(transform, (CGFloat)M_PI_4, 1.0f, 0.0f, 0.0f);
//    transform = CATransform3DRotate(transform, -0.4f, 0.0f, 1.0f, 0.0f);
//    transform = CATransform3DScale(transform, 3.0f, 3.0f, 3.0f);
//    aview.modelTransform = transform;
    
    
//    CGAffineTransform transT = CGAffineTransformMakeTranslation(190, 0);
//    CGAffineTransform scaleT = CGAffineTransformMakeScale(0.76, 0.76);
//    CGAffineTransform conT = CGAffineTransformConcat(transT, scaleT);
//    
//    self.view.transform = conT;
//    
//    UIView *aview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
//    aview.backgroundColor = [UIColor redColor];
//    aview.center = self.view.center;
////    aview.transform = CGAffineTransformMakeTranslation(110.9,220.0);
//    
//    [self.view addSubview:aview];
    
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
