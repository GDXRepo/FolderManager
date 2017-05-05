//
//  STFolderView.m
//  FolderMonitor
//
//  Created by Георгий Малюков on 05.05.17.
//  Copyright © 2017 SwissTechAG. All rights reserved.
//

#import "STFolderView.h"


@interface STFolderView () {
    
}

@property (weak, nonatomic) IBOutlet UILabel *pathLabel;


#pragma mark - Actions

- (IBAction)selectButtonClick:(id)sender;

@end


@implementation STFolderView


#pragma mark - Root

- (void)reloadData {
    [super reloadData];
    
    self.pathLabel.text = (self.folderPath) ? self.folderPath : @"-";
}


#pragma mark - Properties

- (void)setFolderPath:(NSString *)folderPath {
    _folderPath = [folderPath copy];
    
    [self reloadData];
}


#pragma mark - Actions

- (IBAction)selectButtonClick:(id)sender {
    if (self.onSelectCallback) {
        self.onSelectCallback(self);
    }
}

@end
