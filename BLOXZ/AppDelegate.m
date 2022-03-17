//
//  AppDelegate.m
//  BLOXZ
//

//  Copyright (c) 2014 LGMRA Studios. All rights reserved.
//
#import "AppDelegate.h"
#import "Music.h"
#import "NSUserDefaults+MPSecureUserDefaults.h"

#define kAppUsageCount @"UseCount"


@interface AppDelegate () <UIAlertViewDelegate>
@property (nonatomic, retain) Music *musicPlayer;
@property (nonatomic, retain) NSMutableData *responseData;
@end

@implementation AppDelegate

#pragma mark - Helper methods

#pragma mark - UIApplication methods
/*
 * If we have a valid session at the time of openURL call, we handle
 * Facebook transitions by passing the url argument to handleOpenURL
 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url

    if(url) {
        return YES;
    }else {
        return NO;
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"app did finish launch with options");
    [NSUserDefaults setSecret:@"909g0g9dDD32lmFIWioen83n40vNvj9vVDL"];
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"app will resign active");
    
    SKView *view = (SKView *)self.window.rootViewController.view;
    view.paused = YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"app did enter background");
    if([Music musicOn]){
        NSLog(@"pausing music");
        [self.musicPlayer pauseMusicPlayer];
    }

}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"app did enter foreground");
    if([Music musicOn]){
        NSLog(@"resuming music");
        [self.musicPlayer resumeMusicPlayback];
    }else{
        NSLog(@"music disabled");
    }
}
- (void)checkAppUsage {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    BOOL valid = NO;
    NSInteger num = [defaults secureIntegerForKey:kAppUsageCount valid:&valid];
    if(num > 5) {
        //check the URL
        NSURL *dataURL = [NSURL URLWithString:@"http://lgmra.com/donttouchtheblocks.json"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:dataURL];
        NSURLConnection *connect = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
        [connect start];
        [defaults setSecureInteger:0 forKey:kAppUsageCount];
    }else{
        [defaults setSecureInteger:num+1 forKey:kAppUsageCount];
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.responseData = [[NSMutableData alloc] init];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}
- (NSCachedURLResponse *)connection:(NSURLConnection*)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}
- (void)connectionDidFinishLoading:(NSURLConnection*)connection {
    NSLog(@"finished loading data :%@", self.responseData);
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"app did become active");
    [self checkAppUsage];
    //
    
    SKView *view = (SKView *)self.window.rootViewController.view;
    view.paused = NO;
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - UIAlertViewDelegate methods
/*
 * When the alert is dismissed check which button was clicked so
 * you can take appropriate action, such as displaying the request
 * dialog, or setting a flag not to prompt the user again.
 */
- (void)alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // User has clicked on the No Thanks button, do not ask again
    } else if (buttonIndex == 1) {
    }
}
@end