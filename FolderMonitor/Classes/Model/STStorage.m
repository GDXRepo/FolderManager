//
//  STStorage.m
//  FolderMonitor
//
//  Created by Георгий Малюков on 05.05.17.
//  Copyright © 2017 SwissTechAG. All rights reserved.
//

#import "STStorage.h"
#import <SAMKeychain/SAMKeychain.h>

static NSString *const STStorageKeychainAccount = @"com.swisstech.FolderManager.KeychainAccount";


@interface STStorage () {
    
}

@end


@implementation STStorage


#pragma mark - Utils

+ (void)keychainSetValue:(NSString *)value forKey:(NSString *)key {
    if (value) {
        [SAMKeychain setPassword:value forService:key account:STStorageKeychainAccount];
    }
    else {
        [SAMKeychain deletePasswordForService:key account:STStorageKeychainAccount];
    }
}

+ (NSString *)keychainGetValueForKey:(NSString *)key {
    return [SAMKeychain passwordForService:key account:STStorageKeychainAccount];
}

@end
