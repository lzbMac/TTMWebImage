//
//  TTMWebImageTraits.m
//  TTMWebImage
//
//  Created by lzb on 3/8/17.
//  Copyright © 2017 lzb. All rights reserved.
//

#import "TTMWebImageTraits.h"
#import "TTMWebImage.h"


#define kIMAGEDOWNLOADFINISHED  @"kImageDownloadFinish"

NSString *const TTMURLImageDownloadFailNotification = @"TTMURLImageDownloadFailNotification";
NSString *const TTMLargeImageDownloadNotification = @"TTMLargeImageDownloadNotification";

@implementation TTMWebImageTraits
{
    __weak UIImageView *_imageView;
    BOOL _showProgressLine;
    NSString *_URLString;
    NSString *_placeHolderImageName;
    NSInteger _imageSize;
    SDWebImageOptions _options;
    SDWebImageCompletionBlock _completion;
    SDWebImageDownloaderProgressBlock _progress;
}

- (void (^)())fetch
{
    if (!_imageView) return ^{};
    if (!_URLString.length) {
        if (_placeHolderImageName.length > 0) {
            _imageView.image = [UIImage imageNamed:_placeHolderImageName];
        }
        return ^{};
    }
    
    return ^{
        
        if (_showProgressLine) {
            [_imageView ttm_addProgressLineView];
        }
        NSURL *url = [NSURL URLWithString:_URLString];
        if (!url) { return; }
        [_imageView sd_setImageWithURL:url
                      placeholderImage:[UIImage imageNamed:_placeHolderImageName]
                               options:_options
                              progress:^(NSInteger receivedSize, NSInteger expectedSize)
         {
             if (_showProgressLine) {
                 if (expectedSize > 0 && receivedSize > 0) {
                     _imageView.ttm_progressLineView.progress = (CGFloat)receivedSize / expectedSize;
                 }
             }
             
             if (expectedSize > 0) {
                 _imageSize = expectedSize / 1024;
             }
             
             !_progress ?: _progress(receivedSize, expectedSize);
         }
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             if (_showProgressLine) {
                 [_imageView ttm_removeProgressLineView];
             }
             
             if (image && !error) {
                 // 图片下载完后的渐变动画，只做一次
                 if (!image.hasAnimated && _imageView) {
                     image.hasAnimated = YES;
                     CATransition *transition = [CATransition animation];
                     transition.duration = 0.5;
                     transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                     transition.type = kCATransitionFade;
                     [_imageView.layer addAnimation:transition forKey:@"TTMWebImageFade"];
                     
                     // 大图监控(大于300KB)，下载完成后只做一次
                     if (_imageSize > 300) {
                         NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                         [dictionary setValue:[imageURL absoluteString] forKey:@"URLString"];
                         [dictionary setValue:[NSString stringWithFormat:@"%@KB", @(_imageSize)] forKey:@"ImageSize"];
                         [[NSNotificationCenter defaultCenter] postNotificationName:TTMLargeImageDownloadNotification object:dictionary];
                     }
                 }
                 
                 // 图片下载完成通知，保留使用
                 [[NSNotificationCenter defaultCenter] postNotificationName:kIMAGEDOWNLOADFINISHED object:_imageView];
             }
             
             if (error) {
                 NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                 [dictionary setValue:[imageURL absoluteString] forKey:@"URLString"];
                 [dictionary setValue:error forKey:@"ERROR"];
                 [[NSNotificationCenter defaultCenter] postNotificationName:TTMURLImageDownloadFailNotification object:dictionary];
             }
             
             !_completion ?: _completion(image, error, cacheType, imageURL);
         }];
    };
}

- (void (^)())fetchCache
{
    if (!_imageView) return ^{};
    if (!_URLString.length) return ^{};
    
    return ^{
        NSURL *imageURL = [NSURL URLWithString:_URLString];
        NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:imageURL];
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
        if (image) {
            _imageView.image = image;
            // 图片下载完后的渐变动画，只做一次
            if (!image.hasAnimated) {
                image.hasAnimated = YES;
                CATransition *transition = [CATransition animation];
                transition.duration = 0.5;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionFade;
                [_imageView.layer addAnimation:transition forKey:@"TTMWebImageFade"];
            }
        }
        
        !_completion ?: _completion(image, nil, SDImageCacheTypeDisk, imageURL);
    };
}

- (void)reset
{
    _showProgressLine = NO;
    _URLString = nil;
    _placeHolderImageName = nil;
    _options = 0;
    _imageSize = 0;
    _progress = nil;
    _completion = nil;
}

- (instancetype)initWithImageView:(UIImageView *)imageView
{
    if (self = [super init]) {
        _imageView = imageView;
    }
    return self;
}

- (TTMWebImageTraits *)showProgressLine
{
    _showProgressLine = YES;
    return self;
}

- (TTMWebImageTraits *(^)(NSString *))URLString
{
    return ^TTMWebImageTraits *(NSString *URLString){
        _URLString = URLString;
        return self;
    };
}

- (TTMWebImageTraits *(^)(NSString *))placeHolderImageName
{
    return ^TTMWebImageTraits *(NSString *placeHolderImageName){
        _placeHolderImageName = placeHolderImageName;
        return self;
    };
}

- (TTMWebImageTraits *(^)(SDWebImageOptions))options
{
    return ^TTMWebImageTraits *(SDWebImageOptions options){
        _options = options;
        return self;
    };
}

- (TTMWebImageTraits *(^)(SDWebImageCompletionBlock))completion
{
    return ^TTMWebImageTraits *(SDWebImageCompletionBlock completion){
        _completion = completion;
        return self;
    };
}

- (TTMWebImageTraits *(^)(SDWebImageDownloaderProgressBlock))progress
{
    return ^TTMWebImageTraits *(SDWebImageDownloaderProgressBlock progress){
        _progress = progress;
        return self;
    };
}

@end

#import <objc/runtime.h>

static char kHasAnimated;
@implementation UIImage (TTMWebImageAnimationFlag)

- (BOOL)hasAnimated
{
    return [objc_getAssociatedObject(self, &kHasAnimated) boolValue];
}

- (void)setHasAnimated:(BOOL)hasAnimated
{
    objc_setAssociatedObject(self, &kHasAnimated, @(hasAnimated), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
