//
//  ViewController.m
//  WJCustomCameraDemo
//
//  Created by jh navi on 15/8/6.
//  Copyright (c) 2015年 WJ. All rights reserved.
//

#import "ViewController.h"
#import "SystemCameraViewController.h"
#import "CustomCameraViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressSysCamera:(id)sender {
    SystemCameraViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"sys_SID"];
    [self.navigationController pushViewController:svc animated:YES];
}

- (IBAction)pressCusCamera:(id)sender {
    CustomCameraViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"cus_SID"];
    [self.navigationController pushViewController:cvc animated:YES];
}
@end
