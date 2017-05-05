//
//  STFolderMonitor.h
//  FolderMonitor
//
//  Created by Георгий Малюков on 05.05.17.
//  Copyright © 2017 SwissTechAG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@class STFolderMonitor;

typedef NS_ENUM(NSUInteger, STFolderMonitorEvent) {
    STFolderMonitorEventModified,
    STFolderMonitorEventRenamed,
    STFolderMonitorEventRemoved
};


@protocol STFolderMonitorDelegate<NSObject>
@required
- (void)folderMonitor:(STFolderMonitor *)monitor didHandleEvent:(STFolderMonitorEvent)event;

@end


@interface STFolderMonitor : NSObject {
    
}

@property (weak, nonatomic) id<STFolderMonitorDelegate> delegate;

@property (copy, nonatomic) NSString *folderPath;


#pragma mark - Root

- (instancetype)initWithFolderPath:(NSString *)path delegate:(id<STFolderMonitorDelegate>)delegate;
- (instancetype)initWithDelegate:(id<STFolderMonitorDelegate>)delegate;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;


#pragma mark - Utils

- (void)stopMonitoring;

@end
