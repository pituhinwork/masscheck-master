//
//  FFDetect.h
//  DetectingSoundFrequency
//
//  Created by BachUng on 7/28/16.
//  Copyright © 2016 Mac. All rights reserved.
//
#ifndef __FFDetect__
#define __FFDetect__
#import <Foundation/Foundation.h>

@interface FFDetect : NSObject
{
    
}

- (void) start;
- (NSString *) getValue;
- (void) stop;
- (void) StopListener;

@end


#endif
