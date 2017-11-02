//
//  AudioRouter.m
//  appDUT
//
//  Created by Bach Ung on 7/14/14.
//  Copyright (c) 2014MaTran All rights reserved.
//

#import "AudioRouter.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@implementation AudioRouter

#define IS_DEBUGGING NO
#define IS_DEBUGGING_EXTRA_INFO NO

+ (void) initAudioSessionRouting {
    
    // Called once to route all audio through speakers, even if something's plugged into the headphone jack
    static BOOL audioSessionSetup = NO;
    if (audioSessionSetup == NO) {
        
        // set category to accept properties stronged below
        NSError *sessionError = nil;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error: &sessionError];
        
        // Doubly force audio to come out of speaker
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);

        // fix issue with audio interrupting video recording - allow audio to mix on top of other media
        UInt32 doSetProperty = 1;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(doSetProperty), &doSetProperty);
        
        // set active
        [[AVAudioSession sharedInstance] setDelegate:self];
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        
        // add listener for audio input changes
        AudioSessionAddPropertyListener (kAudioSessionProperty_AudioRouteChange, onAudioRouteChange, nil );
        AudioSessionAddPropertyListener (kAudioSessionProperty_AudioInputAvailable, onAudioRouteChange, nil );
        
    }
    
    // Force audio to come out of speaker
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    
    
    // set flag
    audioSessionSetup = YES;
}


+ (void) switchToDefaultHardware {
    // Remove forcing to built-in speaker
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_None;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
}

+ (void) forceOutputToBuiltInSpeakers {
    // Re-force audio to come out of speaker
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
    
    
}

void onAudioRouteChange (void* clientData, AudioSessionPropertyID inID, UInt32 dataSize, const void* inData) {
    
    if( IS_DEBUGGING == YES ) {
        NSLog(@"==== Audio Harware Status ====");
        NSLog(@"Current Input:  %@", [AudioRouter getAudioSessionInput]);
        NSLog(@"Current Output: %@", [AudioRouter getAudioSessionOutput]);
        NSLog(@"Current hardware route: %@", [AudioRouter getAudioSessionRoute]);
        NSLog(@"==============================");
    }
    
    if( IS_DEBUGGING_EXTRA_INFO == YES ) {
        NSLog(@"==== Audio Harware Status (EXTENDED) ====");
        CFDictionaryRef dict = (CFDictionaryRef)inData;
        CFNumberRef reason = CFDictionaryGetValue(dict, kAudioSession_RouteChangeKey_Reason);
        CFDictionaryRef oldRoute = CFDictionaryGetValue(dict, kAudioSession_AudioRouteChangeKey_PreviousRouteDescription);
        CFDictionaryRef newRoute = CFDictionaryGetValue(dict, kAudioSession_AudioRouteChangeKey_CurrentRouteDescription);
        NSLog(@"Audio old route: %@", oldRoute);
        NSLog(@"Audio new route: %@", newRoute);
        NSLog(@"=========================================");
    }
    
    
    
}

+ (NSString*) getAudioSessionInput {
    UInt32 routeSize;
    AudioSessionGetPropertySize(kAudioSessionProperty_AudioRouteDescription, &routeSize);
    CFDictionaryRef desc; // this is the dictionary to contain descriptions
    
    // make the call to get the audio description and populate the desc dictionary
    AudioSessionGetProperty (kAudioSessionProperty_AudioRouteDescription, &routeSize, &desc);
    
    // the dictionary contains 2 keys, for input and output. Get output array
    CFArrayRef outputs = CFDictionaryGetValue(desc, kAudioSession_AudioRouteKey_Inputs);
    
    // the output array contains 1 element - a dictionary
    CFDictionaryRef diction = CFArrayGetValueAtIndex(outputs, 0);
    
    // get the output description from the dictionary
    CFStringRef input = CFDictionaryGetValue(diction, kAudioSession_AudioRouteKey_Type);
    return [NSString stringWithFormat:@"%@", input];
}

+ (NSString*) getAudioSessionOutput {
    UInt32 routeSize;
    AudioSessionGetPropertySize(kAudioSessionProperty_AudioRouteDescription, &routeSize);
    CFDictionaryRef desc; // this is the dictionary to contain descriptions
    
    // make the call to get the audio description and populate the desc dictionary
    AudioSessionGetProperty (kAudioSessionProperty_AudioRouteDescription, &routeSize, &desc);
    
    // the dictionary contains 2 keys, for input and output. Get output array
    CFArrayRef outputs = CFDictionaryGetValue(desc, kAudioSession_AudioRouteKey_Outputs);
    
    // the output array contains 1 element - a dictionary
    CFDictionaryRef diction = CFArrayGetValueAtIndex(outputs, 0);
    
    // get the output description from the dictionary
    CFStringRef output = CFDictionaryGetValue(diction, kAudioSession_AudioRouteKey_Type);
    return [NSString stringWithFormat:@"%@", output];
}

+ (NSString*) getAudioSessionRoute {
    /*
     returns the current session route:
     * ReceiverAndMicrophone
     * HeadsetInOut
     * Headset
     * HeadphonesAndMicrophone
     * Headphone
     * SpeakerAndMicrophone
     * Speaker
     * HeadsetBT
     * LineInOut
     * Lineout
     * Default
     */
    
    UInt32 rSize = sizeof (CFStringRef);
    CFStringRef route;
    AudioSessionGetProperty (kAudioSessionProperty_AudioRoute, &rSize, &route);
    
    if (route == NULL) {
        NSLog(@"Silent switch is currently on");
        return @"None";
    }
    return [NSString stringWithFormat:@"%@", route];
}

@end
