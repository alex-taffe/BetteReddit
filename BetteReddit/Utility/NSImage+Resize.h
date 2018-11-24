//
//  NSImage+Resize.h
//  BetteReddit
//
//  Created by Alex Taffe on 11/24/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

@import AppKit;

NS_ASSUME_NONNULL_BEGIN

@interface NSImage (Resize)

+ (NSImage *)resizedImage:(NSImage *)sourceImage toPixelDimensions:(NSSize)newSize;

@end

NS_ASSUME_NONNULL_END
