//
//  AppDelegate.h
//  testprod
//
//  Created by Bach Ung on 12/14/12.
//  Copyright (c) 2012 ccinteg. All rights reserved.
//




#define APPLOG
#ifdef APPLOG
#   define AppLog(BachUng, ...) NSLog((@"%s[Line %d] " BachUng), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define AppLog(...)
#endif
#define NSTextAlignment UITextAlignment
#define NSTextAlignmentCenter UITextAlignmentCenter
#define appDevice 1
#define TIME_CLOSE 0
#define CAM_READY 5
#define TITLE_HIGHT 90
#define TITLE_TOP 20

//#define AUTO_BRI_NESS 1

#import <UIKit/UIKit.h>

#import "iDevice.h"
#import "CheckPart.h"

@class ViewController;
@class MainTestViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIBackgroundTaskIdentifier bgRunMgr;
    BOOL isLockAnSyn;
    
   
    int radius;         // ban kinh R digitizer
    int fingers;        // so gon tay test digitizer
    int LimitBattery;   // gioi han test charge
    int maxPress;       // so lan nhan khi test button 
    BOOL fastMode;      // test nhanh va test thong thuong dang ap dung : am thanh
    BOOL isHandTest;    // test tay thi khong ghi background
    float iOS;            // lay OS hien tai
    int timeTest;
    int timeout;
    BOOL isBackground;
    BOOL accessRotate;
    
//    BOOL hidenStatusBar;
    
    
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *nav;
@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) MainTestViewController *parentView;
@property (nonatomic, assign) BOOL acceptRetest;
@property (nonatomic, assign) float dcode;
@property (nonatomic, assign) BOOL isActive;// kiem tra xem programe co ve duoi backgroud khong
@property (nonatomic, assign) BOOL isShowNotification;
@property (nonatomic, assign) int radius;
@property (nonatomic, assign) int LimitBattery;
@property (nonatomic, assign) int fingers;
@property (nonatomic, assign) int maxPress;
@property (nonatomic, assign) BOOL fastMode;
@property (nonatomic, assign) BOOL isHandTest;
@property (nonatomic, assign) BOOL isLightTest;
@property (nonatomic, assign) float iOS;
@property (nonatomic, assign) int timeTest;
@property (nonatomic, assign) int timeout;
@property (nonatomic, assign) BOOL isBackground;

@property (nonatomic, assign) BOOL checkListEnabled;
@property (nonatomic, assign) int checkListNum;
@property (nonatomic, assign) int canCheck;

@property (nonatomic, assign) BOOL accessRotate;
@property (nonatomic, assign) BOOL isFinished;
@property (nonatomic, strong) NSString *MessageSaveData;
@property (nonatomic, strong) NSString *serverProcessImage;
@property (nonatomic, strong) NSString *locattorID;
@property (nonatomic, assign) BOOL isExistedMainCamera;
@property (nonatomic, assign) BOOL isExistedFrontCamera;

@property (nonatomic, strong) CheckPart *checkPart;
//@property (nonatomic, strong) BOOL hidenStatusBar;

@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) NSMutableArray *testedData;
@property (nonatomic, strong) NSMutableArray *tableDataShow;
@property (nonatomic, strong) NSMutableArray *arrayRetest;
@property (assign, nonatomic) int passedCount;// doi ngon ngu
@property (assign, nonatomic) int failedCount;// doi ngon ngu
@property (assign, nonatomic) int highligh;// doi ngon ngu
@property (assign, nonatomic) BOOL accessRun;// doi ngon ngu
@property (assign, nonatomic) BOOL firstStop;// doi ngon ngu
@property (assign, nonatomic) BOOL isTestFail;// doi ngon ngu
@property (assign, nonatomic) BOOL dismissable;// doi ngon ngu

- (void) pauseBackgroundService;
- (void) showNotical:(NSString*)msg;

//-------------------------------------------------------------------------------------------------------
@property (assign, nonatomic) int flagLanguage;// doi ngon ngu
@property (strong, nonatomic) NSDictionary *dictionaryLanguage;
//-------------------------------------------da ngon ngu



@property (strong, nonatomic) NSString *EnableTheFollowingText;
@property (strong, nonatomic) NSString *WiFiConnectToARouteText;
@property (strong, nonatomic) NSString *GPSLocationServicesText;
@property (strong, nonatomic) NSString *TouchIDfingerprintScanText;
@property (strong, nonatomic) NSString *ProximitySensorText;
@property (strong, nonatomic) NSString *CoverTheTopPartOfTheScreenWithYourHandText;
@property (strong, nonatomic) NSString *CompassGyroText;
@property (strong, nonatomic) NSString *WaveTheDeviceInaPatternFormingTheFigure8Text;
@property (strong, nonatomic) NSString *PutThePhoneInYourHandAndShakeThePhoneToFollowShapeOfno8Text;
@property (strong, nonatomic) NSString *WatchMeWhileIBlinkText;
@property (strong, nonatomic) NSString *DigitizerText;
@property (strong, nonatomic) NSString *SwipeYourFingerOverTheScreenUntilItIsFullyCoveredText;
@property (strong, nonatomic) NSString *EndTestByPressingTheVolumeButtonText;
@property (strong, nonatomic) NSString *SwipeText;
@property (strong, nonatomic) NSString *UnfilledPointsText;
@property (strong, nonatomic) NSString *ResultsText;
@property (strong, nonatomic) NSString *TouchIDIsOffText;
@property (strong, nonatomic) NSString *SettingTouchIDPasscodeAddFingerprintText;
@property (strong, nonatomic) NSString *PressOKText;
@property (strong, nonatomic) NSString *FollowingTheProcessText;
@property (strong, nonatomic) NSString *ThenReopenTheTradITAppText;
@property (strong, nonatomic) NSString *TouchIDIsTestText;
@property (strong, nonatomic) NSString *WaitingForProcessText;
@property (strong, nonatomic) NSString *PressVolumeDownButtonx1Text;
@property (strong, nonatomic) NSString *PressVolumeUpButtonx1Text;
@property (strong, nonatomic) NSString *FlipTheMuteButtonx1Text;
@property (strong, nonatomic) NSString *PressTheHomeButtonx1Text;
@property (strong, nonatomic) NSString *PressThePowerButtonx1Text;
@property (strong, nonatomic) NSString *LoginAgainAndReopenTradITAppText;
@property (strong, nonatomic) NSString *SpeakerTestText;
@property (strong, nonatomic) NSString *SpeakerText;
@property (strong, nonatomic) NSString *DidYouHearTheSoundClearlyText;
@property (strong, nonatomic) NSString *FlashText;
@property (strong, nonatomic) NSString *PressStartButtonToTestText;
@property (strong, nonatomic) NSString *FlashLightText;
@property (strong, nonatomic) NSString *DidItTurnonText;
@property (strong, nonatomic) NSString *VideoBackText;
@property (strong, nonatomic) NSString *WasTheQualityokText;
@property (strong, nonatomic) NSString *CameraText;
@property (strong, nonatomic) NSString *AutomaticText;
@property (strong, nonatomic) NSString *MicrophoneTestText;
@property (strong, nonatomic) NSString *MicrophoneText;
@property (strong, nonatomic) NSString *ThenSpeakIntoTheMicrophoneAndListenForTheFeedbackText;
@property (strong, nonatomic) NSString *HeadphoneButtonTestText;
@property (strong, nonatomic) NSString *PleasePluginTheHeadphoneCableIntoDeviceText;
@property (strong, nonatomic) NSString *PleaseClickButtonOrToTestText;
@property (strong, nonatomic) NSString *HeadphoneMicText;
@property (strong, nonatomic) NSString *SpeakIntoTheMicrofoneAndListenForTheFeedbackText;
@property (strong, nonatomic) NSString *EarphoneSpeakerText;
@property (strong, nonatomic) NSString *VibrationText;
@property (strong, nonatomic) NSString *VibrationTestText;
@property (strong, nonatomic) NSString *DidTheDeviceVibrateText;
@property (strong, nonatomic) NSString *TestCompletedText;
@property (strong, nonatomic) NSString *WeAreCollectingTheDataText;
@property (strong, nonatomic) NSString *STARTText;
@property (strong, nonatomic) NSString *SkipText;
@property (strong, nonatomic) NSString *OKText;
@property (strong, nonatomic) NSString *RetestText;
@property (strong, nonatomic) NSString *LCDIsBrokenText;
@property (strong, nonatomic) NSString *BrokenText;
@property (strong, nonatomic) NSString *ResumeText;
@property (strong, nonatomic) NSString *PauseText;
@property (strong, nonatomic) NSString *FAILEDText;
@property (strong, nonatomic) NSString *PASSEDText;
@property (strong, nonatomic) NSString *PressStartText;
@property (strong, nonatomic) NSString *LCDTestText;
@property (strong, nonatomic) NSString *UnplugHeadphoneText;
@property (strong, nonatomic) NSString *PleaseCheckAirplaneModeIsOffText;
@property (strong, nonatomic) NSString *CameraCanNotCreateFileText;
@property (strong, nonatomic) NSString *VideoRecordText;
@property (strong, nonatomic) NSString *PleaseOpenBluetoothText;
@property (strong, nonatomic) NSString *AndOpenBluetoothText;
@property (strong, nonatomic) NSString *AnyDeadPixelsOnLCDText;
@property (strong, nonatomic) NSString *MissingPixcelsText;
@property (strong, nonatomic) NSString *ListenForHelloText;
@property (strong, nonatomic) NSString *PointTheFlashlightTowardsYouText;
@property (strong, nonatomic) NSString *PlugHeadphoneToDeviceText;
@property (strong, nonatomic) NSString *PressTheVolumeButtonsText;
@property (strong, nonatomic) NSString *SpeakIntoTheMicrophoneText;
@property (strong, nonatomic) NSString *ListenToTheFeedbackText;
@property (strong, nonatomic) NSString *VolumeUpText;
@property (strong, nonatomic) NSString *VolumeDownText;
@property (strong, nonatomic) NSString *MuteSwitchText;
@property (strong, nonatomic) NSString *HomeButtonText;
@property (strong, nonatomic) NSString *PowerButtonText;
@property (strong, nonatomic) NSString *NextText;


@property (strong, nonatomic) NSString *HeadphoneSpeakerText;
@property (strong, nonatomic) NSString *ConnectHeadphonesToTheDeviceText;
@property (strong, nonatomic) NSString *PlaceTheHeadphonesOnYourHeadText;
@property (strong, nonatomic) NSString *PlaceTheDeviceOnYourEarText;
@property (strong, nonatomic) NSString *FrontBackText;
@property (strong, nonatomic) NSString *WarningText;
@property (strong, nonatomic) NSString *CameraTestInOperationText;
@property (strong, nonatomic) NSString *PluggedText;
@property (strong, nonatomic) NSString *CosmeticSurfaceGradeText;
@property (strong, nonatomic) NSString *LikeNewText;
@property (strong, nonatomic) NSString *TouchAndFillOnTheScreenText;
@property (strong, nonatomic) NSString *PressVolumeButtonToEndTestText;
@property (strong, nonatomic) NSString *TestSummaryText;
@property (strong, nonatomic) NSString *YourScreenWasDimText;
@property (strong, nonatomic) NSString *DimmingTestIsOperatorText;
@property (strong, nonatomic) NSString *HasSoundText;
@property (strong, nonatomic) NSString *EarphoneText;
@property (strong, nonatomic) NSString *PlugInHeadphoneAndListenText;
@property (strong, nonatomic) NSString *HeadphoneText;
@property (strong, nonatomic) NSString *SayToHeadphoneMicAndListenText;
@property (strong, nonatomic) NSString *UnplugHeadphoneHasSoundInPlayerText;
@property (strong, nonatomic) NSString *SwipeTheScreenUntilFullyCoveredText;
@property (strong, nonatomic) NSString *PressStartButtonAndSaySomethingToTestText;
@property (strong, nonatomic) NSString *HasSoundInPlayerText;
@property (strong, nonatomic) NSString *ShakeAndRotateThePhoneUntilYouHearABeepText;
@property (strong, nonatomic) NSString *MotionSensorText;
@property (strong, nonatomic) NSString *PleasePlaceYourHandOnTheTopScreenText;
@property (strong, nonatomic) NSString *HasVibrationOnDeviceText;
@property (strong, nonatomic) NSString *VideoRecordInOperationText;
@property (strong, nonatomic) NSString *SelectVideoResultText;
@property (strong, nonatomic) NSString *HasFlashLightText;
@property (strong, nonatomic) NSString *CollectingTheDataText;
@property (strong, nonatomic) NSString *DoesItShowWIFIListText;
@property (strong, nonatomic) NSString *WIFIManualText;

//---------------------------------------------------------------------------new


@property (strong, nonatomic) NSString *DragToFillTheWholeDisplayText;
@property (strong, nonatomic) NSString *TapKeep3FingersOnTheDisplayUntilFinishText;
@property (strong, nonatomic) NSString *WipeToChangeScreenColorText;
@property (strong, nonatomic) NSString *CheckTheScreenCarefullyToFindTheDeadPixelText;
@property (strong, nonatomic) NSString *ClickStartToBeginText;
@property (strong, nonatomic) NSString *DeadPixelTestText;
@property (strong, nonatomic) NSString *WereDeadPixelsDiscoveredText;
@property (strong, nonatomic) NSString *FailedText;
@property (strong, nonatomic) NSString *PassedText;
@property (strong, nonatomic) NSString *AutomaticTestText;
@property (strong, nonatomic) NSString *HoldYourPhoneStableTest;
@property (strong, nonatomic) NSString *DontBlockTheCameraText;
@property (strong, nonatomic) NSString *FrontBackCamerasTestText;
@property (strong, nonatomic) NSString *DontBlockTheBackCameraAndMicrophoneText;
@property (strong, nonatomic) NSString *VideoRecordingTestText;
@property (strong, nonatomic) NSString *ExternalSpeakerMICTestText;
@property (strong, nonatomic) NSString *DontBlockTheExternalSpeakerAndMicrophoneText;
@property (strong, nonatomic) NSString *DontFaceTheBackCameraToLightSourceText;
@property (strong, nonatomic) NSString *FlashTestText;
@property (strong, nonatomic) NSString *FlipRingSilentSwitchText;
@property (strong, nonatomic) NSString *PressVolumeCongText;
@property (strong, nonatomic) NSString *PressVolumeTruText;
@property (strong, nonatomic) NSString *PressHomeButtonText;
@property (strong, nonatomic) NSString *PressPowerButtonText;
@property (strong, nonatomic) NSString *ButtonsTestText;
@property (strong, nonatomic) NSString *TouchIDTestText;
@property (strong, nonatomic) NSString *StartText;
@property (strong, nonatomic) NSString *PleaseSetupTouchIDText;
@property (strong, nonatomic) NSString *PlaceYourFingerOnTheHomeButtonText;
@property (strong, nonatomic) NSString *ConnectWiFiToNetworkAndClickStart;
@property (strong, nonatomic) NSString *WiFiTestText;
@property (strong, nonatomic) NSString *PleaseTurnOffWiFiAndEnableMobileDataText;
@property (strong, nonatomic) NSString *EndCallAndCombackAppText;
@property (strong, nonatomic) NSString *PlaceYourHandOnToOfTheScreenText;
@property (strong, nonatomic) NSString *ProximityTestText;
@property (strong, nonatomic) NSString *MotionTestText;
@property (strong, nonatomic) NSString *CompassTestText;
@property (strong, nonatomic) NSString *RotationThePhoneToFollowShapeOfNo8;
@property (strong, nonatomic) NSString *TurnOnLocationServicesText;
@property (strong, nonatomic) NSString *CancelText;
@property (strong, nonatomic) NSString *SettingText;
@property (strong, nonatomic) NSString *GPSTestText;
@property (strong, nonatomic) NSString *NowTryAgainText;
@property (strong, nonatomic) NSString *BeginViewNote1Text;
@property (strong, nonatomic) NSString *BeginViewNote2Text;
@property (strong, nonatomic) NSString *ThanksForUsingOurSoftwareText;
@property (strong, nonatomic) NSString *AgreeText;
@property (strong, nonatomic) NSString *DisagreeText;
@property (strong, nonatomic) NSString *DiagnosticsText;
@property (strong, nonatomic) NSString *MultiTouchTestText;
@property (strong, nonatomic) NSString *BatteryTestText;
@property (strong, nonatomic) NSString *BatteryLevelText;
@property (strong, nonatomic) NSString *BatteryStateText;
@property (strong, nonatomic) NSString *UnknownText;
@property (strong, nonatomic) NSString *UnpluggedText;
@property (strong, nonatomic) NSString *ChargingText;
@property (strong, nonatomic) NSString *FullText;


- (NSString *)getCurrentCountrykey;
- (void)changeLanguage:(int)language;
- (NSString *)jsonStringFromDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)diccionaryFromJsonString:(NSString *)stringJson;

- (NSString *)getLanguage:(int)language key:(NSString *)key;

@end

AppDelegate* AppShare;
