//
//  ZCAlbumsSelectedView.h
//  ZCAssetsPickerController
//
//  Created by 赵琛 on 2016/12/12.
//  Copyright © 2016年 赵琛. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ SelectedAlbumBlock) (NSInteger selectedIndex);

@interface ZCAlbumsSelectedView : UIView

- (id)initWithMediaTypes:(NSArray *)mediaTypes;

@property (nonatomic,strong)NSArray *albums;

/**
 显示或者隐藏

 @param isShow 是否显示
 */
- (void)show:(BOOL)isShow;


/**
 刷新
 */
- (void)reloadData;

@property (nonatomic,copy) SelectedAlbumBlock selectedAlbumBlock;

@property (nonatomic, assign)NSInteger selectedIndex;

@end
