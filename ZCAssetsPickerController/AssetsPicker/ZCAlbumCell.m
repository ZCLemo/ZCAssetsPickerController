//
//  ZCAlbumCell.m
//  ZCAssetsPickerController
//
//  Created by 赵琛 on 2016/12/12.
//  Copyright © 2016年 赵琛. All rights reserved.
//

#import "ZCAlbumCell.h"

@interface ZCAlbumCell ()

@end

@implementation ZCAlbumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.thumbnailImageV.contentMode = UIViewContentModeScaleAspectFill;
    
    self.selectedBtn.userInteractionEnabled = NO;
}


@end
