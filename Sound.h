//
//  Sound.h
//  BLOXZ
//
//  Created by Pminu on 7/3/14.
//  Copyright (c) 2014 LGMRA Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kSoundOnKey @"SoundOn"
#define kDefaultSoundSet @"DefaultSound"

@interface Sound : NSObject
-(void)playSound;
+(void)setSoundOn:(BOOL)on;
+(BOOL)soundOn;
@end
