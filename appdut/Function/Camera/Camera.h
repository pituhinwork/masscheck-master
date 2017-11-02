//
//  Camera.h
//  testprod
//
//  Created by Toan Nguyen Van on 12/25/12.
//  Copyright (c) 2012 ccinteg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>

#import <MobileCoreServices/MobileCoreServices.h>
#import "MessageBox.h"

@class MainTestViewController;

@interface Camera : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    int status;
    
    BOOL isPassFront;
    BOOL isPassMain;
    
    BOOL isUsingFront;
    
    BOOL isExistedFront;
    BOOL isExistedMain;
    
    UIImageView *imageCheat;
    
    NSString *msg;
    
    BOOL isPreTestMode;
    BOOL isGotImage;
    
    BOOL isPassedPreTest;
    
    NSObject *camTest;
    
    int callCount;
    int ID;
    MessageBox *msgBox;
    UIButton *btTest;
    
    int countTime;
    NSTimer *timer;
    
    int pecentColorPass;
    
    
    UIButton *btPassed;
    UIButton *btFailed;
    int tapClick;
    int countReady;//truong hop thao module camera ready se duoc gui xuong nhioeu lan
    
    BOOL askList;// cho nha may , sau khi hien red,green, blue hien message cho chon nhieu kq khac.
    NSString *decCameraFront;
    NSString *decCameraMain;
    
    
    int demtg;
    NSTimer *timerCount;

    
}
@property (nonatomic, assign) int ID;
@property (nonatomic, assign) int pecentColorPass;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) UIImagePickerController *capture;
@property (nonatomic, assign) BOOL manual;
@property (nonatomic, assign) BOOL askList;

@property (nonatomic, strong) MainTestViewController *parentView;
- (void) successCheck:(NSString*)desc;
- (void) failedCheck:(NSString*)desc;
- (void) startAutoTest:(NSString*)rKey param:(NSString*)param;

// Addition Functions
- (void) saveImageToAlbumWithCount:(UIImage*)image;
- (void) recieveCameraWarning;
- (void) resetFunction;
- (void) receiveBackgroundAction;

@end
