//
//  TTMWebImageTraits.h
//  TTMWebImage
//
//  Created by lzb on 3/8/17.
//  Copyright © 2017 lzb. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/SDWebImageDownloader.h>

@interface TTMWebImageTraits : NSObject

@property (nonatomic, readonly, strong) TTMWebImageTraits *showProgressLine;

- (TTMWebImageTraits *(^)(NSString *))URLString;
- (TTMWebImageTraits *(^)(NSString *))placeHolderImageName;
- (TTMWebImageTraits *(^)(SDWebImageOptions))options;
- (TTMWebImageTraits *(^)(SDWebImageCompletionBlock))completion;
- (TTMWebImageTraits *(^)(SDWebImageDownloaderProgressBlock))progress;

- (void(^)())fetch;
- (void(^)())fetchCache;

- (void)reset;

- (instancetype)initWithImageView:(UIImageView *)imageView;

@end



@interface UIImage (TTMWebImageAnimationFlag)

@property (nonatomic, assign) BOOL hasAnimated;

@end
