//
//  CustomCameraViewController.h
//  WJCustomCameraDemo
//
//  Created by jh navi on 15/8/6.
//  Copyright (c) 2015年 WJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCameraViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@property(nonatomic,strong) UIImagePickerController *imagePicker;

@property(nonatomic,strong) UIView *myOverView;//整个相机界面
@property(nonatomic,strong) UIView *myBtnView;//相机界面的按钮界面
@property(nonatomic,strong) UIImageView *imageShowView; //拍照后显示图片的图片框
@property(nonatomic,strong) UIButton *locationPicBtn; //本地图片按钮
@property(nonatomic,strong) UIButton *takePhotoBtn;//拍照按钮
@property(nonatomic,strong) UIButton *cancelBtn;//取消拍照按钮
@property(nonatomic,strong) UIButton *finishBtn;//完成按钮
@property(nonatomic,strong) UIButton *nextBtn;//下一张按钮
@property(nonatomic,strong) UIButton *reTakeBtn;//重拍按钮

@property(nonatomic,assign) int ngap;
@property(nonatomic,strong) NSMutableArray *imageMutableArray;//保存拍照后图片的数组
@property(nonatomic,assign) int imageCounts;//拍的图片数量

- (IBAction)PressTakePhoto:(id)sender;
- (void)initCustomCamera;//自定义相机界面

- (void)takePhoto;//照相
- (void)nextPhoto; //拍下一张图片
- (void)reTakePhoto;//重新拍照
- (void)cancelCamera;//取消拍照

- (void)locationPicture;//本地图片
- (void)finish;//完成拍照（最大MAX张）

@end
