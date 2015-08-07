//
//  SystemCameraViewController.h
//  WJCustomCameraDemo
//
//  Created by jh navi on 15/8/6.
//  Copyright (c) 2015年 WJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystemCameraViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
- (IBAction)pressTakePhoto:(id)sender;
- (IBAction)pressPhotoLibrary:(id)sender;

@end
