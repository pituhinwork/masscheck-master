//
//  SpeechToText.m
//  testprod
//
//  Created by Toan Nguyen Van on 02/28/13.
//  Copyright (c) 2012 ccinteg. All rights reserved.
//

#import "iDevice.h"
#import "AppDelegate.h"
#import "SpeechToText.h"

//#import "wav_to_flac.h"
//#import "JSONKit.h"

#define SPEECHTOTEXT
#if defined(SPEECHTOTEXT) || defined(DEBUG_ALL)
#   define SpeechToTextLog(BachUng, ...) NSLog((@"%s[Line %d] " BachUng), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define SpeechToTextLog(...)
#endif


@implementation SpeechToText

- (id) initWithRoot:(id)r sel:(SEL)sel
{
    self = [super init];
    
    callCall = 1;
    
    UInt32 sessionCategory = kAudioSessionCategory_PlayAndRecord;
    AudioSessionSetProperty (kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
    
    recObj = nil;
    
    objRoot = r;
    objSel = sel;
    waveFile = [[NSString alloc] initWithFormat:@"%@", [NSTemporaryDirectory() stringByAppendingPathComponent:@"speak.wav"]];
    if([[NSFileManager defaultManager] fileExistsAtPath:waveFile])
        [[NSFileManager defaultManager] removeItemAtPath:waveFile error:nil];
    return self;
}


- (void) startRecord
{
    callCall++;
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
    if(appDevice == 1)//DUT
        [[AVAudioSession sharedInstance] setMode:AVAudioSessionModeDefault error:nil];
    else [[AVAudioSession sharedInstance] setMode:AVAudioSessionModeVideoRecording error:nil];
    
    [[AVAudioSession sharedInstance] setActive:YES error:Nil];
    sleep(1);
    
    UInt32 sessionCategory = kAudioSessionCategory_PlayAndRecord;
    AudioSessionSetProperty (kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
    
    
    
    recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    NSURL *recordedTmpFile = [NSURL fileURLWithPath:waveFile];
    SpeechToTextLog(@" Record in file: %@", recordedTmpFile);
    
    countNetworkFailed = 0;
    recordGotData = NO;
    
    NSError *err = nil;
    SpeechToTextLog(@"================ 3");
    recObj = [[AVAudioRecorder alloc] initWithURL:recordedTmpFile settings:recordSetting error:&err];
   
    SpeechToTextLog(@"================ 4");
    [recObj setDelegate:self];
    SpeechToTextLog(@"================ 5");
    
    if(err)
    {
        [self onResult:NO desc:@"Can not start Record service"];
        return;
    }
    recObj.meteringEnabled = YES;
    SpeechToTextLog(@"================ 6");
    [recObj prepareToRecord];
    SpeechToTextLog(@"================ 7");
    [recObj recordForDuration:6];
    [recObj performSelector:@selector(stop) withObject:Nil afterDelay:7];
    SpeechToTextLog(@"================ 8");
   
    [self performSelector:@selector(onTimeOut:) withObject:[NSNumber numberWithInt:callCall] afterDelay:8];
    SpeechToTextLog(@"================ 9");
}
- (int)getWaveAudio
{
    if(recObj)
    {
        [recObj updateMeters];
        int average = -1*[recObj averagePowerForChannel:0];
        return average;
    }
    return -1;
}
- (void) onTimeOut:(NSNumber*)num
{
    //NSLog(@"[SpeechToText] onTimeOut call num %d,callCall %d",[num intValue],callCall);
    if([num intValue] != callCall)
    {
        if(!recordGotData)
        {
            SpeechToTextLog(@"TimeOut ");
            [self onResult:NO desc:@"Record got problem, maybe this device microphone has problem"];
        }
        else
        {
            [self onResult:YES desc:waveFile];
        }
    }
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder*)recorder successfully:(BOOL)flag
{
    SpeechToTextLog(@"audioRecorderDidFinishRecording %@", recorder.url.absoluteString);
    
    recordGotData = YES;
    //[self process];
    
    [self onResult:YES desc:recorder.url.absoluteString];
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
     SpeechToTextLog(@" debugDescription : %@", [error debugDescription]);
     SpeechToTextLog(@"description : %@", [error description]);
    [self onResult:NO desc:@"Recorder error"];
}



- (void) onResult:(BOOL)isPassed desc:(NSString*)desc
{
    SpeechToTextLog(@" onResult : %d, %@", isPassed, [desc description]);
    
    if(objRoot && [objRoot respondsToSelector:objSel])
    {
        [objRoot performSelector:objSel withObject:[NSNumber numberWithBool:isPassed] withObject:desc];
    }

    if(recObj)
    {
        recObj = nil;
    }
    
    if(recordSetting)
    {
        recordSetting = nil;
    }
}

- (void) dealloc
{
}

@end
