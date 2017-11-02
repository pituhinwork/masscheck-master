//
//  AudioRouter.h
//  appDUT
//
//  Created by Bach Ung on 7/14/14.
//  Copyright (c) 2014MaTran All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioRouter : NSObject
+ (void) initAudioSessionRouting;
+ (void) switchToDefaultHardware;
+ (void) forceOutputToBuiltInSpeakers;
@end
