//
//  UIImageView+TTMWebImageFetch.h
//  TTMUtilityURLImageView
//
//  Created by lzb on 3/8/17.
//  Copyright © 2017 lzb. All rights reserved.
//

#import <UIKit/UIKit.h> 

/**
 *  用法：
 *  尽量使用代码提示，键入webimage就会有多种参数选择的已经预设好的代码块
 *
 *  例如：
 *
 *  imageView.webImage
 *  .URLString(此处填入URL字符串)
 *  .placeHolderImageName(此处填入本地占位图名字)
 *  .fetch();
 *
 *  webImage代表进入图片下载模式
 *  中间各种“.”后面跟着的参数可以随意自由组合，对即将要进行的图片下载进行参数配置，免去传统多个API那种繁琐方式
 *  fetch()代表执行下载操作，fetch()之后不可以跟任何参数配置代码，一般都在最末尾
 *
 *  PS：这API看上去很玄乎，不是为了炫技或者其他目的，背后包含了很多偏学术化的编程思想，本来想解释一下的，但是涉及概念不是三言两语就能讲完的，而且同程卧虎藏龙，希望会的人专门开课给大家科普一下，以后更新维护也知道个所以然，这里我就不说了
 *  Last day contribution by JacobYang
 */
@class TTMWebImageTraits;

@interface UIImageView (TTMWebImageFetch)

@property (nonatomic, readonly, strong) TTMWebImageTraits *webImage;

@end



@class TTMWebImageProgressLineView;

@interface UIImageView (TTMWebImageProgressLineView)

@property (nonatomic, readonly) TTMWebImageProgressLineView *ttm_progressLineView;

- (void)ttm_addProgressLineView;
- (void)ttm_removeProgressLineView;

@end
