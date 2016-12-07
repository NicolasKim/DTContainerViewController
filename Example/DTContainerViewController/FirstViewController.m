//
//  FirstViewController.m
//  DTContainerViewController
//
//  Created by 金秋成 on 2016/12/7.
//  Copyright © 2016年 NicolasKim. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"first will appear");
}
-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"first did appear");
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"first will disappear");
}
-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"first did disappear");
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"first did load");
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
