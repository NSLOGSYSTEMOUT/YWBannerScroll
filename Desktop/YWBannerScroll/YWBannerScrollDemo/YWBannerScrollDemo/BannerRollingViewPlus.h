//
//  BannerRollingViewPlus.h
//  YWBannerScrollDemo
//
//  Created by sai on 2017/8/22.
//  Copyright © 2017年 BJYWT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapBannerRollingViewBlock)(NSInteger index);

@interface BannerRollingViewPlus : UIView

//填充分页并设置回调
-(void)setupSubViewPages:(NSArray*)pageViews withCallBackBlock:(TapBannerRollingViewBlock)block;

@end
