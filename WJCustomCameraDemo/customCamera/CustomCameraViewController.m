//
//  CustomCameraViewController.m
//  WJCustomCameraDemo
//
//  Created by jh navi on 15/8/6.
//  Copyright (c) 2015年 WJ. All rights reserved.
//

#import "CustomCameraViewController.h"
#import "Tools.h"

#define kMainWidth    [[UIScreen mainScreen] bounds].size.width
#define kMainHeight   [[UIScreen mainScreen] bounds].size.height
#define MAXIMAGES            10

@interface CustomCameraViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic)UIPageControl *pageControl;
@property (nonatomic,assign) BOOL isLocPic;//本地相册图片
@end

@implementation CustomCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ngap = 0;
    self.isLocPic = NO;
    _imageMutableArray = [NSMutableArray array];

    self.myScrollView.delegate = self;
    self.myScrollView.showsHorizontalScrollIndicator = NO;
    self.myScrollView.showsVerticalScrollIndicator = NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    [_imageMutableArray removeAllObjects];
}
- (IBAction)PressTakePhoto:(id)sender {
    [self.imageMutableArray removeAllObjects];
    if ([Tools isCameraPermissions]) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera; //照相机
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        {
            self.imagePicker.sourceType = sourceType;
            [self initCustomCamera];
            [self presentViewController:self.imagePicker animated:YES completion:^{
                NSLog(@"进入相机界面");
            }];
        }else
        {
            NSLog(@"模拟器无法打开照相机,请在真机中使用");
        }
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请打开相机权限:设置 > 隐私 > 相机" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alertView show];
    }

}

#pragma mark -初始化自定义相机
- (void)initCustomCamera{
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imagePicker.allowsEditing = NO;
    _imagePicker.showsCameraControls = NO;
    _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    _imagePicker.cameraViewTransform = CGAffineTransformScale(_imagePicker.cameraViewTransform, 1, 1.0);
    _imagePicker.edgesForExtendedLayout = YES;
    
    int imageGapHeight = 0;
    int btnGapHeight = 0;
    UILabel *textLabel = [[UILabel alloc]init];
    textLabel.text = @"提示：自定义相机";
    textLabel.backgroundColor = [UIColor blackColor];
    [textLabel setTextColor:[UIColor grayColor]];
    [textLabel setFont:[UIFont systemFontOfSize:14]];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    
    if(kMainHeight < 500){
        imageGapHeight = 0;
        btnGapHeight = 0;
        textLabel.hidden = YES;
    }else if(kMainHeight > 500 && kMainHeight < 600){ //5s
        imageGapHeight = 60;
        btnGapHeight = 10;
        textLabel.hidden = NO;
    }else if(kMainHeight > 600 && kMainHeight <700){ //6
        imageGapHeight = 80;
        btnGapHeight = 10;
        textLabel.hidden = NO;
    }else if(kMainHeight > 700){  //6p
        imageGapHeight = 100;
        btnGapHeight = 20;
        textLabel.hidden = NO;
    }
    
    //1. 整个view
    _myOverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainWidth, kMainHeight)];
    
    self.ngap = (kMainWidth - 240)/4;
    //1.1 图片显示框
    _imageShowView = [[UIImageView alloc]init];
    _imageShowView.frame = CGRectMake(0, 0, kMainWidth, kMainHeight-80-imageGapHeight);
    //    _imageView.image = [UIImage imageWithName:@"carmen_card.png"];
    
    //1.2 放置所有按钮的view
    _myBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, kMainHeight-80-imageGapHeight+btnGapHeight, kMainWidth, 80)];
    [_myBtnView setBackgroundColor:[UIColor blackColor]];
    
    textLabel.frame = CGRectMake(0, _myBtnView.frame.origin.y + 90, kMainWidth, 40);
    //1.2.1 本地图片按钮
    _locationPicBtn = [[UIButton alloc]init];
    _locationPicBtn.frame = CGRectMake(3*self.ngap + 160, 2, 80, 80);
    //    [_locationPicBtn setTitle:@"本地图片" forState:UIControlStateNormal];
    [_locationPicBtn setBackgroundImage:[UIImage imageNamed:@"carmen_image_btn_nor.png"] forState:UIControlStateNormal];
    [_locationPicBtn setBackgroundImage:[UIImage imageNamed:@"carmen_image_btn_press.png"] forState:UIControlStateHighlighted];
    [_locationPicBtn addTarget:self action:@selector(locationPicture) forControlEvents:UIControlEventTouchUpInside];
    
    //1.2.2 拍照按钮
    _takePhotoBtn = [[UIButton alloc]init];
    _takePhotoBtn.frame = CGRectMake(2*self.ngap + 80, 2, 80, 80);
    //    [_takePhotoBtn setTitle:@"拍照" forState:UIControlStateNormal];
    [_takePhotoBtn setBackgroundImage:[UIImage imageNamed:@"carmen_photo_btn_nor.png"] forState:UIControlStateNormal];
    [_takePhotoBtn setBackgroundImage:[UIImage imageNamed:@"carmen_photo_btn_nor.png"] forState:UIControlStateHighlighted];
    [_takePhotoBtn addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    
    //1.2.3 取消按钮
    _cancelBtn = [[UIButton alloc]init];
    _cancelBtn.frame = CGRectMake(self.ngap, 2, 80, 80);
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelCamera) forControlEvents:UIControlEventTouchUpInside];
    
    //1.2.4 完成按钮
    _finishBtn = [[UIButton alloc]init];
    _finishBtn.frame = CGRectMake(3*self.ngap + 160, 2, 80, 80);
    [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_finishBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_finishBtn addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    _finishBtn.hidden = YES;
    
    //1.2.5 下一张按钮
    _nextBtn = [[UIButton alloc]init];
    _nextBtn.frame = CGRectMake(2*self.ngap + 80, 2, 80, 80);
    [_nextBtn setTitle:@"下一张" forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(nextPhoto) forControlEvents:UIControlEventTouchUpInside];
    _nextBtn.hidden = YES;
    _nextBtn.enabled = NO;
    [_nextBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    //1.2.6 重拍按钮
    _reTakeBtn = [[UIButton alloc]init];
    _reTakeBtn.frame = CGRectMake(self.ngap, 2, 80, 80);
    [_reTakeBtn setTitle:@"重拍" forState:UIControlStateNormal];
    [_reTakeBtn addTarget:self action:@selector(reTakePhoto) forControlEvents:UIControlEventTouchUpInside];
    _reTakeBtn.hidden = YES;
    _reTakeBtn.enabled = NO;
    [_reTakeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    //按钮放置在一个view
    [_myBtnView addSubview:_locationPicBtn];
    [_myBtnView addSubview:_takePhotoBtn];
    [_myBtnView addSubview:_cancelBtn];
    [_myBtnView addSubview:_finishBtn];
    [_myBtnView addSubview:_nextBtn];
    [_myBtnView addSubview:_reTakeBtn];
    
    //全部放置在最大的view
    [_myOverView addSubview:_imageShowView];
    [_myOverView addSubview:_myBtnView];
    [_myOverView addSubview:textLabel];
    _imagePicker.cameraOverlayView = _myOverView;
}

#pragma mark -拍下一张图片
- (void)nextPhoto{
    _imageShowView.hidden = NO;
    _imageShowView.image = [UIImage imageNamed:@"carmen_card.png"];
    [_imageShowView setBackgroundColor:[UIColor clearColor]];
    _cancelBtn.hidden = YES;
    _takePhotoBtn.hidden = NO;
    _reTakeBtn.hidden = !_reTakeBtn.hidden;
    _nextBtn.hidden = YES;
    _finishBtn.hidden = NO;
    if (_imageMutableArray.count >0) {
        _reTakeBtn.enabled = YES;
    }else{
        _reTakeBtn.enabled = NO;
        _imageCounts = 0;
    }
    
}

#pragma mark -重新拍照
-(void)reTakePhoto{
    _imageCounts--;
    [_imageMutableArray removeLastObject];
    if (_imageMutableArray.count >0) {
        _reTakeBtn.enabled = YES;
    }else{
        _reTakeBtn.enabled = NO;
        _imageCounts = 0;
    }
    
    NSString *str = [NSString stringWithFormat:@"完成(%d)",_imageCounts];
    if (_imageCounts == 0) {
        _finishBtn.enabled = NO;
        [_finishBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    [_finishBtn setTitle:str forState:UIControlStateNormal];
    
    _imageShowView.hidden = NO;
    _imageShowView.image = [UIImage imageNamed:@"carmen_card.png"];
    [_imageShowView setBackgroundColor:[UIColor clearColor]];
    _cancelBtn.hidden = YES;
    _takePhotoBtn.hidden = NO;
    _reTakeBtn.hidden = YES;
    _nextBtn.hidden = YES;
    _finishBtn.hidden = NO;

}

#pragma mark -取消拍照
-(void)cancelCamera{
    [_imagePicker dismissViewControllerAnimated:NO completion:^{
        NSLog(@"取消拍照");
    }];
}

#pragma mark -照相
-(void)takePhoto{
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    _nextBtn.enabled = NO;
    [_nextBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _cancelBtn.hidden = YES;
    _takePhotoBtn.hidden = YES;
    _locationPicBtn.hidden = YES;
    _finishBtn.hidden = NO;
    _finishBtn.enabled = NO;
    
    _nextBtn.hidden = NO;
    _reTakeBtn.hidden = NO;
    [_imagePicker takePicture];
}

#pragma mark -本地图片
-(void)locationPicture{
    
    if (![self isPhotoLibrarySupport]) {
        NSLog(@"不支持图片库");
        return;
    }
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if ([self isPhotoLibrarySupport]) {
        self.isLocPic = YES;
        [self.imageMutableArray removeAllObjects];
        NSArray * availableMediaTypeArr = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        _imagePicker.mediaTypes = availableMediaTypeArr;
        _imagePicker.delegate = self;
        if (self.presentedViewController == nil) {
            [self presentViewController:_imagePicker animated:NO completion:nil];
        }
    }

    
}

#pragma mark -完成拍照（最大MAX张）
-(void)finish{
    [_imagePicker dismissViewControllerAnimated:NO completion:^{
        [self loadImageView];
    }];
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *selectedImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    self.imageShowView.hidden = NO;
    [self.imageShowView setBackgroundColor:[UIColor blackColor]];
    
    //本地相册图片
    if (self.isLocPic) {
        [self.imageMutableArray addObject:selectedImg];
        [self dismissViewControllerAnimated:NO completion:^{
            [self loadImageView];
        }];
        self.isLocPic = NO;
    }else{
        //对拍摄出来的图片进行压缩
        CGSize targetSize = CGSizeMake(768, 1024);//(768, 1024)
        self.imageShowView.image = [self changeImageScale:selectedImg size:targetSize];//selectedImg;
        _imageCounts++;
        self.finishBtn.enabled = YES;
        _reTakeBtn.enabled = YES;
        [_reTakeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.imageMutableArray addObject:[self changeImageScale:selectedImg size:targetSize]];
        
        if (_imageCounts <= MAXIMAGES-1) {
            NSString *str = [NSString stringWithFormat:@"完成(%d)",_imageCounts];
            [_finishBtn setTitle:str forState:UIControlStateNormal];
            [_finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _nextBtn.enabled = YES;
            [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _takePhotoBtn.enabled = YES;
        }else{
            NSString *str = [NSString stringWithFormat:@"完成(%d)",_imageCounts];
            [_finishBtn setTitle:str forState:UIControlStateNormal];
            [_finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            _takePhotoBtn.hidden = YES;
            _takePhotoBtn.enabled = YES;
            _nextBtn.hidden = YES;
            _reTakeBtn.hidden = YES;
            _finishBtn.frame = CGRectMake(120, 20, 80, 50);
            _imageCounts = 0;
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"最多这能拍摄MAXIMAGES(10)张" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
            [alertView show];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"您取消了选择图片");
    }];
}

-(void)loadImageView{
    for (int i = 0; i < self.imageMutableArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:(CGRectMake(i * kMainWidth, 0, kMainWidth, self.myScrollView.frame.size.height))];
        imageView.image = self.imageMutableArray[i];
        [self.myScrollView addSubview:imageView];
    }
    self.myScrollView.contentSize = CGSizeMake(self.imageMutableArray.count * kMainWidth, 0);
    self.myScrollView.pagingEnabled = YES;
    self.pageControl = [[UIPageControl alloc]initWithFrame:(CGRectMake(0, self.myScrollView.frame.origin.y+self.myScrollView.frame.size.height+5, kMainWidth, 20))];
    self.pageControl.numberOfPages = self.imageMutableArray.count;
    //设置非选中页的圆点颜色
    self.pageControl.pageIndicatorTintColor=[UIColor grayColor];
    //设置选中页的圆点颜色
    self.pageControl.currentPageIndicatorTintColor=[UIColor blueColor];
    self.pageControl.enabled=NO;
    [self.view addSubview:self.pageControl];
    self.myScrollView.contentOffset = CGPointMake((self.imageMutableArray.count - 1) * kMainWidth, 0);
    
    self.pageControl.currentPage = self.imageMutableArray.count;
    
}
//当图片正在滚动的时候调用

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //计算页码
    int page=scrollView.contentOffset.x/scrollView.frame.size.width;
    //给圆点添加页码监听事件
    self.pageControl.currentPage=page;
}

#pragma mark -是否支持相机
-(BOOL)isCameraSupport{
    BOOL bStatus = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    return bStatus;
}

#pragma mark -是否支持图片库
-(BOOL)isPhotoLibrarySupport{
    BOOL bStatus = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    return bStatus;
}

-(UIImage *)changeImageScale:(UIImage *)image size:(CGSize)asize{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }else{
        CGSize oldsize = image.size;
        NSLog(@"%f--%f",image.size.width,image.size.height);
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

