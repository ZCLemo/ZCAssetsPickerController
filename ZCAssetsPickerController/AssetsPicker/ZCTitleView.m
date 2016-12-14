//
//  ZCTitleView.m
//  ZCAssetsPickerController
//
//  Created by 赵琛 on 2016/12/12.
//  Copyright © 2016年 赵琛. All rights reserved.
//

#import "ZCTitleView.h"

@interface ZCTitleView ()

@property (nonatomic,strong)UIButton *titleBtn;

@end

@implementation ZCTitleView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.titleBtn];
    
        self.isOpen = NO;
    }
    return self;
}


#pragma mark - setter & getter

- (UIButton *)titleBtn
{
    if (!_titleBtn) {
        _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleBtn.frame = CGRectMake(0, 0, 250, 44);
        [_titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _titleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_titleBtn setImage:[UIImage imageNamed:@"ic_xiala_black"] forState:UIControlStateNormal];
        _titleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -11, 0, 11);
        [_titleBtn addTarget:self action:@selector(titleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleBtn;
}

- (void)setButtonTitle:(NSString *)buttonTitle
{
    if (!buttonTitle) {
        return;
    }
    _buttonTitle = buttonTitle;
    [self.titleBtn setTitle:_buttonTitle forState:UIControlStateNormal];
}
#pragma event

- (void)titleBtnClicked:(UIButton *)sender
{
    self.isOpen = !self.isOpen;
    [self rotateArrow];
}

- (void)rotateArrow
{
    [UIView animateWithDuration:0.35 animations:^{
        if(self.isOpen)
        {
            self.titleBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        }
        else
        {
            self.titleBtn.imageView.transform = CGAffineTransformIdentity;
        }
    } completion:^(BOOL finished) {
    }];
    
    if (self.clickedBlock) {
        self.clickedBlock(self.isOpen);
    }
}

@end
