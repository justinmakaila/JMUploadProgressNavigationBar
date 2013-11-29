//
//  JMProgressView.m
//  JMUploadProgressNavigationController
//
//  Created by Justin Makaila on 11/28/13.
//  Copyright (c) 2013 Present, Inc. All rights reserved.
//

#import "JMProgressView.h"

static NSString *const kUploadingMessage = @"Uploading...";
static NSString *const kFailedMessage = @"Failed";
static NSString *const kCancelledMessage = @"Cancelled";
static NSString *const kFinishedMessage = @"Finished!";
static NSString *const kNoProgressMessage = @"0%";

@implementation JMProgressView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (void)baseInit {
    self.clipsToBounds = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = [UIColor whiteColor];
    self.tintColor = [UIColor whiteColor];
    
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 50, 24)];
    self.progressLabel.text = kNoProgressMessage;
    self.progressLabel.font = [UIFont systemFontOfSize:15.0f];
    self.progressLabel.clipsToBounds = YES;
    [self addSubview:self.progressLabel];
    
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 170, 24)];
    self.messageLabel.text = kUploadingMessage;
    self.messageLabel.font = [UIFont systemFontOfSize:15.0f];
    self.messageLabel.clipsToBounds = YES;
    [self addSubview:self.messageLabel];
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    self.progressView.frame = CGRectMake(0, 42, 320, 10);
    self.progressView.clipsToBounds = YES;
    [self addSubview:self.progressView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.frame = CGRectMake(260, 5, 50, 34);
    [cancelButton setTitle:@"X" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor]
                       forState:UIControlStateNormal];
    
    cancelButton.clipsToBounds = YES;
    [cancelButton addTarget:self
                     action:@selector(cancelButtonPressed)
           forControlEvents:UIControlEventTouchUpInside];
    
    self.cancelButton = cancelButton;
    [self addSubview:self.cancelButton];
    
    
    UIButton *retryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    retryButton.frame = CGRectMake(205, 5, 50, 34);
    [retryButton setTitle:@"R" forState:UIControlStateNormal];
    [retryButton setTitleColor:[UIColor blackColor]
                      forState:UIControlStateNormal];
    
    retryButton.clipsToBounds = YES;
    [retryButton addTarget:self
                    action:@selector(retryButtonPressed)
          forControlEvents:UIControlEventTouchUpInside];
    
    self.retryButton = retryButton;
    [self addSubview:self.retryButton];
}

- (void)updateProgressView:(float)progress {
    int progressInt = floor(progress);
    self.progressLabel.text = [NSString stringWithFormat:@"%i%%", progressInt];

    [self.progressView setProgress:(progress / 100) animated:YES];
    
    if (progressInt == 100) {
        if (self.finishedMessage) {
            self.messageLabel.text = self.finishedMessage;
        }else {
            self.messageLabel.text = kFinishedMessage;
        }
        
        if ([_delegate respondsToSelector:@selector(uploadFinished)]) {
            [_delegate uploadFinished];
        }
    }
    
}

- (void)start {
    self.progressLabel.text = kNoProgressMessage;
    
    if (self.uploadingMessage) {
        self.messageLabel.text = self.uploadingMessage;
    }else {
        self.messageLabel.text = kUploadingMessage;
    }
}

- (void)cancel {
    if (self.cancelledMessage) {
        self.messageLabel.text = self.cancelledMessage;
    }else {
        self.messageLabel.text = kCancelledMessage;
    }
}

#pragma mark - IBActions

- (void)retryButtonPressed {
    if ([_delegate respondsToSelector:@selector(retryButtonPressed)]) {
        [_delegate retryButtonPressed];
    }
}

- (void)cancelButtonPressed {
    if ([_delegate respondsToSelector:@selector(cancelButtonPressed)]) {
        [_delegate cancelButtonPressed];
    }
}

@end