# ZQCycleView

[![CI Status](http://img.shields.io/travis/13525505765@163.com/ZQCycleView.svg?style=flat)](https://travis-ci.org/13525505765@163.com/ZQCycleView)
[![Version](https://img.shields.io/cocoapods/v/ZQCycleView.svg?style=flat)](http://cocoapods.org/pods/ZQCycleView)
[![License](https://img.shields.io/cocoapods/l/ZQCycleView.svg?style=flat)](http://cocoapods.org/pods/ZQCycleView)
[![Platform](https://img.shields.io/cocoapods/p/ZQCycleView.svg?style=flat)](http://cocoapods.org/pods/ZQCycleView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ZQCycleView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ZQCycleView'
```

## Author

13525505765@163.com, 13525505765@163.com

## License

轮播图，长方形分页控件
最新更新功能：支持无限滚动、点击回调等
使用方法：
1.进行初始化，并实现代理方法：
- (instancetype)initWithframe:(CGRect)frame
imageUrls:(NSArray *)imageUrls
delegate:(id<ZQCycleViewDelegate>)delegate
selectPageControlColor:(UIColor*)selectPageControlColor
pageControlAliment:(PageControlAliment)pageControlAliment;
/** 点击图片回调 */
- (void)cycleScrollView:(ZQCycleView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;
2.注意事项：1.需要infoplist文件里设置Allow Arbitrary Loads = YES;
                     2.初始化没有数据时，例如imageUrls,可以在初始化的时候置为nil，随后进行属性赋值即可；

![image](https://github.com/aaazq/ZQCycleView/blob/master/GuiderView/image/zqCycyle.gif)

