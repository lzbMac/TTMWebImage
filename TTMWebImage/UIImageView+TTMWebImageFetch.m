//
//  UIImageView+TTMWebImageFetch.m
//  TTMUtilityURLImageView
//
//  Created by lzb on 3/8/17.
//  Copyright © 2017 lzb. All rights reserved.
//

#import "UIImageView+TTMWebImageFetch.h"
#import "TTMWebImageTraits.h"
#import <objc/runtime.h> 

@implementation UIImageView (TTMWebImageFetch)

- (TTMWebImageTraits *)webImage
{
    TTMWebImageTraits *traits = objc_getAssociatedObject(self, _cmd);
    
    if (traits) {
        [traits reset];
    } else {
        traits = [TTMWebImageTraits.alloc initWithImageView:self];
        objc_setAssociatedObject(self, _cmd, traits, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return traits;
}

@end



#import "TTMWebImageProgressLineView.h"

static char PROGRESS_LINE_VIEW;

@implementation UIImageView (TTMWebImageProgressLineView)

- (void)ttm_addProgressLineView
{
    if (self.ttm_progressLineView) {
        return;
    }
    
    TTMWebImageProgressLineView *lineView = [TTMWebImageProgressLineView new];
    lineView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:lineView];
    
    [self addConstraints:
     @[[NSLayoutConstraint constraintWithItem:lineView
                                    attribute:NSLayoutAttributeLeading
                                    relatedBy:NSLayoutRelationEqual
                                       toItem:self
                                    attribute:NSLayoutAttributeLeading
                                   multiplier:1
                                     constant:50],
       [NSLayoutConstraint constraintWithItem:lineView
                                    attribute:NSLayoutAttributeTrailing
                                    relatedBy:NSLayoutRelationEqual
                                       toItem:self
                                    attribute:NSLayoutAttributeTrailing
                                   multiplier:1
                                     constant:-50],
       [NSLayoutConstraint constraintWithItem:lineView
                                    attribute:NSLayoutAttributeCenterY
                                    relatedBy:NSLayoutRelationEqual
                                       toItem:self
                                    attribute:NSLayoutAttributeCenterY
                                   multiplier:1
                                     constant:0]
       ]
     ];
    
    objc_setAssociatedObject(self, &PROGRESS_LINE_VIEW, lineView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)ttm_removeProgressLineView
{
    if (!self.ttm_progressLineView) {
        return;
    }
    
    [self.ttm_progressLineView removeFromSuperview];
    objc_setAssociatedObject(self, &PROGRESS_LINE_VIEW, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TTMWebImageProgressLineView *)ttm_progressLineView
{
    return objc_getAssociatedObject(self, &PROGRESS_LINE_VIEW);
}

@end
