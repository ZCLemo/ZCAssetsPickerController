//
//  ZCBrowserCollectionViewCell.h
//  ZCAssetsPickerController
//
//  Created by 赵琛 on 2016/12/13.
//  Copyright © 2016年 赵琛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

#define KZCBrowserCollectionViewCellId @"ZCBrowserCollectionViewCellId"

#define KItemW KScreenWidth

#define KItemH KScreenHeight-64

@interface ZCBrowserCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)PHAsset *asset;

@end
