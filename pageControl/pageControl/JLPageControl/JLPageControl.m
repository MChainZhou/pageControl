//
//  JLPageControl.m
//  pageControl
//
//  Created by apple on 2017/1/13.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "JLPageControl.h"
#import "UIView+Extension.h"

static CGFloat const JLPageControlRadius = 3.0;
static CGFloat const pageMargin = 15;

@interface JLPageControl ()
/// 所有的page
@property (nonatomic, strong) NSMutableArray *pages;
/// 所有的layer
@property (nonatomic, strong) NSMutableArray *layers;
/// 当前选中的layer
@property (nonatomic, strong) CAShapeLayer *currentLayer;
/// 所有圆点的父识图
@property (nonatomic, strong) UIView *layerSuperView;
/// 动画的线
@property (nonatomic, strong) CAShapeLayer *lineLayer;
/// 上一个选中的分也
@property (nonatomic,assign) NSInteger forwardPage;
/// 总的长度
@property (nonatomic,assign) CGFloat totalW;
@end

@implementation JLPageControl
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setNumberOfPages:(NSUInteger)numberOfPages{
    _numberOfPages = numberOfPages;
    
    CGFloat layerX = 0;
    
    UIBezierPath * linePath = [UIBezierPath bezierPath];
    
    
    
    for (int i = 0; i < numberOfPages; i ++) {
        
        layerX = i * pageMargin;
        
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(JLPageControlRadius, JLPageControlRadius) radius:JLPageControlRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(layerX, 0, JLPageControlRadius + 1, JLPageControlRadius + 1);
        if (i == 0) {
            [linePath moveToPoint:CGPointMake(layerX +  JLPageControlRadius, JLPageControlRadius)];
        }else{
            [linePath addLineToPoint:CGPointMake(layerX +  JLPageControlRadius, JLPageControlRadius)];
            [linePath moveToPoint:CGPointMake(layerX +  JLPageControlRadius, JLPageControlRadius)];
        }
        
        layer.path = path.CGPath;
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.strokeColor = [UIColor redColor].CGColor;
        if (i == 0 && self.currentLayer == nil) {
            self.currentLayer = layer;
            self.currentLayer.fillColor = self.currentPageIndicatorTintColor.CGColor;
            
        }
        
        if (i == numberOfPages - 1) {
            self.layerSuperView.width = (numberOfPages - 1) * 10 + 2 * JLPageControlRadius;
            self.layerSuperView.x = (self.width - self.layerSuperView.width)/2;
        }
        layer.lineWidth = 1;
        
        [self.layerSuperView.layer addSublayer:layer];
        [self.layers addObject:layer];
        
    }
    
    [self.layerSuperView.layer addSublayer:self.lineLayer];
    self.lineLayer.frame = self.layerSuperView.bounds;
    self.lineLayer.path = linePath.CGPath;
    
    self.totalW = pageMargin * (numberOfPages - 1);
}



- (void)pageDidChangeWithScrollView:(UIScrollView *)scrollView{
    UIPanGestureRecognizer *panGes = scrollView.panGestureRecognizer;
    [self handleSwipe:panGes withScrollView:scrollView];
    
    
}
- (void)handleSwipe:(UIPanGestureRecognizer *)panGes withScrollView:(UIScrollView *)scrollView{
    [self commitTranslation:[panGes translationInView:scrollView] withScrolliew:scrollView];

}

- (void)commitTranslation:(CGPoint)translation withScrolliew:(UIScrollView *)scrollView{
    
    CGFloat contentOffSetX = scrollView.contentOffset.x;
    //滑动的长度的整值
    NSInteger index = contentOffSetX/[UIScreen mainScreen].bounds.size.width;
    //滑动的长度的浮点
    CGFloat percent = contentOffSetX/[UIScreen mainScreen].bounds.size.width;
    
    static CGFloat currentPercent;
    static CGFloat startStroke;
    static CGFloat endStroke;
    if (translation.x < 0) {//向左滑动
        if (percent - index < 0.5) {
            currentPercent = percent - self.currentPage;
            startStroke = self.currentPage * pageMargin / self.totalW;
            endStroke = (self.currentPage + currentPercent) * pageMargin / self.totalW;
        }else{
            currentPercent = percent + 1 - self.currentPage;
            startStroke = (self.currentPage + currentPercent - 1) * pageMargin / self.totalW;
            endStroke = self.currentPage * pageMargin / self.totalW;
        }
        
    }else{//向右滑动
        if (percent - index < 0.5) {
            currentPercent = percent - self.currentPage;
            startStroke = self.currentPage * pageMargin / self.totalW;
            endStroke = (self.currentPage + currentPercent) * pageMargin / self.totalW;
        }else{
            currentPercent = percent - self.currentPage;
            startStroke = (self.currentPage + currentPercent) * pageMargin / self.totalW;
            endStroke = self.currentPage * pageMargin / self.totalW;
        }
    }
    self.lineLayer.strokeStart = startStroke;
    self.lineLayer.strokeEnd = endStroke;
}

- (void)setHidesForSinglePage:(BOOL)hidesForSinglePage{
    _hidesForSinglePage = hidesForSinglePage;
    if (hidesForSinglePage) {
        self.layerSuperView.hidden = self.numberOfPages == 1 ? YES : NO;
    }
}


- (void)setCurrentPage:(NSUInteger)currentPage{
    _currentPage = currentPage;
    if (self.currentLayer) {
        self.currentLayer.fillColor = [UIColor clearColor].CGColor;
    }
    if (currentPage > self.layers.count-1) {
        return;
    }
    self.currentLayer = self.layers[currentPage];
    self.currentLayer.fillColor = self.currentPageIndicatorTintColor.CGColor;
    
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor{
    self.currentLayer.fillColor = currentPageIndicatorTintColor.CGColor;
    
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor{
    _pageIndicatorTintColor = pageIndicatorTintColor;
}

//MARK: -- 懒加载
- (NSMutableArray *)pages{
    if (!_pages) {
        _pages = [NSMutableArray array];
    }
    return _pages;
}

- (NSMutableArray *)layers{
    if (!_layers) {
        _layers = [NSMutableArray array];
    }
    return _layers;
}

- (UIView *)layerSuperView{
    if (!_layerSuperView) {
        _layerSuperView = [UIView new];
        _layerSuperView.height = JLPageControlRadius;
        _layerSuperView.centerY = self.height/2;
        [self addSubview:_layerSuperView];
    }
    return _layerSuperView;
}

- (CAShapeLayer *)lineLayer{
    if (!_lineLayer) {
        _lineLayer = [CAShapeLayer layer];
        _lineLayer.lineWidth = JLPageControlRadius * 2;
        _lineLayer.lineCap = kCALineCapRound;
        _lineLayer.lineJoin = kCALineJoinRound;
        _lineLayer.fillColor = [UIColor whiteColor].CGColor;
        _lineLayer.strokeColor = [UIColor whiteColor].CGColor;
        _lineLayer.strokeStart = 0.f;
        _lineLayer.strokeEnd = 0.f;
    }
    return _lineLayer;
}

@end
