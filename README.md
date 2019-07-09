# ZCAssetsPickerController
根据PhotoKit写的图片，视频选择器


#### 1.在公司的项目中，图片选择的时候需要自己定义一个图片选择器，自己根据PhotoKit写了一个Demo，也顺便学习了一下PhotoKit，自己扩展了一下，既能选择图片也能选择视频。

##### 1.1 图片选择，如下图:
![IMG_2052.PNG](https://upload-images.jianshu.io/upload_images/1930004-646798c9f4ef9981.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


##### 1.2 获取相册，如下图:
![IMG_2053.PNG](https://upload-images.jianshu.io/upload_images/1930004-3ea2355325e25c91.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


##### 1.3 视频选择，如下图:
![IMG_2054.PNG](https://upload-images.jianshu.io/upload_images/1930004-7238fd62e45e5013.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


#### 2.相册和媒体的获取代码主要在ZCPhotoManager这个类里面，接下来可能写一篇关于PhotoKit介绍的博客。

##### 2.1 获取相册
``` bash
- (NSMutableArray *)showAlbums {
    
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    self.fetchResults = @[smartAlbums, topLevelUserCollections];
    
    NSMutableArray *albums = [NSMutableArray array];
    
    for (PHFetchResult *fetchResult in self.fetchResults)
    {
        for (PHCollection *collection in fetchResult) {
            if ([collection isKindOfClass:[PHAssetCollection class]])
            {
                PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
                PHFetchResult *assets = [self assetsInAssetCollection:assetCollection];
                if (assets.count > 0) {
                    if (assetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
                        [albums insertObject:assetCollection atIndex:0];
                    } else {
                        [albums addObject:assetCollection];
                    }
                    
                }
                
            }
        }
    }
    return albums;
}

```

##### 2.2 获取相册中的媒体
``` bash
- (PHFetchResult *)assetsInAssetCollection:(PHAssetCollection *)album{
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType in %@", self.mediaTypes];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    return [PHAsset fetchAssetsInAssetCollection:(PHAssetCollection *)album options:options];
}
```
##### 2.3 然后主要的功能就是图片的展示，布局。


#### 3.直接上Demo
[github地址](https://github.com/ZCLemo/ZCAssetsPickerController)

##### 3.1 由于时间比较短，里面的UI写的可能有点粗糙，主要是为了自己学习，就这样吧。
