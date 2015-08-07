//
//  SystemCameraViewController.m
//  WJCustomCameraDemo
//
//  Created by jh navi on 15/8/6.
//  Copyright (c) 2015年 WJ. All rights reserved.
//

#import "SystemCameraViewController.h"
#import "Tools.h"

@interface SystemCameraViewController ()
@property(nonatomic,strong) UIImagePickerController *picker;

@end

@implementation SystemCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.delegate = self;
    [self.myImageView setContentMode:UIViewContentModeScaleToFill];
    
}

- (IBAction)pressTakePhoto:(id)sender {
    if ([Tools isCameraPermissions]) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera; //照相机
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        {
            //设置拍照后的图片可被编辑
            self.picker.allowsEditing = YES;
            self.picker.sourceType = sourceType;
            [self presentViewController:self.picker animated:YES completion:^{
                NSLog(@"进入相机界面");
            }];
        }else
        {
            NSLog(@"模拟其中无法打开照相机,请在真机中使用");
        }
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请打开相机权限:设置 > 隐私 > 相机" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alertView show];
    }

}

- (IBAction)pressPhotoLibrary:(id)sender {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //图片库
        //        self.picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //保存的相片
        self.picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.picker.sourceType];
        
    }
    self.picker.allowsEditing = NO;
    [self presentViewController:self.picker animated:YES completion:^{
        NSLog(@"进入相册界面");
    }];

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ( [type isEqualToString: @"public.image"]) {
        UIImage *selectedImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        self.myImageView.image = selectedImg;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"退出相机(册)界面");
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"您取消了选择图片");
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
