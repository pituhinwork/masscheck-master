//
//  Camera.m
//  testprod
//
//  Created by Toan Nguyen Van on 12/25/12.
//  Copyright (c) 2012 ccinteg. All rights reserved.
//

#import "Camera.h"

#import "AppDelegate.h"

#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "iDevice.h"
#import "Utilities.h"
#import "MainTestViewController.h"



#define CAMERA_NONE 0
#define CAMERA_STARTED 1
#define CAMERA_CAPTURING 2
#define CAMERA_FINISHED 3

//#define CAMERA
#if defined(CAMERA) || defined(DEBUG_ALL)
#   define CameraLog(BachUng, ...) NSLog((@"%s[Line %d] " BachUng), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define CameraLog(...)
#endif



@implementation Camera
@synthesize key;
@synthesize capture;
@synthesize askList;
@synthesize ID;
@synthesize pecentColorPass;
@synthesize manual;

- (id) init
{
    self = [super init];
    key = @"Camera";
    ID = -1;
    askList = NO;
    status = CAMERA_NONE;
    isPassMain = NO;
    isPassFront = NO;
    pecentColorPass = 0;
    manual = NO;
    tapClick = 0;
    imageCheat = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cheatCam.png"]];
    imageCheat.frame = AppShare.parentView.view.frame;
    btTest = Nil;
    decCameraFront = Nil;
    decCameraMain = Nil;
    return self;
    
}
- (void) dealloc
{
    
    [self releaseResource];
    imageCheat = nil;
}
- (void)cameraIsReady:(NSNotification *)notification
{
    countReady++;
//    [self performSelector:@selector(resetcountReady:) withObject:[NSNumber numberWithInt:countReady] afterDelay:3];
    NSLog(@"Camera is ready...%d",countReady);
    if(countReady==CAM_READY)
    {
         [self writeDebug:[NSString stringWithFormat:@" ---------------- Skip by countReady=%d",countReady]];
        countReady = 0;
        [self performSelectorOnMainThread:@selector(checkCameraTimeOut:) withObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:callCount], [NSNumber numberWithBool:isUsingFront], nil] waitUntilDone:NO];
        //[self checkCameraTimeOut:[NSArray arrayWithObjects:[NSNumber numberWithInt:callCount], [NSNumber numberWithBool:isUsingFront], nil]];
    }
    
   // [self showButtonTake];
    // Whatever
}

//- (void)resetcountReady:(NSNumber*)num
//{
//    NSLog(@"reset count Ready:num %d=%d countReady",[num intValue],countReady);
//    if([num intValue] == countReady)
//    {
//        NSLog(@"reset count Ready...%d",countReady);
//        countReady = 0;
//    }
//}

- (void)resetTap
{
    tapClick = 0;
}

- (void) startPreTestCamFront
{
    
    CameraLog(@" ---------------- Pretest Front, askList: %@",askList?@"YES":@"NO");
     [self writeDebug:[NSString stringWithFormat:@" ---------------- Pretest Front, askList: %@",askList?@"YES":@"NO"]];
    isUsingFront = YES;
    isGotImage = NO;
     [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self createCamera];
}

- (void) startPretestCamMain
{
    CameraLog(@" ---------------- Pretest Main");
     [self writeDebug:[NSString stringWithFormat:@" ---------------- Pretest Main"]];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    isUsingFront = NO;
    isGotImage = NO;
    [self createCamera];
}

- (void) releaseCamera
{
        
    if(capture)
    {
         CameraLog(@" ================ releaseCamera %@",isUsingFront?@"Front":@"Main");
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        countReady = 0;
        [self writeDebug:[NSString stringWithFormat:@" releaseCamera---------------- %@",isUsingFront?@"front":@"Rear"]];
        if(capture.view.superview)
        {
            [capture.view removeFromSuperview];
        }
        
        capture = nil;
    }
    
}

- (void) createCamera
{
    [self writeDebug:[NSString stringWithFormat:@"[%s] releaseCam---------------- %@",__FUNCTION__,isUsingFront?@"front":@"Rear"]];
    [self releaseCamera];
    countReady = 0;
    CameraLog(@" ================ Create camera %@",isUsingFront?@"Front":@"Main");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cameraIsReady:) name:AVCaptureSessionDidStartRunningNotification object:nil];

     callCount++;
    [self writeDebug:[NSString stringWithFormat:@"callCount:%d ================ Create camera %@",callCount,isUsingFront?@"Front":@"Main"]];
    int cap = 3;//7
    
    NSString *model = [UIDevice currentDevice].model;
    NSString *partNum = getPhoneModal(2);
    if([[model uppercaseString] rangeOfString:@"IPHONE"].location != NSNotFound && [partNum floatValue] > 4.1)
       cap = 3;//5

    if(!capture)
    {
       [self writeDebug:[NSString stringWithFormat:@"capture=Nil : alloc with camera:%@",isUsingFront?@"Front":@"Main"]];
        if((isUsingFront && isExistedFront) || ((!isUsingFront) && isExistedMain))
        {
            CameraLog(@" ------- Create camera %@",isUsingFront?@"Front":@"Main");
            capture = [[UIImagePickerController alloc] init];
            capture.modalPresentationStyle = UIModalPresentationFullScreen;
            capture.delegate = self;
            capture.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            if(isUsingFront)
            {
                [capture setCameraDevice:UIImagePickerControllerCameraDeviceFront];
            }
            else
            {
                [capture setCameraDevice:UIImagePickerControllerCameraDeviceRear];
            }
            
            capture.mediaTypes = [NSArray arrayWithObject:(NSString*)kUTTypeImage];
            capture.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
            capture.allowsEditing = NO;
            capture.showsCameraControls = NO;
            
            capture.view.frame = AppShare.parentView.view.frame;
            
            if((!isUsingFront) && ((!isPassFront) && isExistedFront))
            {
                CameraLog(@"-----------------------anh thanh keu giam xuong 26 - 1");
//                cap = 7;//10;anh thinh chuyen thanh 3
//                if([[model uppercaseString] rangeOfString:@"IPHONE"].location != NSNotFound && [partNum floatValue] > 4.1)
//                    cap = 5;
                cap = 2;
            }
            [AppShare.parentView.view addSubview:capture.view];
            
//            [capture performSelector:@selector(takePicture) withObject:nil afterDelay:cap];
            if(AppShare.iOS < 8)
                [self performSelector:@selector(takePic:) withObject:[NSNumber numberWithBool:isUsingFront]  afterDelay:1];
            else
                [self performSelector:@selector(takePic:) withObject:[NSNumber numberWithBool:isUsingFront]  afterDelay:1];
            
        }
        
    }
    if(manual == NO)
    {
        [self performSelector:@selector(checkCameraTimeOut:) withObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:callCount], [NSNumber numberWithBool:isUsingFront], nil] afterDelay:cap+1];
    }
}

- (void)takePic:(NSNumber*)useCam
{
    if([useCam boolValue]==isUsingFront)
    {
        if(isGotImage == NO && status != CAMERA_FINISHED)
        {
            CameraLog();
            [capture takePicture];
            if(AppShare.iOS < 8)
                [self performSelector:@selector(takePic:) withObject:[NSNumber numberWithBool:isUsingFront] afterDelay:1];
            else [self performSelector:@selector(takePic:) withObject:[NSNumber numberWithBool:isUsingFront] afterDelay:1];
        }
    }
}

- (void)showButtonTake
{
    CameraLog();
     CGRect rect = AppShare.parentView.view.frame;
    if(btTest != Nil) return;
    btTest = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btTest.frame = CGRectMake(0, rect.size.height - 50, rect.size.width, 50);
    [btTest setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    int ios = [AppShare.parentView getIOS];
    if(ios >= 7)
    {
        btTest.layer.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5].CGColor;
        btTest.layer.borderColor = [[UIColor blueColor] CGColor];
        btTest.layer.borderWidth = 1;
        btTest.layer.cornerRadius = 10;
        [btTest.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        
    }
    [btTest setTitle:@"Take picture" forState:UIControlStateNormal];
    [btTest addTarget:self action:@selector(onTake:) forControlEvents:UIControlEventTouchUpInside];
    if(btTest && btTest.superview)
        [capture.view bringSubviewToFront:btTest];
    else
        [capture.view addSubview:btTest];

}
//begin Manual---------------------------------------------------------------------------------------------------------------
- (void) askResult:(UIImage*)imageShow
{
    imageCheat.image = imageShow;
    imageCheat.hidden = NO;
  //  btTest.hidden = YES;
    btPassed.hidden = NO;
    btFailed.hidden = NO;
    
    
}
- (void) onPassed:(id)sender
{

//    btPassed.hidden = YES;
//    btFailed.hidden = YES;
    if(isUsingFront)
    {
        isPassFront = YES;
        if(isExistedMain)
            [self startPretestCamMain];
        else
            [self performSelector:@selector(completedPreTest)];
    }
    else
    {
        isPassMain = YES;
        [self performSelector:@selector(completedPreTest)];
    }
    
}
- (void) onFailed:(id)sender
{

    btPassed.hidden = YES;
    btFailed.hidden = YES;
    if(isUsingFront)
    {
        isPassFront = NO;
        if(isExistedMain)
            [self startPretestCamMain];
        else
            [self performSelector:@selector(completedPreTest)];
    }
    else
    {
        isPassMain = NO;
        [self performSelector:@selector(completedPreTest)];
    }
}
//End Manual---------------------------------------------------------------------------------------------------------------

- (void) checkCameraTimeOut:(NSArray*)ar
{
   
    
    NSNumber *a1 = [ar objectAtIndex:0];
    NSNumber *a2 = [ar objectAtIndex:1];
    
    
   
    if(([a1 intValue] == callCount) && ([a2 boolValue] == isUsingFront))
    {
        if(!isGotImage)
        {
            CameraLog(@" ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Time out : %@", (isUsingFront?@"Front":@"Main"));
             [self writeDebug:[NSString stringWithFormat:@" ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Time out : %@", (isUsingFront?@"Front":@"Main")]];
            [self releaseCamera];
            
            if(isUsingFront)
            {
                if(isExistedMain)
                    [self startPretestCamMain];
                else [self performSelector:@selector(completedPreTest)];
            }
            else
            {
                [self performSelector:@selector(completedPreTest)];
            }
        }
    }
}

- (void) successCheck:(NSString*)desc
{
    if(status != CAMERA_FINISHED)
    {
         [self releaseResource];
        status = CAMERA_FINISHED;
//        [iDevice completedTest:key isPass:YES desc:desc];
    }
}

- (void) failedCheck:(NSString*)desc
{
    if(status != CAMERA_FINISHED)
    {
        [self releaseResource];
        status = CAMERA_FINISHED;
//        [iDevice completedTest:key isPass:NO desc:desc];
    }
}

- (void) releaseResource
{
     [self writeDebug:[NSString stringWithFormat:@"[%s] releaseCam---------------- %@",__FUNCTION__,isUsingFront?@"front":@"Rear"]];
    [self releaseCamera];
    if(msgBox)
    {
        [msgBox dismiss];
        msgBox = nil;
    }

    if(imageCheat)
    {
        if(imageCheat.superview)
        {
            [imageCheat removeFromSuperview];
        }
    }
    
//    if(btTest!= Nil && btTest.superview)
//    {
//        [btTest removeFromSuperview];
//    }
    
    if(btFailed != Nil && btFailed.superview)
    {
        [btFailed removeFromSuperview];
    }
    if(btPassed != Nil && btPassed.superview)
    {
        [btPassed removeFromSuperview];
    }
    if(camTest)
    {
        camTest = nil;
    }
    
}
- (void) writeDebug:(NSString *)str
{
    //return;
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *file = [NSString stringWithFormat:@"%@/cameradebug.txt",[path objectAtIndex:0]];
    NSString *datafile = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:Nil];
    datafile = [NSString stringWithFormat:@"%@\n%@",datafile,str];
    [datafile writeToFile:file atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}
- (void) receiveBackgroundAction
{
    if(status == CAMERA_STARTED)
    {
        if(capture)
            capture.delegate = Nil;
        [self failedCheck:@"App go to background"];
        [self performSelector:@selector(completedPreTest)];
    }
}
- (void) preTest
{
    if(status == CAMERA_NONE)
    {
         status = CAMERA_STARTED;
        callCount++;
        
        CameraLog(@" ==========================================================================================");
        [self writeDebug:[NSString stringWithFormat:@"[preTest] =============================================callCount:%d",callCount]];
        isPassedPreTest = NO;
        isPassFront = NO;
        isPassMain = NO;
        
        isExistedFront = AppShare.isExistedFrontCamera;
        isExistedMain = AppShare.isExistedMainCamera;
        CameraLog(@"ExistedFront:%@, ExistedMain:%@",isExistedFront?@"YES":@"NO",isExistedMain?@"YES":@"NO");
         [self writeDebug:[NSString stringWithFormat:@"ExistedFront:%@, ExistedMain:%@",isExistedFront?@"YES":@"NO",isExistedMain?@"YES":@"NO"]];
        if(isExistedFront==NO && isExistedMain == NO)
        {
            isExistedMain = isExistCamera();
        }
        
       
        if((!isExistedFront) && (!isExistedMain))
        {
            [self writeDebug:@"[preTest] Front:FAILED; Rear:FAILED"];
            [self failedCheck:@"Front:FAILED; Rear:FAILED"];
            [self performSelector:@selector(completedPreTest)];
            return;
        }

        CameraLog(@" 1==========================================================================================");

        
        
        if(pecentColorPass > 0 || manual == YES)
        {
            CGRect rect = AppShare.parentView.view.frame;
            int ios = [AppShare.parentView getIOS];
            
            NSLog(@"manual:%@ create button",manual?@"YES":@"NO");
            if(manual == YES)
            {
                
                btPassed = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                btPassed.frame = CGRectMake(rect.size.width/2 - 150 , rect.size.height - 50, 100, 50);
                [btPassed setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                if(ios >= 7)
                {
                    btPassed.layer.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5].CGColor;
                    btPassed.layer.borderColor = [[UIColor blueColor] CGColor];
                    btPassed.layer.borderWidth = 1;
                    btPassed.layer.cornerRadius = 10;
                    [btPassed.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
                    
                }
                [btPassed setTitle:@"Passed" forState:UIControlStateNormal];
                UITapGestureRecognizer *tgPassed = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPassed:)];
                tgPassed.numberOfTapsRequired = 2;
                [btPassed addGestureRecognizer:tgPassed];
                
                
                btFailed = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                btFailed.frame = CGRectMake(rect.size.width/2 + 50, rect.size.height - 50, 100, 50);
                [btFailed setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                if(ios >= 7)
                {
                    btFailed.layer.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5].CGColor;
                    btFailed.layer.borderColor = [[UIColor redColor] CGColor];
                    btFailed.layer.borderWidth = 1;
                    btFailed.layer.cornerRadius = 10;
                    [btFailed.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
                    
                }
                [btFailed setTitle:@"Failed" forState:UIControlStateNormal];
                UITapGestureRecognizer *tgFailed = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onFailed:)];
                tgFailed.numberOfTapsRequired = 2;
                [btFailed addGestureRecognizer:tgFailed];
//                [btFailed addTarget:self action:@selector(onFailed:) forControlEvents:UIControlEventTouchUpInside];

            }
        }

        [self performSelector:@selector(clearOldImage) withObject:nil afterDelay:0.1];
        imageSaveCount = 0;
        
        [AppShare.parentView.view addSubview:imageCheat];
        imageCheat.frame = AppShare.parentView.view.frame;
        
        if(camTest)
        {
            camTest = nil;
        }
         [self writeDebug:[NSString stringWithFormat:@"[%s] releaseCam---------------- %@",__FUNCTION__,isUsingFront?@"front":@"Rear"]];
        [self releaseCamera];
        CameraLog(@" 2==========================================================================================");
        if((!isExistedFront) && (!isExistedMain))
        {
            [self writeDebug:[NSString stringWithFormat:@"[preTest]Front:FAILED; Rear:FAILED"]];
            [self failedCheck:@"Front:FAILED; Rear:FAILED"];
            [self performSelector:@selector(completedPreTest)];
        }
        else
        {
         
            if(AppShare.isActive)
            {
                @try
                {
                    
                    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                    if(authStatus == AVAuthorizationStatusAuthorized)
                    {
                        NSLog(@"Camera access to Status Authorize");
                        // do your logic
                    }
                    else if(authStatus == AVAuthorizationStatusDenied)
                    {
                        NSLog(@"Camera access to Status Denied");
                        [self failedCheck:@"Permission Denied"];
                        [self performSelector:@selector(completedPreTest)];
                        return;
                        // denied
                    }
                    else if(authStatus == AVAuthorizationStatusRestricted)
                    {
                        NSLog(@"Camera access to Status Restricted");
                        // restricted, normally won't happen
                    }
                    else if(authStatus == AVAuthorizationStatusNotDetermined)
                    {
                        // not determined?!
                        //            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                        //                if(granted)
                        //                {
                        //                    NSLog(@"Camera Granted access to %@", AVMediaTypeVideo);
                        //                }
                        //                else
                        //                {
                        //                    NSLog(@"Camera Not granted access to %@", AVMediaTypeVideo);
                        //                }
                        //            }];
                    }
                    else
                    {
                        // impossible, unknown authorization status
                        NSLog(@"Camera unknown status");
                    }
                }
                @catch (NSException *ex)
                {
                    AppLog(@"Error: %@",[ex description]);
                }

                if(isExistedFront)
                {
                    [self startPreTestCamFront];
                }
                else
                {
                    if(isExistedMain)
                        [self startPretestCamMain];
                    else [self performSelector:@selector(completedPreTest)];
                }

            }
            else
            {
                countTime = 0;
                timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playerRun) userInfo:nil repeats:YES];
            }

        }
    }
}


- (void) playerRun
{
    countTime++;
    if(AppShare.isActive)
    {
        countTime=0;
        [timer invalidate];
        timer = Nil;
        @try
        {
            
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if(authStatus == AVAuthorizationStatusAuthorized)
            {
                NSLog(@"Camera access to Status Authorize");
                // do your logic
            }
            else if(authStatus == AVAuthorizationStatusDenied)
            {
                NSLog(@"Camera access to Status Denied");
                [self failedCheck:@"Permission Denied"];
                [self performSelector:@selector(completedPreTest)];
                return;
                // denied
            }
            else if(authStatus == AVAuthorizationStatusRestricted)
            {
                NSLog(@"Camera access to Status Restricted");
                // restricted, normally won't happen
            }
            else if(authStatus == AVAuthorizationStatusNotDetermined)
            {
                // not determined?!
                //            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                //                if(granted)
                //                {
                //                    NSLog(@"Camera Granted access to %@", AVMediaTypeVideo);
                //                }
                //                else
                //                {
                //                    NSLog(@"Camera Not granted access to %@", AVMediaTypeVideo);
                //                }
                //            }];
            }
            else
            {
                // impossible, unknown authorization status
                NSLog(@"Camera unknown status");
            }
        }
        @catch (NSException *ex)
        {
            AppLog(@"Error: %@",[ex description]);
        }

        if(isExistedFront)
        {
            [self startPreTestCamFront];
        }
        else
        {
            if(isExistedMain)
                [self startPretestCamMain];
            else [self performSelector:@selector(completedPreTest)];
        }
    }
    if(countTime > 60)
    {
        countTime=0;
        [timer invalidate];
        timer = Nil;
        [self failedCheck:@"Timeout in background: Front:N/A, Rear:N/A"];
        [self performSelector:@selector(completedPreTest)];
    }
}


// This function is started when Master Linux request
- (void) startAutoTest:(NSString*)rKey param:(NSString*)param
{
    NSLog(@"status %d==%d CAMERA_FINISHED",status, CAMERA_FINISHED);
    if(AppShare.parentView.actionRetest == YES || status == CAMERA_FINISHED)
    {
        status = CAMERA_NONE;
    }

    if(status != CAMERA_NONE)
        return;
    
    
    [self performSelector:@selector(preTest) withObject:nil afterDelay:0];
   
    demtg = AppShare.timeTest;
    
    
}

- (void) onTake:(id)sender
{
    CameraLog();
    callCount++;
    [self performSelector:@selector(onTakePic:) withObject:[NSNumber numberWithInt:callCount] afterDelay:0];
}
- (void) onTakePic:(NSNumber*)num
{
    CameraLog();
    if([num intValue]==callCount)
    {
        CameraLog(@"callcount = Num");
        callCount++;
        if(AppShare.isActive == YES)
        {
            [capture performSelector:@selector(takePicture)];
        }        
        [btTest removeFromSuperview];
        btTest = Nil;
    }
    else CameraLog(@" da chup roi");
}
- (void) onMessageList:(NSString*)data
{
    CameraLog();
    
    if(isUsingFront)
    {
        
        if([[data uppercaseString] isEqualToString:[@"Retest" uppercaseString]])
        {
            [self startPreTestCamFront];
        }
        else
        {
            decCameraFront = [[NSString alloc] initWithFormat:@"%@",data];
            if(isExistedMain)
                [self startPretestCamMain];
            else [self performSelector:@selector(completedPreTest)];
        }
    }
    else
    {
        if([[data uppercaseString] isEqualToString:[@"Retest" uppercaseString]])
        {
            [self startPretestCamMain];
        }
        else
        {
            decCameraMain = [[NSString alloc] initWithFormat:@"%@",data];
            [self performSelector:@selector(completedPreTest)];
        }
    }
}

- (void) onMessage:(NSNumber*)num
{
    int tag = [num intValue];
    
    if(tag == 1)
    {
        [self preTest];
    }
    else if(tag == 101)// skip
    {
        [self performSelector:@selector(completedPreTest)];
    }
    else if(tag == 102)//start
    {
        [self preTest];
    }
   
    else if(tag == 201)// skip
    {
        [self performSelector:@selector(completedPreTest)];
    }
    else if(tag == 202)//pause
    {
        if(msgBox)
        {
            [msgBox dismiss];
            msgBox = Nil;
        }
        msgBox = [[MessageBox alloc] init];
        NSMutableArray *buttons = [[NSMutableArray alloc] initWithObjects:AppShare.SkipText,AppShare.STARTText, nil];
        [msgBox showContentSeg:AppShare.FrontBackText title:AppShare.CameraText Button:buttons tag:100 delegate:self sel:@selector(onMessage:)];
    }
    else if(tag == 203) // start
    {
        [self preTest];
    }


}

- (void) clearOldImage
{
    NSString *fileCam = [iDevice.requestFileName stringByReplacingOccurrencesOfString:@"request.txt" withString:@"cam_"];
    for(int i=1; i<=12; i++)
    {
        [[NSFileManager defaultManager] removeItemAtPath:[fileCam stringByAppendingFormat:@"%02d.png", i] error:nil];
    }
}

- (void) recieveCameraWarning
{
    [self writeDebug:[NSString stringWithFormat:@"[%s] releaseCam---------------- %@",__FUNCTION__,isUsingFront?@"front":@"Rear"]];
    if(status != CAMERA_FINISHED)
    {
        [self writeDebug:[NSString stringWithFormat:@"[%s] recieve Warning nguy co thoat app ---------------- %@",__FUNCTION__,isUsingFront?@"front":@"Rear"]];
    }
//        [self releaseCamera]; //
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    @try
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if(image)
        {
            isGotImage = YES;
            
            CameraLog(@" manual:%@==================== Worked %@",manual?@"YES":@"NO", (isUsingFront?@"Front":@"Main"));
            [self writeDebug:[NSString stringWithFormat:@" imagePickerController didFinishPickingMediaWithInfo---------------- %@",isUsingFront?@"front":@"Rear"]];
            PlayBeep();
             [self writeDebug:[NSString stringWithFormat:@"[%s] releaseCam---------------- %@",__FUNCTION__,isUsingFront?@"front":@"Rear"]];
            [self releaseCamera];
            
        
                BOOL checkcolor = [self processImage:image];
                if(isUsingFront)
                {
                    if(checkcolor == YES)
                        isPassFront = YES;
                }
                else
                {
                    if(checkcolor == YES)
                        isPassMain = YES;
                }

                
                if(isUsingFront)
                {
                    if(isExistedMain)
                        [self startPretestCamMain];
                    else [self performSelector:@selector(completedPreTest)];
                }
                else
                {
                    [self performSelector:@selector(completedPreTest)];
                }
            
        }
    }
    @catch (NSException *exception)
    {
        CameraLog(@"error: %@",[exception description]);
         [self writeDebug:[NSString stringWithFormat:@"error: %@",[exception description]]];
        if(isUsingFront)
        {
            isPassFront = NO;
        }
        else
        {
            isPassMain = NO;
        }
        
        PlayBeep();
         [self writeDebug:[NSString stringWithFormat:@"[%s] releaseCam---------------- %@",__FUNCTION__,isUsingFront?@"front":@"Rear"]];
        [self releaseCamera];
        
        if(isUsingFront)
        {
            if(isExistedMain)
                [self startPretestCamMain];
            else [self performSelector:@selector(completedPreTest)];
        }
        else
        {
            [self performSelector:@selector(completedPreTest)];
        }
    }
}
- (BOOL) processImage:(UIImage*)img
{
    BOOL kq=NO;
    if(pecentColorPass == 0)
    {
        return YES;
    }
    long long countPixel = 0;
    long long countRed = 0;
    long long countGreen = 0;
    long long countBlue = 0;
    
    int percentRed=0, percentGreen=0, percentBlue=0;
    
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(img.CGImage));
    const UInt8* data = CFDataGetBytePtr(pixelData);
    CameraLog(@"%s begin",__FUNCTION__);
    float w = img.size.width;
    float h = img.size.height;
    int max = 150,min=100;
    //long long pixelInfo = ((w  * y) + x) * 4;
    
    for (int y=0; y<h; y++)
    {
        for(int x=0; x<w; x++)
        {
            long long pos = (w*y+x)*4;
            unsigned char red    = data[pos];
            unsigned char green  = data[pos + 1];
            unsigned char blue   = data[pos + 2];
            //unsigned char alpha = data[pos + 3];
//            CameraLog(@"%s ==================== color: r: %d,g: %d,b:%d",__FUNCTION__, red,green,blue);
            //check red
            
            if(red > max && green < min && blue < min)
            {
                countRed++;
            }
            else if( red < min && green > max && blue <min)
            {
                countGreen++;
            }
            else if( red < min && green < min && blue > max)
            {
                countBlue++;
            }
            
            countPixel++;
        }
    }
    
    CFRelease(pixelData);
    
    percentRed = ((countRed * 100.0) / countPixel);
    percentGreen = ((countGreen * 100.0) / countPixel);
    percentBlue = ((countBlue * 100.0) / countPixel);
    
    int sum = percentRed + percentGreen + percentBlue;
    if(sum > pecentColorPass)
        kq = YES;
    CameraLog(@" %@===== total: countPixel: %lld, Red: %lld - %d, Green: %lld - %d, Blue: %lld - %d, width: %f, heigh: %f,  %f",kq?@"PASSED":@"FAILED",countPixel, countRed, percentRed, countGreen, percentGreen, countBlue, percentBlue, w, h, w*h);
    return kq;
}

- (void) completedPreTest
{
    CameraLog(@" ========== Completed PreTest : Passed Front [%d], Passed Main [%d]", isPassFront, isPassMain);
    // temp =arc4random() % 10;
    /*
       note:
         FRONT                  MAIN
         PASSED/FAILED/NA       PASSED/FAILED
     */
    BOOL kq = isPassMain && (isExistedFront?isPassFront:YES);
    NSString *model = getPhoneModal(3),*kqFront = @"FAILED";
   
   
    if([model isEqualToString:@"iPhone 3G"] || [model isEqualToString:@"iPhone 3GS"] )
    {
        kqFront =@"N/A";
    }
    else
    {
        kq = isPassMain && (isExistedFront?isPassFront:NO);
        CameraLog(@"set ketqua: %@",kq?@"PASSED":@"FAILED");
    }
   
    
    CameraLog(@"ketqua: %@",kq?@"PASSED":@"FAILED");
   
    NSString *camState = [NSString stringWithFormat:@" %@#%@#Front: %@, Rear: %@",manual?@"CAMERAMANUAL":key,(kq?@"PASSED":@"FAILED"), (isExistedFront?(isPassFront?@"PASSED":@"FAILED"):kqFront), (isPassMain?@"PASSED":@"FAILED")];
    if(askList)
    {
        camState = [NSString stringWithFormat:@" %@#%@#Front: %@ %@, Rear: %@ %@",
                    manual?@"CAMERAMANUAL":key,
                    (kq?@"PASSED":@"FAILED"),
                    (isExistedFront?(isPassFront?@"PASSED":@"FAILED"):kqFront),
                    decCameraFront.length==0?@"":[NSString stringWithFormat:@"(%@)",decCameraFront],
                    (isPassMain?@"PASSED":@"FAILED"),
                    decCameraMain.length==0?@"":[NSString stringWithFormat:@"(%@)",decCameraMain]];
    }
   

    status = CAMERA_FINISHED;
    CameraLog(@"%@:%@",key,camState);
     [self writeDebug:[NSString stringWithFormat:@"%@:%@",key,camState]];
    [AppShare.parentView updateResult:ID value:camState];
    
    [self performSelector:@selector(releaseResource) withObject:nil afterDelay:2];
    
}



- (void) saveImageToAlbumWithCount:(UIImage *)image
{
    
    saveImageToAlbumWithCount(image);
    
    if((imageSaveCount == 2) || (imageSaveCount == 4) || (imageSaveCount == 6) || (imageSaveCount == 8) || (imageSaveCount == 10))
    {
         NSString *camState = [NSString stringWithFormat:@"%@;%@", (isExistedFront?(isPassFront?@"PASSED":@"FAILED"):@"NA"), (isPassMain?@"PASSED":@"FAILED")];
         [iDevice completedTest:[NSString stringWithFormat:@"CAM%d", imageSaveCount/2] isPass:YES desc:camState];
    }
}

- (void) resetFunction
{
     [self writeDebug:[NSString stringWithFormat:@"[%s] releaseCam---------------- %@",__FUNCTION__,isUsingFront?@"front":@"Rear"]];
    [self releaseCamera];
    if(camTest)
    {
        camTest = nil;
    }
}

@end
