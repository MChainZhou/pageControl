//
//  ViewController.m
//  pageControl
//
//  Created by apple on 2017/1/13.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ViewController.h"
#import "JLPageControl.h"
#import "UIView+Extension.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
///
@property (nonatomic, strong) JLPageControl *pageControl;
/// 开始跌位置
@property (nonatomic,assign) CGFloat start;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"pageControl";
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize =self.view.size;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.pageControl];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
    
    return cell;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat contentOffSetX = scrollView.contentOffset.x  + self.view.width * 0.5;
    NSInteger index = contentOffSetX / self.view.width;
    self.pageControl.currentPage = index;
    
    [self.pageControl pageDidChangeWithScrollView:scrollView];
}


- (JLPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[JLPageControl alloc]init];
        _pageControl.frame = CGRectMake(100, self.view.height - 80, self.view.width - 200, 50);
        _pageControl.numberOfPages = 7;
        _pageControl.hidesForSinglePage = YES;
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    return _pageControl;
}



@end
