//
//  STStorage.h
//  FolderMonitor
//
//  Created by Георгий Малюков on 05.05.17.
//  Copyright © 2017 SwissTechAG. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface STStorage : NSObject {
    
}

#pragma mark - Keychain

+ (void)keychainSetValue:(NSString *)value forKey:(NSString *)key;
+ (NSString *)keychainGetValueForKey:(NSString *)key;

@end
