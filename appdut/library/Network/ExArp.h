//
//  ExArp.h
//  IZap04
//
//  Created by Bach Ung on 9/30/14.
//  Copyright (c) 2014 Bach Ung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExArp : NSObject
+(NSString*) ip2mac: (char*) ip;
+(int) dump:(u_long) addr;
+(NSMutableArray*) getList:(u_long) addr;
+(NSMutableArray*) getListWithDevice:(u_long) addr;
@end
