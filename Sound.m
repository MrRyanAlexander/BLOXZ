//
//  Sound.m
//  BLOXZ
//
//  Created by Pminu on 7/3/14.
//  Copyright (c) 2014 LGMRA Studios. All rights reserved.
//

#import "Sound.h"
@interface Sound()
//@property (nonatomic, assign) SystemSoundID *audioEffect;
@end

@implementation Sound
{
    SystemSoundID _audioEffect;
}
- (id)init
{
    if (self = [super init])
    {
        if([[NSUserDefaults standardUserDefaults] boolForKey:kDefaultSoundSet] == YES){
            //the game has already been run once and the default was set to YES, this will never run again
        }else{
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kSoundOnKey];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDefaultSoundSet];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        if([[NSUserDefaults standardUserDefaults] boolForKey:kSoundOnKey] == YES){
            //setup the sounds
            NSString *path = [[NSBundle mainBundle] pathForResource:@"smack" ofType:@"wav"];
            NSURL *pathURL = [NSURL fileURLWithPath:path];
            
            AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &_audioEffect);
        }else{
            //dont do anything
        }
        
    }
    return self;
}
-(void)playSound
{
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:kSoundOnKey]){
        
        AudioServicesPlaySystemSound(_audioEffect);
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            AudioServicesDisposeSystemSoundID(_audioEffect);
        });
    }else{
        NSLog(@"sounds are disabled");
    }
  
    
}
+ (void)setSoundOn:(BOOL)on
{
    [[NSUserDefaults standardUserDefaults] setBool:on forKey:kSoundOnKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(BOOL)soundOn
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSoundOnKey];
}
@end
