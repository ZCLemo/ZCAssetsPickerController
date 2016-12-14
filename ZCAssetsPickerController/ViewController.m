//
//  ViewController.m
//  ZCAssetsPickerController
//
//  Created by 赵琛 on 2016/12/9.
//  Copyright © 2016年 赵琛. All rights reserved.
//

#import "ViewController.h"
#import "ZCAssetsPickerViewController.h"
#import <Photos/Photos.h>

@interface ViewController ()<ZCAssetsPickerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) PHCachingImageManager *imageManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.imageManager = [[PHCachingImageManager alloc] init];
}


#pragma mark - Events

- (IBAction)choosePhotos:(id)sender {
    ZCAssetsPickerViewController *picker = [[ZCAssetsPickerViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:picker];
    picker.type = ChooseTypePhoto;
    picker.maximumNumbernMedia = 9;
    picker.delegate = self;
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)chooseVideos:(id)sender {
    ZCAssetsPickerViewController *picker = [[ZCAssetsPickerViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:picker];
    picker.type = ChooseTypeVideo;
    picker.maximumNumbernMedia = 8;
    picker.delegate = self;
   [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)photosAndVideos:(id)sender {
    ZCAssetsPickerViewController *picker = [[ZCAssetsPickerViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:picker];
    picker.type = ChooseTypeMedia;
    picker.maximumNumbernMedia = 4;
    picker.delegate = self;
   [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - ZCAssetsPickerViewControllerDelegate

- (void)finishPickWithSelectedAssets:(NSArray *)selectedAsset
{
    
    if (selectedAsset.count == 0) {
        return;
    }
    PHAsset *asset = selectedAsset.firstObject;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    __weak typeof(self) weakSelf = self;
    [self.imageManager requestImageForAsset:asset
                                 targetSize:CGSizeMake([UIScreen mainScreen].scale * self.imageView.frame.size.width, [UIScreen mainScreen].scale * self.imageView.frame.size.height)
                                contentMode:PHImageContentModeAspectFill
                                    options:options
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  if (result) {
                                      weakSelf.imageView.image = result;
                                  }
                              }];
    

}

@end
