//
//  FBAppDelegate.m
//  FBShareSandbox
//
//  Created by zhangxueyang on 05/04/2018.
//  Copyright (c) 2018 zhangxueyang. All rights reserved.
//

#import "FBAppDelegate.h"
#import "FBShareSandbox.h"

@implementation FBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSURL* testUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString* path = [testUrl.path stringByAppendingPathComponent:@"test.txt"];
    [@"123" writeToFile:path atomically:true encoding:NSUTF8StringEncoding error:nil];
    
    NSString* path1 = [testUrl.path stringByAppendingPathComponent:@"test1.txt"];
    [@"123456" writeToFile:path1 atomically:true encoding:NSUTF8StringEncoding error:nil];
    
    
#ifdef DEBUG
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[FBShareSandbox sharedSandbox] swipSandboxPage];
    });
#endif
    
    return YES;
}


@end
