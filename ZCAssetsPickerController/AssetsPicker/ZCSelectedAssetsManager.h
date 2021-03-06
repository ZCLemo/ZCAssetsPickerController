//
//  ZCSelectedAssetsManager.h
//  ZCAssetsPickerController
//
//  Created by 赵琛 on 2016/12/13.
//  Copyright © 2016年 赵琛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface ZCSelectedAssetsManager : NSObject

+ (ZCSelectedAssetsManager *)sharedInstance;

@property (nonatomic,assign) NSInteger maximumNumbernMedia;

/**
 选中媒体

 @param asset 媒体
 */
- (BOOL)addAssetWithAsset:(PHAsset *)asset;


/**
 删除媒体

 @param asset 媒体
 */
- (void)removeAssetWithAsset:(PHAsset *)asset;


/**
 返回所有选中的媒体

 @return 媒体数组
 */
- (NSArray *)allSelectedAssets;


/**
 删除所有选中的数组
 */
- (void)removeAllSelectedAssets;


@end
