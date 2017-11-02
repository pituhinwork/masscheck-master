//
//  MainTestViewController.h
//  MassTrade
//
//  Created by Admin on 9/28/17.
//  Copyright © 2017 GDT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <CoreBluetooth/CoreBluetooth.h>


#import "Telephone.h"
#import "Wireless.h"

#import "Appearance.h"
#import "TouchScreen.h"
#import "Wifi.h"
#import "Vibrate.h"
#import "Call.h"
#import "Camera.h"
#import "CheckPart.h"
#import "GPS.h"
#import "RecordBack.h"
#import "TouchID.h"
#import "ButtonFunc.h"
#import "Bluetooth.h"

#import "RBDMuteSwitch.h"
@class DACircularProgressView;

@interface MainTestViewController : UIViewController
{
    NSTimer *IMMTimer;
    NSTimer *buttonFuncTimer;
    NSTimer *bluetoothTimer;
    int count;
    NSTimer *updateTimer;
    MessageBox *msgBox;
    int vibrationEnabled;
    int tempVt;
    NSString *tempString;
    NSMutableArray *checkLists;
}
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;
@property (retain, nonatomic) IBOutlet UILabel *testLabel;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (nonatomic, strong) Telephone *telephone;
@property (nonatomic, strong) Wireless *wireless;

@property (nonatomic, strong) Wifi *wifi;
@property (nonatomic, strong) Vibrate *vibrate;
@property (nonatomic, strong) Call *call;
@property (nonatomic, strong) Camera *camera;
@property (nonatomic, strong) CheckPart *checkPart;
@property (nonatomic, strong) GPS *gps;
@property (nonatomic, strong) RecordBack *recordBack;
@property (nonatomic, strong) TouchScreen *touchScreen;
@property (nonatomic, strong) TouchID *touchID;
@property (nonatomic, strong) ButtonFunc *buttonFunc;
@property (nonatomic, strong) Bluetooth *bluetooth;
@property (nonatomic, strong) Appearance *appearance;
@property (nonatomic, assign) int timeDurate;

@property (unsafe_unretained, nonatomic) IBOutlet UIView *barImage1;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *barImage2;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *barImage3;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *barImage4;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *phoneButtonImage;
@property (nonatomic, assign) BOOL acceptHomePress;
@property (nonatomic, assign) BOOL actionRetest;
@property (nonatomic, assign) BOOL aceptRetest;
@property (nonatomic, assign) BOOL isRetest;
@property (nonatomic, assign) BOOL finished;
@property (nonatomic, assign) BOOL isAppRunning;
@property (nonatomic, assign) BOOL damua;
@property (nonatomic, assign) int option1;
@property (nonatomic, assign) int option2;
@property (nonatomic, assign) int option3;
@property (nonatomic, assign) int currentStep;
@property (nonatomic, assign) int volumnUp;
@property (nonatomic, assign) int volumnDown;
@property (nonatomic, assign) int mute;
@property (nonatomic, assign) int power;
@property (nonatomic, strong) CBCentralManager *bluetoothManager;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (retain, nonatomic) IBOutlet UILabel *buttonTestAlert;

@property (nonatomic, assign) int updateScreen;

- (void)beginDetection;
- (void)startTestRingerButton;
- (void)endTestRingerButton;
- (float)getIOS;
- (NSString*)getModel;
- (void)updateResult:(int)vt value:(NSString*)result;
- (void)updateParent:(int)vt value:(NSString*)result;
- (void)finishTest:(NSString*)str position:(int)pos;
- (void)complete:(NSString*)str;
- (void)showResult;
- (void)writeResult:(NSString*)str;
- (void)writeResultFinished; // use when retest continues button even call and test Finished
- (void)checkAndRemoveFirstFailed;// remove value first fail for retest
- (BOOL)checkConnectNetwork;
- (void)startRun;

- (void)initResultView;
//- (void) setImageBKSelfie:(UIImage *)img;

- (void)processResult:(NSMutableDictionary *)dic;

- (void) updateInfo;
- (void) updateButtonCheck:(int)num flag:(int)flag;

- (void) copytoClip:(NSString *)str;
- (NSString *) readFromClip;

@end
