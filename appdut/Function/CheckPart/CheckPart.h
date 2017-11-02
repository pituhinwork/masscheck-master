//
//  CheckPart.h
//  testprod
//
//  Created by Toan Nguyen Van on 03/29/13.
//  Copyright (c) 2013 ccinteg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UDIDClass.h"

@interface CheckPart : NSObject
{
    int status;
    BOOL installProfile;
    UDIDClass *deviceInfo;
    NSMutableDictionary *dicDataOnline;//serial,FMI,....
    NSString *strFMI;
    int finishGetInfo;
    
    NSString *strGUID;
    
    NSMutableDictionary *dicColorName;
    
    BOOL isGetInforOfWeb;
}

@property (nonatomic, strong) NSString *key;
@property (nonatomic, assign) int finishGetInfo;

- (void) successCheck:(NSString*)desc;
- (void) failedCheck:(NSString*)desc;
- (void) startAutoTest:(NSString*)rKey param:(NSString*)param;
- (void)intallProfile;
- (NSString*) getInfo;
- (NSString*) getCarier;
- (NSString*) getSerialNumber1;
- (NSString *) getSerialNumber;

- (NSString*) getValue:(NSString *)iosearch;
- (NSString *)getAllInfo;
//- (void)startGetInfo;
// Addition Functions
- (NSString*) getBrightness;
- (NSString*) getVolume;
- (NSString*) getColor;
- (NSString*) getColorCode;
- (BOOL) isAirplaneMode;
- (NSString*) getCapacity;
- (NSString*)getModel;
- (NSString*)getModelFull;
- (BOOL) checkJailbreaked;
- (int)numCPU;
- (float) cpu_usage;
- (NSString *) RAM_memory;
- (float) getRamPercent;
- (NSString *)getDID;

- (NSString *) deviceSerial;
- (NSString *) deviceFMI;
- (NSString *) deviceIMEI;

- (void)detectInfoFromCliboard;
- (NSString *) getGUID;
- (NSString *) deviceUniqueid;
- (void) getInfoOnline;

- (void)setInfoOnWeb:(NSDictionary *)dic forsave:(BOOL)save;

@end
