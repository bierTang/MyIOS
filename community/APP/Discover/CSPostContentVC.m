//
//  CSPostContentVC.m
//  community
//
//  Created by 蔡文练 on 2019/10/16.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "CSPostContentVC.h"
#import "STTextView.h"
#import "PhotoCell.h"
#import "VideoPicked.h"

#define VIDEOCACHEPATH [NSTemporaryDirectory() stringByAppendingPathComponent:@"videoCache"]

@interface CSPostContentVC ()<UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong)STTextView *inputView;
@property (nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic,strong)UIView *btnbgView;
@property (nonatomic,strong)UIButton *imageBtn;
@property (nonatomic,strong)UIButton *videoBtn;

@property (nonatomic,strong)NSMutableArray<PickerModel *> *dataArr;
@property (nonatomic,strong)NSMutableArray<PickerModel *> *tmpArr;

@property (nonatomic,strong)VideoPicked *videoPickView;
@property (nonatomic,strong)UIButton *postBtn;

///1图片  2视频
@property (nonatomic,assign)NSInteger postType;
@property (nonatomic,strong)NSString *videoPath;

@end

@implementation CSPostContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArr = [NSMutableArray new];
    self.tmpArr = [NSMutableArray new];
    
    self.title = @"发布内容";
    
    [self setUpNav];
    
    [self initUI];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endofEdit)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
}
-(void)endofEdit{
    [self.view endEditing:YES];
}
-(void)setUpNav{
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 78, 44)];
    
    self.postBtn = [[UIButton alloc] initWithFrame:CGRectMake(35, 11, 44, 22)];
    [rightButtonView addSubview:self.postBtn];
    self.postBtn.backgroundColor = [UIColor colorWithHexString:@"08c567"];
    self.postBtn.layer.cornerRadius = 4;
    self.postBtn.clipsToBounds = YES;
    [self.postBtn setTitle:@"发布" forState:UIControlStateNormal];
    self.postBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.postBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.postBtn addTarget:self action:@selector(postContent:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
}

#pragma mark --发布内容
-(void)postContent:(UIButton *)sender{
    NSLog(@"发布内容");
  
    if (self.postType < 1 && self.inputView.text.length < 1) {
        [[MYToast makeText:@"请先添加内容"]show];
        return;
    }
    
    NSDictionary *param;
    if (self.postType == 1) {
        NSMutableArray *imgArr = [NSMutableArray new];
        for (int i=0; i<self.tmpArr.count; i++) {
            [imgArr addObject:[NSString stringWithFormat:@"%@",self.tmpArr[i].link]];
        }
        param = @{@"user_id":[UserTools userID],@"type":@"1",@"content":self.inputView.text,@"images":imgArr};
    }else if(self.postType ==2){
        param = @{@"user_id":[UserTools userID],@"type":@"2",@"content":self.inputView.text,@"video_file":self.videoPath};
    }else{
        param = @{@"user_id":[UserTools userID],@"type":@"3",@"content":self.inputView.text};
    }
    
    __weak typeof(self) wself = self;
    [[AppRequest sharedInstance]requstPostContent:param Block:^(AppRequestState state, id  _Nonnull result) {
        NSLog(@"发布：：%@",result);
        if (state == AppRequestState_Success) {
            [[MYToast makeText:@"发布成功，已提交后台审核"]show];
            [wself.navigationController popViewControllerAnimated:YES];
        }else if(result[@"msg"]){
            [[MYToast makeText:result[@"msg"]]show];
        }else{
            [[MYToast makeText:@"发布失败"]show];
        }
    }];
   
}

-(void)initUI{
    
    self.inputView = [[STTextView alloc]initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH-32, 100)];
    self.inputView.placeholder = @"记录这一刻";
    [self.view addSubview:self.inputView];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.top.equalTo(self.inputView.bottom).offset(10);
        make.height.equalTo(450);
    }];
    
    self.videoPickView = [[VideoPicked alloc]init];
    [self.view addSubview:self.videoPickView];
    self.videoPickView.hidden = YES;
    [self.videoPickView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(self.inputView.bottom).offset(10);
        make.height.equalTo(200);
        make.width.equalTo(300);
    }];
    
    __weak typeof(self) wself = self;
    self.videoPickView.delBlock = ^{
        wself.videoPickView.bgImage.image = nil;
        wself.videoPickView.hidden = YES;
        wself.imageBtn.enabled = YES;
        wself.videoBtn.enabled = YES;
        wself.postType = 0;
    };
    
    self.btnbgView = [[UIView alloc]init];
    [self.view addSubview:self.btnbgView];
    [self.btnbgView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-KBottomSafeArea);
        make.left.right.equalTo(0);
        make.height.equalTo(100);
    }];
    
    self.imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.imageBtn setImage:[UIImage imageNamed:@"postImgIcon"] forState:UIControlStateNormal];
    [self.imageBtn setImage:[UIImage imageNamed:@"postImage_hoverIcon"] forState:UIControlStateDisabled];
    [self.imageBtn addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnbgView addSubview:self.imageBtn];
    
    [self.imageBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(105);
        make.bottom.equalTo(-20);
    }];
    
    self.videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.videoBtn setImage:[UIImage imageNamed:@"postVideoIcon"] forState:UIControlStateNormal];
    [self.videoBtn setImage:[UIImage imageNamed:@"postVideo_hoverIcon"] forState:UIControlStateDisabled];
    [self.videoBtn addTarget:self action:@selector(chooseVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnbgView addSubview:self.videoBtn];
    
    [self.videoBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-105);
        make.bottom.equalTo(-20);
    }];
    
    //键盘的开关通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
}

///键盘出现，弹幕view位置改变和恢复
-(void)keyBoardShow:(NSNotification *)no
{
    //textField
    id objFrame = no.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyBoardFrame = {0};
    [objFrame getValue:&keyBoardFrame];
    CGFloat y= keyBoardFrame.size.height;
    
    [self.btnbgView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-KBottomSafeArea-y);
    }];
    
    
}

-(void)keyBoardHide:(NSNotification *)no{
    [self.btnbgView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-KBottomSafeArea);
    }];
}

-(void)chooseImage:(UIButton *)sender{
    if (self.postType == 2) {
        [[MYToast makeText:@"不能同时选择图片和视频"]show];
        return;
    }
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:9-self.tmpArr.count delegate:self];
    
    // 是否显示可选原图按钮
    imagePicker.allowPickingOriginalPhoto = NO;
    // 是否允许显示视频
    imagePicker.allowPickingVideo = NO;
    // 是否允许显示图片
    imagePicker.allowPickingImage = YES;
    
    //只能present
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    imagePicker.allowCrop = YES;
    //    imagePicker.cropRect = CGRectMake(0, imagePicker.cropRect.origin.y-50, self.view.bounds.size.width, SCREEN_WIDTH);
    imagePicker.showSelectBtn = NO;
}
-(void)chooseVideo:(UIButton *)sender{
    if (self.postType == 1) {
        [[MYToast makeText:@"不能同时选择图片和视频"]show];
        return;
    }
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    
    // 是否显示可选原图按钮
    imagePicker.allowPickingOriginalPhoto = NO;
    // 是否允许显示视频
    imagePicker.allowPickingVideo = YES;
    // 是否允许显示图片
    imagePicker.allowPickingImage = NO;
    
    //只能present
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    imagePicker.allowCrop = YES;
    
    imagePicker.showSelectBtn = NO;
}

#pragma mark --选择图片后的回调
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
   // NSLog(@"ppp1111::::%@",assets);
    
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    
    self.postType = 1;
//    self.imageBtn.enabled = NO;
//    self.videoBtn.enabled = NO;
    
    for (int i =0; i<photos.count; i++) {
        PickerModel *model = [PickerModel new];
        model.image = photos[i];
        model.tag = i;
        [self.tmpArr addObject:model];
        __weak typeof(self) wself = self;
        [[AppRequest sharedInstance]uploadImage:photos[i] backBlock:^(AppRequestState state, id  _Nonnull result) {
            model.link = result[@"data"][@"filePath"];
            NSLog(@"批量：%@--%d--%d",result,model.tag,i);
            [wself.collectionView reloadData];
        }];
    }
    
    [self.dataArr removeAllObjects];
    PickerModel *addModel = [PickerModel new];
    addModel.isAddIcon = YES;
    [self.dataArr addObjectsFromArray:self.tmpArr];
    [self.dataArr addObject:addModel];
    
    
    
}
// 获取视频第一帧
- (UIImage*) getVideoPreViewImage:(NSURL *)path
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 1);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}
#pragma mark-- 选择视频的回调
-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset{
    
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeFastFormat;
    PHImageManager *manager = [PHImageManager defaultManager];
    [manager requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        
        AVURLAsset *urlAsset = (AVURLAsset *)asset;
        CMTime time = [urlAsset duration];
        int duration = ceil(time.value/time.timescale);
//        NSString *fileString = [NSString stringWithFormat:@"%@",urlAsset.URL];
//        NSData *fileData = [NSData dataWithContentsOfURL:urlAsset.URL];
//        float videoSize = (fileData.length)/(1024*1024);
        NSLog(@"视频回调时长：%d",duration);
//        NSString *astr = [fileString stringByReplacingOccurrencesOfString:@"file://" withString:@""];
//        NSData *videoData = [NSData dataWithContentsOfURL:urlAsset.URL];
        
        if (duration > 15) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[MYToast makeText:@"请选择15s内的视频"]show];
            });
            
            //return ;
        }else{
//            self.imageBtn.enabled = NO;
//            self.videoBtn.enabled = NO;
            self.postType = 2;
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *snapShot = [self getVideoPreViewImage:urlAsset.URL];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.videoPickView.hidden = NO;
                    self.videoPickView.bgImage.image = snapShot;
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd_HH-mm-ss"];
                    NSString *name = [[dateFormatter stringFromDate:[NSDate date]] stringByAppendingString:@".mp4"];
                    
                    [self shipinZhuanma:urlAsset.URL withName:name];
                });
            });
            
        }
        
        
       
    }];
}
-(void)uploadVideo:(NSData *)data{
    [[AppRequest sharedInstance]uploadVideo:data backBlock:^(AppRequestState state, id  _Nonnull result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (state == AppRequestState_Success) {
            self.videoPath = result[@"data"][@"filePath"];
        }else{
            [[MYToast makeText:@"视频上传失败"]show];
        }
    }];
}
////////////////////////////

//视频转码方法    传相册或者相机得到的url和给视频命名
-(void)shipinZhuanma:(NSURL *)url withName:(NSString *)name{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self creatSandBoxFilePathIfNoExist];
    
    //保存至沙盒路径
    
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *videoPath = [NSString stringWithFormat:@"%@/zhuanMaVideo", pathDocuments];
    
    NSString *sandboxPath = [videoPath stringByAppendingPathComponent:name];
    NSLog(@"sandpath::%@",sandboxPath);
    //转码配置
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
    
    //AVAssetExportPresetMediumQuality可以更改，是枚举类型，官方有提供，更改该值可以改变视频的压缩比例
    AVAssetExportSession *exportSession= [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    
    exportSession.shouldOptimizeForNetworkUse = YES;
    
    exportSession.outputURL = [NSURL fileURLWithPath:sandboxPath];
    
    //AVFileTypeMPEG4 文件输出类型，可以更改，是枚举类型，官方有提供，更改该值也可以改变视频的压缩比例
    
    exportSession.outputFileType = AVFileTypeMPEG4;
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        int exportStatus = exportSession.status;
        
        NSLog(@"exportStatus::%d",exportStatus);
        switch (exportStatus)
        {
            case AVAssetExportSessionStatusFailed:
            {
                NSError *exportError = exportSession.error;
                NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [[MYToast makeText:@"视频转码失败"]show];
                //转码失败
                break;
            }
            case AVAssetExportSessionStatusCompleted:
            {
                NSData *data = [NSData dataWithContentsOfFile:sandboxPath];
                if (data) {
                    [self uploadVideo:data];
                }
            }
        }
    }];
    
}

- (void)creatSandBoxFilePathIfNoExist
{
    //沙盒路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSLog(@"databse--->%@",documentDirectory);
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    //创建目录
    NSString *createPath = [NSString stringWithFormat:@"%@/zhuanMaVideo", pathDocuments];
    
    // 判断文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        NSLog(@"FileImage is exists.");
    }
    
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //设置CollectionView的属性
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"PhotoCell"];
    }
    
    return _collectionView;
}

#pragma mark  设置CollectionView 组数
//-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    return 1;
//}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"PhotoCell";
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    __weak typeof(self) wself = self;
    cell.deleteBlock = ^(id  _Nonnull data) {
        [wself.dataArr removeObjectAtIndex:indexPath.item];
        [wself.tmpArr removeObjectAtIndex:indexPath.item];
        if (wself.tmpArr.count == 0) {
            [wself.dataArr removeAllObjects];
//            wself.imageBtn.enabled = YES;
//            wself.videoBtn.enabled = YES;
            wself.postType = 0;
        }
        [wself.collectionView reloadData];
    };
    [cell refreshItem:self.dataArr[indexPath.item]];
    return cell;
}

#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return  CGSizeMake(100*K_SCALE,100*K_SCALE );
}
#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(1,16,1,16);//（上、左、下、右）
}
//#pragma mark  定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
#pragma mark  点击CollectionView触发事件

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"dianjicell");
 
    if (self.dataArr[indexPath.item].isAddIcon) {
        [self chooseImage:nil];
    }
    
}
#pragma mark  设置CollectionViewCell是否可以被点击
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view != self.collectionView) {
        [self.inputView resignFirstResponder];
        return NO;
    }
    return YES;
}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    NSLog(@"dealllllloc");
}
@end
