//
//  Music.m
//  3111
//
//  Created by Pminu on 5/19/14.
//  Copyright (c) 2014 LGMRA Studios. All rights reserved.
//

#import "Music.h"
@interface Music()
@property (nonatomic, assign) BOOL playing;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@end

@implementation Music
{
    NSArray *_songs;
    NSInteger currentSongsIndex;
    BOOL _isPlayerAvailable;
}
@synthesize audioPlayer;

- (id)init
{
    if (self = [super init])
    {
        if([[NSUserDefaults standardUserDefaults] boolForKey:kDefaultMusicSet] == YES){
            //the game has already been run once and the default was set to YES, this will never run again
        }else{
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kMusicOnKey];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDefaultMusicSet];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        if([[NSUserDefaults standardUserDefaults] boolForKey:kMusicOnKey] == YES){
            NSLog(@"music should begin playing");
            if(!self.playing){
                [self startPlayer];
            }
        }else{
            NSLog(@"the music is disabled");
            if(self.playing){
                [self stopMusicPlayer];
            }
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kMusicOnKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    return self;
}
- (void) startPlayer
{
    currentSongsIndex = 0;
    [self createSongArray];
    [self playMusic];
}
- (void) createSongArray
{
    _songs = [NSArray arrayWithObjects:@"song1.mp3",@"song2.mp3",@"song3.mp3",@"song4.mp3",@"song5.mp3", nil];
}

- (void) playMusic
{
    if ([[AVAudioSession sharedInstance] isOtherAudioPlaying]) {
        NSLog(@"music is already playing, so we cannot start the player");
    }else{
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:[_songs objectAtIndex:currentSongsIndex] ofType:nil]] error:&error];
        if(error != nil)
        {
            NSLog(@"Error in mediaPlayer: %@",error);
        }
        else
        {
            NSLog(@"music is going to start playing");

            [audioPlayer setDelegate:self];
            [audioPlayer prepareToPlay];
            [audioPlayer play];
            self.playing = YES;
        }
    }
}
-(void)playFirstMusic
{
    if ([[AVAudioSession sharedInstance] isOtherAudioPlaying]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Playing Music"
                              message:@"It appears that you are already listening to music in another app, please close that and try again."
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil];
        [alert show];
    }else{
        currentSongsIndex = 0;
        [self createSongArray];
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:[_songs objectAtIndex:currentSongsIndex] ofType:nil]] error:&error];
        if(error != nil)
        {
            NSLog(@"Error in mediaPlayer: %@",error);
        }
        else
        {
            NSLog(@"music is going to start playing");
            //set some on screen text for the song//self.SongName.text = [_songs objectAtIndex:currentSoundsIndex];
            [audioPlayer setDelegate:self];
            [audioPlayer prepareToPlay];
            [audioPlayer play];
            self.playing = YES;
        }
    }
}

+ (void)setMusicOn:(BOOL)on
{
    [[NSUserDefaults standardUserDefaults] setBool:on forKey:kMusicOnKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)musicOn
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kMusicOnKey];
}
- (void)pauseMusicPlayer {
    [audioPlayer pause];
}
- (void)resumeMusicPlayback {
    [audioPlayer play];
}
- (void)stopMusicPlayer
{
    [audioPlayer stop];
    [audioPlayer setRate:0.0];
    self.playing = NO;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //if songCounter < [songs count] increment songCounter, play next song; looping!
    if(currentSongsIndex >= [_songs count] -1 )
    {
        currentSongsIndex = 0;
        [self playMusic];
    }
    else
    {
        //increments the counter if not at end of array yet, else above resets
        currentSongsIndex++;
        [self playMusic];
    }
    
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"An audio error has occured: %@", error);
}
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    NSLog(@"audio player began interuption");
}
-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
    NSLog(@"audio player ended interuption");
}
@end
