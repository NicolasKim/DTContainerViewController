//
//  DTContainerViewController.h
//  Pods
//
//  Created by 金秋成 on 2016/12/6.
//
//

#import <UIKit/UIKit.h>

@protocol DTContainerViewControllerDataSource <NSObject>
//返回某个索引下的视图控制器
-(UIViewController *)viewControllerAtIndex:(NSUInteger)index;


/*
  视图视图控制器的数量
  次数量可能不同于真实的视图控制器的数量
  比如说tableview  返回的cell数量为100   但是真正的cell实例并不会有100个
*/
-(NSUInteger)numberOfChildViewController;

@end

@protocol DTContainerViewControllerDelegate <NSObject>
//即将开始转场
-(void)didStartTrasitionFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
//交互转场过程
-(void)transitionFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex withProgress:(CGFloat)progress;
//转场结束
-(void)didEndTrasitionFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

@end



@interface DTContainerViewController : UIViewController
//当前选择的索引
@property (nonatomic,assign,readonly)NSUInteger currentIndex;
//手动选择索引
@property (nonatomic,assign)NSUInteger selectIndex;
//容器视图的上下左右间距
@property (nonatomic,assign)UIEdgeInsets containerViewEdge;
//数据源代理
@property (nonatomic,weak)id<DTContainerViewControllerDataSource> dataSource;
//事件代理
@property (nonatomic,weak)id<DTContainerViewControllerDelegate> delegate;
//reload 类似tableview的reloadData
-(void)reloadChildViewControllers;

@end
