//
//  SpeechToText.h
//  testprod
//
//  Created by Toan Nguyen Van on 02/28/13.
//  Copyright (c) 2012 ccinteg. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface SpeechToText : NSObject <AVAudioRecorderDelegate>
{
    int callCall;
    
    NSMutableDictionary* recordSetting;
    AVAudioRecorder *recObj;
    
    id objRoot;
    SEL objSel;
    
//    SEL objSelFailed;
//    SEL objSelSuccess;
    
    int countNetworkFailed;
    BOOL recordGotData;
    
    NSString *waveFile;
    //NSString *flacFile;
    //NSString *flacFileWithoutExtension;
}

//- (void) setRoot:(id)root selSuc:(SEL)selectorSuccess selFail:(SEL)seletorFailed;
- (id) initWithRoot:(id)r sel:(SEL)sel;
- (void) startRecord;
- (int)getWaveAudio;
@end