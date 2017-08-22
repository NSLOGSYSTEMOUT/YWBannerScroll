//
//  BannerRollingViewPlus.m
//  YWBannerScrollDemo
//
//  Created by sai on 2017/8/22.
//  Copyright © 2017年 BJYWT. All rights reserved.
//

#import "BannerRollingViewPlus.h"

@interface BannerRollingViewPlus ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>{

    UIScrollView    *_scrollView;
    UIPageControl   *_pageControl;
    NSInteger       _pageCount;
    NSTimer         *_kvTimer;
    TapBannerRollingViewBlock   _tapBlock;
    
    NSArray         *_imageArray;   //存放展示图片集合
    NSInteger       _prePageIndex;  //记录之前的page下标，用于pageControl小圆点点击事件
}

@end

@implementation BannerRollingViewPlus

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setBackgroundColor:[UIColor lightGrayColor]];
        
        [self initScrollView];
        [self initpageControl];
        [self initTapGesture];
        
    }
    
    return self;
}

-(void)initScrollView{

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    
    [self addSubview:_scrollView];
    
}

-(void)initpageControl{

    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height-50, self.frame.size.width, 50)];
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    _pageControl.enabled = YES;
    
    [_pageControl setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.2]];
    [_pageControl addTarget:self action:@selector(pageControlTouch) forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:_pageControl];
}

-(void)initTapGesture{

    UITapGestureRecognizer  *tapGesture = [[UITapGestureRecognizer   alloc] init];
    [tapGesture addTarget:self action:@selector(pageClick)];
    [self addGestureRecognizer:tapGesture];
}

-(void)pageClick{

    if (_tapBlock) {
        
        _tapBlock(_pageControl.currentPage);
    }
}

#pragma mark  设置外部分页
-(void)setupSubViewPages:(NSArray *)pageViews withCallBackBlock:(TapBannerRollingViewBlock)block{

    
    _imageArray = pageViews;
    _pageCount = pageViews.count;
    
    //设置滚动范围
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame)*3, CGRectGetHeight(self.frame));
    
    _pageControl.numberOfPages = _pageCount;
    
    _tapBlock = block;
    
    for (int i = 0; i < 3; i++) {
        
        UIImageView  *page = [[UIImageView alloc] init];
        page.frame = CGRectMake(self.frame.size.width *i, 0, self.frame.size.width, self.frame.size.height);
        page.tag = 1000+i;
        [_scrollView addSubview:page];
    }
    
    //设置初展示图片
    
    UIImageView     *leftPage = [_scrollView viewWithTag:1000];
    UIImageView     *middlePage = [_scrollView viewWithTag:1001];
    UIImageView     *rightPage = [_scrollView viewWithTag:1002];
    
    // 一开始要显示中间的第一张，所以左边放最后一张，右边放第二张
    leftPage.image = _imageArray.lastObject;
    middlePage.image = _imageArray.firstObject;
    rightPage.image = _imageArray[1];
    
    // 设置初始偏移量和索引
    _scrollView.contentOffset  = CGPointMake(self.frame.size.width, 0);
    _pageControl.currentPage = 0;
    _prePageIndex = 0;
    
    [self startTimer];
    
}

-(void)startTimer{

    _kvTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(changePageRight) userInfo:nil repeats:YES];
    
}

-(void)stopTimer{

    [_kvTimer invalidate];
    _kvTimer = nil;
}

#pragma mark 定时器回调
-(void)changePageRight{
    
     // 往右滑并且设置小圆点，永远都是滑到第三页
    [_scrollView setContentOffset:CGPointMake(self.frame.size.width *2, 0) animated:YES];
    [self resetPageIndex:YES];
}

-(void)changePageLeft{

    // 往左滑，永远都是滑动到第一页
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self resetPageIndex:NO];
}


-(void)resetPageIndex:(BOOL)isRight{

    
    if (isRight)
    {
        // 根据之前的page下标来修改
        if (_prePageIndex == _pageCount - 1)
        {
            // 到头了就回到第一个
            _pageControl.currentPage = 0;
        }
        else
        {
            // 这里用_prePageIndex来算，否则点击小圆点条会重复计算了
            _pageControl.currentPage = _prePageIndex + 1;
        }
    }
    else
    {
        if (_prePageIndex == 0)
        {
            _pageControl.currentPage = _pageCount - 1;
        }
        else
        {
            _pageControl.currentPage = _prePageIndex - 1;
        }
    }
    _prePageIndex = _pageControl.currentPage;
}


#pragma mark pageControl 事件
-(void)pageControlTouch{

    [self stopTimer];
    
    NSInteger   currentPageIndx = _pageControl.currentPage;
    if (currentPageIndx > _prePageIndex) {
        
        //
        [self changePageRight];
    } else {
        [self changePageLeft];
    }
    
    [self startTimer];
}

#pragma mark scrollView delegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self stopTimer];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    //手动拖拽滑动结束后
    if (scrollView.contentOffset.x > self.frame.size.width) {
        
        [self resetPageIndex:YES];
    } else {
    
        [self resetPageIndex:NO];
    }
    
    [self resetPageView];
    // 开启定时器
    [self startTimer];

}


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{

    //自动滑动结束后重新设置图片
    [self resetPageView];
}


-(void)resetPageView{

    //滑动完之后又重新设置当前显示的page时中间的page
    UIImageView *leftPage = [_scrollView viewWithTag:1000];
    UIImageView *middlePage = [_scrollView viewWithTag:1001];
    UIImageView *rightPage = [_scrollView viewWithTag:1002];
    
    if (_pageControl.currentPage == _pageCount - 1)
    {
        // n- 1 -> n -> 0
        leftPage.image = _imageArray[_pageControl.currentPage - 1];
        middlePage.image = _imageArray[_pageControl.currentPage];
        rightPage.image = _imageArray.firstObject;
        
    }
    else if (_pageControl.currentPage == 0)
    {
        // n -> 0 -> 1
        // 到尾部了，改成从头开始
        leftPage.image = _imageArray.lastObject;
        middlePage.image = _imageArray.firstObject;
        rightPage.image = _imageArray[1];
    }
    else
    {
        // x - 1 -> x -> x + 1
        leftPage.image = _imageArray[_pageControl.currentPage - 1];
        middlePage.image = _imageArray[_pageControl.currentPage];
        rightPage.image = _imageArray[_pageControl.currentPage + 1];
    }
    
    // 重新设置偏移量
    _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    
}

@end





