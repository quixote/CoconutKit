//
//  UIImageView+HLSURLConnection.m
//  CoconutKit
//
//  Created by Samuel Défago on 11.04.12.
//  Copyright (c) 2012 Hortis. All rights reserved.
//

#import "UIImageView+HLSURLConnection.h"

#import "HLSCategoryLinker.h"
#import "HLSURLConnection.h"
#import "HLSRuntime.h"

HLSLinkCategory(UIImageView_HLSURLConnection)

// Associated object keys
static void *s_connectionKey = &s_connectionKey;
static void *s_internalDelegateKey = &s_internalDelegateKey;

// Original implementation of the methods we swizzle
static void (*s_UIImageView__willMoveToWindow_Imp)(id, SEL, id) = NULL;

// Swizzled method implementations
static void swizzled_UIImageView__willMoveToWindow_Imp(id self, SEL _cmd, UIWindow *window);

/**
 * Hidden internal delegate, so that the UIImageView class does not implement delegate protocols
 * itself. This avoids issues which could arise if somebody also subclasses UIImageView and
 * implements the same protocols (in which case super would need to be called in each of the
 * protocol method implementations, which is easy to forget)
 */
@interface UIImageView_HLSExtensions_InternalDelegate : NSObject <HLSURLConnectionDelegate> {
@private
    UIImageView *_imageView;
}

@property (nonatomic, assign) UIImageView *imageView;           // weak ref

@end

@implementation UIImageView (HLSURLConnection)

#pragma mark Class methods

+ (void)load
{
    s_UIImageView__willMoveToWindow_Imp = (void (*)(id, SEL, id))hls_class_swizzle_selector(self,
                                                                                            @selector(willMoveToWindow:),
                                                                                            (IMP)swizzled_UIImageView__willMoveToWindow_Imp);
}

#pragma mark Loading an image from a URL

- (void)loadWithImageRequest:(NSURLRequest *)request
{
    // Create the connection
    HLSURLConnection *connection = objc_getAssociatedObject(self, s_connectionKey);
    if (connection) {
        [connection cancel];
    }
    connection = [HLSURLConnection connectionWithRequest:request];
    objc_setAssociatedObject(self, s_connectionKey, connection, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // Setup the internal delegate. When this delegate gets deallocated (i.e. when the image view gets deallocated), the
    // HLSURLConnection will automatically be cancelled
    UIImageView_HLSExtensions_InternalDelegate *internalDelegate = [[[UIImageView_HLSExtensions_InternalDelegate alloc] init] autorelease];
    internalDelegate.imageView = self;
    connection.delegate = internalDelegate;
    objc_setAssociatedObject(self, s_internalDelegateKey, internalDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // The connection is scheduled with the NSRunLoopCommonModes run loop mode to allow connection events (i.e. 
    // image assignment when the download is complete) also when scrolling occurs (which is quite common when image 
    // views are used within table view cells)
    [connection startWithRunLoopMode:NSRunLoopCommonModes];
    
    // TODO: Customizable placeholder view / image
    self.image = nil;
}
                             
- (void)loadWithImageAtURL:(NSURL *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self loadWithImageRequest:request];
}

@end

@implementation UIImageView_HLSExtensions_InternalDelegate

#pragma mark Object creation and destruction

- (void)dealloc
{
    self.imageView = nil;
    
    [super dealloc];
}

#pragma mark Accessors and mutators

@synthesize imageView = _imageView;

#pragma mark HLSURLConnectionDelegate protocol implementation

- (void)connectionDidFinishLoading:(HLSURLConnection *)connection
{
    UIImage *image = [UIImage imageWithData:[connection data]];
    self.imageView.image = image;
}

- (void)connection:(HLSURLConnection *)connection didFailWithError:(NSError *)error
{
    // TODO: Customizable placeholder image
    self.imageView.image = nil;
}

@end

#pragma mark Swizzled method implementations

static void swizzled_UIImageView__willMoveToWindow_Imp(id self, SEL _cmd, UIWindow *window)
{
    // When removed from display, stop downloading if a connection object is attached to the image view
    if (! window) {
        HLSURLConnection *connection = objc_getAssociatedObject(self, s_connectionKey);
        [connection cancel];
    }
    
    (*s_UIImageView__willMoveToWindow_Imp)(self, _cmd, window);
}
