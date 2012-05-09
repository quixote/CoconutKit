//
//  HLSURLImageView.m
//  CoconutKit
//
//  Created by Samuel Défago on 09.05.12.
//  Copyright (c) 2012 Hortis. All rights reserved.
//

#import "HLSURLImageView.h"

#import "HLSLogger.h"
#import "HLSZeroingWeakRef.h"

@interface HLSURLImageView ()

+ (NSCache *)sharedImageCache;

- (void)hlsURLImageViewInit;

@property (nonatomic, retain) HLSZeroingWeakRef *connectionZeroingWeakRef;
@property (nonatomic, retain) UIImageView *imageView;

@end

@implementation HLSURLImageView

#pragma mark Class methods

+ (NSCache *)sharedImageCache
{
    static NSCache *s_instance = nil;
    static BOOL s_created = NO;
    if (! s_created) {
        // NSCache is available starting with iOS 4
        if (NSClassFromString(@"NSCache")) {
            s_instance = [[NSCache alloc] init];
        }
        else {
            HLSLoggerWarn(@"The image cache is available for iOS 4 and above only");
        }
        s_created = YES;
    }
    return s_instance;
}

#pragma mark Object creation and destruction

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self hlsURLImageViewInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self hlsURLImageViewInit];
    }
    return self;
}

- (void)hlsURLImageViewInit
{
    self.backgroundColor = [UIColor clearColor];
    self.imageView = [[[UIImageView alloc] initWithFrame:self.bounds] autorelease];
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.imageView];
}

- (void)dealloc
{
    self.connectionZeroingWeakRef = nil;
    self.loadingView = nil;
    self.loadingFailureImage = nil;

    [super dealloc];
}

#pragma mark Accessors and mutators

@synthesize connectionZeroingWeakRef = _connectionZeroingWeakRef;

@dynamic image;

- (UIImage *)image
{
    return self.imageView.image;
}

@synthesize imageView = _imageView;

@synthesize loadingView = _loadingView;

@synthesize loadingFailureImage = _loadingFailureImage;

@synthesize loadingTransitionStyle = _loadingtransitionStyle;

- (void)loadWithRequest:(NSURLRequest *)request
{
    if (! request) {
        self.imageView.image = nil;
        return;
    }
    
    UIImage *image = [[HLSURLImageView sharedImageCache] objectForKey:[request URL]];
    if (image) {
        self.imageView.image = image;
        return;
    }
    
    // Create the connection
    HLSURLConnection *connection = self.connectionZeroingWeakRef.object;
    if (connection) {
        [connection cancel];
    }
    
    connection = [HLSURLConnection connectionWithRequest:request];
    connection.delegate = self;
    
    self.connectionZeroingWeakRef = [[[HLSZeroingWeakRef alloc] initWithObject:connection] autorelease];
    
    // The connection is scheduled with the NSRunLoopCommonModes run loop mode to allow connection events (i.e. 
    // image assignment when the download is complete) also when scrolling occurs (which is quite common when image 
    // views are used within table view cells)
    [connection startWithRunLoopMode:NSRunLoopCommonModes];
    
    // TODO: Customizable placeholder view / image
    self.imageView.image = nil;
}

- (void)setContentMode:(UIViewContentMode)contentMode
{
    self.imageView.contentMode = contentMode;
}

- (UIViewContentMode)contentMode
{
    return self.imageView.contentMode;
}

#pragma mark HLSURLConnectionDelegate protocol implementation

- (void)connectionDidFinishLoading:(HLSURLConnection *)connection
{
    UIImage *image = [UIImage imageWithData:[connection data]];
    [[HLSURLImageView sharedImageCache] setObject:image forKey:[connection.request URL]];
    
    self.imageView.image = image;
}

- (void)connection:(HLSURLConnection *)connection didFailWithError:(NSError *)error
{
    // TODO: Customizable placeholder image
    self.imageView.image = nil;
}

#pragma mark View lifecycle

- (void)willMoveToWindow:(UIWindow *)window
{
    // When removed from display, stop downloading if a connection object is attached to the image view
    if (! window) {
        HLSURLConnection *connection = self.connectionZeroingWeakRef.object;
        [connection cancel];        
    }
}

@end
