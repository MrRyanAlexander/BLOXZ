//
//  SecureData.h
//  BLOXZ
//
//  Created by Pminu on 7/28/14.
//  Copyright (c) 2014 LGMRA Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecureData : NSObject
+ (void) updateOrCreateSecureItem :(NSString*)stringItem :(NSString*)itemLabel;
+ (void) deleteSecureItem :(NSString*)stringItem :(NSString*)itemLabel;
+ (NSString*) getSecureItem :(NSString*)itemLabel;
@end
