//
//  BannerRollingView.h
//  YWBannerScroll
//
//  Created by sai on 2017/8/21.
//  Copyright © 2017年 BJYWT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BannerRollingView;
#pragma mark 轮播图片的Datasource 协议

@protocol BannerRollingDataSource <NSObject>

@required

@optional

//轮播图的个数
-(NSInteger)countOfCellForBannerRollingView:(BannerRollingView *)bannerRollingView;
//轮播图填充
-(UIView *)bannerRollingView:(BannerRollingView *)bannerRollingView cellAtIndex:(NSInteger)index;

@end


#pragma mark 轮播图的Delegate协议

@protocol BannerRollingDelegate <NSObject>

@required

@optional
//选中轮播图的index
-(void)bannerRollingView:(BannerRollingView *)bannerRollingView didSelectedAtIndex:(NSInteger)index;

@end


@interface BannerRollingView : UIView

@property(nonatomic, weak)id <BannerRollingDelegate> delegate;
@property(nonatomic, weak)id <BannerRollingDataSource> dateSource;

@end
