//
//  ZQViewController.m
//  ZQCycleView
//
//  Created by 13525505765@163.com on 04/16/2018.
//  Copyright (c) 2018 13525505765@163.com. All rights reserved.
//

#import "ZQViewController.h"
#import "ZQCycleView.h"
@interface ZQViewController () <ZQCycleViewDelegate>

@end

@implementation ZQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    ZQCycleView *cycleView = [[ZQCycleView alloc] initWithframe:CGRectMake(20, 20, [UIScreen mainScreen].bounds.size.width - 40, 200) imageUrls:@[@"http://b.hiphotos.baidu.com/zhidao/pic/item/4b90f603738da9770889666fb151f8198718e3d4.jpg", @"http://g.hiphotos.baidu.com/zhidao/pic/item/f2deb48f8c5494ee4e84ef5d2cf5e0fe98257ed4.jpg", @"http://d.hiphotos.baidu.com/zhidao/pic/item/9922720e0cf3d7ca104edf32f31fbe096b63a93e.jpg", @"http://b.hiphotos.baidu.com/zhidao/pic/item/4b90f603738da9770889666fb151f8198718e3d4.jpg", @"http://g.hiphotos.baidu.com/zhidao/pic/item/f2deb48f8c5494ee4e84ef5d2cf5e0fe98257ed4.jpg"] delegate:self
                                         selectPageControlColor:[UIColor whiteColor] pageControlAliment: PageControlAlimentRight];
    
    [self.view addSubview:cycleView];
}

- (void)cycleScrollView:(ZQCycleView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"index: %zd", index);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
