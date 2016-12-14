//
//  ZCTitleView.h
//  ZCAssetsPickerController
//
//  Created by 赵琛 on 2016/12/12.
//  Copyright © 2016年 赵琛. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ ClickedBlock)(BOOL isShow);

@interface ZCTitleView : UIView

@property (nonatomic,strong)NSString *buttonTitle;

@property (nonatomic,copy) ClickedBlock clickedBlock;

@property (nonatomic,assign)BOOL isOpen;

/**
 旋转箭头
 */
- (void)rotateArrow;

@end
