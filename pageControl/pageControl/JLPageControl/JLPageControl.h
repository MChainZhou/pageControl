//
//  JLPageControl.h
//  pageControl
//
//  Created by apple on 2017/1/13.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLPageControl : UIView
/// 分页的个数
@property(nonatomic,assign) NSUInteger numberOfPages;
/// 当前选中的分页
@property(nonatomic,assign) NSUInteger currentPage;
/// 选中的page的颜色
@property(nonatomic, strong) UIColor *currentPageIndicatorTintColor;
/// page的颜色
@property(nonatomic, strong) UIColor *pageIndicatorTintColor;
@property(nonatomic, assign) BOOL hidesForSinglePage;


- (void)pageDidChangeWithScrollView:(UIScrollView *)scrollView;

@end
