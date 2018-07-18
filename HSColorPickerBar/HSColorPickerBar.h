//
//  HSColorPickerBar.h
//  HSColorPickerBar
//
//  Created by kylehankinson on 2018-07-18.
//  Copyright © 2018 Hankinsoft Development, Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//! Project version number for HSColorPickerBar.
FOUNDATION_EXPORT double HSColorPickerBarVersionNumber;

//! Project version string for HSColorPickerBar.
FOUNDATION_EXPORT const unsigned char HSColorPickerBarVersionString[];

#import <Cocoa/Cocoa.h>

@class HSColorPickerBar;

@protocol HSColorPickerBarDelegate <NSObject>

- (void) colorPickerBar: (HSColorPickerBar*) colorPickerBar
   selectedColorChanged: (NSColor*) color;

@end

IB_DESIGNABLE
@interface HSColorPickerBar : NSView

- (NSColor*) selectedColor;

@property(nonatomic,assign) IBInspectable CGFloat padding;

@property(nonatomic,retain) IBInspectable NSColor* color1;
@property(nonatomic,retain) IBInspectable NSColor* color2;
@property(nonatomic,retain) IBInspectable NSColor* color3;
@property(nonatomic,retain) IBInspectable NSColor* color4;
@property(nonatomic,retain) IBInspectable NSColor* color5;
@property(nonatomic,retain) IBInspectable NSColor* color6;
@property(nonatomic,retain) IBInspectable NSColor* color7;
@property(nonatomic,retain) IBInspectable NSColor* color8;
@property(nonatomic,retain) IBInspectable NSColor* color9;
@property(nonatomic,retain) IBInspectable NSColor* color10;

@property(nonatomic,weak) IBInspectable id<HSColorPickerBarDelegate> delegate;

@end
