//
//  HSColorPickerColorHelper.h
//  HSColorPickerBar
//
//  Created by Kyle Hankinson on 2019-05-14.
//  Copyright © 2019 Hankinsoft Development, Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HSColorPickerColorHelper : NSObject

+ (BOOL) isDark: (NSColor*) targetColor;
+ (NSColor *) darkerColor: (NSColor *) targetColor;
+ (NSColor *) lighterColor: (NSColor *) targetColor;

@end

NS_ASSUME_NONNULL_END
