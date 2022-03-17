//
//  Score.h
//  3111
//
//  Created by Pminu on 4/23/14.
//  Copyright (c) 2014 LGMRA Studios. All rights reserved.
//

#define kBestScoreKey @"BestScore"
#define kCheatDetected @"Tamper"

@interface Score : NSObject

+ (void) registerScore:(NSInteger) score;
+ (void) setBestScore:(NSInteger) bestScore;
+ (NSInteger) bestScore;


@end
