//
//  ZQCycleView.m
//  GuiderView
//
//  Created by 张奇 on 2017/10/13.
//  Copyright © 2017年 bocweb. All rights reserved.
//

#import "ZQCycleView.h"
#import "UIView+ZQAdditions.h"
#import "UIImageView+WebCache.h"
@interface ZQCycleView() <UIScrollViewDelegate>
{
    CGFloat _startContentOffsetX;
    CGFloat _willEndContentOffsetX;
    CGFloat _endContentOffsetX;
    //frame
    CGFloat _bannerW;
    CGFloat _bannerH;
}
@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, strong) UIButton *currentBtn;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic, strong) NSMutableArray *btnXArray;
@property (nonatomic, copy) NSString *scrollDirection;
@end
static NSInteger const delayTime = 3;
//pageControl宽高
static NSInteger const normalbtnWH = 10.0;
//pageControl选中宽
static NSInteger const selectBtnWidth = 20.0;
//间距
static NSInteger const btnMargin = 20.0;

static NSInteger const pageControlMarginDown = 25;
@implementation ZQCycleView

- (instancetype)initWithframe:(CGRect)frame
                    imageUrls:(NSArray *)imageUrls
                     delegate:(id<ZQCycleViewDelegate>)delegate
              selectPageControlColor:(UIColor*)selectPageControlColor
           pageControlAliment:(PageControlAliment)pageControlAliment {
    if (self == [super initWithFrame:frame]) {
        _bannerW = frame.size.width;
        _bannerH = frame.size.height;
        self.selectPageControlColor = selectPageControlColor;
        self.pageControlAliment = pageControlAliment;
        self.delegate = delegate;
        if (imageUrls.count) {
            [self setupSubViewsWithImageUrls:imageUrls];
            if (imageUrls.count > 1) {
                [self addTimer];
            } else {
                self.bgScrollView.scrollEnabled = NO;
            }
        }
    }
    return self;
}

- (void)setImageUrls:(NSArray *)imageUrls {
    _imageUrls = imageUrls;
    if (imageUrls.count) {
        [self setupSubViewsWithImageUrls:imageUrls];
        if (imageUrls.count > 1) {
            [self addTimer];
        } else {
            self.bgScrollView.scrollEnabled = NO;
        }
    }
}

- (void)setupSubViewsWithImageUrls:(NSArray *)imageUrls {
    //重置self
    [self removeAllSubviews];
    //ScrollView
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _bannerW, _bannerH)];
    _bgScrollView.pagingEnabled = YES;
    _bgScrollView.showsHorizontalScrollIndicator = NO;
    _bgScrollView.bounces = YES;
    _bgScrollView.delegate = self;
    _bgScrollView.contentSize = CGSizeMake(_bannerW*(imageUrls.count+2), _bannerH);
    [self addSubview:self.bgScrollView];
    
    //imageView
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:imageUrls];
    [mArray insertObject:imageUrls.lastObject atIndex:0];
    [mArray addObject:imageUrls.firstObject];
    for (int i = 0; i < mArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_bannerW*i, 0, _bannerW, _bannerH)];
        imageView.tag = 2000+i;
        [imageView sd_setImageWithURL:[NSURL URLWithString:mArray[i]] placeholderImage:[self imageWithName:@"banner"]];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageViewWithTapGesture:)];
        [imageView addGestureRecognizer:tapGesture];
        [self.bgScrollView addSubview:imageView];
    }
    //左边添加了一张额外的图片，因此要把contentoffsetX左移一个位置
    [self.bgScrollView setContentOffset:CGPointMake(_bannerW, 0) animated:NO];
    
    //按钮
    CGFloat pageControlMarginRight = _pageControlAliment ? 25 : _bannerW/2-normalbtnWH*(imageUrls.count);
    CGFloat X = _bannerW-normalbtnWH*(imageUrls.count-1)-normalbtnWH*(imageUrls.count-1)-selectBtnWidth- pageControlMarginRight;
    CGFloat Y = _bannerH-pageControlMarginDown;
    self.btnArray = [NSMutableArray arrayWithCapacity:imageUrls.count];
    self.btnXArray = [NSMutableArray arrayWithCapacity:imageUrls.count];
    for (int i = 0; i < imageUrls.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(X, Y, normalbtnWH, normalbtnWH);
        btn.layer.cornerRadius = normalbtnWH/2;
        btn.backgroundColor = _normalPageControlColor == nil ? [UIColor whiteColor] : _normalPageControlColor;
        btn.alpha = 0.5;
        btn.tag = 1000+i;
        [self.btnXArray addObject:[NSString stringWithFormat:@"%f", btn.frame.origin.x]];
        [self addSubview:btn];
        [self.btnArray addObject:btn];
        if (0 == i) {
            btn.frame = CGRectMake(X, Y, selectBtnWidth, normalbtnWH);
            btn.backgroundColor = _selectPageControlColor;
            btn.alpha = 1.0;
            self.currentBtn = btn;
            X += btnMargin+normalbtnWH;
        } else {
            X += btnMargin;
        }
    }
}

- (void)addTimer {
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:delayTime target:self selector:@selector(scrollAnimation:) userInfo:nil repeats:YES];
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollAnimation:(NSTimer *)timer {
    //画面从左往右移动，后一页
    if (self.currentBtn.tag-1000 == self.btnArray.count-1) {
        //最后一页，注意：1.将bgScrollView滑到额外的最后一页
        [self.bgScrollView setContentOffset:CGPointMake(_bannerW*(self.btnArray.count+1), 0) animated:YES];
        //2.按钮动画至第一页
        [self animationWithIsRightDirection:YES isTimerAutomate:NO isNeedReset:YES];
    } else {
        //后一页
        [self animationWithIsRightDirection:YES isTimerAutomate:YES isNeedReset:NO];
    }
}

/**
 @param isRight 是否是向右滚动
 @param isTimerAutomate 是否是定时器导致的
 */
- (void)animationWithIsRightDirection:(BOOL)isRight isTimerAutomate:(BOOL)isTimerAutomate isNeedReset:(BOOL)isNeedReset {
    [UIView animateWithDuration:1 animations:^{
        for (UIButton *tempBtn in self.btnArray) {
            if ([tempBtn isEqual:[self moveNextBtnWithDirection:isRight]]) {
                tempBtn.backgroundColor = self.selectPageControlColor;
                tempBtn.alpha = 1.0;
            } else {
                tempBtn.backgroundColor = self.normalPageControlColor == nil ? [UIColor whiteColor] : self.normalPageControlColor;
                tempBtn.alpha = 0.5;
            }
        }
        
        if (isTimerAutomate) {
            if (self.currentBtn.tag == (1000+self.btnArray.count-1)) {
                for (UIButton *tempBtn in self.btnArray) {
                    tempBtn.left += (selectBtnWidth-normalbtnWH);
                }
            }
            self.currentBtn.width = normalbtnWH;
            UIButton *nextBtn = [self moveNextBtnWithDirection:isRight];
            nextBtn.width = selectBtnWidth;
            nextBtn.left -= (selectBtnWidth-normalbtnWH);
            self.currentBtn = [self moveNextBtnWithDirection:isRight];
            
            
            [self.bgScrollView setContentOffset:CGPointMake(self->_bannerW*(self.currentBtn.tag-1000+1), 0) animated:YES];
            
        } else {
            self.currentBtn.width = normalbtnWH;
            UIButton *nextBtn = [self moveNextBtnWithDirection:isRight];
            nextBtn.width = selectBtnWidth;
            if (self.currentBtn.tag-1000 == self.btnArray.count-1 && isRight) {
                for (UIButton *tempBtn in self.btnArray) {
                    if ([tempBtn isEqual:nextBtn]) {
                        continue;
                    }
                    tempBtn.left += (selectBtnWidth-normalbtnWH);
                }
            } else if (self.currentBtn.tag-1000 == 0 && !isRight) {
                for (UIButton *tempBtn in self.btnArray) {
                    if ([tempBtn isEqual:self.currentBtn]) {
                        continue;
                    }
                    tempBtn.left -= (selectBtnWidth-normalbtnWH);
                }
            } else {
                
                if (isRight) {
                    nextBtn.left -= (selectBtnWidth-normalbtnWH);
                } else {
                    self.currentBtn.left += (selectBtnWidth-normalbtnWH);
                }
            }
            self.currentBtn = [self moveNextBtnWithDirection:isRight];

        }
    } completion:^(BOOL finished) {
        //3.如果通过倒计时移到最后一张，需要重置为第一张
        if (self.currentBtn.tag == 1000 && isNeedReset) {
            [self.bgScrollView setContentOffset:CGPointMake(self->_bannerW, 0) animated:NO];
        }
    }];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //拖动前的起始坐标
    _startContentOffsetX = scrollView.contentOffset.x;
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self addTimer];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{    //将要停止前的坐标
    _willEndContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    _endContentOffsetX = scrollView.contentOffset.x;
    NSInteger currentOffsetX = scrollView.contentOffset.x;
    NSInteger currentIndex = floor(currentOffsetX/_bannerW);
//    NSLog(@"index: %ld", currentIndex);
    if (_endContentOffsetX < _willEndContentOffsetX && _willEndContentOffsetX < _startContentOffsetX) { //画面从右往左移动，前一页
        if (currentIndex == 0) {
            [self.bgScrollView setContentOffset:CGPointMake(_bannerW*(self.btnArray.count), 0) animated:NO];
        }
        [self animationWithIsRightDirection:NO isTimerAutomate:NO isNeedReset:NO];
    } else if (_endContentOffsetX > _willEndContentOffsetX && _willEndContentOffsetX > _startContentOffsetX) {
        //画面从左往右移动，后一页
        if (currentIndex == self.btnArray.count+1) {
            [self.bgScrollView setContentOffset:CGPointMake(_bannerW, 0) animated:NO];
        }
        [self animationWithIsRightDirection:YES isTimerAutomate:NO isNeedReset:NO];
    }
    
}


- (UIButton *)moveNextBtnWithDirection:(BOOL)isRight {
    if (isRight) {
        if (self.currentBtn.tag == (1000+self.btnArray.count-1)) {
            return self.btnArray.firstObject;
        } else {
            return [self viewWithTag:self.currentBtn.tag+1];
        }
    } else {
        if (self.currentBtn.tag == 1000) {
            return self.btnArray.lastObject;
        } else {
            return [self viewWithTag:self.currentBtn.tag-1];
        }
    }
}

- (UIImage*)imageWithName:(NSString *)imageName {
    NSString *normalImgName = [NSString stringWithFormat:@"%@@2x.png", imageName];
    NSBundle *curBundle = [NSBundle bundleForClass:self.class];
    
    NSString *curBundleName = curBundle.infoDictionary[@"CFBundleName"];
    NSString *curBundleDirectory = [NSString stringWithFormat:@"%@.bundle", curBundleName];
    NSString *normalImgPath = [curBundle pathForResource:normalImgName ofType:nil inDirectory:curBundleDirectory];
    
    UIImage *image = [UIImage imageWithContentsOfFile:normalImgPath];
    return image;
}

/** 点击图片回调 */
- (void)clickImageViewWithTapGesture:(UITapGestureRecognizer *)tapGesture {
    UIImageView *imageView = (UIImageView*)tapGesture.view;
    NSInteger index = imageView.tag-2000-1;
    [self.delegate cycleScrollView:self didSelectItemAtIndex:index];
}


@end
