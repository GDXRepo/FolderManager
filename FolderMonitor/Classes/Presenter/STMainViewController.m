//
//  STMainViewController.m
//  FolderMonitor
//
//  Created by Георгий Малюков on 05.05.17.
//  Copyright © 2017 SwissTechAG. All rights reserved.
//

#import "STMainViewController.h"
#import "STFolderMonitor.h"
#import "STFolderView.h"


@interface STMainViewController ()<UIDocumentPickerDelegate, STFolderMonitorDelegate> {
    STFolderMonitor *monitor;
}

@property (weak, nonatomic) IBOutlet STFolderView *folderView;

@end


@implementation STMainViewController


#pragma mark - Root

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.folderView.onSelectCallback = ^(STFolderView *view) {
        NSString *typeDirectory = (__bridge NSString *)kUTTypeDirectory;
        UIDocumentPickerViewController *controller = [[UIDocumentPickerViewController alloc]
                                                      initWithDocumentTypes:@[typeDirectory]
                                                      inMode:UIDocumentPickerModeOpen];
        controller.delegate = self;
        
        [self presentViewController:controller animated:YES completion:nil];
    };
}


#pragma mark - UIDocumentPickerDelegate

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    if (!monitor) {
        monitor = [[STFolderMonitor alloc] initWithFolderPath:url.absoluteString delegate:self];
    }
    else {
        monitor.folderPath = url.absoluteString;
    }
}


#pragma mark - STFolderMonitorDelegate

- (void)folderMonitor:(STFolderMonitor *)monitor didHandleEvent:(STFolderMonitorEvent)event {
    NSString *message = nil;
    
    switch (event) {
        case STFolderMonitorEventModified: {
            message = @"File modification handled.";
            break;
        }
        case STFolderMonitorEventRemoved: {
            message = @"File removal handled.";
            break;
        }
        case STFolderMonitorEventRenamed: {
            message = @"File renaming handled.";
            break;
        }
    }
    if (message) {
        UIAlertController *ctrl = [UIAlertController
                                   alertControllerWithTitle:nil
                                   message:message
                                   preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOK = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * _Nonnull action) {
                                       [ctrl dismissViewControllerAnimated:YES
                                                                completion:nil];
                                   }];
        [ctrl addAction:actionOK];
        [self presentViewController:ctrl animated:YES completion:nil];
    }
}

@end
