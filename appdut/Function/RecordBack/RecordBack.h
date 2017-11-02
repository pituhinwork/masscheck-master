//
//  RecordBack.h
//  IVERIFY
//
//  Created by Bach Ung on 7/14/14.
//  Copyright (c) 2014MaTran All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import "FFDetect.h"
@class MainTestViewController;

@interface RecordBack : NSObject <AVAudioPlayerDelegate>
{
    int ID;
    int status;
    int dem;
    int demtam;
    int demlever;
    int currentLeve;
    int currentAver;
    BOOL isPassed;
    int callCount;
    
    

    NSString *NameFile;
    
    NSTimer *timer;
    
    
    UIView *view;
   
    FFDetect *detect;
    int Freg;
    int countFreg;
    NSMutableArray *musicArray;
    
    int countBackground;
    
    AVAudioPlayer *audioPlayer;
    AVAudioRecorder *audioRecorder;
    
    BOOL isAskFromLinux;
}
@property (nonatomic, strong) NSString *key;
@property (nonatomic, assign) int ID;
@property (nonatomic, strong) NSString *result;
@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) MainTestViewController *parentView;
- (void) successCheck:(NSString*)desc;
- (void) failedCheck:(NSString*)desc;
- (void) releaseResouce;
- (void) startAutoTest:(NSString*)rKey param:(NSString*)param;
- (void) preTest;
@end
