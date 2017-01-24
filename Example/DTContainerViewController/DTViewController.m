//
//  DTViewController.m
//  DTContainerViewController
//
//  Created by NicolasKim on 12/06/2016.
//  Copyright (c) 2016 NicolasKim. All rights reserved.
//

#import "DTViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import <DTFamily/DTScrollTitleBar.h>
@interface DTViewController ()<DTContainerViewControllerDelegate,DTContainerViewControllerDataSource>


@property (nonatomic,strong)NSArray * vcArr;
@property (nonatomic,strong)DTScrollTitleBar * scrollTitleBar;

@end

@implementation DTViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.containerViewEdge = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}





- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    
    
    
    FirstViewController * f = [[FirstViewController alloc]init];
    SecondViewController *s = [[SecondViewController alloc]init];
    ThirdViewController * t = [[ThirdViewController alloc]init];
    self.vcArr = @[f,s,t];
    
    [self reloadChildViewControllers];
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.selectIndex = 1;
    });
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.selectIndex = 2;
//    });
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.selectIndex = 7;
//    });
    
    self.scrollTitleBar = [[DTScrollTitleBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    self.scrollTitleBar.titleBarStyle = DTScrollTitleBarType_fitToTitleSize;
    [[[[self.scrollTitleBar titleForTitleBar:^NSString *(NSInteger index) {
        return [NSString stringWithFormat:@"haha%ld",index];
    }] numberOfTitle:^NSInteger{
        return 11;
    }] onSelect:^(NSInteger index) {
        self.selectIndex = index;
    }] reloadData];
    [self.view addSubview:self.scrollTitleBar];
    
}


-(UIViewController *)viewControllerAtIndex:(NSUInteger)index{
    return self.vcArr[index%3];
}

-(NSUInteger)numberOfChildViewController{
    return 11;
}




-(void)didStartTrasitionFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex{
    
}

-(void)transitionFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex withProgress:(CGFloat)progress{
    
}
-(void)didEndTrasitionFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex{
    [self.scrollTitleBar setSelectIndex:toIndex animated:YES];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
