//
//  Tools.m
//  CameraWithUIImagePicker
//
//  Created by jh navi on 15/2/2.
//  Copyright (c) 2015年 QWJ. All rights reserved.
//

#import "Tools.h"

@implementation Tools

+ (BOOL) isCameraPermissions
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
        
        //无权限
        return NO;
    }
    return YES;
}

@end
