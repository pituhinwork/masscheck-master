//
//  FFDetect.m
//  DetectingSoundFrequency
//
//  Created by BachUng on 7/28/16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "FFDetect.h"
#import "mo_audio.h" //stuff that helps set up low-level audio
#import "FFTHelper.h"

//#define FDETECTINGLOG
#if defined(FDETECTINGLOG) || defined(DEBUG_ALL)
#   define FFDetectLog(BachUng, ...) NSLog((@"%s[Line %d] " BachUng), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define FFDetectLog(...)
#endif

#define SAMPLE_RATE 44100  //22050 //44100
#define FRAMESIZE  512
#define NUMCHANNELS 2

#define kOutputBus 0
#define kInputBus 1

/// Nyquist Maximum Frequency
const Float32 NyquistMaxFreq = SAMPLE_RATE/2.0;

// The Main FFT Helper
FFTHelperRef *fftConverter = NULL;

/// caculates HZ value for specified index from a FFT bins vector
Float32 frequencyHerzValue(long frequencyIndex, long fftVectorSize, Float32 nyquistFrequency )
{
//   FFDetectLog();
    return ((Float32)frequencyIndex/(Float32)fftVectorSize) * nyquistFrequency;
}


//Accumulator Buffer=====================

const UInt32 accumulatorDataLenght = 16384;//131072;  //16384; //32768; 65536; 131072;
UInt32 accumulatorFillIndex = 0;
Float32 *dataAccumulator = NULL;
static void initializeAccumulator()
{
    FFDetectLog();
    dataAccumulator = (Float32*) malloc(sizeof(Float32)*accumulatorDataLenght);
    accumulatorFillIndex = 0;
}
static void destroyAccumulator()
{
    FFDetectLog();
//    if (dataAccumulator!=NULL)
//    {
//        free(dataAccumulator);
        dataAccumulator = NULL;
//    }
    accumulatorFillIndex = 0;
    FFDetectLog(@"end");
}

static BOOL accumulateFrames(Float32 *frames, UInt32 lenght)  //returned YES if full, NO otherwise.
//    float zero = 0.0;
//    vDSP_vsmul(frames, 1, &zero, frames, 1, lenght);
{
       FFDetectLog();
    if (accumulatorFillIndex>=accumulatorDataLenght)
    { return YES; }
    else
    {
        if(dataAccumulator==NULL)
            return NO;
        if(accumulatorDataLenght < accumulatorFillIndex+lenght)
            return YES;
        @try {
            memmove(dataAccumulator+accumulatorFillIndex, frames, sizeof(Float32)*lenght);
        } @catch (NSException *exception) {
            NSLog(@"memmove Accumulator not success\n%@",exception);
        }
        
        accumulatorFillIndex = accumulatorFillIndex+lenght;
        if (accumulatorFillIndex>=accumulatorDataLenght) { return YES; }
    }
    return NO;
}

static void emptyAccumulator()
{
  FFDetectLog();
    accumulatorFillIndex = 0;
    if(dataAccumulator==NULL)return;
    memset(dataAccumulator, 0, sizeof(Float32)*accumulatorDataLenght);
}
//=======================================


//==========================Window Buffer
const UInt32 windowLength = accumulatorDataLenght;
Float32 *windowBuffer= NULL;
//=======================================



/// max value from vector with value index (using Accelerate Framework)
static Float32 vectorMaxValueACC32_index(Float32 *vector, unsigned long size, long step, unsigned long *outIndex)
{
   // FFDetectLog(@"%s);
    Float32 maxVal;
    vDSP_maxvi(vector, step, &maxVal, outIndex, size);
    return maxVal;
}




///returns HZ of the strongest frequency.
static Float32 strongestFrequencyHZ(Float32 *buffer, FFTHelperRef *fftHelper, UInt32 frameSize, Float32 *freqValue)
{
   //FFDetectLog();
     @try
    {
    //the actual FFT happens here
    //****************************************************************************
    Float32 *fftData = computeFFT(fftHelper, buffer, frameSize);
    //****************************************************************************
    
    
    fftData[0] = 0.0;
    unsigned long length = frameSize/2.0;
    Float32 max = 0;
    unsigned long maxIndex = 0;
    max = vectorMaxValueACC32_index(fftData, length, 1, &maxIndex);
    if (freqValue!=NULL) { *freqValue = max; }
    Float32 HZ = frequencyHerzValue(maxIndex, length, NyquistMaxFreq);
         return HZ;
        
    }
    @catch (NSException *exception)
    {
        FFDetectLog(@"%s\nError: %@",__FUNCTION__,[exception description]);
        UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"Error" message:[exception description] delegate:Nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
    }
}



UILabel *labelToUpdate1 = nil;



#pragma mark MAIN CALLBACK
void AudioCallback( Float32 * buffer, UInt32 frameSize, void * userData )
{
   FFDetectLog();
    
    if(dataAccumulator==NULL)
    {
         FFDetectLog(@"dataAccumulator = NULL");
        return;
    }
    
    if(buffer==NULL)
    {
         FFDetectLog(@"buffer = NULL");
    }
        
        //take only data from 1 channel
        Float32 zero = 0.0;
        vDSP_vsadd(buffer, 2, &zero, buffer, 1, frameSize*NUMCHANNELS);
        
        
        @try{
        if (accumulateFrames(buffer, frameSize)==YES)
        { //if full
            
            //windowing the time domain data before FFT (using Blackman Window)
            if (windowBuffer==NULL)
            {
                windowBuffer = (Float32*) malloc(sizeof(Float32)*windowLength);
            }
            vDSP_blkman_window(windowBuffer, windowLength, 0);
            vDSP_vmul(dataAccumulator, 1, windowBuffer, 1, dataAccumulator, 1, accumulatorDataLenght);
            //=========================================
            
            
            Float32 maxHZValue = 0;
            Float32 maxHZ = strongestFrequencyHZ(dataAccumulator, fftConverter, accumulatorDataLenght, &maxHZValue);
            
            NSLog(@" max HZ = %0.3f ", maxHZ);
            dispatch_async(dispatch_get_main_queue(), ^{ //update UI only on main thread
                labelToUpdate1.text = [NSString stringWithFormat:@"%0.3f HZ",maxHZ];
            });
            
            emptyAccumulator(); //empty the accumulator when finished
        }
        memset(buffer, 0, sizeof(Float32)*frameSize*NUMCHANNELS);
        } @catch (NSException *exception) {
            NSLog(@"memmove Accumulator not success\n%@",exception);
        }
}



@implementation FFDetect
- (id) init
{
    FFDetectLog();
    self = [super init];
    labelToUpdate1 = [[UILabel alloc] init];
    labelToUpdate1.text = @"";
    dataAccumulator = Nil;
    [self start];
    return self;
}

- (void) start
{
    FFDetectLog();
    initializeAccumulator();
    fftConverter = FFTHelperCreate(accumulatorDataLenght);

    [self initMomuAudio];

}
- (NSString *) getValue
{
    //NSLog(@"%s  %@",__FUNCTION__,labelToUpdate1.text);
    if(labelToUpdate1)
        return labelToUpdate1.text;
    else return @"0";
}
-(void) initMomuAudio
{
   FFDetectLog();
    bool result = false;

    result = MoAudio::init( SAMPLE_RATE, FRAMESIZE, NUMCHANNELS, false);
    if (!result) { NSLog(@" MoAudio init ERROR"); }
    result = MoAudio::start( AudioCallback, NULL );
    if (!result) { NSLog(@" MoAudio start ERROR"); }
}

- (void) StopListener
{
    MoAudio::StopListener();
}

- (void) stop
{
    FFDetectLog();
    [self StopListener];
    MoAudio::shutdown();
    FFTHelperRelease(fftConverter);
    fftConverter = NULL;
    destroyAccumulator();

}


- (void) dealloc
{
   FFDetectLog();
    [self stop];
    if(windowBuffer)
    {
        free(windowBuffer);
        windowBuffer = NULL;
    }

    if(labelToUpdate1)
    {
        labelToUpdate1 = Nil;
    }
}

@end
