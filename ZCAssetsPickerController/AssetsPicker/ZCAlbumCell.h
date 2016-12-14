//
//  ZCAlbumCell.h
//  ZCAssetsPickerController
//
//  Created by 赵琛 on 2016/12/12.
//  Copyright © 2016年 赵琛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCAlbumCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageV;

@property (weak, nonatomic) IBOutlet UILabel *nameLb;

@property (weak, nonatomic) IBOutlet UILabel *countLb;

@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;

@end
