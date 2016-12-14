//
//  ZCPhotoManager.h
//  ZCAssetsPickerController
//
//  Created by 赵琛 on 2016/12/12.
//  Copyright © 2016年 赵琛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface ZCPhotoManager : NSObject

- (id)initWithMediaTypes:(NSArray *)mediaTypes;


/**
 获取相册

 @return 相册
 */
- (NSMutableArray *)showAlbums;


/**
 获取相册中的媒体

 @param album 相册
 @return 媒体
 */
- (PHFetchResult *)assetsInAssetCollection:(PHAssetCollection *)album;

@end
