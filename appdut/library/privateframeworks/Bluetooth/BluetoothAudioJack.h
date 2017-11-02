/*
 *     Generated by class-dump 3.1.1.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2006 by Steve Nygard.
 */

#import <Foundation/NSObject.h>

@interface BluetoothAudioJack : NSObject
{
    struct BTAudioJackImpl *_jack;
}

- (BOOL)available:(id)fp8;	// IMP=0x32272428
- (id)availableDevices;	// IMP=0x322722f8
- (void)connect:(id)fp8;	// IMP=0x32272234
- (BOOL)connected;	// IMP=0x322722a8
- (void)dealloc;	// IMP=0x32272030
- (void)disconnect;	// IMP=0x3227227c
- (id)initWithAudioJack:(struct BTAudioJackImpl *)fp8;	// IMP=0x32271fe4
- (struct BTAudioJackImpl *)jack;	// IMP=0x322722f0
- (void)startMonitoring;	// IMP=0x322721c0
- (void)stopMonitoring;	// IMP=0x322721fc

@end

