//
//  ZCAssetCollectionViewCell.h
//  ZCAssetsPickController
//
//  Created by 赵琛 on 2016/12/8.
//  Copyright © 2016年 赵琛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

#define KZCAssetCollectionViewCellId @"ZCAssetCollectionViewCell"

#define KSpace 1.0

#define KLineCount 3

#define KItemHW (KScreenWidth - KSpace * (KLineCount - 1)) / KLineCount

#define KAssetGridThumbnailSize CGSizeMake(KItemHW * [UIScreen mainScreen].scale, KItemHW * [UIScreen mainScreen].scale)

typedef void(^ SelectedBlock)(PHAsset *handleAsset,NSIndexPath *indexPath);

@interface ZCAssetCollectionViewCell : UICollectionViewCell

@property (nonatomic,copy) SelectedBlock selectedBlock;

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,strong)PHAsset *asset;

@property (nonatomic,strong)UIButton *selectedBtn;

@end
