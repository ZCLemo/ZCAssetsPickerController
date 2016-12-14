//
//  ZCAssetsPickerViewController.h
//  ZCAssetsPickerController
//
//  Created by 赵琛 on 2016/12/9.
//  Copyright © 2016年 赵琛. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ZCAssetsPickerViewControllerDelegate <NSObject>

- (void)finishPickWithSelectedAssets:(NSArray *)selectedAsset;

@end

/**
 选取类型

 - ChooseTypePhoto: 照片
 - ChooseTypeVideo: 视频
 - ChooseTypeMedia: 照片和视频
 */
typedef NS_ENUM(NSInteger, ChooseType){
    ChooseTypePhoto,
    ChooseTypeVideo,
    ChooseTypeMedia,
};

@interface ZCAssetsPickerViewController : UIViewController

//最大选取数量
@property (nonatomic,assign) NSInteger maximumNumbernMedia;
//选取类型
@property (nonatomic,assign) ChooseType type;

@property (nonatomic,weak) id<ZCAssetsPickerViewControllerDelegate> delegate;

@end
