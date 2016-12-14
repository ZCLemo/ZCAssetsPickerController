//
//  ZCBrowserViewController.h
//  ZCAssetsPickerController
//
//  Created by 赵琛 on 2016/12/13.
//  Copyright © 2016年 赵琛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef void(^ AssetSelectedBlock)(NSInteger currentIndex);

@interface ZCBrowserViewController : UIViewController

@property (nonatomic,strong) PHFetchResult *assets;

@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic,copy) AssetSelectedBlock assetSelectedBlock;

@end
