

#include <stdio.h>


#import "FFTHelper.h"

//#define FFTHELPERLOG
#if defined(FFTHELPERLOG) || defined(DEBUG_ALL)
#   define FFTHelperLog(LichDuyet, ...) NSLog((@"%s[Line %d] " LichDuyet), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define FFTHelperLog(...)
#endif

BOOL create = NO;
FFTHelperRef * FFTHelperCreate(long numberOfSamples)
{
    FFTHelperLog();
    FFTHelperRef *helperRef = (FFTHelperRef*) malloc(sizeof(FFTHelperRef));
    vDSP_Length log2n = log2f(numberOfSamples);    
    helperRef->fftSetup = vDSP_create_fftsetup(log2n, FFT_RADIX2);
    int nOver2 = numberOfSamples/2;
    helperRef->complexA.realp = (Float32*) malloc(nOver2*sizeof(Float32) );
    helperRef->complexA.imagp = (Float32*) malloc(nOver2*sizeof(Float32) );
    
    helperRef->outFFTData = (Float32 *) malloc(nOver2*sizeof(Float32) );
    memset(helperRef->outFFTData, 0, nOver2*sizeof(Float32) );

    helperRef->invertedCheckData = (Float32*) malloc(numberOfSamples*sizeof(Float32) );
    create = YES;
    return  helperRef;
}


Float32 * computeFFT(FFTHelperRef *fftHelperRef, Float32 *timeDomainData, long numSamples)
{
    FFTHelperLog();
	vDSP_Length log2n = log2f(numSamples);
    Float32 mFFTNormFactor = 1.0/(2*numSamples);
    
    //Convert float array of reals samples to COMPLEX_SPLIT array A
	vDSP_ctoz((COMPLEX*)timeDomainData, 2, &(fftHelperRef->complexA), 1, numSamples/2);
    
    
    //Perform FFT using fftSetup and A
    //Results are returned in A
	vDSP_fft_zrip(fftHelperRef->fftSetup, &(fftHelperRef->complexA), 1, log2n, FFT_FORWARD);
    
    //scale fft 
    vDSP_vsmul(fftHelperRef->complexA.realp, 1, &mFFTNormFactor, fftHelperRef->complexA.realp, 1, numSamples/2);
    vDSP_vsmul(fftHelperRef->complexA.imagp, 1, &mFFTNormFactor, fftHelperRef->complexA.imagp, 1, numSamples/2);
    
    vDSP_zvmags(&(fftHelperRef->complexA), 1, fftHelperRef->outFFTData, 1, numSamples/2);
    
    //to check everything (checking by reversing to time-domain data) =============================
    vDSP_fft_zrip(fftHelperRef->fftSetup, &(fftHelperRef->complexA), 1, log2n, FFT_INVERSE);
    vDSP_ztoc( &(fftHelperRef->complexA), 1, (COMPLEX *) fftHelperRef->invertedCheckData , 2, numSamples/2);
    //=============================================================================================

    
    return fftHelperRef->outFFTData;
}


void FFTHelperRelease(FFTHelperRef *fftHelper)
{
    @try
    {
        
    
    if(create==NO) return;
    create=NO;
    if(fftHelper == NULL) return;
     FFTHelperLog(@"0");
    vDSP_destroy_fftsetup(fftHelper->fftSetup);
     FFTHelperLog(@"1");
    free(fftHelper->complexA.realp);
     FFTHelperLog(@"2");
    free(fftHelper->complexA.imagp);
     FFTHelperLog(@"3");
    free(fftHelper->outFFTData);
     FFTHelperLog(@"4");
    free(fftHelper->invertedCheckData);
     FFTHelperLog(@"5");
    free(fftHelper);
     FFTHelperLog(@"6");
    fftHelper = NULL;
     FFTHelperLog(@"7");
    }
    @catch (NSException *exception)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[exception debugDescription] delegate:Nil cancelButtonTitle:@"Close" otherButtonTitles:Nil, nil];
        [alert show];
    }
}

