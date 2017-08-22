//
//  ViewController.m
//  YWBannerScrollDemo
//
//  Created by sai on 2017/8/22.
//  Copyright © 2017年 BJYWT. All rights reserved.
//

#import "ViewController.h"
#import "BannerRollingView.h"

#import "BannerRollingViewPlus.h"

@interface ViewController ()<BannerRollingDelegate, BannerRollingDataSource>{
    
    // 轮播图变量，其实作为局部变量也行
    BannerRollingView       *bannerView;
    
    BannerRollingViewPlus   *bannerViewPlus;
    
    // 轮播图相关的数据
    NSArray *kvDataArray;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化一些数据
    kvDataArray = @[@"page 1", @"page 2", @"page3", @"page 4", @"page 5"];
    
    // 添加轮播图1
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 150, 30)];
    label1.text = @"两边加多余页方式";
    [self.view addSubview:label1];
    
    bannerView = [[BannerRollingView alloc] init];
    bannerView.frame = CGRectMake(0, 50, self.view.frame.size.width, 200);
    bannerView.dateSource = self;
    bannerView.delegate = self;
    [self.view addSubview:bannerView];
    
    
    
    // 添加轮播图2
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 270, 150, 30)];
    label2.text = @"三张页面循环方式";
    [self.view addSubview:label2];
    
    bannerViewPlus = [[BannerRollingViewPlus alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 200)];
    [self setBannerViewPlus];
    [self.view addSubview:bannerViewPlus];

    
}

#pragma mark - 轮播图代理

-(NSInteger)countOfCellForBannerRollingView:(BannerRollingView *)bannerRollingView{
    
    return kvDataArray.count;
}

-(UIView *)bannerRollingView:(BannerRollingView *)bannerRollingView cellAtIndex:(NSInteger)index{
    // 先用空白页测试
    //    UIView *imageView = [[UIView alloc] init];
    //    int R = (arc4random() % 256) ;
    //    int G = (arc4random() % 256) ;
    //    int B = (arc4random() % 256) ;
    //    imageView.backgroundColor = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
    
    // 填充view，可以是任意view
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg", (long)index + 1]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 100, 50)];
    label.text = kvDataArray[index];
    [imageView addSubview:label];
    
    return imageView;
    
}

-(void)bannerRollingView:(BannerRollingView *)bannerRollingView didSelectedAtIndex:(NSInteger)index{
    
    NSLog(@"%@",kvDataArray[index]);
    
}


#pragma mark - 轮播图2设置 
- (void)setBannerViewPlus
{
    // 图片数组，可以是其他的资源，设置到轮播图上就可以
    NSMutableArray *imagerray = [NSMutableArray array];
    for (int i = 0; i < kvDataArray.count; i++)
    {
        // 先用空白页测试
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i + 1]];
        [imagerray addObject:image];
    }
    
    
    [bannerViewPlus setupSubViewPages:imagerray withCallBackBlock:^(NSInteger index) {
        NSLog(@"clicked %ld", (long)index);
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
