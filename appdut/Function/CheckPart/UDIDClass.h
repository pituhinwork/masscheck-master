//
//  UDIDClass.h
//  IVERIFY
//
//  Created by BachUng on 9/21/15.
//  Copyright © 2015MaTran All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UDIDClass : NSObject
{
    NSString *IDIDDeviceString;
    NSString *mac;
}
- (void) pingLocal;
- (NSString *)getIDID;
- (NSString *) localIPAddress;
- (NSString *)convertMac;

@end
