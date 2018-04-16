//
//  ZQCycleView.h
//  GuiderView
//
//  Created by 张奇 on 2017/10/13.
//  Copyright © 2017年 bocweb. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, PageControlAliment) {
    PageControlAlimentCenter = 0,
    PageControlAlimentRight,
};

@class ZQCycleView;
@protocol ZQCycleViewDelegate <NSObject>

@optional
/** 点击图片回调 */
- (void)cycleScrollView:(ZQCycleView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;

@end

@interface ZQCycleView : UIView

/** pageControlX轴位置 */
@property (nonatomic, assign) PageControlAliment pageControlAliment;
/** SelectPageCconrol的颜色 */
@property (nonatomic, strong) UIColor *selectPageControlColor;
/** NormalPageCconrol的颜色 */
@property (nonatomic, strong) UIColor *normalPageControlColor;
/** 网络图片url数组 */
@property (nonatomic, strong) NSArray *imageUrls;

@property (nonatomic, assign) id<ZQCycleViewDelegate> delegate;

/** 初始化方法 */
- (instancetype)initWithframe:(CGRect)frame
                    imageUrls:(NSArray *)imageUrls
                     delegate:(id<ZQCycleViewDelegate>)delegate
              selectPageControlColor:(UIColor*)selectPageControlColor
           pageControlAliment:(PageControlAliment)pageControlAliment;



@end
