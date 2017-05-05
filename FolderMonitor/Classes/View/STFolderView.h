//
//  STFolderView.h
//  FolderMonitor
//
//  Created by Георгий Малюков on 05.05.17.
//  Copyright © 2017 SwissTechAG. All rights reserved.
//

#import "STView.h"

@class STFolderView;

typedef void(^STFolderViewCallback)(STFolderView *view);


@interface STFolderView : STView {
    
}

@property (copy, nonatomic) NSString             *folderPath;
@property (copy, nonatomic) STFolderViewCallback onSelectCallback;

@end
