//
//  ZCAlbumsSelectedView.m
//  ZCAssetsPickerController
//
//  Created by 赵琛 on 2016/12/12.
//  Copyright © 2016年 赵琛. All rights reserved.
//

#import "ZCAlbumsSelectedView.h"
#import "ZCAlbumCell.h"
#import "ZCPhotoManager.h"

@interface ZCAlbumsSelectedView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSArray *mediaTypes;

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)ZCPhotoManager *photoManager;

@property (nonatomic, strong)PHCachingImageManager *imageManager;

@end

@implementation ZCAlbumsSelectedView

- (instancetype)initWithMediaTypes:(NSArray *)mediaTypes{
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        self.mediaTypes = mediaTypes;
        self.photoManager = [[ZCPhotoManager alloc] initWithMediaTypes:self.mediaTypes];
        self.imageManager = [[PHCachingImageManager alloc] init];
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.tableView];
    }
    return self;
}

#pragma mark - setter & getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60.0f;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"ZCAlbumCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZCAlbumCellId"];
    }
    return _tableView;
}

- (void)reloadData
{
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.albums.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZCAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCAlbumCellId" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PHAssetCollection *album = self.albums[indexPath.row];
    PHFetchResult *assets = [self.photoManager assetsInAssetCollection:album];
    
    cell.countLb.text = [NSString stringWithFormat:@"%zd张",assets.count];
    cell.nameLb.text = album.localizedTitle;
    
    PHAsset *asset = nil;
    if (assets.count > 0) {
        asset = assets.firstObject;
    }
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    [self.imageManager requestImageForAsset:asset
                                 targetSize:CGSizeMake(60*[UIScreen mainScreen].scale, 60*[UIScreen mainScreen].scale)
                                contentMode:PHImageContentModeAspectFill
                                    options:options
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  cell.thumbnailImageV.image = result;
                              }];
    
    cell.selectedBtn.selected = (self.selectedIndex == indexPath.row);
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedAlbumBlock) {
        self.selectedAlbumBlock(indexPath.row);
    }
    self.selectedIndex = indexPath.row;
    [self show:NO];
}

#pragma show 

- (void)show:(BOOL)isShow
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2f animations:^{
        if (isShow) {
            weakSelf.frame = CGRectMake(0, 64 , KScreenWidth, KScreenHeight-64);
        }else{
            weakSelf.frame = CGRectMake(0, 64, KScreenWidth, 0);
        }
        
    } completion:^(BOOL finished) {
        
    }];
}


@end
