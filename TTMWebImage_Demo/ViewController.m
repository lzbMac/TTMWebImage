//
//  ViewController.m
//  TTMWebImage_Demo
//
//  Created by 李正兵 on 2017/3/16.
//  Copyright © 2017年 李正兵. All rights reserved.
//

#import "ViewController.h"
#import "TTMWebImage.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgTop;
@property (weak, nonatomic) IBOutlet UIImageView *imgMid;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imgMid.webImage
    .URLString(@"https://upload-images.jianshu.io/upload_images/1634654-16fc1b4c176fed6d.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240")
    .placeHolderImageName(@"")
    .fetch();
    
    
    _imgTop.webImage
    .URLString(@"https://upload-images.jianshu.io/upload_images/1634654-16fc1b4c176fed6d.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240")
    .placeHolderImageName(@"")
    .completion(^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    })
    .fetch();
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
