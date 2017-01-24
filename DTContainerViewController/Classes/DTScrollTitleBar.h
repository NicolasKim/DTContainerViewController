//
//  DTScrollTitleBar.h
//  Pods
//
//  Created by 金秋成 on 2017/1/23.
//
//

#import <UIKit/UIKit.h>

typedef NSString *(^DTScrollTitleBarTitleBlock)(NSInteger index);
typedef NSInteger (^DTScrollTitleBarNumberBlock)();
typedef void(^DTScrollTitleBarSelectBlock)(NSInteger index);

typedef NS_ENUM(NSUInteger, DTScrollTitleBarStyle) {
    DTScrollTitleBarType_Average,
    DTScrollTitleBarType_fitToTitleSize,
};



@interface DTScrollTitleBar : UIScrollView

@property (nonatomic,strong,readonly)UIView * indicatorView;

//上和下不生效
@property (nonatomic,assign)UIEdgeInsets hEdge;

@property (nonatomic,assign)CGFloat      hSpace;

@property (nonatomic,assign)DTScrollTitleBarStyle titleBarStyle;

//只有titleBarStyle为DTScrollTitleBarType_fitToTitleSize时该属性才生效
@property (nonatomic,assign)CGSize titleHedge;

@property (nonatomic,strong)UIFont * titleFont;

@property (nonatomic,strong)UIColor * titleColor;

@property (nonatomic,strong)UIColor * selectedTitleColor;



@property (nonatomic,assign,getter=selectedIndex)NSInteger selectIndex;

-(void)setSelectIndex:(NSInteger)selectIndex animated:(BOOL)animated;

-(instancetype)titleForTitleBar:(DTScrollTitleBarTitleBlock)block;

-(instancetype)numberOfTitle:(DTScrollTitleBarNumberBlock)block;

-(instancetype)onSelect:(DTScrollTitleBarSelectBlock)block;

-(void)reloadData;

@end
