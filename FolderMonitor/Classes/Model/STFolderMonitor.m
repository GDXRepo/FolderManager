//
//  STFolderMonitor.m
//  FolderMonitor
//
//  Created by Георгий Малюков on 05.05.17.
//  Copyright © 2017 SwissTechAG. All rights reserved.
//

#import "STFolderMonitor.h"
#import "STStorage.h"

static NSString *const STFolderMonitorFolderPathKey = @"FMFPK";


@interface STFolderMonitor () {
    NSURL *folderURL;
    
    dispatch_source_t source;
    int  fileDescriptor;
    BOOL keepMonitoringFile;
    BOOL isMonitoring;
}

#pragma mark - Private

- (void)startMonitoring;
- (void)recreateSource;
- (void)parseSourceEvents:(unsigned long)events;

@end


@implementation STFolderMonitor


#pragma mark - Root

- (instancetype)initWithFolderPath:(NSString *)path delegate:(id<STFolderMonitorDelegate>)delegate {
    self = [super init];
    if (self) {
        self.folderPath = path;
        _delegate = delegate;
        keepMonitoringFile = NO;
        
        if (!self.folderPath) {
            self.folderPath = [STStorage keychainGetValueForKey:STFolderMonitorFolderPathKey];
        }
        // save new path
        [STStorage keychainSetValue:self.folderPath forKey:STFolderMonitorFolderPathKey];
    }
    return self;
}

- (instancetype)initWithDelegate:(id<STFolderMonitorDelegate>)delegate {
    return [self initWithFolderPath:nil delegate:delegate];
}

- (void)dealloc {
    keepMonitoringFile = NO;
    dispatch_source_cancel(source);
}


#pragma mark - Utils

- (void)stopMonitoring {
    keepMonitoringFile = NO;
    dispatch_source_cancel(source);
}


#pragma mark - Properties

- (void)setFolderPath:(NSString *)folderPath {
    _folderPath = [folderPath copy];
    folderURL = [NSURL fileURLWithPath:self.folderPath];
    NSAssert(folderURL, @"Invalid folder path.");
    
    if (isMonitoring) {
        [self recreateSource];
    }
}


#pragma mark - Private

- (void)startMonitoring {
    // open file descriptor for the path
    fileDescriptor = open([[folderURL path] fileSystemRepresentation], O_EVTONLY);
    // Get a reference to the default queue so our file notifications can go out on it
    dispatch_queue_t defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // Create a dispatch source
    source = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE,
                                    fileDescriptor,
                                    (DISPATCH_VNODE_DELETE | DISPATCH_VNODE_RENAME | DISPATCH_VNODE_WRITE),
                                    defaultQueue);
    // Log one or more messages to the screen when there's a file change event
    dispatch_source_set_event_handler(source, ^{
        [self parseSourceEvents:dispatch_source_get_data(source)];
    });
    dispatch_source_set_cancel_handler(source, ^{
        close(fileDescriptor);
        fileDescriptor = 0;
        source = nil;
        isMonitoring = NO;
        // If this dispatch source was canceled because of a rename or delete notification, recreate it
        if (keepMonitoringFile) {
            keepMonitoringFile = NO;
            
            [self startMonitoring];
        }
    });
    // Start monitoring the file
    dispatch_resume(source);
    isMonitoring = YES;
}

- (void)recreateSource {
    keepMonitoringFile = YES;
    dispatch_source_cancel(source);
}

- (void)parseSourceEvents:(unsigned long)events {
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL recreateDispatchSource = NO;
        NSMutableSet *eventSet = [[NSMutableSet alloc] initWithCapacity:3];
        
        if (events & DISPATCH_VNODE_DELETE) {
            [eventSet addObject:@(STFolderMonitorEventRemoved)];
            recreateDispatchSource = YES;
        }
        if (events & DISPATCH_VNODE_RENAME) {
            [eventSet addObject:@(STFolderMonitorEventRenamed)];
            recreateDispatchSource = YES;
        }
        if (events & DISPATCH_VNODE_WRITE) {
            [eventSet addObject:@(STFolderMonitorEventModified)];
        }
        // notify delegate
        for (NSNumber *eventId in eventSet) {
            [self.delegate folderMonitor:self didHandleEvent:(STFolderMonitorEvent)eventId.integerValue];
        }
        if (recreateDispatchSource) {
            [self recreateSource];
        }
    });
}

@end
