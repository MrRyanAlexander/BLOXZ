//
//  Score.m
//  3111
//
//  Created by Pminu on 4/23/14.
//  Copyright (c) 2014 LGMRA Studios. All rights reserved.
//

#import "Score.h"
#import "NSUserDefaults+MPSecureUserDefaults.h"

@interface Score()
@end
@implementation Score

+ (void)registerScore:(NSInteger)score
{
    if(score > [Score bestScore]){
        [Score setBestScore:score];
        NSLog(@"registered higher score");
    }else{
        NSLog(@"not a higher score");
    }
}

+ (void) setBestScore:(NSInteger) bestScore
{
    [[NSUserDefaults standardUserDefaults] setSecureInteger:bestScore forKey:kBestScoreKey];
}

+ (NSInteger) bestScore
{
    
    BOOL valid = NO;
    NSInteger num = [[NSUserDefaults standardUserDefaults] secureIntegerForKey:kBestScoreKey valid:&valid];
    if (valid) {
        return num;
    }else {
        BOOL cheat = [[NSUserDefaults standardUserDefaults] secureBoolForKey:kCheatDetected valid:&cheat];
        if(!cheat) {
            [[NSUserDefaults standardUserDefaults] setSecureBool:YES forKey:kCheatDetected];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CHEAT WARNING!"
                                                            message:@"Cheat and your score is automatically reset to ZERO! HA HA HA"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
        return 0;
    }
}

@end
