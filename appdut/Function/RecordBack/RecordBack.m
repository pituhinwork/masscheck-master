    //
    //  RecordBack.m
    //  IVERIFY
    //
    //  Created by Bach Ung on 7/14/14.
    //  Copyright (c) 2014MaTran All rights reserved.
    //
#import <Foundation/Foundation.h>

#import "AppDelegate.h"
#import "RecordBack.h"
#import "AudioRouter.h"
#import "Utilities.h"
#import "MainTestViewController.h"



#define RECORDBACK_NONE 0
#define RECORDBACK_START 1
#define RECORDBACK_FINISHED 2

@implementation RecordBack
@synthesize key;
@synthesize ID;
@synthesize result;
@synthesize audioPlayer;
@synthesize audioRecorder;

- (id) init
{
    self = [super init];
    key = @"RecordBack";
    status = RECORDBACK_NONE;
    result = Nil;
    detect = Nil;
    ID = -1;
    isPassed = NO;
    dem = 0;
    view = Nil;
    audioPlayer = Nil;
    audioRecorder = Nil;
    NameFile = [[NSString alloc] initWithFormat:@"Testing"];

    musicArray = [[NSMutableArray alloc] init];
    [musicArray removeAllObjects];
    [musicArray addObject:@"Testing"];
    [musicArray addObject:@"Testing"];
        //    [musicArray addObject:@"10150"];
        //    [musicArray addObject:@"10440"];
        //    [musicArray addObject:@"10730"];
        //    [musicArray addObject:@"11020"];
        //    [musicArray addObject:@"11310"];
        //    [musicArray addObject:@"11600"];
        //    [musicArray addObject:@"11890"];
        //    [musicArray addObject:@"12180"];
        //    [musicArray addObject:@"12470"];
    
    
    [self initView];
    return self;
}
    //- (void)audioSessionDidChangeInterruptionType:(NSNotification *)notification
    //{
    //    AVAudioSessionInterruptionType interruptionType = [[[notification userInfo]
    //                                                        objectForKey:AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    //    if (AVAudioSessionInterruptionTypeBegan == interruptionType)
    //    {
    //        AppLog(@"AVAudioSessionInterruptionTypeBegan");
    //    }
    //    else if (AVAudioSessionInterruptionTypeEnded == interruptionType)
    //    {
    //        AppLog(@"AVAudioSessionInterruptionTypeEnded");
    //    }
    //}
- (void) dealloc
{
    if(view)
    {
        view = Nil;
    }
    
    if(musicArray)
    {
        musicArray = Nil;
    }
    if(NameFile)
    {
        NameFile = Nil;
    }
    if(audioRecorder)
    {
        [audioRecorder stop];
        audioRecorder = Nil;
    }
    if(audioPlayer)
    {
        [audioPlayer stop];
        audioPlayer = Nil;
    }
    if(detect)
    {
        detect = Nil;
    }
        // [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    
    
}

- (void) initView
{
    CGRect rect = [UIScreen mainScreen].bounds;
    view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *caption = [[UILabel alloc] init];
    caption.frame = CGRectMake(0, 0, view.frame.size.width, TITLE_HIGHT);
    caption.backgroundColor = [UIColor colorWithRed:0xEF*1.0/0xFF green:0xEF*1.0/0xFF blue:0xF4*1.0/0xFF alpha:1];
    caption.font = [UIFont fontWithName:@"HelveticaNeue" size:24];
    caption.textAlignment = NSTextAlignmentCenter;
    caption.numberOfLines = 0;
    caption.tag = 1;
    caption.text = AppShare.ExternalSpeakerMICTestText;
    [view addSubview:caption];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - 100,view.frame.size.height/4,200,100)];
    imageView.image = [UIImage imageNamed:@"SpeakerMic.png"];
    imageView.center = CGPointMake(view.frame.size.width/2, view.frame.size.height/4);
    [view addSubview:imageView];
    
    
    UILabel *conten = [[UILabel alloc] init];
    conten.frame = CGRectMake(10, 0, view.frame.size.width-20, view.frame.size.height);//35
    conten.backgroundColor = [UIColor clearColor];
    conten.font = [UIFont fontWithName:@"Roboto-Light" size:24];
    conten.textAlignment = NSTextAlignmentCenter;
    conten.numberOfLines = 0;
    conten.tag = 2;
    conten.text = [NSString stringWithFormat:@"%@\n%@",AppShare.AutomaticTestText,AppShare.DontBlockTheExternalSpeakerAndMicrophoneText];
    [view addSubview:conten];
    
}
- (void) failedCheck:(NSString*)desc
{
    if(status != RECORDBACK_FINISHED)
    {
        if(audioRecorder)
        {
            [audioRecorder stop];
            audioRecorder = Nil;
        }
        if(audioPlayer)
        {
            [audioPlayer stop];
            audioPlayer = Nil;
        }
        isPassed = NO;
        if(result != Nil)
        {
            result = Nil;
        }
        result = [[NSString alloc ] initWithFormat:@"%@",desc];
        status = RECORDBACK_FINISHED;
        [self performSelector:@selector(writeValue) withObject:Nil afterDelay:1];
    }
}

- (void) successCheck:(NSString*)desc
{
    if(status != RECORDBACK_FINISHED)
    {
        if(audioRecorder)
        {
            [audioRecorder stop];
            audioRecorder = Nil;
        }
        if(audioPlayer)
        {
            [audioPlayer stop];
            audioPlayer = Nil;
        }
        isPassed = YES;
        if(result != Nil)
        {
            result = Nil;
        }
        result = [[NSString alloc ] initWithFormat:@"%@",desc];
        
        status = RECORDBACK_FINISHED;
        [self performSelector:@selector(writeValue) withObject:Nil afterDelay:1];
    }
}

- (void) writeValue
{
    [self.parentView updateResult:ID value:[NSString stringWithFormat:@" %@#%@#%@",key,isPassed?@"PASSED":@"FAILED",result]];
    if(audioRecorder)
    {
        [audioRecorder stop];
        audioRecorder = Nil;
    }
    if(audioPlayer)
    {
        [audioPlayer stop];
        audioPlayer = Nil;
    }
    [self releaseResouce];
}
- (void) releaseResouce
{
    [view removeFromSuperview];
    if(musicArray)
    {
        musicArray = Nil;
    }
    if(NameFile)
    {
        NameFile = Nil;
    }
    if(audioRecorder)
    {
        audioRecorder = Nil;
    }
    if(audioPlayer)
    {
        audioPlayer = Nil;
    }
    
    if(detect)
    {
        detect = Nil;
    }
    if(result != Nil)
    {
        result = Nil;
    }
    
}
- (void) preTest
{
        // thu am
    
    if(view && view.subviews)
    {
        [view removeFromSuperview];
    }
    [view setHidden:YES];
    [self.parentView.view addSubview:view];
    if(status == RECORDBACK_NONE)
    {
        
        @try
        {
            if(AppShare.iOS < (float)8.0)
            {
                AVAuthorizationStatus microPhoneStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
                switch (microPhoneStatus)
                {
                    case AVAuthorizationStatusAuthorized:// Has access
                        break;
                    case AVAuthorizationStatusDenied:// No access granted
                    {
                        [self failedCheck:@"Permission Denied"];
                        return;
                    } break;
                    case AVAuthorizationStatusRestricted:// Microphone disabled in settings
                    {
                        [self failedCheck:@"Microphone disabled in settings"];
                        return;
                    }break;
                    case AVAuthorizationStatusNotDetermined:// Didn't request access yet
                    {
                        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted)
                         {
                             if(granted)
                             {
                                 NSLog(@"Micro Granted access to %@", AVMediaTypeAudio);
                             }
                             else
                             {
                                 NSLog(@"Micro Not granted access to %@", AVMediaTypeVideo);
                                 [self failedCheck:@"Microphone is granted accept failed "];
                                 return;
                             }
                             
                         }];
                    } break;
                    default:break;
                }
            }
            else //ios >= 8
            {
                
                if([[AVAudioSession sharedInstance] respondsToSelector:@selector(recordPermission)]==YES)
                {
                    AVAudioSessionRecordPermission statusPemission = [[AVAudioSession sharedInstance] recordPermission];
                    if(statusPemission == AVAudioSessionRecordPermissionUndetermined)
                    {
                        [self failedCheck:@"Microphone is Undetermined"];
                        return;
                    }
                    else if(statusPemission == AVAudioSessionRecordPermissionDenied)
                    {
                        NSLog(@"Microphone Permission Denied");
                        [self failedCheck:@"Permission Denied"];
                        return;
                    }
                    else
                    {
                        NSLog(@"Microphone Permission Granted");
                    }
                    
                }
                
            }
            
        }
        @catch (NSException *exception)
        {
            NSLog(@"Error: %@",[exception debugDescription]);
        }
        
        
        if(AppShare.isActive==NO)
        {
            countBackground++;
            AppLog(@"count: %d",countBackground);
            if(countBackground < 60)
                [self performSelector:@selector(preTest) withObject:Nil afterDelay:1];
            else
            {
                [self failedCheck:@"App in background"];
                countBackground=0;
            }
            return;
        }
        
        
            //reset sesstion
        AudioSessionInitialize (NULL, NULL, NULL, NULL);
        AudioSessionSetActive(true);
            // Allow playback even if Ring/Silent switch is on mute
        UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
        AudioSessionSetProperty (kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
        
        dem = 0;demtam = 0;
        callCount ++;
        setDeviceVolume(0.7);
        MPMusicPlayerController *iPod = [MPMusicPlayerController iPodMusicPlayer];
        iPod.volume = 0.7;
        
            //    [AppShare.viewController.view addSubview:view];
        
        
        status = RECORDBACK_START;
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *waveFile = [NSString stringWithFormat:@"%@/speakRecordBack.wav", [paths objectAtIndex:0]];
        NSURL *audioFileURL = [NSURL fileURLWithPath:waveFile];
        NSMutableDictionary *audioSettings = [[NSMutableDictionary alloc] init];
        [audioSettings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
        [audioSettings setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
        [audioSettings setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
        
        self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:audioFileURL settings:audioSettings error:nil];
        
        [AudioRouter initAudioSessionRouting];
        [AudioRouter forceOutputToBuiltInSpeakers];
        
        Freg = 9570;
        srand( (unsigned int) time(NULL) );
        int i = rand()%musicArray.count;
        if(i<musicArray.count)
            Freg = [[musicArray objectAtIndex:i] intValue];
        AppLog(@"i:%d, count:%d Freg:%d",i,musicArray.count,Freg);
        
        [self play:[NSString stringWithFormat:@"%d",Freg]];
        int timeRecode = 5;//4
        countFreg=0;
        
        [self performSelector:@selector(Recoder) withObject:Nil afterDelay:0];
        
        detect = [[FFDetect alloc] init];
        [self getValue];
        
        [self performSelector:@selector(audioStop) withObject:Nil afterDelay:timeRecode];
            // [self performSelector:@selector(timeOut:) withObject:[NSNumber numberWithInt:callCount] afterDelay:timeRecode+2];
        
        
    }
}

- (void) getValue
{
    if(status != RECORDBACK_FINISHED)
    {
        NSString *str = [detect getValue];
        NSLog(@"%s Hz %@",__FUNCTION__,str);
        int val = [str intValue];
        int anpha = 5;
        if(val > Freg-anpha && val < Freg+anpha)
        {
            countFreg ++;
            isPassed = YES;
            AppLog(@"Stop Listener");
            [detect StopListener];
        }
        else [self performSelector:@selector(getValue) withObject:Nil afterDelay:0.2];
    }
}
- (void) timeOut:(NSNumber*)num
{
    if([num intValue] == callCount)
    {
        if(status != RECORDBACK_FINISHED)
        {
            [self failedCheck:@"Timeout"];
        }
    }
}

- (void) timerTask {
    [self.audioRecorder updateMeters];
    
        //ep kieu float to int va doi dau am
    int level = -1*[self.audioRecorder peakPowerForChannel:0];
    int average = -1*[self.audioRecorder averagePowerForChannel:0];
    
    if(level < 20)
    {
        if(level >= currentLeve)
        {
            if(demtam >= 0)
                demtam++;
        }
        else demtam = 0;
        if(demtam > 2)//3 lan
        {
            dem++;
            demtam = -1;
        }
    }
    if(level< 30)
        demlever++;
    
    currentAver = average;
    currentLeve = level;
    NSLog(@"peakPowerForChannel: %d - averagePowerForChannel: %d", level,average);
}

- (void)Recoder
{
    timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(timerTask) userInfo:nil repeats:YES];
    
    [self.audioRecorder prepareToRecord];
    self.audioRecorder.meteringEnabled = YES;
    [self.audioRecorder record];
}

- (IBAction)audioStop
{
    if(timer)
    {
        [timer invalidate];
        timer = Nil;
    }
    NSLog(@"%s dem %d, demlever:%d",__FUNCTION__, dem,demlever);
    if(detect)
        [detect stop];
    [self.audioPlayer stop];
    [self.audioRecorder stop];
    
    if(isPassed)//tan so pass
    {
        if(demlever == 0 && dem==0)
            [self failedCheck:@"Mic or Speaker have prolem"];
        else [self successCheck:@""];
    }
    else if(dem<2)
    {
        if(demlever == 0 && dem==0)
            [self failedCheck:@"Mic have prolem"];
        else [self failedCheck:@"Not valid"];
    }
    else //[self successCheck:@"But Audio not valid"];
        [self successCheck:@"."];
}


- (void)play:(NSString*)path
{
    
    NSLog(@"%s NameFile:%@ ",__FUNCTION__,path);
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:path ofType:@"mp3"];
    NSLog(@"%s filePath:%@ ",__FUNCTION__,filePath);
//    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
//        NSLog(@"%s filePath not exists run with default",__FUNCTION__);
        filePath = [[NSBundle mainBundle] pathForResource:@"Testing" ofType:@"mp3"];
    }
    
    [[MPMusicPlayerController applicationMusicPlayer] setVolume:0.7];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    NSError *error = nil;
    if(audioPlayer)
    {
        audioPlayer = Nil;
    }
    audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData error:&error];
    [audioPlayer setVolume:0.7];
    [[AVAudioSession sharedInstance] setDelegate:self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:Nil];
    UInt32 doChangeDefaultRoute = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);
    
    [[AVAudioSession sharedInstance] setActive:YES error:Nil];
    audioPlayer.numberOfLoops = -1;
    audioPlayer.delegate = self;
    [audioPlayer play];
    
    
    
    
}
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"%s",__FUNCTION__);
    [NSThread sleepForTimeInterval:1.0];
    
}
//- (void) pause
//{
//    [self.audioPlayer stop];
//    if(status != RECORDBACK_FINISHED)
//    {
//        srand( (unsigned int) time(NULL) );
//        int i = 1;//rand()%3;
//        AppLog(@"i=%d",i+2);
//        [self performSelector:@selector(endPause) withObject:Nil afterDelay:2];
//    }
//}
//- (void) endPause
//{
//    AppLog(@"--------------------------------------------------------------------");
//    if(status != RECORDBACK_FINISHED)
//    {
//        [self.audioPlayer play];
//        [self performSelector:@selector(pause) withObject:Nil afterDelay:1];
//        
//    }
//}
//
    // This function is started when Master Linux request
- (void) startAutoTest:(NSString*)rKey param:(NSString*)param
{
    NSLog(@"%s key:%@ Param:%@",__FUNCTION__,rKey,param);
    countBackground = 0;
    
    if(param.length > 1)
    {
        NameFile = [[NSString alloc] initWithFormat:@"%@",param];
    }
    NSLog(@"name: %@",NameFile);
    if (status == RECORDBACK_FINISHED)
    {
        status = RECORDBACK_NONE;
    }
    if (status != RECORDBACK_FINISHED)
        [self preTest];
    else [self writeValue];
    UILabel *caption = (UILabel *)[view viewWithTag:1];
    caption.text = AppShare.ExternalSpeakerMICTestText;
    UILabel *conten = (UILabel *)[view viewWithTag:2];
    conten.text = [NSString stringWithFormat:@"%@\n%@",AppShare.AutomaticTestText,AppShare.DontBlockTheExternalSpeakerAndMicrophoneText];
}


@end
