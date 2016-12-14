//
//  ZCAssetsPickerViewController.m
//  ZCAssetsPickerController
//
//  Created by 赵琛 on 2016/12/9.
//  Copyright © 2016年 赵琛. All rights reserved.
//

#import "ZCAssetsPickerViewController.h"
#import "ZCAssetCollectionViewCell.h"
#import "ZCTitleView.h"
#import "ZCAlbumsSelectedView.h"
#import "ZCPhotoManager.h"
#import "ZCBrowserViewController.h"
#import "ZCSelectedAssetsManager.h"
#import <Photos/Photos.h>

@implementation NSIndexSet (Convenience)

- (NSArray *)aapl_indexPathsFromIndexesWithSection:(NSUInteger)section {
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:idx inSection:section]];
    }];
    return indexPaths;
}

@end

@implementation UICollectionView (Convenience)

- (NSArray *)aapl_indexPathsForElementsInRect:(CGRect)rect {
    NSArray *allLayoutAttributes = [self.collectionViewLayout layoutAttributesForElementsInRect:rect];
    if (allLayoutAttributes.count == 0) { return nil; }
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:allLayoutAttributes.count];
    for (UICollectionViewLayoutAttributes *layoutAttributes in allLayoutAttributes) {
        NSIndexPath *indexPath = layoutAttributes.indexPath;
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

@end

@interface ZCAssetsPickerViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong)ZCPhotoManager *photoManager;

//选中的相册
@property (nonatomic, assign) NSInteger selectedGroup;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) PHCachingImageManager *imageManager;

@property (nonatomic, strong) NSArray <PHAssetCollection *>*albums;

@property (nonatomic, strong) NSArray *mediaTypes;

@property (nonatomic,assign) CGRect previousPreheatRect;

@property (nonatomic,strong) PHFetchResult *assets;

@property (nonatomic,strong) ZCTitleView *titleView;

@property (nonatomic,strong) ZCAlbumsSelectedView *albumsView;

@end

@implementation ZCAssetsPickerViewController

#pragma mark - lifeCycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    self.selectedGroup = 0;
    self.maximumNumbernMedia = 0;
    self.imageManager = [[PHCachingImageManager alloc] init];
    self.previousPreheatRect = CGRectZero;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateCachedAssets];
}

#pragma mark - Private Methods

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneClick)];

}

- (void)updateRightBarButtonItem
{
    if ([ZCSelectedAssetsManager sharedInstance].allSelectedAssets.count == 0   ) {
        self.navigationItem.rightBarButtonItem.title = @"完成";
        return;
    }
    
    self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"完成(%zd)",[ZCSelectedAssetsManager sharedInstance].allSelectedAssets.count];
}

#pragma mark - setter & getter

- (void)setType:(ChooseType)type
{
    _type = type;
    
    switch (_type) {
        case ChooseTypePhoto:{
            self.mediaTypes = @[@(PHAssetMediaTypeImage)];
        }
            
            break;
            
        case ChooseTypeVideo:{
            self.mediaTypes = @[@(PHAssetMediaTypeVideo)];
        }
            
            break;
            
        case ChooseTypeMedia:{
            self.mediaTypes = @[@(PHAssetMediaTypeImage), @(PHAssetMediaTypeVideo)];
            
        }
            break;
            
        default:
            break;
    }
    
    self.photoManager = [[ZCPhotoManager alloc] initWithMediaTypes:self.mediaTypes];
    [self getAlbums];
    [self.view addSubview:self.albumsView];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(KItemHW, KItemHW);
        layout.sectionInset = UIEdgeInsetsMake(1.0, 0, 0, 0);
        layout.minimumInteritemSpacing = KSpace;
        layout.minimumLineSpacing  = KSpace;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) collectionViewLayout:layout];
        _collectionView.allowsMultipleSelection = YES;
        [_collectionView registerClass:[ZCAssetCollectionViewCell class]
                forCellWithReuseIdentifier:KZCAssetCollectionViewCellId];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.bounces = YES;
        _collectionView.scrollsToTop = YES;
        
    }
   return _collectionView;
}

- (ZCTitleView *)titleView
{
    if (!_titleView) {
        _titleView = [[ZCTitleView alloc] initWithFrame:CGRectMake(0, 0, 250, 44)];
        __weak typeof(self) weakSelf = self;
        _titleView.clickedBlock = ^(BOOL isShow){
            [weakSelf.albumsView show:isShow];
        };
    }
    return _titleView;
}

- (ZCAlbumsSelectedView *)albumsView
{
    if (!_albumsView) {
        _albumsView = [[ZCAlbumsSelectedView alloc] initWithMediaTypes:self.mediaTypes];
        _albumsView.frame = CGRectMake(0, 64, KScreenWidth, 0);
        __weak typeof(self) weakSelf = self;
        _albumsView.selectedAlbumBlock = ^(NSInteger selectedIndex){
            weakSelf.selectedGroup = selectedIndex;
        
            weakSelf.titleView.isOpen = NO;
            [weakSelf.titleView rotateArrow];
            
            [weakSelf selectAlbumWithIndex:weakSelf.selectedGroup];
        };
    }
    return _albumsView;
}

- (void)setMaximumNumbernMedia:(NSInteger)maximumNumbernMedia
{
    _maximumNumbernMedia = maximumNumbernMedia;
    [ZCSelectedAssetsManager sharedInstance].maximumNumbernMedia = _maximumNumbernMedia;
}

#pragma mark - event

- (void)cancelClick
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [[ZCSelectedAssetsManager sharedInstance] removeAllSelectedAssets];
    }];
}

- (void)doneClick
{
    if (self.delegate) {
        [self.delegate finishPickWithSelectedAssets:[ZCSelectedAssetsManager sharedInstance].allSelectedAssets];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [[ZCSelectedAssetsManager sharedInstance] removeAllSelectedAssets];
    }];
}


#pragma mark - 相册和照片获取

//获取相册

- (void)getAlbums
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusAuthorized) {
                    [weakSelf selectAlbumWithIndex:self.selectedGroup];
                } else {
                    [weakSelf showNoAuthority];
                }
            });
        }];
    } else if (status == PHAuthorizationStatusAuthorized) {
        [self selectAlbumWithIndex:self.selectedGroup];
    } else {
        [self showNoAuthority];
    }
    
}

- (void)selectAlbumWithIndex:(NSInteger)index
{
    self.albums = [self.photoManager showAlbums];
    
    if (self.albums.count == 0) {
        return;
    }
    PHAssetCollection *album = self.albums[index];
    self.assets = [self.photoManager assetsInAssetCollection:album];
    [self.collectionView reloadData];
    
    self.titleView.buttonTitle = album.localizedTitle;
    self.navigationItem.titleView = self.titleView;
    
    self.albumsView.albums = self.albums;
    [self.albumsView reloadData];
}

// 无权限
- (void)showNoAuthority {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"请在\"设置\"->\"隐私\"->\"相册\"开启访问权限" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - 照片缓存

- (void)updateCachedAssets
{
    BOOL isViewVisible = [self isViewLoaded] && [[self view] window] != nil;
    if (!isViewVisible) { return; }
    
    // The preheat window is twice the height of the visible rect
    CGRect preheatRect = self.collectionView.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0f, -0.5f * CGRectGetHeight(preheatRect));
    
    // If scrolled by a "reasonable" amount...
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    if (delta > CGRectGetHeight(self.collectionView.bounds) / 3.0f) {
        
        // Compute the assets to start caching and to stop caching.
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];
        
        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect removedHandler:^(CGRect removedRect) {
            NSArray *indexPaths = [self.collectionView aapl_indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        } addedHandler:^(CGRect addedRect) {
            NSArray *indexPaths = [self.collectionView aapl_indexPathsForElementsInRect:addedRect];
            [addedIndexPaths addObjectsFromArray:indexPaths];
        }];
        
        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];
        
        [self.imageManager startCachingImagesForAssets:assetsToStartCaching
                                            targetSize:KAssetGridThumbnailSize
                                           contentMode:PHImageContentModeAspectFill
                                               options:nil];
        [self.imageManager stopCachingImagesForAssets:assetsToStopCaching
                                           targetSize:KAssetGridThumbnailSize
                                          contentMode:PHImageContentModeAspectFill
                                              options:nil];
        
        self.previousPreheatRect = preheatRect;
    }
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(CGRect removedRect))removedHandler addedHandler:(void (^)(CGRect addedRect))addedHandler
{
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}



- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths
{
    if (indexPaths.count == 0) { return nil; }
    
    NSMutableArray *indexPathAssets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        PHAsset *asset = self.assets[indexPath.item];
        [indexPathAssets addObject:asset];
    }
    return indexPathAssets;
}


#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZCAssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KZCAssetCollectionViewCellId forIndexPath:indexPath];
    PHAsset *asset = self.assets[indexPath.row];
    cell.asset = asset;
    cell.indexPath = indexPath;
    cell.selectedBtn.selected = [[ZCSelectedAssetsManager sharedInstance].allSelectedAssets containsObject:asset];
    
    __weak typeof(self) weakSelf = self;
    cell.selectedBlock = ^(PHAsset *handleAsset,NSIndexPath *handleIndexPath){
        if (![[ZCSelectedAssetsManager sharedInstance].allSelectedAssets containsObject:handleAsset]) {
            
            [[ZCSelectedAssetsManager sharedInstance] addAssetWithAsset:asset];
            
        }else{
            [[ZCSelectedAssetsManager sharedInstance] removeAssetWithAsset:asset];
        }
        
        [weakSelf updateRightBarButtonItem];
        [weakSelf.collectionView reloadItemsAtIndexPaths:@[handleIndexPath]];
    };
    return cell;
}

#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZCBrowserViewController *browserVC = [[ZCBrowserViewController alloc] init];
    browserVC.assets = self.assets;
    browserVC.currentIndex = indexPath.row;
    __weak typeof(self) weakSelf = self;
    browserVC.assetSelectedBlock = ^(NSInteger currentIndex){
        NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
        [weakSelf.collectionView reloadItemsAtIndexPaths:@[currentIndexPath]];
        [weakSelf updateRightBarButtonItem];
    };
    [self.navigationController pushViewController:browserVC animated:YES];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Update cached assets for the new visible area.
    [self updateCachedAssets];
}


@end
