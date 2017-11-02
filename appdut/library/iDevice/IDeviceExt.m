/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import "IDeviceExt.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <mach/mach_host.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <ifaddrs.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <ifaddrs.h>
#include <dlfcn.h>



#if SUPPORTS_IOKIT_EXTENSIONS
#pragma mark IOKit miniheaders

#define kIODeviceTreePlane		"IODeviceTree"

enum {
    kIORegistryIterateRecursively	= 0x00000001,
    kIORegistryIterateParents		= 0x00000002
};

typedef mach_port_t	io_object_t;
typedef io_object_t	io_registry_entry_t;
typedef char		io_name_t[128];
typedef UInt32		IOOptionBits;

CFTypeRef
IORegistryEntrySearchCFProperty(
								io_registry_entry_t	entry,
								const io_name_t		plane,
								CFStringRef		key,
								CFAllocatorRef		allocator,
								IOOptionBits		options );

kern_return_t
IOMasterPort( mach_port_t	bootstrapPort,
			 mach_port_t *	masterPort );

io_registry_entry_t
IORegistryGetRootEntry(
					   mach_port_t	masterPort );

CFTypeRef
IORegistryEntrySearchCFProperty(
								io_registry_entry_t	entry,
								const io_name_t		plane,
								CFStringRef		key,
								CFAllocatorRef		allocator,
								IOOptionBits		options );

kern_return_t   mach_port_deallocate
(ipc_space_t                               task,
 mach_port_name_t                          name);


@implementation UIDevice (IOKit_Extensions)
#pragma mark IOKit Utils
NSArray *getValue(NSString *iosearch)
{
#if __LP64__
    return Nil;
#else
     return Nil;
//    mach_port_t          masterPort;
//    CFTypeID             propID = (CFTypeID) NULL;
//    unsigned int         bufSize;
//    
//    kern_return_t kr = IOMasterPort(MACH_PORT_NULL, &masterPort);
//    if (kr != noErr) return nil;
//	
//    io_registry_entry_t entry = IORegistryGetRootEntry(masterPort);
//    if (entry == MACH_PORT_NULL) return nil;
//    
//    CFTypeRef prop = IORegistryEntrySearchCFProperty(entry, kIODeviceTreePlane, (__bridge CFStringRef) iosearch, nil, kIORegistryIterateRecursively);
//    if (!prop) return nil;
//	
//	propID = CFGetTypeID(prop);
//    if (!(propID == CFDataGetTypeID())) 
//	{
//		mach_port_deallocate(mach_task_self(), masterPort);
//		return nil;
//	}
//	
//    CFDataRef propData = (CFDataRef) prop;
//    if (!propData) return nil;
//	
//    bufSize = CFDataGetLength(propData);
//    if (!bufSize) return nil;
//	
//    NSString *p1 = [[NSString alloc] initWithBytes:CFDataGetBytePtr(propData) length:bufSize encoding:1];
//    mach_port_deallocate(mach_task_self(), masterPort);
//    return [p1 componentsSeparatedByString:@"\0"];
#endif
}

- (NSString *) imei
{
	NSArray *results = getValue(@"device-imei");
	if (results) return [results objectAtIndex:0];
	return @" ";
}

- (NSString *) serialnumber
{
	NSArray *results = getValue(@"serial-number");
	if (results) return [results objectAtIndex:0];
	return @" ";
}

- (NSString *) backlightlevel
{
	NSArray *results = getValue(@"backlight-level");
	if (results) return [results objectAtIndex:0];
	return @" ";
}

- (NSString *) adress
{
    NSString *address = @"error";
    NSString *netmask = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                NSString *temp = [NSString stringWithUTF8String:temp_addr->ifa_name];
                if([temp isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    netmask = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    NSLog(@"address %@", address);
    NSLog(@"netmask %@", netmask);
    return address;
}

@end


#endif
