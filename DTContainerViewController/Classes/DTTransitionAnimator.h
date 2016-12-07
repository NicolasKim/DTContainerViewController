//
//  DTTransitionAnimator.h
//  Pods
//
//  Created by 金秋成 on 2016/12/6.
//
//

#import <Foundation/Foundation.h>


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
