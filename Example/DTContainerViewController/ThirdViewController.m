//
//  ThirdViewController.m
//  DTContainerViewController
//
//  Created by 金秋成 on 2016/12/7.
//  Copyright © 2016年 NicolasKim. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"third will appear");
}
-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"third did appear");
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"third will disappear");
}
-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"third did disappear");
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"third did load");
}

- (void)didReceiveMemoryWarning {
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
