//
//  UIWebView+HLSExtensions.h
//  CoconutKit
//
//  Created by Samuel Défago on 10.01.12.
//  Copyright (c) 2012 Hortis. All rights reserved.
//

@interface UIWebView (HLSExtensions)

/**
 * Make the web view background transparent
 */
- (void)makeBackgroundTransparent;

/**
 * If set to YES, remove the shadow seen behind the web view when it is scrolled to the top of the bottom.
 * Default value is NO
 */
@property (nonatomic, assign, getter=isShadowHidden) BOOL shadowHidden;

/**
 * If set to NO, disable scrolling in both directions
 * Default value is YES
 */
@property (nonatomic, assign, getter=isScrollEnabled) BOOL scrollEnabled;

@end
