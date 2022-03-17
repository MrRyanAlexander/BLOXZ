//
//  Music.h
//  3111
//
//  Created by Pminu on 5/19/14.
//  Copyright (c) 2014 LGMRA Studios. All rights reserved.
//

//#import <Foundation/Foundation.h>
#define kMusicOnKey @"MusicOn"
#define kDefaultMusicSet @"DefaultMusic"
@interface Music : NSObject <AVAudioPlayerDelegate>

- (void)playFirstMusic;
- (void)stopMusicPlayer;
- (void)pauseMusicPlayer;
- (void)resumeMusicPlayback;
+ (void)setMusicOn:(BOOL)on;
+ (BOOL)musicOn;
@end
