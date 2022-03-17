//
//  SecureData.m
//  BLOXZ
//
//  Created by Pminu on 7/28/14.
//  Copyright (c) 2014 LGMRA Studios. All rights reserved.
//
#import <Security/Security.h>
#import "SecureData.h"

@implementation SecureData

-(id)init {
    
    if (self = [super init])
    {
        
    }
    return self;
}
/*
 AppUsedCounter
 BestScore
 CurrentRuns
 RunTimes
 UseCount
 */
+ (NSString*) getSecureItem :(NSString*)itemLabel
{
    NSMutableDictionary *keyChainItem = [NSMutableDictionary dictionary];
    
    keyChainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassKey;//class
    keyChainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleAlways;//pdmn
    keyChainItem[(__bridge id)kSecAttrLabel] = itemLabel;//labl
    
    keyChainItem[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;//data
    keyChainItem[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;//attribute
    NSLog(@"searching for the keychain item:%@", keyChainItem);
    CFDictionaryRef result = nil;
    
    OSStatus sts = SecItemCopyMatching((__bridge CFDictionaryRef)keyChainItem, (CFTypeRef *)& result);
    NSLog(@"GET Error code :%d", (int)sts);

    if(sts == noErr) {
        NSDictionary *resultDict = (__bridge_transfer NSDictionary *)result;
        NSData *itm = resultDict[(__bridge id)kSecValueData];
        NSString *item = [[NSString alloc] initWithData:itm encoding:NSUTF8StringEncoding];
        NSLog(@"Found item:%@", item);
        return item;
    }else{
        NSLog(@"Found nothing");        
        return nil;
    }
}
+ (void) updateOrCreateSecureItem :(NSString*)stringItem :(NSString*)itemLabel {
    
    NSMutableDictionary *keyChainItem = [NSMutableDictionary dictionary];
    
    keyChainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassKey;
    keyChainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleAlways;
    keyChainItem[(__bridge id)kSecAttrLabel] = itemLabel;

    NSLog(@"Creating the keychain item:%@", keyChainItem);
    //check if item exists
    if(SecItemCopyMatching((__bridge CFDictionaryRef)keyChainItem, NULL) == noErr) {
        
        //update existing item
            NSMutableDictionary *attributesToUpdate = [NSMutableDictionary dictionary];
        attributesToUpdate[(__bridge id)kSecValueData] = [stringItem dataUsingEncoding:NSUTF8StringEncoding];

        OSStatus sts = SecItemUpdate((__bridge CFDictionaryRef)keyChainItem, (__bridge CFDictionaryRef)attributesToUpdate);
        
        NSLog(@"UPDATE Error code :%d", (int)sts);
    } else {
        //no item exists, create item
        keyChainItem[(__bridge id)kSecValueData] = [stringItem dataUsingEncoding:NSUTF8StringEncoding];
        
        OSStatus sts = SecItemAdd((__bridge CFDictionaryRef)keyChainItem, NULL);
        NSLog(@"ADD Error code :%d", (int)sts);
    }
}
+ (void) deleteSecureItem :(NSString*)stringItem :(NSString*)itemLabel {
    
    NSMutableDictionary *keyChainItem = [NSMutableDictionary dictionary];
    
    keyChainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassKey;
    keyChainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked;
    keyChainItem[(__bridge id)kSecAttrLabel] = itemLabel;

    //check if item exists
    if(SecItemCopyMatching((__bridge CFDictionaryRef)keyChainItem, NULL) == noErr) {
        
        //delete exsisting item
        OSStatus sts = SecItemDelete((__bridge CFDictionaryRef)keyChainItem);
        NSLog(@"DELETE Error code :%d", (int)sts);
    } else {
        NSLog(@"Not item to delete");
    }
}
@end
