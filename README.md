# DTContainerViewController

[![CI Status](http://img.shields.io/travis/NicolasKim/DTContainerViewController.svg?style=flat)](https://travis-ci.org/NicolasKim/DTContainerViewController)
[![Version](https://img.shields.io/cocoapods/v/DTContainerViewController.svg?style=flat)](http://cocoapods.org/pods/DTContainerViewController)
[![License](https://img.shields.io/cocoapods/l/DTContainerViewController.svg?style=flat)](http://cocoapods.org/pods/DTContainerViewController)
[![Platform](https://img.shields.io/cocoapods/p/DTContainerViewController.svg?style=flat)](http://cocoapods.org/pods/DTContainerViewController)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

DTContainerViewController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DTContainerViewController"
```
## 说明
# 教你如何制作自定义容器类

在最近的项目中，需要一个类似今日头条的可翻页容器类。于是在网上找了各种资料，经过一个星期业余的时间，终于搞出来了。给自己来点掌声！！！

### 类结构

> 1. 容器控制器
> 2. 转场上下文
> 3. 转场代理
> 4. 转场动画控制器
> 5. 转场交互控制器



### 先了解一下系统的UINavigationController的转场是什么样子的

 ![c1](c1.png)

由上图为一次转场的上下文环境，也就是说转场时上下文可以描述，这一次的转场 从哪一个控制器（fromView）转到哪一个控制器（toView）在哪一个父视图（containerview）上进行转场。

获得了以上三个视图，我们就可以大胆滴做动画效果了，只有想不到，没有做不到。

当然，这个动画需要一个动画控制器去控制，上下文只提供了一个转场环境。

交互式转场稍后再说。先把动画控制器做出来。

### 动画控制器

动画控制器需要满足一个协议<UIViewControllerAnimatedTransitioning>

```objective-c
//返回动画时长
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
//在该方法中实现动画效果
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
```

我们做一个简单的 左/右滑动时切换视图的动画控制器

新建名为DTTransitionAnimator继承与NSObject的类 并加入协议

.h

```objective-c
#import <UIKit/UIKit.h>
//这里可以定义更多的动画样式，交给-animateTransition:处理
typedef NS_ENUM(NSUInteger, DTTransitionDirect) {
    DTTransitionDirectLeftToRight,//从左向右滑动
    DTTransitionDirectRightToLeft,//从右向左滑动
};

@interface DTTransitionAnimator : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic,assign,readonly)DTTransitionDirect transitionDirect;
-(instancetype)initWithTransitionDirect:(DTTransitionDirect)direct;

@end
```

.m

```objective-c
#import "DTTransitionAnimator.h"
@implementation DTTransitionAnimator
-(instancetype)initWithTransitionDirect:(DTTransitionDirect)direct{
    self = [super init];
    if (self) {
        _transitionDirect = direct;
    }
    return self;
}
//协议方法：确定转场的动画时长
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.28;//统一动画时长为0.28秒
}
//协议方法：确定转场的动画的样式
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
}
@end
```



接下来就是根据direct决定动画的样式，编写协议方法**-animateTransition：**如下:

```objective-c
//协议方法：确定转场的动画的样式
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    //获取toviewcontroller
    UIViewController * tovc   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //获取fromviewcontroller
    UIViewController * fromvc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    //获取容器视图，所有转场都在该视图内进行
    UIView * containerView = [transitionContext containerView];
    UIView * toView        = tovc.view;
    UIView * fromView      = fromvc.view;
    //获取转场时长
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    //设置视图为容器视图的大小，考虑后续有控件加入容器视图控制器的view的情况。
    toView.frame = containerView.bounds;
    [containerView addSubview:toView];
    //这里就不多做解释
    switch (_transitionDirect) {
        case DTTransitionDirectLeftToRight:
        {
            CGFloat toTranslationX = toView.frame.size.width;
            CGFloat fromTranslationX = fromView.frame.size.width;
            toView.transform = CGAffineTransformMakeTranslation(-toTranslationX, 0);
            fromView.transform = CGAffineTransformIdentity;
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                toView.transform = CGAffineTransformMakeTranslation(0, 0);
                fromView.transform = CGAffineTransformMakeTranslation(fromTranslationX, 0);
            } completion:^(BOOL finished) {
                toView.transform = CGAffineTransformIdentity;
                fromView.transform = CGAffineTransformIdentity;
                //动画完成后必须调用该方法
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
        }
            break;
        case DTTransitionDirectRightToLeft:
        {
            CGFloat toTranslationX = toView.frame.size.width;
            CGFloat fromTranslationX = fromView.frame.size.width;
            toView.transform = CGAffineTransformMakeTranslation(toTranslationX, 0);
            fromView.transform = CGAffineTransformIdentity;
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                toView.transform = CGAffineTransformMakeTranslation(0, 0);
                fromView.transform = CGAffineTransformMakeTranslation(-fromTranslationX, 0);
            } completion:^(BOOL finished) {
                //动画结束后重置transform
                toView.transform = CGAffineTransformIdentity;
                fromView.transform = CGAffineTransformIdentity;
                //动画完成后必须调用该方法
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
        }
            break;
        default:
        {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }
            break;
    }
}
```



### 转场代理

动画控制器已经创建好，接下来就是转场代理。

像UINavigationController，UIKit提供了一个代理协议UINavigationControllerDelegate。

那容器控制器该用哪个协议呢？UIKit当然不会那么面面俱到地给我们开发者提供这种协议。咋整？自己写呗！

我们先看一下UINavigationControllerDelegate是什么样的。

重点看一下以下的协议：

```objective-c
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC;
```

说明转场过程中转场上下文会提供从哪个控制器pop/push到哪一个控制器。

那我们想象我们的协议该怎么写，看看今日头条的，每个标签都对应一个视图控制器，那么如果夸张一点，有几百个标签，我们难道要创建一百个视图控制器吗？ 显然这不太合理。我们应该考虑到试图控制器的复用就像tableview复用cell一样。

好，那我们着手写代理协议，先新建一个名为DTTransitionDelegate继承与NSObject的代理类，如下：

```objective-c
@protocol DTTransitionProtocol <NSObject>

-(id<UIViewControllerAnimatedTransitioning>)dt_animationControllerForContainerViewController:(UIViewController *)containerViewController
                                                                   transitFromViewController:(UIViewController *)fromViewController
                                                                                     atIndex:(NSUInteger)fromIndex
                                                                            toViewController:(UIViewController *)toViewController
                                                                                     atIndex:(NSUInteger)toIndex;

@end
```

参数说明

containerViewController：容器控制器

fromViewController：

fromIndex：fromviewcontroller的索引

toViewController：

toIndex：toViewController的索引

为什么这么写呢？

这样的话视图控制器会从索引分离。

比如说今日头条，有100个标签索引就是从0到99，但是视图控制器可以只有10个甚至更少。



接下来实现DTTransitionDelegate 的协议方法

```objective-c
-(id<UIViewControllerAnimatedTransitioning>)dt_animationControllerForContainerViewController:(UIViewController *)containerViewController
                                                                   transitFromViewController:(UIViewController *)fromViewController atIndex:(NSUInteger)fromIndex
                                                                            toViewController:(UIViewController *)toViewController atIndex:(NSUInteger)toIndex{
    //fromindex 和toindex再次只决定滑动方向
    if (fromIndex < toIndex) {
        return [[DTTransitionAnimator alloc]initWithTransitionDirect:DTTransitionDirectRightToLeft];
        
    }
    else{
        return [[DTTransitionAnimator alloc]initWithTransitionDirect:DTTransitionDirectLeftToRight];
    }
}
```

代理写完了，下面是最头痛的上下文，可以先喝杯水，休息一下。

### 上下文

开始写转场上下文吧。

还好UIKit为我们提供了转场上下文的协议UIViewControllerContextTransitioning，可以点进去看一下，好多协议方法吧？我们暂时只看动画转场的部分。

```objective-c
- (UIView *)containerView;//返回容器视图
- (BOOL)isAnimated;//是否在动画专场中
- (BOOL)transitionWasCancelled;//转场是否被取消
- (void)completeTransition:(BOOL)didComplete;//完成转场与否
- (nullable __kindof UIViewController *)viewControllerForKey:(UITransitionContextViewControllerKey)key;//根据key值返回fromviewcontroller/toviewcontroller
- (nullable __kindof UIView *)viewForKey:(UITransitionContextViewKey)key; NS_AVAILABLE_IOS(8_0)//暂时不用写。
- (CGRect)initialFrameForViewController:(UIViewController *)vc;//初始视图frame
- (CGRect)finalFrameForViewController:(UIViewController *)vc;//最终的视图frame
```

以上方法是不是有点眼熟，对他们都在DTTransitionAnimator里用着呢，也就是说这些方法都是由animator进行调用的，上下文的作用就是为动画控制器和交互控制器提供转场环境的。

创建DTTransitionContext继承与NSObject 签订UIViewControllerContextTransitioning协议，编辑头文件如下：

```
#import <Foundation/Foundation.h>
#import "DTTransitionDelegate.h"
@interface DTTransitionContext : NSObject<UIViewControllerContextTransitioning>
@property (nonatomic,weak)UIViewController * fromViewController;
@property (nonatomic,assign)NSUInteger fromIndex;
@property (nonatomic,weak)UIViewController * toViewController;
@property (nonatomic,assign)NSUInteger toIndex;

//转场代理
@property (nonatomic,strong,readonly)DTTransitionDelegate * trasitionDelegate;

-(instancetype)initWithContainerViewController:(UIViewController *)containerViewController
                                 containerView:(UIView *)containerView;
//开始动画转场
-(void)startAnimationTrasition;
@end
```

实现初始化方法如下：

```objective-c
-(instancetype)initWithContainerViewController:(UIViewController *)containerViewController
                                 containerView:(UIView *)containerView{
    self = [super init];
    if (self) {
      //不要忘了在声明以下两个全局变量
        self.privateContainerViewController = containerViewController;
        self.privateContainerView = containerView;
        _trasitionDelegate = [[DTTransitionDelegate alloc]init];
    }
    return self;
}
```

编写startAnimationTrasition

```objective-c
-(void)startAnimationTrasition{
    self.animator = [self.trasitionDelegate dt_animationControllerForContainerViewController:self.privateContainerViewController
                                                                   transitFromViewController:self.fromViewController
                                                                                     atIndex:self.fromIndex
                                                                            toViewController:self.toViewController
                                                                                     atIndex:self.toIndex];
    
    self.isCancelled = NO;
    //调用viewwillappear
    [self.toViewController willMoveToParentViewController:self.privateContainerViewController];
    //给动画控制器传入context
    [self.animator animateTransition:self];
}
```





我们去一个个去实现UIViewControllerContextTransitioning协议方法：

```objective-c
-(UIView *)containerView{
    return  self.privateContainerView;
}
-(UIViewController *)viewControllerForKey:(UITransitionContextViewControllerKey)key{
    if ([key isEqualToString:UITransitionContextFromViewControllerKey]) {
        return self.fromViewController;
    }
    else if([key isEqualToString:UITransitionContextToViewControllerKey]){
        return self.toViewController;
    }
    return nil;
}

-(UIView *)viewForKey:(UITransitionContextViewKey)key{
    if ([key isEqualToString:UITransitionContextFromViewKey]) {
        return self.fromViewController.view;
    }
    else if([key isEqualToString:UITransitionContextToViewKey]){
        return self.toViewController.view;
    }
    return nil;
}

-(CGRect)initialFrameForViewController:(UIViewController *)vc{
    return CGRectZero;
}

-(CGRect)finalFrameForViewController:(UIViewController *)vc{
    return vc.view.frame;
}

-(BOOL)transitionWasCancelled{
    return self.isCancelled;//标记动画或者交互是否被取消
}


//管理viewcontroller的生命周期
-(void)completeTransition:(BOOL)isComplete{
    [self.toViewController didMoveToParentViewController:self.privateContainerViewController];
    if (isComplete) {
        //会调用viewwilldisappear
        [self.fromViewController willMoveToParentViewController:nil];
        [self.fromViewController.view removeFromSuperview];
        //会调用viewDidDisappear
        [self.fromViewController removeFromParentViewController];
    }
    else{
        //会调用viewwilldisappear
        [self.toViewController willMoveToParentViewController:nil];
        [self.toViewController.view removeFromSuperview];
        //会调用viewDidDisappear
        [self.toViewController removeFromParentViewController];
    }
    if ([self.animator respondsToSelector:@selector(animationEnded:)]) {
        [self.animator animationEnded:!self.isCancelled];
    }
}
```

以上部分的上下文已经编写好了

### 容器控制器

考虑到扩展，要满足一下条件：

1. 可扩展（没有一个多余的控件修饰，甚至没有标题滑动条，因为开发者使用时，可能有好多不同的控件样式，所以与其写一个高度扩展性的滑动条控件，还不如什么都没有，好让开发者自由发挥）
2. 可子类化 
3. 可单独使用

在此我借鉴了一下 tableview的设计思想。

既然是借鉴了tableview的设计思想，当然少不了代理协议了。

新建容器控制器类DTContainerViewController，编写两个协议如下：

```objective-c
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
//转场结束
-(void)didEndTrasitionFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
@end
```

添加两个代理属性，如下：

```objective-c
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
```









### 编写交互控制器



### 进一步完成上下文



### 总结



参考文献



## Author

NicolasKim, jinqiucheng1006@live.cn

## License

DTContainerViewController is available under the MIT license. See the LICENSE file for more info.
