//
//  AppDelegate.m
//  testprod
//
//  Created by Bach Ung on 12/14/12.
//  Copyright (c) 2012 ccinteg. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>

#import "AppDelegate.h"
#import "Utilities.h"
#import "MainTestViewController.h"
//#define BUTTON_POWER 6




#define APPDELEGATEBUG
#if defined(APPDELEGATEBUG) || defined(DEBUG_ALL)
#   define AppDelegateLog(BachUng, ...) NSLog((@"%s[Line %d] " BachUng), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define AppDelegateLog(...)
#endif

@implementation AppDelegate
@synthesize nav;
@synthesize viewController;
@synthesize window = _window;
@synthesize dcode;
@synthesize isActive;
@synthesize isHandTest;

@synthesize tableData;
@synthesize tableDataShow;
@synthesize arrayRetest;

@synthesize radius;
@synthesize fingers;
@synthesize maxPress;
@synthesize LimitBattery;
@synthesize fastMode;
@synthesize iOS;
@synthesize timeTest;
@synthesize timeout;
@synthesize isBackground;
@synthesize accessRotate;
@synthesize isFinished;
@synthesize isShowNotification;
@synthesize isLightTest;
@synthesize MessageSaveData;
@synthesize serverProcessImage;
@synthesize locattorID;
@synthesize isExistedMainCamera;
@synthesize isExistedFrontCamera;
static int deviceLock = NO;

//----------------------------------da ngon ngu
#pragma mark -
#pragma mark Method Multy language

@synthesize flagLanguage;
@synthesize dictionaryLanguage;

@synthesize EnableTheFollowingText;
@synthesize WiFiConnectToARouteText;
@synthesize GPSLocationServicesText;
@synthesize TouchIDfingerprintScanText;
@synthesize ProximitySensorText;
@synthesize CoverTheTopPartOfTheScreenWithYourHandText;
@synthesize CompassGyroText;
@synthesize WaveTheDeviceInaPatternFormingTheFigure8Text;

@synthesize PutThePhoneInYourHandAndShakeThePhoneToFollowShapeOfno8Text;
@synthesize WatchMeWhileIBlinkText;
@synthesize DigitizerText;
@synthesize SwipeYourFingerOverTheScreenUntilItIsFullyCoveredText;
@synthesize EndTestByPressingTheVolumeButtonText;
@synthesize SwipeText;
@synthesize UnfilledPointsText;
@synthesize ResultsText;
@synthesize TouchIDIsOffText;
@synthesize SettingTouchIDPasscodeAddFingerprintText;
@synthesize PressOKText;
@synthesize FollowingTheProcessText;
@synthesize ThenReopenTheTradITAppText;
@synthesize TouchIDIsTestText;
@synthesize WaitingForProcessText;
@synthesize PressVolumeDownButtonx1Text;
@synthesize PressVolumeUpButtonx1Text;
@synthesize FlipTheMuteButtonx1Text;
@synthesize PressTheHomeButtonx1Text;
@synthesize PressThePowerButtonx1Text;
@synthesize LoginAgainAndReopenTradITAppText;
@synthesize SpeakerTestText;
@synthesize SpeakerText;
@synthesize DidYouHearTheSoundClearlyText;
@synthesize FlashText;
@synthesize PressStartButtonToTestText;
@synthesize FlashLightText;
@synthesize DidItTurnonText;
@synthesize VideoBackText;
@synthesize WasTheQualityokText;
@synthesize CameraText;
@synthesize AutomaticText;
@synthesize MicrophoneTestText;
@synthesize MicrophoneText;
@synthesize ThenSpeakIntoTheMicrophoneAndListenForTheFeedbackText;
@synthesize HeadphoneButtonTestText;
@synthesize PleasePluginTheHeadphoneCableIntoDeviceText;
@synthesize PleaseClickButtonOrToTestText;
@synthesize HeadphoneMicText;
@synthesize SpeakIntoTheMicrofoneAndListenForTheFeedbackText;
@synthesize EarphoneSpeakerText;
@synthesize VibrationText;
@synthesize VibrationTestText;
@synthesize DidTheDeviceVibrateText;
@synthesize TestCompletedText;
@synthesize WeAreCollectingTheDataText;
@synthesize STARTText;
@synthesize SkipText;
@synthesize OKText;
@synthesize FAILEDText;
@synthesize PASSEDText;
@synthesize RetestText;
@synthesize ResumeText;
@synthesize PauseText;
@synthesize LCDIsBrokenText;
@synthesize BrokenText;
@synthesize PressStartText;
@synthesize LCDTestText;
@synthesize UnplugHeadphoneText;
@synthesize PleaseCheckAirplaneModeIsOffText;
@synthesize CameraCanNotCreateFileText;
@synthesize VideoRecordText;
@synthesize PleaseOpenBluetoothText;
@synthesize AndOpenBluetoothText;
@synthesize AnyDeadPixelsOnLCDText;
@synthesize MissingPixcelsText;
@synthesize ListenForHelloText;
@synthesize PointTheFlashlightTowardsYouText;
@synthesize PlugHeadphoneToDeviceText;
@synthesize PressTheVolumeButtonsText;
@synthesize SpeakIntoTheMicrophoneText;
@synthesize ListenToTheFeedbackText;
@synthesize VolumeUpText;
@synthesize VolumeDownText;
@synthesize MuteSwitchText;
@synthesize HomeButtonText;
@synthesize PowerButtonText;
@synthesize WarningText;
@synthesize PluggedText;
@synthesize CameraTestInOperationText;
@synthesize CosmeticSurfaceGradeText;
@synthesize LikeNewText;

@synthesize HeadphoneSpeakerText;
@synthesize ConnectHeadphonesToTheDeviceText;
@synthesize PlaceTheHeadphonesOnYourHeadText;
@synthesize PlaceTheDeviceOnYourEarText;
@synthesize FrontBackText;
@synthesize TouchAndFillOnTheScreenText;
@synthesize PressVolumeButtonToEndTestText;
@synthesize NextText;
@synthesize TestSummaryText;
@synthesize  YourScreenWasDimText;
@synthesize  DimmingTestIsOperatorText;
@synthesize HasSoundText;
@synthesize EarphoneText;
@synthesize PlugInHeadphoneAndListenText;
@synthesize HeadphoneText;
@synthesize SayToHeadphoneMicAndListenText;
@synthesize UnplugHeadphoneHasSoundInPlayerText;
@synthesize SwipeTheScreenUntilFullyCoveredText;
@synthesize PressStartButtonAndSaySomethingToTestText;
@synthesize HasSoundInPlayerText;
@synthesize ShakeAndRotateThePhoneUntilYouHearABeepText;
@synthesize MotionSensorText;
@synthesize PleasePlaceYourHandOnTheTopScreenText;
@synthesize HasVibrationOnDeviceText;
@synthesize VideoRecordInOperationText;
@synthesize SelectVideoResultText;
@synthesize HasFlashLightText;
@synthesize CollectingTheDataText;
@synthesize DoesItShowWIFIListText;
@synthesize WIFIManualText;

//------------------------------new
@synthesize DragToFillTheWholeDisplayText;
@synthesize TapKeep3FingersOnTheDisplayUntilFinishText;
@synthesize WipeToChangeScreenColorText;
@synthesize CheckTheScreenCarefullyToFindTheDeadPixelText;
@synthesize ClickStartToBeginText;
@synthesize DeadPixelTestText;
@synthesize WereDeadPixelsDiscoveredText;
@synthesize FailedText;
@synthesize PassedText;
@synthesize AutomaticTestText;
@synthesize HoldYourPhoneStableTest;
@synthesize DontBlockTheCameraText;
@synthesize FrontBackCamerasTestText;
@synthesize DontBlockTheBackCameraAndMicrophoneText;
@synthesize VideoRecordingTestText;
@synthesize ExternalSpeakerMICTestText;
@synthesize DontBlockTheExternalSpeakerAndMicrophoneText;
@synthesize DontFaceTheBackCameraToLightSourceText;
@synthesize FlashTestText;
@synthesize FlipRingSilentSwitchText;
@synthesize PressVolumeCongText;
@synthesize PressVolumeTruText;
@synthesize PressHomeButtonText;
@synthesize PressPowerButtonText;
@synthesize ButtonsTestText;
@synthesize TouchIDTestText;
@synthesize StartText;
@synthesize PleaseSetupTouchIDText;
@synthesize PlaceYourFingerOnTheHomeButtonText;
@synthesize ConnectWiFiToNetworkAndClickStart;
@synthesize WiFiTestText;
@synthesize PleaseTurnOffWiFiAndEnableMobileDataText;
@synthesize EndCallAndCombackAppText;
@synthesize PlaceYourHandOnToOfTheScreenText;
@synthesize ProximityTestText;
@synthesize MotionTestText;
@synthesize CompassTestText;
@synthesize RotationThePhoneToFollowShapeOfNo8;
@synthesize TurnOnLocationServicesText;
@synthesize CancelText;
@synthesize SettingText;
@synthesize GPSTestText;
@synthesize NowTryAgainText;
@synthesize BeginViewNote1Text;
@synthesize BeginViewNote2Text;
@synthesize ThanksForUsingOurSoftwareText;
@synthesize AgreeText;
@synthesize DisagreeText;
@synthesize DiagnosticsText;
@synthesize MultiTouchTestText;
@synthesize BatteryTestText;
@synthesize BatteryLevelText;
@synthesize BatteryStateText;
@synthesize UnknownText;
@synthesize UnpluggedText;
@synthesize ChargingText;
@synthesize FullText;

@synthesize checkListNum;
@synthesize checkListEnabled;
@synthesize checkPart;

#pragma mark -
- (void)initTextDefault
{
    UnknownText= @"Unknown";
    UnpluggedText= @"Unplugged";
    ChargingText= @"Charging";
    FullText = @"Full";
    BatteryStateText = @"Battery State";
    BatteryLevelText = @"Battery level";
    BatteryTestText = @"Battery Test";
    MultiTouchTestText = @"Multi-Touch Test";
    DiagnosticsText = @"Diagnostics";
    AgreeText = @"Agree";
    DisagreeText = @"Disagree";
    BeginViewNote1Text = @"1. The test results of this app is just for your reference, using it at your own risk.";
    BeginViewNote2Text = @"2. These tests: Camera, Video recording, Wi-Fi, 3G/4G, Call just test whether they can launch or not, their quality are not test.";
    ThanksForUsingOurSoftwareText = @"Thanks for using our software.";
    NowTryAgainText = @"Now try again";
    GPSTestText = @"GPS Test";
    TurnOnLocationServicesText = @"Turn on Location Services to allow app to determine your locatio";
    CancelText = @"Cancel";
    SettingText = @"Setting";
    RotationThePhoneToFollowShapeOfNo8 = @"Rotation the device to follow shape of no.8";
    CompassTestText = @"Compass Test";
    MotionTestText = @"Motion Test";
    PlaceYourHandOnToOfTheScreenText = @"Place your hand on top of the screen";
    ProximityTestText = @"Proximity Test";
    EndCallAndCombackAppText = @"End call and come back app";
    PleaseTurnOffWiFiAndEnableMobileDataText = @"Please Turn off Wi-Fi and Enable Mobile Data";
    WiFiTestText = @"WI-FI Test";
    ConnectWiFiToNetworkAndClickStart = @"Connect Wi-Fi to network and click Start";
    PlaceYourFingerOnTheHomeButtonText = @"Place your finger on the Home button";
    TouchIDTestText = @"Touch ID test";
    StartText = @"Start";
    PleaseSetupTouchIDText = @"Please setup Touch ID";
    ButtonsTestText = @"Buttons Test";
    FlipRingSilentSwitchText = @"Flip Ring/Silent switch";
    PressVolumeCongText = @"Press Volume +";
    PressVolumeTruText = @"Press Volume -";
    PressHomeButtonText = @"Press Home Button";
    PressPowerButtonText = @"Press Sleep/Wake button";
    FlashTestText = @"Flash test";
    DontFaceTheBackCameraToLightSourceText = @"Don’t face the back camera to light source";
    DontBlockTheExternalSpeakerAndMicrophoneText = @"Don’t block the external speaker and microphone";
    ExternalSpeakerMICTestText = @"External speaker & MIC test";
    VideoRecordingTestText = @"Video recording test";
    DontBlockTheBackCameraAndMicrophoneText = @"Don’t block the back camera and microphone";
    FrontBackCamerasTestText = @"Front & back cameras test";
    AutomaticTestText = @"Automatic test";
    HoldYourPhoneStableTest = @"Hold your phone stable";
    DontBlockTheCameraText = @"Don't block the camera";
    DragToFillTheWholeDisplayText = @"Drag to fill the whole display";
    TapKeep3FingersOnTheDisplayUntilFinishText = @"Tap & keep 3 fingers on the display until finish";
    WipeToChangeScreenColorText = @"Wipe to change screen color";
    CheckTheScreenCarefullyToFindTheDeadPixelText = @"Check the screen carefully to find the dead pixel";
    ClickStartToBeginText = @"Click Start to begin";
    WereDeadPixelsDiscoveredText = @"Were dead pixels discovered?";
    FailedText=@"Failed";
    PassedText=@"Passed";
    
    
    
    
    //------------------------------------------------
    
    
    
    EnableTheFollowingText=@"Enable the following:";
    WiFiConnectToARouteText=@"Wi-Fi (connect to a route)";
    GPSLocationServicesText=@"GPS location services";
    TouchIDfingerprintScanText=@"Touch ID (fingerprint scan)";
    ProximitySensorText=@"Proximity sensor";
    CoverTheTopPartOfTheScreenWithYourHandText=@"Cover the top part of the screen with your hand";
    CompassGyroText=@"Compass/Gyro";
    WaveTheDeviceInaPatternFormingTheFigure8Text=@"Wave the device in a pattern forming the figure 8";
    //CompassText=@"Compass";
    PutThePhoneInYourHandAndShakeThePhoneToFollowShapeOfno8Text=@"Put the phone in your hand and shake the phone to follow shape of no.8";
    WatchMeWhileIBlinkText=@"Watch me while I blink";
    DigitizerText=@"Digitizer";
    SwipeYourFingerOverTheScreenUntilItIsFullyCoveredText=@"Swipe your finger over the screen until it is fully covered";
    EndTestByPressingTheVolumeButtonText=@"End test by pressing the volume button";
    SwipeText=@"Swipe";
    UnfilledPointsText=@"Unfilled points";
    MissingPixcelsText = @"Missing Pixcels";
    ResultsText=@"Results";
    TouchIDIsOffText=@"Touch ID is off";
    SettingTouchIDPasscodeAddFingerprintText=@"Setting -> Touch ID & Passcode -> add Fingerprint";
    PressOKText=@"Press OK";
    FollowingTheProcessText=@"Following the process";
    ThenReopenTheTradITAppText=@"Then re-open the TradIT app";
    TouchIDIsTestText=@"Touch ID is Test";
    WaitingForProcessText=@"Waiting for process";
    PressVolumeDownButtonx1Text=@"Press volume-down button x 1";
    PressVolumeUpButtonx1Text=@"Press volume-up button x 1";
    FlipTheMuteButtonx1Text=@"Flip the mute button x 1";
    PressTheHomeButtonx1Text=@"Press the Home button x1";
    PressThePowerButtonx1Text = @"Press the Power button x1";
    LoginAgainAndReopenTradITAppText=@"Login again and re-open TradIT app";
    SpeakerTestText=@"Speaker Test";
    SpeakerText=@"Speaker";
    DidYouHearTheSoundClearlyText=@"Did you hear the sound clearly?";
    FlashText=@"Flash:";
    PressStartButtonToTestText=@"Press Start button to test";
    FlashLightText=@"Flashlight";
    DidItTurnonText=@"Did it turn on?";
    VideoBackText=@"Video [back]";
    WasTheQualityokText=@"Was the quality OK?";
    CameraText=@"Front &\nBack Camera";
    AutomaticText=@"Automatic!";
    MicrophoneTestText=@"Microphone Test";
    MicrophoneText=@"Microphone";
    ThenSpeakIntoTheMicrophoneAndListenForTheFeedbackText=@"Then speak into the microphone and listen for the feedback";
    HeadphoneButtonTestText=@"Headphone button test";
    PleasePluginTheHeadphoneCableIntoDeviceText=@"Please plug-in the headphone cable into device";
    PleaseClickButtonOrToTestText=@"Please click button (+) or (-) to test";
    HeadphoneMicText=@"Headphone mic";
    SpeakIntoTheMicrofoneAndListenForTheFeedbackText=@"Speak into the microfone and listen for the feedback";
    EarphoneSpeakerText=@"Earphone [speaker]";
    VibrationText=@"Vibration";
    VibrationTestText=@"Vibration test";
    DidTheDeviceVibrateText=@"Did the device vibrate?";
    TestCompletedText=@"Test Completed";
    WeAreCollectingTheDataText=@"We are collecting the data";
    STARTText=@"Start";
    SkipText=@"Skip";
    OKText=@"OK";
    FAILEDText = @"FAILED";
    PASSEDText = @"PASSED";
    RetestText=@"Retest";
    ResumeText=@"Resume";
    PauseText = @"Pause";
    LCDIsBrokenText = @"LCD Is Broken";
    BrokenText = @"BROKEN";
    PressStartText=@"Press Start";
    LCDTestText=@"LCD Test";
    UnplugHeadphoneText=@"Unplug headphone";
    PleaseCheckAirplaneModeIsOffText = @"Please check Airplane Mode is off";
    CameraCanNotCreateFileText = @"Camera can not create file";
    VideoRecordText = @"Video Record";
    PleaseOpenBluetoothText = @"Please ppen Bluetooth";
    AndOpenBluetoothText = @"Open Bluetooth";
    AnyDeadPixelsOnLCDText = @"Any dead pixels on LCD?";
    PointTheFlashlightTowardsYouText = @"Point the flashlight to wards you";
    PlugHeadphoneToDeviceText = @"Plug headphone to device";
    PressTheVolumeButtonsText = @"Press the Volume buttons";
    SpeakIntoTheMicrophoneText = @"Speak into the microphone";
    ListenToTheFeedbackText = @"Listen to the feedback";
    VolumeUpText = @"Volume Up";
    VolumeDownText = @"Volume Down";
    MuteSwitchText = @"Mute Switch";
    HomeButtonText = @"Home Button";
    PowerButtonText = @"Power Button";
    HeadphoneSpeakerText = @"Headphone [Speaker]";
    ConnectHeadphonesToTheDeviceText = @"Connect headphones to the device";
    PlaceTheHeadphonesOnYourHeadText = @"Place the headphones on your head";
    PlaceTheDeviceOnYourEarText = @"Place The Device On Your Ear";
    FrontBackText = @"Front & Back";
    ListenForHelloText = @"Listen For Hello";
    WarningText = @"Warning";
    PluggedText = @"Plugged";
    CameraTestInOperationText = @"Camera test in operation";
    CosmeticSurfaceGradeText = @"Cosmetic Surface Grade";
    LikeNewText = @"Like New.";
    TouchAndFillOnTheScreenText = @"Touch and fill on the screen";
    PressVolumeButtonToEndTestText = @"Press Volume button to end test";
    NextText = @"Next";
    TestSummaryText = @"Test summary";
    YourScreenWasDimText = @"Your Screen Was Dim";
    DimmingTestIsOperatorText = @"Dimming Test Is Operator";
    HasSoundText = @"Has Sound";
    EarphoneText = @"Earphone";
    PlugInHeadphoneAndListenText = @"Plug in headphone and listen";
    HeadphoneText = @"Headphone";
    SayToHeadphoneMicAndListenText = @"Say to headphone mic and listen";
    UnplugHeadphoneHasSoundInPlayerText = @"Unplug headphone. Has sound in player?";
    SwipeTheScreenUntilFullyCoveredText = @"Swipe the screen until fully covered";
    PressStartButtonAndSaySomethingToTestText = @"Press Start button and say something to test";
    HasSoundInPlayerText = @"Has sound in player?";
    ShakeAndRotateThePhoneUntilYouHearABeepText = @"Shake and rotate the phone until you hear a beep";
    MotionSensorText = @"Motion Sensor";
    PleasePlaceYourHandOnTheTopScreenText = @"Please place your hand on the top screen";
    HasVibrationOnDeviceText = @"Has vibration on device?";
    VideoRecordInOperationText = @"Video Record in operation";
    SelectVideoResultText = @"Select video result";
    HasFlashLightText = @"Has Flashlight?";
    CollectingTheDataText = @"Collecting the data";
    DoesItShowWIFIListText = @"Does it show WIFI list";
    WIFIManualText = @"Wi-Fi Manual";
    DeadPixelTestText = @"Dead Pixel test";
}


- (NSString *)getLanguage:(int)language key:(NSString *)key
{
    if(language < 0)
        language = flagLanguage;
    NSMutableArray *country = [dictionaryLanguage objectForKey:@"country"];
    NSDictionary *countrySelect = [country objectAtIndex:language];
    NSString *countrykey = [countrySelect objectForKey:@"key"];
        // AppDelegateLog(@"countrykey: %@",countrykey);
    NSString *str = [self getValueLanguage:key country:countrykey];
     AppDelegateLog(@"%@: %@",key,str);
    return str.length > 0 ? str : key;
}
- (NSString *)getCurrentCountrykey
{
    if(dictionaryLanguage == Nil)
    {
        AppDelegateLog(@"dictionaryLanguage is Null");
        return @"";
    }
    
    NSMutableArray *country = [dictionaryLanguage objectForKey:@"country"];
    NSDictionary *countrySelect = [country objectAtIndex:flagLanguage];
    NSString *countrykey = [countrySelect objectForKey:@"key"];
    AppDelegateLog(@"countrykey: %@",countrykey);
    return countrykey;
}
- (void)changeLanguage:(int)language
{
    
    if(dictionaryLanguage == Nil)
    {
        AppDelegateLog(@"dictionaryLanguage is Null");
        return;
    }
    flagLanguage = language;
    NSMutableArray *country = [dictionaryLanguage objectForKey:@"country"];
    NSDictionary *countrySelect = [country objectAtIndex:flagLanguage];
    NSString *countrykey = [countrySelect objectForKey:@"key"];
    AppDelegateLog(@"countrykey: %@",countrykey);
    
    
    
    
    UnknownText= [self getValueLanguage:@"UnknownText" country:countrykey];
    UnpluggedText= [self getValueLanguage:@"UnpluggedText" country:countrykey];
    ChargingText=[self getValueLanguage:@"ChargingText" country:countrykey];
    FullText = [self getValueLanguage:@"FullText" country:countrykey];
    BatteryStateText = [self getValueLanguage:@"BatteryStateText" country:countrykey];
    BatteryLevelText = [self getValueLanguage:@"BatteryLevelText" country:countrykey];
    BatteryTestText = [self getValueLanguage:@"BatteryTestText" country:countrykey];
    MultiTouchTestText = [self getValueLanguage:@"MultiTouchTestText" country:countrykey];
    DiagnosticsText = [self getValueLanguage:@"DiagnosticsText" country:countrykey];
    AgreeText = [self getValueLanguage:@"AgreeText" country:countrykey];
    DisagreeText = [self getValueLanguage:@"DisagreeText" country:countrykey];
    BeginViewNote1Text = [self getValueLanguage:@"BeginViewNote1Text" country:countrykey];
    BeginViewNote2Text = [self getValueLanguage:@"BeginViewNote2Text" country:countrykey];
    ThanksForUsingOurSoftwareText = [self getValueLanguage:@"ThanksForUsingOurSoftwareText" country:countrykey];
    DragToFillTheWholeDisplayText = [self getValueLanguage:@"DragToFillTheWholeDisplayText" country:countrykey];
    TapKeep3FingersOnTheDisplayUntilFinishText = [self getValueLanguage:@"TapKeep3FingersOnTheDisplayUntilFinishText" country:countrykey];
    WipeToChangeScreenColorText = [self getValueLanguage:@"WipeToChangeScreenColorText" country:countrykey];
    CheckTheScreenCarefullyToFindTheDeadPixelText = [self getValueLanguage:@"CheckTheScreenCarefullyToFindTheDeadPixelText" country:countrykey];
    ClickStartToBeginText = [self getValueLanguage:@"ClickStartToBeginText" country:countrykey];
    DeadPixelTestText = [self getValueLanguage:@"DeadPixelTestText" country:countrykey];
    WereDeadPixelsDiscoveredText = [self getValueLanguage:@"WereDeadPixelsDiscoveredText" country:countrykey];
    FailedText = [self getValueLanguage:@"FailedText" country:countrykey];
    PassedText = [self getValueLanguage:@"PassedText" country:countrykey];
    AutomaticTestText = [self getValueLanguage:@"AutomaticTestText" country:countrykey];
    HoldYourPhoneStableTest = [self getValueLanguage:@"HoldYourPhoneStableTest" country:countrykey];
    DontBlockTheCameraText = [self getValueLanguage:@"DontBlockTheCameraText" country:countrykey];
    FrontBackCamerasTestText = [self getValueLanguage:@"FrontBackCamerasTestText" country:countrykey];
    DontBlockTheBackCameraAndMicrophoneText = [self getValueLanguage:@"DontBlockTheBackCameraAndMicrophoneText" country:countrykey];
    VideoRecordingTestText = [self getValueLanguage:@"VideoRecordingTestText" country:countrykey];
    ExternalSpeakerMICTestText = [self getValueLanguage:@"ExternalSpeakerMICTestText" country:countrykey];
    DontBlockTheExternalSpeakerAndMicrophoneText = [self getValueLanguage:@"DontBlockTheExternalSpeakerAndMicrophoneText" country:countrykey];
    FlashTestText = [self getValueLanguage:@"FlashTestText" country:countrykey];
    DontFaceTheBackCameraToLightSourceText = [self getValueLanguage:@"DontFaceTheBackCameraToLightSourceText" country:countrykey];
    FlipRingSilentSwitchText = [self getValueLanguage:@"FlipRingSilentSwitchText" country:countrykey];
    PressVolumeCongText = [self getValueLanguage:@"PressVolumeCongText" country:countrykey];
    PressVolumeTruText = [self getValueLanguage:@"PressVolumeTruText" country:countrykey];
    PressHomeButtonText = [self getValueLanguage:@"PressHomeButtonText" country:countrykey];
    PressPowerButtonText = [self getValueLanguage:@"PressPowerButtonText" country:countrykey];
    ButtonsTestText = [self getValueLanguage:@"ButtonsTestText" country:countrykey];
    TouchIDTestText = [self getValueLanguage:@"TouchIDTestText" country:countrykey];
    StartText = [self getValueLanguage:@"StartText" country:countrykey];
    PleaseSetupTouchIDText = [self getValueLanguage:@"PleaseSetupTouchIDText" country:countrykey];
    PlaceYourFingerOnTheHomeButtonText = [self getValueLanguage:@"PlaceYourFingerOnTheHomeButtonText" country:countrykey];
    ConnectWiFiToNetworkAndClickStart = [self getValueLanguage:@"ConnectWiFiToNetworkAndClickStart" country:countrykey];
    WiFiTestText = [self getValueLanguage:@"WiFiTestText" country:countrykey];
    PleaseTurnOffWiFiAndEnableMobileDataText = [self getValueLanguage:@"PleaseTurnOffWiFiAndEnableMobileData" country:countrykey];
    EndCallAndCombackAppText = [self getValueLanguage:@"EndCallAndCombackApp" country:countrykey];
    PlaceYourHandOnToOfTheScreenText = [self getValueLanguage:@"PlaceYourHandOnToOfTheScreenText" country:countrykey];
    ProximityTestText = [self getValueLanguage:@"ProximityTestText" country:countrykey];
    MotionTestText = [self getValueLanguage:@"MotionTestText" country:countrykey];
    CompassTestText = [self getValueLanguage:@"CompassTestText" country:countrykey];
    RotationThePhoneToFollowShapeOfNo8 = [self getValueLanguage:@"RotationThePhoneToFollowShapeOfNo8" country:countrykey];
    TurnOnLocationServicesText = [self getValueLanguage:@"TurnOnLocationServicesText" country:countrykey];
    CancelText = [self getValueLanguage:@"CancelText" country:countrykey];
    SettingText = [self getValueLanguage:@"SettingText" country:countrykey];
    GPSTestText = [self getValueLanguage:@"GPSTestText" country:countrykey];
    NowTryAgainText = [self getValueLanguage:@"NowTryAgainText" country:countrykey];
    
    
    //---------------------------------------------------------------------------------------------- cu
    
    
    EnableTheFollowingText = [self getValueLanguage:@"EnableTheFollowingText" country:countrykey];
    WiFiConnectToARouteText = [self getValueLanguage:@"WiFiConnectToARouteText" country:countrykey];
    GPSLocationServicesText = [self getValueLanguage:@"GPSLocationServicesText" country:countrykey];
    TouchIDfingerprintScanText = [self getValueLanguage:@"TouchIDfingerprintScanText" country:countrykey];
    ProximitySensorText = [self getValueLanguage:@"ProximitySensorText" country:countrykey];
    CoverTheTopPartOfTheScreenWithYourHandText = [self getValueLanguage:@"CoverTheTopPartOfTheScreenWithYourHandText" country:countrykey];
    CompassGyroText = [self getValueLanguage:@"CompassGyroText" country:countrykey];
    WaveTheDeviceInaPatternFormingTheFigure8Text = [self getValueLanguage:@"WaveTheDeviceInaPatternFormingTheFigure8Text" country:countrykey];
    //CompassText = [self getValueLanguage:@"CompassText" country:countrykey];
    PutThePhoneInYourHandAndShakeThePhoneToFollowShapeOfno8Text = [self getValueLanguage:@"PutThePhoneInYourHandAndShakeThePhoneToFollowShapeOfno8Text" country:countrykey];
    WatchMeWhileIBlinkText = [self getValueLanguage:@"WatchMeWhileIBlinkText" country:countrykey];
    DigitizerText = [self getValueLanguage:@"DigitizerText" country:countrykey];
    SwipeYourFingerOverTheScreenUntilItIsFullyCoveredText = [self getValueLanguage:@"SwipeYourFingerOverTheScreenUntilItIsFullyCoveredText" country:countrykey];
    EndTestByPressingTheVolumeButtonText = [self getValueLanguage:@"EndTestByPressingTheVolumeButtonText" country:countrykey];
    SwipeText = [self getValueLanguage:@"SwipeText" country:countrykey];
    UnfilledPointsText = [self getValueLanguage:@"UnfilledPointsText" country:countrykey];
    MissingPixcelsText = [self getValueLanguage:@"MissingPixcelsText" country:countrykey];
    ListenForHelloText = [self getValueLanguage:@"ListenForHelloText" country:countrykey];
    PointTheFlashlightTowardsYouText = [self getValueLanguage:@"PointTheFlashlightTowardsYouText" country:countrykey];
    ResultsText = [self getValueLanguage:@"ResultsText" country:countrykey];
    FAILEDText = [self getValueLanguage:@"FailedText" country:countrykey];
    PASSEDText = [self getValueLanguage:@"PassedText" country:countrykey];
    TouchIDIsOffText = [self getValueLanguage:@"TouchIDIsOffText" country:countrykey];
    SettingTouchIDPasscodeAddFingerprintText = [self getValueLanguage:@"SettingTouchIDPasscodeAddFingerprintText" country:countrykey];
    PressOKText = [self getValueLanguage:@"PressOKText" country:countrykey];
    FollowingTheProcessText = [self getValueLanguage:@"FollowingTheProcessText" country:countrykey];
    ThenReopenTheTradITAppText = [self getValueLanguage:@"ThenReopenTheTradITAppText" country:countrykey];
    TouchIDIsTestText = [self getValueLanguage:@"TouchIDIsTestText" country:countrykey];
    WaitingForProcessText = [self getValueLanguage:@"WaitingForProcessText" country:countrykey];
    PressVolumeDownButtonx1Text = [self getValueLanguage:@"PressVolumeDownButtonx1Text" country:countrykey];
    PressVolumeUpButtonx1Text = [self getValueLanguage:@"PressVolumeUpButtonx1Text" country:countrykey];
    FlipTheMuteButtonx1Text = [self getValueLanguage:@"FlipTheMuteButtonx1Text" country:countrykey];
    PressTheHomeButtonx1Text = [self getValueLanguage:@"PressTheHomeButtonx1Text" country:countrykey];
    PressThePowerButtonx1Text = [self getValueLanguage:@"PressThePowerButtonx1Text" country:countrykey];
    LoginAgainAndReopenTradITAppText = [self getValueLanguage:@"LoginAgainAndReopenTradITAppText" country:countrykey];
    SpeakerTestText = [self getValueLanguage:@"SpeakerTestText" country:countrykey];
    SpeakerText = [self getValueLanguage:@"SpeakerText" country:countrykey];
    DidYouHearTheSoundClearlyText = [self getValueLanguage:@"DidYouHearTheSoundClearlyText" country:countrykey];
    FlashText = [self getValueLanguage:@"FlashText" country:countrykey];
    PressStartButtonToTestText = [self getValueLanguage:@"PressStartButtonToTestText" country:countrykey];
    FlashLightText = [self getValueLanguage:@"FlashLightText" country:countrykey];
    DidItTurnonText = [self getValueLanguage:@"DidItTurnonText" country:countrykey];
    VideoBackText = [self getValueLanguage:@"VideoBackText" country:countrykey];
    WasTheQualityokText = [self getValueLanguage:@"WasTheQualityokText" country:countrykey];
    CameraText = [self getValueLanguage:@"CameraText" country:countrykey];
    AutomaticText = [self getValueLanguage:@"AutomaticText" country:countrykey];
    MicrophoneTestText = [self getValueLanguage:@"MicrophoneTestText" country:countrykey];
    MicrophoneText = [self getValueLanguage:@"MicrophoneText" country:countrykey];
    ThenSpeakIntoTheMicrophoneAndListenForTheFeedbackText = [self getValueLanguage:@"ThenSpeakIntoTheMicrophoneAndListenForTheFeedbackText" country:countrykey];
    HeadphoneButtonTestText = [self getValueLanguage:@"HeadphoneButtonTestText" country:countrykey];
    PleasePluginTheHeadphoneCableIntoDeviceText = [self getValueLanguage:@"PleasePluginTheHeadphoneCableIntoDeviceText" country:countrykey];
    PleaseClickButtonOrToTestText = [self getValueLanguage:@"PleaseClickButtonOrToTestText" country:countrykey];
    HeadphoneMicText = [self getValueLanguage:@"HeadphoneMicText" country:countrykey];
    SpeakIntoTheMicrofoneAndListenForTheFeedbackText = [self getValueLanguage:@"SpeakIntoTheMicrofoneAndListenForTheFeedbackText" country:countrykey];
    EarphoneSpeakerText = [self getValueLanguage:@"EarphoneSpeakerText" country:countrykey];
    VibrationText = [self getValueLanguage:@"VibrationText" country:countrykey];
    VibrationTestText = [self getValueLanguage:@"VibrationTestText" country:countrykey];
    DidTheDeviceVibrateText = [self getValueLanguage:@"DidTheDeviceVibrateText" country:countrykey];
    TestCompletedText = [self getValueLanguage:@"TestCompletedText" country:countrykey];
    WeAreCollectingTheDataText = [self getValueLanguage:@"WeAreCollectingTheDataText" country:countrykey];
    STARTText = [self getValueLanguage:@"StartText" country:countrykey];
    SkipText = [self getValueLanguage:@"SkipText" country:countrykey];
    OKText = [self getValueLanguage:@"OKText" country:countrykey];
    RetestText = [self getValueLanguage:@"RetestText" country:countrykey];
    ResumeText = [self getValueLanguage:@"ResumeText" country:countrykey];
    PauseText = [self getValueLanguage:@"PauseText" country:countrykey];
    PressStartText = [self getValueLanguage:@"PressStartText" country:countrykey];
    LCDTestText = [self getValueLanguage:@"LCDTestText" country:countrykey];
    UnplugHeadphoneText = [self getValueLanguage:@"UnplugHeadphoneText" country:countrykey];
    PleaseCheckAirplaneModeIsOffText = [self getValueLanguage:@"PleaseCheckAirplaneModeIsOffText" country:countrykey];
    CameraCanNotCreateFileText = [self getValueLanguage:@"CameraCanNotCreateFileText" country:countrykey];
    VideoRecordText = [self getValueLanguage:@"VideoRecordText" country:countrykey];
    PleaseOpenBluetoothText =[self getValueLanguage:@"PleaseOpenBluetoothText" country:countrykey];
    AndOpenBluetoothText = [self getValueLanguage:@"AndOpenBluetoothText" country:countrykey];
    AnyDeadPixelsOnLCDText = [self getValueLanguage:@"AnyDeadPixelsOnLCDText" country:countrykey];
    PlugHeadphoneToDeviceText = [self getValueLanguage:@"PlugHeadphoneToDeviceText" country:countrykey];
    PressTheVolumeButtonsText = [self getValueLanguage:@"PressTheVolumeButtonsText" country:countrykey];
    SpeakIntoTheMicrophoneText= [self getValueLanguage:@"SpeakIntoTheMicrophoneText" country:countrykey];
    ListenToTheFeedbackText = [self getValueLanguage:@"ListenToTheFeedbackText" country:countrykey];
    HeadphoneSpeakerText = [self getValueLanguage:@"HeadphoneSpeakerText" country:countrykey];
    ConnectHeadphonesToTheDeviceText = [self getValueLanguage:@"ConnectHeadphonesToTheDeviceText" country:countrykey];
    PlaceTheHeadphonesOnYourHeadText = [self getValueLanguage:@"PlaceTheHeadphonesOnYourHeadText" country:countrykey];
    PlaceTheDeviceOnYourEarText = [self getValueLanguage:@"PlaceTheDeviceOnYourEarText" country:countrykey];
    FrontBackText = [self getValueLanguage:@"FrontBackText" country:countrykey];
    VolumeUpText = [self getValueLanguage:@"VolumeUpText" country:countrykey];
    VolumeDownText = [self getValueLanguage:@"VolumeDownText" country:countrykey];
    MuteSwitchText = [self getValueLanguage:@"MuteSwitchText" country:countrykey];
    HomeButtonText = [self getValueLanguage:@"HomeButtonText" country:countrykey];
    PowerButtonText = [self getValueLanguage:@"PowerButtonText" country:countrykey];
    LCDIsBrokenText = [self getValueLanguage:@"LCDIsBrokenText" country:countrykey];
    BrokenText = [self getValueLanguage:@"BrokenText" country:countrykey];
    WarningText = [self getValueLanguage:@"WarningText" country:countrykey];
    PluggedText = [self getValueLanguage:@"PluggedText" country:countrykey];
    CameraTestInOperationText = [self getValueLanguage:@"CameraTestInOperationText" country:countrykey];
    CosmeticSurfaceGradeText = [self getValueLanguage:@"CosmeticSurfaceGradeText" country:countrykey];
    LikeNewText = [self getValueLanguage:@"LikeNewText" country:countrykey];
    TouchAndFillOnTheScreenText = [self getValueLanguage:@"TouchAndFillOnTheScreenText" country:countrykey];
    PressVolumeButtonToEndTestText = [self getValueLanguage:@"PressVolumeButtonToEndTestText" country:countrykey];
    NextText = [self getValueLanguage:@"NextText" country:countrykey];
    TestSummaryText = [self getValueLanguage:@"TestSummaryText" country:countrykey];
    YourScreenWasDimText = [self getValueLanguage:@"YourScreenWasDimText" country:countrykey];
    DimmingTestIsOperatorText = [self getValueLanguage:@"DimmingTestIsOperatorText" country:countrykey];
    HasSoundText = [self getValueLanguage:@"HasSoundText" country:countrykey];
    EarphoneText = [self getValueLanguage:@"EarphoneText" country:countrykey];
    PlugInHeadphoneAndListenText = [self getValueLanguage:@"PlugInHeadphoneAndListenText" country:countrykey];
    HeadphoneText = [self getValueLanguage:@"HeadphoneText" country:countrykey];
    SayToHeadphoneMicAndListenText = [self getValueLanguage:@"SayToHeadphoneMicAndListenText" country:countrykey];
    UnplugHeadphoneHasSoundInPlayerText = [self getValueLanguage:@"UnplugHeadphoneHasSoundInPlayerText" country:countrykey];
    SwipeTheScreenUntilFullyCoveredText = [self getValueLanguage:@"SwipeTheScreenUntilFullyCoveredText" country:countrykey];
    PressStartButtonAndSaySomethingToTestText = [self getValueLanguage:@"PressStartButtonAndSaySomethingToTestText" country:countrykey];
    HasSoundInPlayerText = [self getValueLanguage:@"HasSoundInPlayerText" country:countrykey];
    ShakeAndRotateThePhoneUntilYouHearABeepText = [self getValueLanguage:@"ShakeAndRotateThePhoneUntilYouHearABeepText" country:countrykey];
    MotionSensorText = [self getValueLanguage:@"MotionSensorText" country:countrykey];
    PleasePlaceYourHandOnTheTopScreenText = [self getValueLanguage:@"PleasePlaceYourHandOnTheTopScreenText" country:countrykey];
    HasVibrationOnDeviceText = [self getValueLanguage:@"HasVibrationOnDeviceText" country:countrykey];
    VideoRecordInOperationText = [self getValueLanguage:@"VideoRecordInOperationText" country:countrykey];
    SelectVideoResultText = [self getValueLanguage:@"SelectVideoResultText" country:countrykey];
    HasFlashLightText = [self getValueLanguage:@"HasFlashLightText" country:countrykey];
    CollectingTheDataText = [self getValueLanguage:@"CollectingTheDataText" country:countrykey];
    DoesItShowWIFIListText = [self getValueLanguage:@"DoesItShowWIFIListText" country:countrykey];
    WIFIManualText = [self getValueLanguage:@"WIFIManualText" country:countrykey];
//    EnableTheFollowingText = [self getValueLanguage:@"EnableTheFollowingText" country:countrykey];
//    WiFiConnectToaRouteText = [self getValueLanguage:@"WiFiConnectToaRouteText" country:countrykey];
//    GPSLocationServicesText = [self getValueLanguage:@"GPSLocationServicesText" country:countrykey];
//    TouchIDFingerprintScanText = [self getValueLanguage:@"TouchIDFingerprintScanText" country:countrykey];
//    ProximitySenserText = [self getValueLanguage:@"ProximitySenserText" country:countrykey];

    
}
- (void)createDefaultLanguage
{

    NSString *data = @"{\"country\": [{\"key\": \"en\",\"value\": \"EN\"},{\"key\": \"cn\",\"value\": \"Mandarin\"},{\"key\": \"hk\",\"value\": \"Cantonese\"},{\"key\": \"sp\",\"value\": \"Spanish\"}],\"language\": {\"EnableTheFollowingText\": {\"en\": \"Enable the following:\",\"cn\": \"请开启以下功能:\",\"hk\": \"啟用以下：\",\"sp\": \"Enable the following:\"},\"WiFiConnectToARouteText\": {\"en\": \"Wi-Fi (connect to a router)\",\"cn\": \"请开启Wi-Fi连接至无线网络\",\"hk\": \"無線網絡連接（連接到路由器）\",\"sp\": \"Wi-Fi (connect to a router)\"},\"GPSLocationServicesText\": {\"en\": \"GPS location services\",\"cn\": \"请开启GPS定位服务\",\"hk\": \"GPS定位服務\",\"sp\": \"GPS location services\"},\"TouchIDfingerprintScanText\": {\"en\": \"Touch ID (fingerprint scan)\",\"cn\": \"请开启Touch ID(指纹扫描)\",\"hk\": \"觸摸ID（指紋掃描）\",\"sp\": \"Touch ID (fingerprint scan)\"},\"ProximitySensorText\": {\"en\": \"Proximity sensor\",\"cn\": \"接近传感器\",\"hk\": \"鄰近感應器\",\"sp\": \"Proximity sensor\"},\"CoverTheStopPartOfTheScreenWithYourHandText\": {\"en\": \"Cover the stop part of the screen with your hand\",\"cn\": \"请用手盖住屏幕的上部\",\"hk\": \"覆蓋屏幕的用你的手停止部\",\"sp\": \"Cover the stop part of the screen with your hand\"},\"CompassGyroText\": {\"en\": \"Compass/Gyro\",\"cn\": \"指南针/陀螺仪\",\"hk\": \"指南針/陀螺儀\",\"sp\": \"Compass/Gyro\"},\"WaveTheDeviceInaPatternFormingTheFigure8Text\": {\"en\": \"Wave the device in a pattern forming the figure 8\",\"cn\": \"请挥动设备在空中画“8”字图案\",\"hk\": \"打8字形式搖動智能裝置\",\"sp\": \"Wave the device in a pattern forming the figure 8\"},\"CompassText\": {\"en\": \"Compass\",\"cn\": \"指南针\",\"hk\": \"指南針\",\"sp\": \"Compass\"},\"PutThePhoneInYourHandAndShakeThePhoneToFollowShapeOfno8Text\": {\"en\": \"Put the phone in your hand and shake the phone to follow shape of no.8\",\"cn\": \"请将手机放在手中并晃动手机形成数字“8”的图形\",\"hk\": \"打8字形式搖動智能裝置\",\"sp\": \"Put the phone in your hand and shake the phone to follow shape of no.8\"},\"WatchMeWhileIBlinkText\": {\"en\": \"Watch me while I blink\",\"cn\": \"请观测屏幕闪烁\",\"hk\": \"留意屏幕閃動\",\"sp\": \"Watch me while I blink\"},\"DigitizerText\": {\"en\": \"Digitizer\",\"cn\": \"触摸屏\",\"hk\": \"數字化儀\",\"sp\": \"Digitizer\"},\"SwipeYourFingerOverTheScreenUntilItIsFullyCoveredText\": {\"en\": \"Swipe your finger over the screen until it is fully covered\",\"cn\": \"请将手指用力在屏幕上滑动直至完全覆盖屏幕\",\"hk\": \"用手指在屏幕上輕掃，直到完全填滿\",\"sp\": \"Swipe your finger over the screen until it is fully covered\"},\"EndTestByPressingTheVolumeButtonText\": {\"en\": \"Abort test by pressing volume button (+)(-)\",\"cn\": \"按音量按鈕中止測試 (+)(-)\",\"hk\": \"按音量按钮中止测试 (+)(-)\",\"sp\": \"Abortar prueba pulsando el botón de volumen (+)(-)\"},\"SwipeText\": {\"en\": \"Swipe\",\"cn\": \"滑动\",\"hk\": \"輕掃\",\"sp\": \"Swipe\"},\"UnfilledPointsText\": {\"en\": \"Unfilled points \",\"cn\": \"未能填充的点\",\"hk\": \"未填點\",\"sp\": \"Unfilled points\"},\"ResultsText\": {\"en\": \"Results\",\"cn\": \"结果\",\"hk\": \"結果\",\"sp\": \"Results:\"},\"FAILEDText\": {\"en\": \"FAILED\",\"cn\": \"失败\",\"hk\": \"失敗\",\"sp\": \"FAILED\"},\"PASSEDText\": {\"en\": \"PASSED\",\"cn\": \"通过\",\"hk\": \"通過\",\"sp\": \"PASSED\"},\"TouchIDIsOffText\": {\"en\": \"Touch ID is off\",\"cn\": \"Touch ID关闭\",\"hk\": \"按確定\",\"sp\": \"Touch ID is off\"},\"SettingTouchIDPasscodeAddFingerprintText\": {\"en\": \"Setting -> Touch ID & Passcode -> add Fingerprint\",\"cn\": \"请通过：设置 -> Touch ID与密码 -> 添加指纹\",\"hk\": \"設定 - >Touch ID與密碼 - >加入指紋\",\"sp\": \"Setting -> Touch ID & Passcode -> add Fingerprint\"},\"PressOKText\": {\"en\": \"Press OK\",\"cn\": \"请点击OK\",\"hk\": \"按確定\",\"sp\": \"Press OK\"},\"FollowingTheProcessText\": {\"en\": \"Following the process\",\"cn\": \"请按照程序操作\",\"hk\": \"按照流程\",\"sp\": \"Following the process\"},\"ThenReopenTheTradITAppText\": {\"en\": \"Then re-open the TradIT app\",\"cn\": \"接着请重新打开TradIT应用程序\",\"hk\": \"然後重新打開TradIT 應用程式\",\"sp\": \"Then re-open the TradIT app\"},\"TouchIDIsTestText\": {\"en\": \"Touch ID is Test\",\"cn\": \"正在测试Touch ID\",\"hk\": \"測試 Touch ID\",\"sp\": \"Touch ID is Test\"},\"WaitingForProcessText\": {\"en\": \"Waiting for process…\",\"cn\": \"请稍候 …\",\"hk\": \"等待過程中...\",\"sp\": \"Waiting for process…\"},\"PressVolumedownButtonx1Text\": {\"en\": \"Press volume-down button x 1\",\"cn\": \"请点击音量减少键一次\",\"hk\": \"按音量減小按鈕×1\",\"sp\": \"Press volume-down button x 1\"},\"PressVolumeupButtonx1Text\": {\"en\": \"Press volume-up button x 1\",\"cn\": \"请点击音量增加键一次\",\"hk\": \"按音量增大按鈕×1\",\"sp\": \"Press volume-up button x 1\"},\"FlipTheMuteButtonx1Text\": {\"en\": \"Flip the mute button ONLY x 1\",\"cn\": \"请拨动静音键一次\",\"hk\": \"翻動靜音按鈕×1\",\"sp\": \"Flip the mute button ONLY x 1\"},\"PressTheHomeButtonx1Text\": {\"en\": \"Press the Home button x 1\",\"cn\": \"请点按主屏按键(Home键)一次\",\"hk\": \"按Home按鈕×1\",\"sp\": \"Press the Home button x 1\"},\"PressThePowerButtonx1Text\": {\"en\": \"Press the Power button x 1\",\"cn\": \"请点按电源键一次\",\"hk\": \"按電源按鈕×1\",\"sp\": \"Press the Home button x 1\"},\"LoginAgainAndReopenTradITAppText\": {\"en\": \"Login again and re-open TradIT app\",\"cn\": \"接下来请再次登入并重新开启TradIT应用程序\",\"hk\": \"然後重新打開TradIT應用程式\",\"sp\": \"Login again and re-open TradIT app\"},\"SpeakerTestText\": {\"en\": \"Speaker Test\",\"cn\": \"扬声器测试\",\"hk\": \"揚聲器測試\",\"sp\": \"Speaker Test\"},\"SpeakerText\": {\"en\": \"Speaker\",\"cn\": \"扬声器测试\",\"hk\": \"揚聲器測試\",\"sp\": \"Speaker\"},\"DidYouHearTheSoundClearlyText\": {\"en\": \"Did you hear the sound clearly?\",\"cn\": \"是否清楚听到声音?\",\"hk\": \"是否清晰聽到聲音？\",\"sp\": \"Did you hear the sound clearly?\"},\"FlashText\": {\"en\": \"Flash\",\"cn\": \"闪光灯\",\"hk\": \"閃光燈\",\"sp\": \"Flash\"},\"PressStartButtonToTestText\": {\"en\": \"Press Start button to test\",\"cn\": \"按下啟動按鈕來測試\",\"hk\": \"按下启动按钮来测试\",\"sp\": \"Press Start button to test\"},\"FlashLightText\": {\"en\": \"Flashlight\",\"cn\": \"闪光灯\",\"hk\": \"閃光燈\",\"sp\": \"linterna\"},\"DidItTurnonText\": {\"en\": \"Did it turn on?\",\"cn\": \"是否打开?\",\"hk\": \"是否開啟?\",\"sp\": \"Did it turn on?\"},\"VideoBackText\": {\"en\": \"Video [back]\",\"cn\": \"视频[后摄像头]\",\"hk\": \"視頻[後鏡頭]\",\"sp\": \"Video [back]\"},\"WasTheQualityokText\": {\"en\": \"Was the quality OK?\",\"cn\": \"视频质量是否可接受?\",\"hk\": \"質數如何？\",\"sp\": \"Was the quality OK?\"},\"CameraText\": {\"en\": \"Camera\",\"cn\": \"摄像头测试\",\"hk\": \"相機測試\",\"sp\": \"Camera\"},\"AutomaticText\": {\"en\": \"Automatic!\",\"cn\": \"自动进行!\",\"hk\": \"自動！\",\"sp\": \"Automatic!\"},\"MicrophoneTestText\": {\"en\": \"Microphone Test\",\"cn\": \"话筒测试\",\"hk\": \"話筒測試\",\"sp\": \"Microphone Test\"},\"MicrophoneText\": {\"en\": \"Microphone\",\"cn\": \"话筒测试\",\"hk\": \"話筒測試\",\"sp\": \"Microphone\"},\"ThenSpeakIntoTheMicrophoneAndListenForTheFeedbackText\": {\"en\": \"Then speak into the microphone and listen for the feedback\",\"cn\": \"接下来请对着话筒说话并听取反馈\",\"hk\": \"然後對著話筒錄音，並聽取重播\",\"sp\": \"Then speak into the microphone and listen for the feedback\"},\"HeadphoneButtonTestText\": {\"en\": \"Headphone [button]\",\"cn\": \"耳机按键测试\",\"hk\": \"耳機按鈕測試\",\"sp\": \"Headphone [button]\"},\"PleasePluginTheHeadphoneCableIntoDeviceText\": {\"en\": \"Please plug-in the headphone cable into device\",\"cn\": \"请将耳机插入至设备\",\"hk\": \"請插入耳機到智能裝置\",\"sp\": \"Please plug-in the headphone cable into device\"},\"PlugHeadphoneToDeviceText\": {\"en\": \"Plug headphones to the device\",\"cn\": \"请将耳机插入至设备\",\"hk\": \"請插入耳機到智能裝置\",\"sp\": \"plug the headphone to device\"},\"PleaseClickButtonOrToTestText\": {\"en\": \"Please click button (+) or (-) to test\",\"cn\": \"请点击按键(+)或(-)进行测试\",\"hk\": \"請按（+）或（ - ）來測試\",\"sp\": \"Please click button (+) or (-) to test\"},\"HeadphoneMicText\": {\"en\": \"Headphone mic\",\"cn\": \"耳机话筒\",\"hk\": \"耳機話筒測試\",\"sp\": \"Headphone mic\"},\"SpeakIntoTheMicrofoneAndListenForTheFeedbackText\": {\"en\": \"Speak into the microfone and listen for the feedback\",\"cn\": \"请对着耳机的话筒说话并听取反馈\",\"hk\": \"對著耳機話筒錄音，並聽取重播\",\"sp\": \"Speak into the microfone and listen for the feedback\"},\"EarphoneSpeakerText\": {\"en\": \"Earphone [speaker]\",\"cn\": \"听筒 [扬声器]\",\"hk\": \"耳機[揚聲器]\",\"sp\": \"Earphone [speaker]\"},\"VibrationText\": {\"en\": \"Vibration\",\"cn\": \"震动\",\"hk\": \"振動\",\"sp\": \"Vibration\"},\"VibrationTestText\": {\"en\": \"Vibration test\",\"cn\": \"振动测试\",\"hk\": \"振動試驗\",\"sp\": \"Vibration test\"},\"DidTheDeviceVibrateText\": {\"en\": \"Did the device vibrate?\",\"cn\": \"设备是否震动?\",\"hk\": \"設備有否振動?\",\"sp\": \"Did the device vibrate?\"},\"TestCompletedText\": {\"en\": \"Test Completed\",\"cn\": \"测试完成\",\"hk\": \"測試完成\",\"sp\": \"Test Completed\"},\"WeAreCollectingTheDataText\": {\"en\": \"We are collecting the data\",\"cn\": \"耳机话筒\",\"hk\": \"耳機話筒測試\",\"sp\": \"We are collecting the data\"},\"STARTText\": {\"en\": \"Start\",\"cn\": \"开始\",\"hk\": \"開始\",\"sp\": \"Start\"},\"SkipText\": {\"en\": \"Skip\",\"cn\": \"跳过\",\"hk\": \"略過\",\"sp\": \"Skip\"},\"OKText\": {\"en\": \"OK\",\"cn\": \"OK\",\"hk\": \"OK\",\"sp\": \"OK\"},\"RetestText\": {\"en\": \"Retest\",\"cn\": \"重新测试\",\"hk\": \"重新測試\",\"sp\": \"Retest\"},\"ResumeText\": {\"en\": \"Resume\",\"cn\": \"重新开始\",\"hk\": \"重新開始\",\"sp\": \"Resume\"},\"PressStartText\": {\"en\": \"Press Start\",\"cn\": \"点击开始\",\"hk\": \"按下開始\",\"sp\": \"Press Start\"},\"LCDTestText\": {\"en\": \"LCD Test\",\"cn\": \"液晶显示屏测试\",\"hk\": \"液晶顯示屏測試\",\"sp\": \"LCD Test\"},\"PauseText\": {\"en\": \"Pause\",\"cn\": \"暫停\",\"hk\": \"暂停\",\"sp\": \"Pausa\"},\"AnyDeadPixelsOnLCDText\": {\"en\": \"Any dead pixels on LCD?\",\"cn\": \"任何坏点在LCD上？\",\"hk\": \"任何壞點在LCD上？\",\"sp\": \"Cualquier píxeles muertos en la pantalla LCD?\"},\"UnplugHeadphoneText\": {\"en\": \"Unplug headphone\",\"cn\": \"拔下耳机\",\"hk\": \"拔下耳機\",\"sp\": \"Unplug headphone\"},\"AndOpenBluetoothText\": {\"en\": \"Open Bluetooth\",\"cn\": \"打开蓝牙\",\"hk\": \"打開藍牙\",\"sp\": \"Bluetooth Abrir\"},\"MissingPixcelsText\": {\"en\": \"Missing Pixcels\",\"cn\": \"缺少Pixcels\",\"hk\": \"缺少Pixcels\",\"sp\": \"Pixcels Desaparecidos\"},\"ListenForHelloText\": {\"en\": \"Listen for Hello\",\"cn\": \"收聽你好\",\"hk\": \"收听你好\",\"sp\": \"Escuche Hola\"},\"PointTheFlashlightTowardsYouText\": {\"en\": \"Point the flashlight to wards you\",\"cn\": \"點手電筒朝你\",\"hk\": \"点手电筒朝你\",\"sp\": \"Point the flashlight to wards you\"},\"PressTheVolumeButtonsText\": {\"en\": \"Press the volume buttons\",\"cn\": \"按音量按鈕\",\"hk\": \"按音量按钮\",\"sp\": \"Pulse el botón de volumen\"},\"SpeakIntoTheMicrophoneText\": {\"en\": \"Speak into the microphone\",\"cn\": \"对着麦克风讲话\",\"hk\": \"對著麥克風講話\",\"sp\": \"Hable por el micrófono\"},\"ListenToTheFeedbackText\": {\"en\": \"Listen to the feedback\",\"cn\": \"聽反饋\",\"hk\": \"听反馈\",\"sp\": \"Escuche las votaciones\"},\"HeadphoneSpeakerText\": {\"en\": \"Headphone [speaker]\",\"cn\": \"聽反饋\",\"hk\": \"听反馈\",\"sp\": \"Headphone [speaker]\"},\"ConnectHeadphonesToTheDeviceText\": {\"en\": \"Connect headphones to the device\",\"cn\": \"聽反饋\",\"hk\": \"听反馈\",\"sp\": \"Connect headphones to the device\"},\"PlaceTheHeadphonesOnYourHeadText\": {\"en\": \"Place the headphones on your head\",\"cn\": \"聽反饋\",\"hk\": \"听反馈\",\"sp\": \"Place the headphones on your head\"},\"PlaceTheDeviceOnYourEarText\": {\"en\": \"Place the device on your ear\",\"cn\": \"聽反饋\",\"hk\": \"听反馈\",\"sp\": \"Place the device on your ear\"},\"FrontBackText\": {\"en\": \"Front & Back\",\"cn\": \"聽正面和背面\",\"hk\": \"听前后\",\"sp\": \"frente atrás\"},\"CameraCanNotCreateFileText\": {\"en\":\"Camera can not create file\",\"cn\": \"相机无法创建文件\",\"hk\": \"相機無法創建文件\",\"sp\": \"La cámara no puede crear el archivo\"},\"VideoRecordText\": {\"en\":\"Video Record\",\"cn\": \"視頻記錄\",\"hk\": \"视频记录\",\"sp\": \"Grabación de video\"},\"VolumeUpText\": {\"en\":\"Volume Up\",\"cn\": \"提高音量\",\"hk\": \"提高音量\",\"sp\": \"Sube el volumen\"},\"VolumeDownText\": {\"en\":\"Volume Down\",\"cn\": \"音量减小\",\"hk\": \"調低音量\",\"sp\": \"Bajar el volumen\"},\"MuteSwitchText\": {\"en\":\"Mute Switch\",\"cn\": \"静音开关\",\"hk\": \"靜音開關\",\"sp\": \"Interruptor Mute\"},\"HomeButtonText\": {\"en\":\"Home Button\",\"cn\": \"主頁按鈕\",\"hk\": \"主页按钮\",\"sp\": \"Botón de inicio\"},\"PowerButtonText\": {\"en\":\"Power Button\",\"cn\": \"電源按鈕\",\"hk\": \"电源开关\",\"sp\": \"Botón de encendido\"}}}";
    
    NSString *FileName = [[NSBundle mainBundle] pathForResource:@"Language" ofType:@"json"];
   // AppDelegateLog(@"file Path:%@",FileName);
    if([[NSFileManager defaultManager] fileExistsAtPath:FileName])
    {
        AppDelegateLog(@"file exists");
        NSString *dataFile = [NSString stringWithContentsOfFile:FileName encoding:NSUTF8StringEncoding error:Nil];
        if(dataFile != Nil)
            data = [NSString stringWithFormat:@"%@",dataFile];
    }else AppDelegateLog(@"file not exists");

    [self saveFileLanguage:data];
}
- (BOOL)saveFileLanguage:(NSString *)data
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *FileName = [NSString stringWithFormat:@"%@/language.txt", [paths objectAtIndex:0]];
    NSError *er = Nil;
    [data writeToFile:FileName atomically:YES encoding:NSUTF8StringEncoding error:&er];
    if(er)
    {
        AppDelegateLog(@"Error: %@",[er description]);
        return NO;
    }
    return YES;
}

- (void)loadDataLanguage
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *FileName = [[NSString alloc] initWithFormat:@"%@/language.txt", [paths objectAtIndex:0]];
    [self loadDataLanguageWithPath:FileName];
    
}
- (NSString *)loadDataLanguageWithPath:(NSString *)path
{
    if([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSError *er;
        NSString *dataFile = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&er];
        //AppDelegateLog(@"dataFile : \n%@",dataFile);
        NSDictionary *dataDictionary = [self diccionaryFromJsonString:dataFile];
        if(dataDictionary != Nil)
        {
            AppDelegateLog(@"load data language success");
            dictionaryLanguage = [[NSDictionary alloc] initWithDictionary:dataDictionary];
            return dataFile;
        }
        else
        {
            AppDelegateLog(@"data language error");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Language data error" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:Nil, nil];
            [alert show];
        }
        return @"";
    }
    return @"";
}
- (NSString *)getValueLanguage:(NSString *)key country:(NSString *)countryKey
{
    NSString *temp = [[[dictionaryLanguage objectForKey:@"language"] objectForKey:key] objectForKey:countryKey];
    //NSString *subCatSelectedName = [temp stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //AppDelegateLog(@"%@ : %@",key,temp);
    if(temp == Nil)
        temp = key;
    return temp;
}
#pragma mark -
#pragma mark Method Default
- (void)initDefault
{
    fastMode = NO;
    isLightTest = NO;
    timeTest = 3;
    timeout= 10;
    MessageSaveData = Nil;
    isShowNotification = NO;
    accessRotate = NO;
    isFinished = NO;
    isHandTest = NO;// cap nhat trong idevice khi nhan duoc lenh run isHandTest = yes;
    flagLanguage = 0;
    dictionaryLanguage = Nil;

 
}
#pragma mark -
#pragma mark Method Delegate

- (void)dealloc
{
    if(serverProcessImage)
    {
       // [serverProcessImage release];
        self.serverProcessImage = Nil;
    }
    if(dictionaryLanguage)
    {
        dictionaryLanguage = Nil;
    }
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    iOS = [[UIDevice currentDevice].systemVersion floatValue];
    iDevice = Nil;
    locattorID = Nil;
//    hidenStatusBar = NO;
    forceVolume = -1;
    serverProcessImage = Nil;
    isExistedMainCamera = NO;
    isExistedFrontCamera = NO;
    _canCheck = 0;
    AppLog(@"iOS: %.2f",iOS);
    
    if(!iDevice)
    {
        iDevice = [[_iDevice alloc] init];
         isActive = YES;
        // Apply object to share
        AppShare = self;
        AppShare.tableData = nil;
        AppShare.testedData = nil;
        AppShare.dismissable = NO;
        [self initDefault];
        // Override point for customization after application launch.
        [self initTextDefault];
        
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filename = [NSString stringWithFormat:@"%@/language.txt", [paths objectAtIndex:0]];
       
            [self createDefaultLanguage];
        
        [self loadDataLanguage];
        
        // [self changeLanguage:0];

        
        
//        CGRect rect = [[UIScreen mainScreen] bounds];
//        AppLog(@"Rect: %@",NSStringFromCGRect(rect));
//        self.window = [[UIWindow alloc] initWithFrame:rect];
//       
//
//        
//        viewController = [[ViewController alloc] init];
//        viewController.acceptRotate = NO;
//        viewController.view.frame = rect;
//        nav = [[UINavigationController alloc] initWithRootViewController:viewController];
//        nav.view.backgroundColor = [UIColor whiteColor];
//        nav.navigationBar.hidden = NO;
//        
//        
//        viewController.aceptRetest = NO;
//        self.window.rootViewController = nav;
//        [self.window makeKeyAndVisible];

        
        [iDevice setupEnvironment];
        

        
        NSString *dCode = getPhoneModal(2);
        dcode = [dCode floatValue];
        radius = 30;
        fingers = 5;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
        deviceLock = NO;
        if(iOS > 6)
        {
            CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),    //center
                                        NULL,                                               // observer
                                        displayStatusChanged,                               // callback
                                        CFSTR("com.apple.springboard.lockcomplete"),        // event name
                                        NULL,                                               // object
                                        CFNotificationSuspensionBehaviorDeliverImmediately);
        
            CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), //center
                                        NULL, // observer
                                        displayStatusChanged, // callback
                                        CFSTR("com.apple.springboard.lockstate"), // event name
                                        NULL, // object
                                        CFNotificationSuspensionBehaviorDeliverImmediately);
        }
    }
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if(localNotification)
    {
        [application cancelAllLocalNotifications];
    }
    
    [self performSelector:@selector(showNotical:) withObject:@"Welcome to test" afterDelay:1];
    checkPart = [[CheckPart alloc] init];
    [checkPart getInfoOnline];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if(AppShare.parentView.checkPart.finishGetInfo==1)
    {
        AppLog(@"Da co info roi khong lay nua");
        return NO;
    }
    AppLog(@"Calling Application Bundle ID: %@", sourceApplication);
    AppLog(@"URL scheme:%@", [url scheme]);
    AppLog(@"URL query: %@", [url query]);
 
    NSString *decoded = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AppLog(@"URL decoded: %@", decoded);
    decoded = [decoded stringByReplacingOccurrencesOfString:@"data=" withString:@""];
    NSDictionary *dic=[self diccionaryFromJsonString:decoded];
    AppLog(@"setInfo from open delegete");
    [AppShare.parentView.checkPart setInfoOnWeb:dic forsave:YES];
 
    return YES;
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if(accessRotate == NO)
        return UIInterfaceOrientationMaskPortrait;
    return UIInterfaceOrientationMaskLandscapeLeft;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    AppDelegateLog(@"[APP] ------- applicationWillResignActive");         
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     isActive = NO;
    
    if(AppShare.parentView.camera)
    {
        [AppShare.parentView.camera receiveBackgroundAction];
    }
        
    if(isLightTest == NO)
    {
#ifdef AUTO_BRI_NESS
        [[UIScreen mainScreen] setBrightness:1.0];
#endif
    }
    


    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    //kiem tra dieu kien.khi dang test tay thi khoong ghi Background- qui thach yeu cau
//    if(isHandTest == NO && iDevice.acceptWriteInBackgroud == NO)
    isActive = NO;// cho biet app co active tren mang hinh hay khong
    AppDelegateLog(@"[APP] ------- applicationDidEnterBackground ");
    if(isShowNotification == YES)
    {
         AppDelegateLog(@"[APP] ------- data bleu leu ");
        if(deviceLock)
            [self performSelector:@selector(showNotical:) withObject:@"Slide to Open"];
        else
            [self performSelector:@selector(showNotical:) withObject:@"Click to Open"];
    }

    
    if(bgRunMgr == UIBackgroundTaskInvalid)
    {
        bgRunMgr = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            ;
        }];
    }
    
    if(!isLockAnSyn)
    {
        isLockAnSyn = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            ;
        });
    }
    
    
        
    
    if(AppShare.parentView.buttonFunc)
    {
        if(iOS<7)
        {
            
            UIApplicationState state = [application applicationState];
            if (state == UIApplicationStateInactive)
            {
                AppDelegateLog(@"[App] state == UIApplicationStateInactive receiveBackgroundByPower");
                [AppShare.parentView.buttonFunc receiveBackgroundByPower];
            }
            else if (state == UIApplicationStateBackground)
            {
                AppDelegateLog(@"[App] state == UIApplicationStateBackground receiveBackgroundByHome");
                [AppShare.parentView.buttonFunc receiveBackgroundByHome];
            }
        }
        else// IOS 7 khong co trang thai UIApplicationStateInactive
        {
            if(deviceLock == YES)
            {
                [AppShare.parentView.buttonFunc receiveBackgroundByPower];
            }
            else
            {
                AppDelegateLog(@"AppShare.viewController.acceptHomePress:%@",AppShare.parentView.acceptHomePress?@"YES":@"NO");
                if(AppShare.parentView.acceptHomePress && AppShare.parentView.pageControl.currentPage == 2)
                {
                    [AppShare.parentView.buttonFunc receiveBackgroundByHome];
                }
            }
            
        }
        [AppShare.parentView.buttonFunc resetRingTest];
        
    }


    deviceLock = NO;
   
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    AppDelegateLog(@"[APP] ------- applicationWillEnterForeground");
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    AppDelegateLog(@"[APP] ------- applicationDidBecomeActive");
    if(isLightTest == NO)
    {
#ifdef AUTO_BRI_NESS
        [[UIScreen mainScreen] setBrightness:1.0];
#endif
    }

    isActive = YES;
    
  //  [AppShare.viewController performSelector:@selector(showResult) withObject:Nil afterDelay:1];
    if(AppShare.parentView.call)
       [AppShare.parentView.call stopShowNotific];
 
     AppShare.parentView.acceptHomePress = YES;
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    AppDelegateLog(@"[APP]  ------- applicationWillTerminate");
    [@"active" writeToFile:[iDevice.requestFileName stringByReplacingOccurrencesOfString:@"request.txt" withString:@"cmd.txt"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
     isActive = NO;
}


#pragma mark -
#pragma mark Method define

- (void) volumeChanged:(NSNotification*)notify
{
    
    float volume = [[[notify userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    AppDelegateLog(@" ------- volumeChanged %.2f, forceVolume:%.2f",volume,forceVolume);
    
    float value = fabs(forceVolume - volume);
    
    if(value >= 0.00)
    {
        
        if(AppShare.parentView.buttonFunc)
        {
            [AppShare.parentView.buttonFunc volumeChanged:volume];
        }


        
    }
    forceVolume = volume;
}

- (void) pauseBackgroundService
{
    if(bgRunMgr != UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:bgRunMgr];
        bgRunMgr = UIBackgroundTaskInvalid;
    }
}


static void displayStatusChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    NSString *lockState = (__bridge NSString*)name;
    if([lockState isEqualToString:@"com.apple.springboard.lockcomplete"])
    {
        AppDelegateLog(@"[APP] DEVICE LOCKED");
        deviceLock = YES;
    }
}
- (void) showNotical:(NSString*)msg
{
    AppDelegateLog(@"%@",msg);
    UIApplication *application = [UIApplication sharedApplication];
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        //UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeAlert|UIUserNotificationTypeSound) categories:nil];
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeSound) categories:nil];
        [application registerUserNotificationSettings:settings];
        
    }
    else // iOS 7 or earlier
    {
        //UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    //    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    localNotification.alertAction = @"Itest";
    localNotification.alertBody = [NSString stringWithFormat:@"%@",msg];
    localNotification.soundName = UILocalNotificationDefaultSoundName; // den den den
    localNotification.repeatInterval = 7;
    //[UIApplication sharedApplication].applicationIconBadgeNumber=1;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

}

#pragma mark -
#pragma mark Dictionary converter

- (NSDictionary *)diccionaryFromJsonString:(NSString *)stringJson
{
    NSData *data = [stringJson dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error=Nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if(error)
    {
        NSLog(@"%s Error al leer json: %@",__FUNCTION__, [error description]);
        jsonDictionary = Nil;
    }
    return jsonDictionary;
}

- (NSString *)jsonStringFromDictionary:(NSDictionary *)dictionary
{
    NSError *error = Nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    if (error)
    {
        NSLog(@"%s Error: %@",__FUNCTION__, error);
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}


@end
