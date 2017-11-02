/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

/*
 http://broadcast.oreilly.com/2009/04/iphone-dev-iokit---the-missing.html
 
*/

#import <UIKit/UIKit.h>

#define SUPPORTS_IOKIT_EXTENSIONS	1

/*
 * To use, you must add the (semi)public IOKit framework before compiling
 */

/*
 
 This category is no longer maintained.
 
 */

#if SUPPORTS_IOKIT_EXTENSIONS
@interface UIDevice (IOKit_Extensions)
- (NSString *) imei;
- (NSString *) serialnumber;
- (NSString *) backlightlevel;
- (NSString *) adress;
@end
#endif

