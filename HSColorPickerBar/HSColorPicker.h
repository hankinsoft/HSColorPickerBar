//
//  HSColorPicker.h
//  ColorPicker
//
//  Created by kylehankinson on 2018-06-29.
//  Copyright © 2018 kylehankinson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class HSColorPicker;

@protocol HSColorPickerDelegate <NSObject>

- (void) colorPickerWasClicked: (HSColorPicker*) colorPicker;
- (void) customColorPickerUpdateColor: (HSColorPicker*) colorPicker;

@end

IB_DESIGNABLE
@interface HSColorPicker : NSView {
@protected
  BOOL            mouseOver;
}

@property(nonatomic,assign) BOOL isSelected;
@property(nonatomic,retain) IBInspectable NSColor * backgroundColor;
@property(nonatomic,weak)   IBOutlet id<HSColorPickerDelegate> delegate;

@end
