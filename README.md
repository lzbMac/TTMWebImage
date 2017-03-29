# TTMWebImage
基于SDWebImage，拓展了一种链式写法
_imgView.webImage
    .URLString(@"url")
    .placeHolderImageName(@"placeholder")
    .fetch();
    
    
//pod 安装，依赖库SDWebImage，无需重复pod
pod "TTMWebImage"
