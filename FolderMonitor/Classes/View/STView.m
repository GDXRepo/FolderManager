//
//  STView.m
//  FolderMonitor
//
//  Created by Георгий Малюков on 05.05.17.
//  Copyright © 2017 SwissTechAG. All rights reserved.
//

#import "STView.h"


@interface STView () {
    
}

#pragma mark - Private

- (void)autoLoad;

@end


@implementation STView


#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    // zero frame must be reset to original frame from the nib (if possible)
    if (CGRectEqualToRect(frame, CGRectZero)) {
        NSString *name = NSStringFromClass([self class]);
        
        if ([[NSBundle mainBundle] pathForResource:name ofType:@"nib"]) {
            UINib *nib = [UINib nibWithNibName:name bundle:[NSBundle mainBundle]];
            UIView *view = [nib instantiateWithOwner:self options:nil].firstObject;
            frame = view.frame;
            // this may occur if the view was initialized by "alloc-init" or "new" call
            return [[self.class alloc] initWithFrame:frame];
        }
    }
    // otherwise perform normal initialization
    self = [super initWithFrame:frame];
    if (self) {
        [self autoLoad];
        [self awakeFromNib];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self autoLoad]; // "setup" will be called in "awakeFromNib" automatically
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self localize];
}


#pragma mark - Setup

- (void)localize {
    // empty
}

- (void)reloadData {
    // empty
}


#pragma mark - Private

- (void)autoLoad {
    NSString *name = NSStringFromClass([self class]);
    
    if ([[NSBundle mainBundle] pathForResource:name ofType:@"nib"]) {
        UINib *nib = [UINib nibWithNibName:name bundle:[NSBundle mainBundle]];
        UIView *view = [nib instantiateWithOwner:self options:nil].firstObject;
        view.frame = self.bounds;
        view.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                                 | UIViewAutoresizingFlexibleHeight);
        [self addSubview:view];
    }
}

@end
