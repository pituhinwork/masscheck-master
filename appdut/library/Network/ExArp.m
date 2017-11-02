//
//  ExArp.m
//  IZap04
//
//  Created by Bach Ung on 9/30/14.
//  Copyright (c) 2014 Bach Ung. All rights reserved.
//
#import "AppDelegate.h"
#import "ExArp.h"
#include <sys/param.h>
#include <sys/file.h>
#include <sys/socket.h>
#include <sys/sysctl.h>

#include <net/if.h>
#include <net/if_dl.h>
#include "if_types.h"
//#include "route.h"
#include "if_ether.h"
#include <netinet/in.h>


#include <arpa/inet.h>

#include <err.h>
#include <errno.h>
#include <netdb.h>

#include <paths.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#if TARGET_IPHONE_SIMULATOR
#include <net/route.h>
#else
#include "route.h"
#endif



@implementation ExArp

+ (NSString*)ip2mac:(char*) ip //chay thu nghiem
{
    
   in_addr_t addr = inet_addr(ip);
    
    NSString *ret = nil;
    
    size_t needed;
    char *buf, *next;
    
    struct rt_msghdr *rtm;
    struct sockaddr_inarp *sin;
    struct sockaddr_dl *sdl;
    
    int mib[6];
    
    mib[0] = CTL_NET;
    mib[1] = PF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_INET;
    mib[4] = NET_RT_FLAGS;
    mib[5] = RTF_LLINFO;
    
    if (sysctl(mib, sizeof(mib) / sizeof(mib[0]), NULL, &needed, NULL, 0) < 0)
        err(1, "route-sysctl-estimate");
    
    if ((buf = (char*)malloc(needed)) == NULL)
        err(1, "malloc");
    
    if (sysctl(mib, sizeof(mib) / sizeof(mib[0]), buf, &needed, NULL, 0) < 0)
        err(1, "retrieval of routing table");
    
    for (next = buf; next < buf + needed; next += rtm->rtm_msglen) {
        
        rtm = (struct rt_msghdr *)next;
        sin = (struct sockaddr_inarp *)(rtm + 1);
        sdl = (struct sockaddr_dl *)(sin + 1);
        
        if (addr != sin->sin_addr.s_addr || sdl->sdl_alen < 6)
            continue;
        
        u_char *cp = (u_char*)LLADDR(sdl);
        
        ret = [NSString stringWithFormat:@"%X:%X:%X:%X:%X:%X",
               cp[0], cp[1], cp[2], cp[3], cp[4], cp[5]];
        
        break;
    }
    
    free(buf);
    
    return ret;
}

// lay default gw: dang dung
//+(NSString*) ip2mac: (char*) ip
//{
//    int expire_time, flags, export_only, doing_proxy, found_entry;
//    NSString *mAddr = nil;
//    u_long addr = inet_addr(ip);
//    int mib[6];
//    int nflag = 0;
//    size_t needed;
//    char *host, *lim, *buf, *next;
//    struct rt_msghdr *rtm;
//    struct sockaddr_inarp *sin;
//    struct sockaddr_dl *sdl;
//    extern int h_errno;
//    struct hostent *hp;
//    
//    mib[0] = CTL_NET;
//    mib[1] = PF_ROUTE;
//    mib[2] = 0;
//    mib[3] = AF_INET;
//    mib[4] = NET_RT_FLAGS;
//    mib[5] = RTF_LLINFO;
//    if (sysctl(mib, 6, NULL, &needed, NULL, 0) < 0)
//        err(1, "route-sysctl-estimate");
//    if ((buf = malloc(needed)) == NULL)
//        err(1, "malloc");
//    if (sysctl(mib, 6, buf, &needed, NULL, 0) < 0)
//        err(1, "actual retrieval of routing table");
//    
//    
//    lim = buf + needed;
//    for (next = buf; next < lim; next += rtm->rtm_msglen) {
//        rtm = (struct rt_msghdr *)next;
//        sin = (struct sockaddr_inarp *)(rtm + 1);
//        sdl = (struct sockaddr_dl *)(sin + 1);
//        if (addr) {
//            if (addr != sin->sin_addr.s_addr)
//                continue;
//            found_entry = 1;
//        }
//        if (nflag == 0)
//            hp = gethostbyaddr((caddr_t)&(sin->sin_addr),
//                               sizeof sin->sin_addr, AF_INET);
//        else
//            hp = 0;
//        if (hp)
//            host = hp->h_name;
//        else {
//            host = "?";
//            if (h_errno == TRY_AGAIN)
//                nflag = 1;
//        }
//        
//        
//        
//        if (sdl->sdl_alen) {
//            u_char *cp = LLADDR(sdl);
//            mAddr = [NSString stringWithFormat:@"%x:%x:%x:%x:%x:%x", cp[0], cp[1], cp[2], cp[3], cp[4], cp[5]];
//            //  ether_print((u_char *)LLADDR(sdl));
//        }
//        else
//            
//            mAddr = nil;
//    }
//    
//    
//    if (found_entry == 0)
//    {
//        return nil;
//    }
//    else
//    {
//        return mAddr;
//    }
//  
//}
static int nflag;

+(int) dump:(u_long) addr
{
    int mib[6];
    size_t needed;
    char *host, *lim, *buf, *next;
    struct rt_msghdr *rtm;
    struct sockaddr_inarp *sin;
    struct sockaddr_dl *sdl;
    extern int h_errno;
    struct hostent *hp;
    int found_entry = 0;
    
    mib[0] = CTL_NET;
    mib[1] = PF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_INET;
    mib[4] = NET_RT_FLAGS;
    mib[5] = RTF_LLINFO;
    if (sysctl(mib, 6, NULL, &needed, NULL, 0) < 0)
        err(1, "route-sysctl-estimate");
    if ((buf = malloc(needed)) == NULL)
        err(1, "malloc");
    if (sysctl(mib, 6, buf, &needed, NULL, 0) < 0)
        err(1, "actual retrieval of routing table");
    lim = buf + needed;
    for (next = buf; next < lim; next += rtm->rtm_msglen) {
        rtm = (struct rt_msghdr *)next;
        sin = (struct sockaddr_inarp *)(rtm + 1);
        sdl = (struct sockaddr_dl *)(sin + 1);
        if (addr) {
            if (addr != sin->sin_addr.s_addr)
                continue;
            found_entry = 1;
        }
        if (nflag == 0)
            hp = gethostbyaddr((caddr_t)&(sin->sin_addr), sizeof sin->sin_addr, AF_INET);
        else
            hp = 0;
        if (hp)
            host = hp->h_name;
        else {
            host = "?";
            if (h_errno == TRY_AGAIN)
                nflag = 1;
        }
       
        
        printf("%s (%s) at ", host, inet_ntoa(sin->sin_addr));
        if (sdl->sdl_alen)
        {
            u_char *cp=(u_char *)LLADDR(sdl);
            NSLog(@"%x:%x:%x:%x:%x:%x", cp[0], cp[1], cp[2], cp[3], cp[4], cp[5]);
        }
        else
            NSLog(@"(incomplete)");
        if (rtm->rtm_rmx.rmx_expire == 0)
            NSLog(@" permanent");
        if (sin->sin_other & SIN_PROXY)
            NSLog(@" published (proxy only)");
        if (rtm->rtm_addrs & RTA_NETMASK)
        {
            sin = (struct sockaddr_inarp *)
            (sdl->sdl_len + (char *)sdl);
            if (sin->sin_addr.s_addr == 0xffffffff)
                NSLog(@" published");
            if (sin->sin_len != 8)
                NSLog(@"(weird)");
        }
        NSLog(@"\n");
    }
    return (found_entry);
}

+(NSMutableArray*) getList:(u_long) addr
{
    NSMutableArray *array =  [[NSMutableArray alloc] init];
    [array removeAllObjects];
    int mib[6];
    size_t needed;
    char *lim, *buf, *next;
    struct rt_msghdr *rtm;
    struct sockaddr_inarp *sin;
    struct sockaddr_dl *sdl;
    extern int h_errno;
    int found_entry = 0;
    
    mib[0] = CTL_NET;
    mib[1] = PF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_INET;
    mib[4] = NET_RT_FLAGS;
    mib[5] = RTF_LLINFO;
    if (sysctl(mib, 6, NULL, &needed, NULL, 0) < 0)
        err(1, "route-sysctl-estimate");
    if ((buf = malloc(needed)) == NULL)
        err(1, "malloc");
    if (sysctl(mib, 6, buf, &needed, NULL, 0) < 0)
        err(1, "actual retrieval of routing table");
    lim = buf + needed;
    printf("\n");
    for (next = buf; next < lim; next += rtm->rtm_msglen)
    {
        rtm = (struct rt_msghdr *)next;
        sin = (struct sockaddr_inarp *)(rtm + 1);
        sdl = (struct sockaddr_dl *)(sin + 1);
        
        if (addr) {
            if (addr != sin->sin_addr.s_addr)
                continue;
            found_entry = 1;
        }
        
//        printf("%s\n", inet_ntoa(sin->sin_addr));
        NSLog(@"%s\n", inet_ntoa(sin->sin_addr));
        [array addObject:[NSString stringWithFormat:@"%s",inet_ntoa(sin->sin_addr)]];
        
    }
    return array;
}

+(NSMutableArray*) getListWithDevice:(u_long) addr
{
    NSMutableArray *array =  [[NSMutableArray alloc] init];
    [array removeAllObjects];
    int mib[6];
    size_t needed;
    char *lim, *buf, *next;
    struct rt_msghdr *rtm;
    struct sockaddr_inarp *sin;
    struct sockaddr_dl *sdl;
    extern int h_errno;
    int found_entry = 0;
    
    mib[0] = CTL_NET;
    mib[1] = PF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_INET;
    mib[4] = NET_RT_FLAGS;
    mib[5] = RTF_LLINFO;
    if (sysctl(mib, 6, NULL, &needed, NULL, 0) < 0)
        err(1, "route-sysctl-estimate");
    if ((buf = malloc(needed)) == NULL)
        err(1, "malloc");
    if (sysctl(mib, 6, buf, &needed, NULL, 0) < 0)
        err(1, "actual retrieval of routing table");
    lim = buf + needed;
    printf("\n");
    for (next = buf; next < lim; next += rtm->rtm_msglen)
    {
        rtm = (struct rt_msghdr *)next;
        sin = (struct sockaddr_inarp *)(rtm + 1);
        sdl = (struct sockaddr_dl *)(sin + 1);
        
        if (addr) {
            if (addr != sin->sin_addr.s_addr)
                continue;
            found_entry = 1;
        }
        
    }
    return array;
}


//+(void) ether_print:(u_char *)cp
//{
//    AppLog(@"%x:%x:%x:%x:%x:%x", cp[0], cp[1], cp[2], cp[3], cp[4], cp[5]);
//}


@end
