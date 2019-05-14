//
//  HSColorPickerBar.m
//  ColorPicker
//
//  Created by kylehankinson on 2018-07-17.
//  Copyright © 2018 kylehankinson. All rights reserved.
//

#import "HSColorPickerBar.h"
#import "HSColorPicker.h"
#import "HSCustomColorPicker.h"

@interface HSColorPickerBar()<HSColorPickerDelegate>
{
    NSMutableArray<HSColorPicker*>* colorPickers;
  
    HSColorPicker *customColorPicker; // This ivar is used to toggle the custom color picker on and off
}
@end

@implementation HSColorPickerBar

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self != nil)
    {
    }

    return self;
}

- (void) prepareForInterfaceBuilder
{
    [super prepareForInterfaceBuilder];
    [self initializeColorBar];
}

- (void) awakeFromNib
{
    [super awakeFromNib];

    [self initializeColorBar];
} // End of awakeFromNib

// Align pickers left (pass YES) of right (pass NO).
-(void)setColorPickersAlignmentLeft:(BOOL)alignLeft {
  // 1) Remove all color pickers from the current View
  [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
  
  // 2) Add all color pickers and their constraints, one by one
  if(alignLeft) {
    for(HSColorPicker *colorPicker in colorPickers) {
      [self addSubview: colorPicker];
      
      NSInteger index = [colorPickers indexOfObject:colorPicker];
      
      CGFloat offset = index * (self.bounds.size.height + self.padding);
      
      [colorPicker.heightAnchor constraintEqualToConstant: self.bounds.size.height].active = YES;
      [colorPicker.widthAnchor constraintEqualToConstant: self.bounds.size.height].active = YES;
      [colorPicker.centerYAnchor constraintEqualToAnchor: self.centerYAnchor].active = YES;
      //Working left anchor alignment (default)
      [colorPicker.leftAnchor constraintEqualToAnchor: self.leftAnchor constant: offset].active = YES;
    }
  } else {
    for (HSColorPicker *colorPicker  in [colorPickers reverseObjectEnumerator]) {
      
      [self addSubview: colorPicker];
      
      NSInteger index = [colorPickers indexOfObject:colorPicker];
      
      CGFloat offset = (colorPickers.count-index-1) * (self.bounds.size.height + self.padding);
      
      if(!self.allowsCustomColorSelection) {
        offset -= (self.bounds.size.height + self.padding);
      }
      
      [colorPicker.heightAnchor constraintEqualToConstant: self.bounds.size.height].active = YES;
      [colorPicker.widthAnchor constraintEqualToConstant: self.bounds.size.height].active = YES;
      [colorPicker.centerYAnchor constraintEqualToAnchor: self.centerYAnchor].active = YES;
      
      //Working right-anchor alignment
      [colorPicker.rightAnchor constraintEqualToAnchor: self.rightAnchor constant: -offset].active = YES;
    }
  }
  
  [self setNeedsLayout: YES];
  [self setNeedsDisplay: YES];
  
  _colorPickersAlignmentLeft = alignLeft;
}

- (void) initializeColorBar
{
    if(nil == colorPickers)
    {
        colorPickers = @[].mutableCopy;
    }
  
    // Adding all the "colors", from left to right
    [self initializeColorBarWithColor: self.color1];
    [self initializeColorBarWithColor: self.color2];
    [self initializeColorBarWithColor: self.color3];
    [self initializeColorBarWithColor: self.color4];
    [self initializeColorBarWithColor: self.color5];
    [self initializeColorBarWithColor: self.color6];
    [self initializeColorBarWithColor: self.color7];
    [self initializeColorBarWithColor: self.color8];
    [self initializeColorBarWithColor: self.color9];
    [self initializeColorBarWithColor: self.color10];
  
    [self initializeCustomColorBar]; // We add the custom color bar always, but show it or hide it based on the allowsCustomColorSelection property.
  
    // Forcefully calling the property setter to update initial state set in Interface Builder
    [self setAllowsCustomColorSelection:self.allowsCustomColorSelection];

    // Force alignment as per Interface Builder settings
    [self setColorPickersAlignmentLeft:self.colorPickersAlignmentLeft];

  
    [self setNeedsLayout: YES];
    [self setNeedsDisplay: YES];
}

- (void) initializeColorBarWithColor: (NSColor*) color
{
    if(nil == color)
    {
        return;
    } // End of no color ie not picked in interface

    HSColorPicker * colorPicker = [[HSColorPicker alloc] init];
    colorPicker.delegate = self;
    colorPicker.backgroundColor = color;

    colorPicker.translatesAutoresizingMaskIntoConstraints = false;

    // Add our color picker
    [colorPickers addObject: colorPicker];
}

- (void) initializeCustomColorBar
{
  HSCustomColorPicker * colorPicker = [[HSCustomColorPicker alloc] init];
  colorPicker.delegate = self;
  colorPicker.backgroundColor = nil; // By default we start with no selected color
  colorPicker.translatesAutoresizingMaskIntoConstraints = false;

  // Add our color picker
  [colorPickers addObject: colorPicker];
  
  customColorPicker = colorPicker;
}

- (NSColor*) selectedColor
{
    for(HSColorPicker * colorPicker in colorPickers)
    {
        if(colorPicker.isSelected)
        {
            return colorPicker.backgroundColor;
        }
    }
    
    return nil;
} // End of selectedColor

- (void) setSelectedColor: (NSColor*) selectedColor
{
    [self setSelectedColor: selectedColor
             withTolerance: 0.0f];
}

- (void) setSelectedColor: (NSColor*) selectedColor
            withTolerance: (CGFloat) tolerance
{
    // Default, clear selection.
    for(HSColorPicker * colorPicker in colorPickers)
    {
        colorPicker.isSelected = false;
    }

    // Clearing selection, no need to do anything else.
    if(nil == selectedColor)
    {
        return;
    } // End of no selected color

    BOOL didFind = false;
    for(HSColorPicker * colorPicker in colorPickers)
    {
        // Use a tolerance for
        BOOL isEqual = [self color: selectedColor
                    isEqualToColor: colorPicker.backgroundColor
                     withTolerance: tolerance];

        if(isEqual)
        {
            didFind = true;
            colorPicker.isSelected = true;
            break;
        }
    }

    if(!didFind && self.allowsCustomColorSelection)
    {
        customColorPicker.backgroundColor = selectedColor;
        customColorPicker.isSelected = true;
    } // End of did not find an item and we have a custom picker
}

// From: https://stackoverflow.com/a/21622229/127853
- (BOOL) color: (NSColor *) color1
isEqualToColor: (NSColor *) color2
 withTolerance: (CGFloat) tolerance
{
    CGFloat r1, g1, b1, a1, r2, g2, b2, a2;
    [color1 getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [color2 getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    return
    fabs(r1 - r2) <= tolerance &&
    fabs(g1 - g2) <= tolerance &&
    fabs(b1 - b2) <= tolerance &&
    fabs(a1 - a2) <= tolerance;
}

#pragma mark - HSColorPickerDelegate

- (void) colorPickerWasClicked: (HSColorPicker*) sender
{
    // Toggle the sender
    sender.isSelected = !sender.isSelected;
    
    if(self.delegate && [self.delegate respondsToSelector: @selector(colorPickerBar:selectedColorChanged:)])
    {
        NSColor * selectedColor = sender.backgroundColor;

        // Clear if we are not selected (aka we de-selected)
        if(!sender.isSelected)
        {
            selectedColor = nil;
        }
        
        [self.delegate colorPickerBar: self
                 selectedColorChanged: selectedColor];
    } // End of we have a delegate and the selection changed

    // Disable the others
    for(HSColorPicker * colorPicker in colorPickers)
    {
        if(colorPicker == sender)
        {
            continue;
        }
        
        colorPicker.isSelected = false;
    } // End of colorPicker enumeration
} // End of colorPicker selection changed

- (void)customColorPickerUpdateColor: (HSColorPicker*) sender
{
  if(self.delegate && [self.delegate respondsToSelector: @selector(colorPickerBar:selectedColorChanged:)])
  {
    NSColor * selectedColor = sender.backgroundColor;
    
    if([sender isSelected]) {
      [self.delegate colorPickerBar: self
             selectedColorChanged: selectedColor];
    }
  } // End of we have a delegate and the selection changed
}

-(void) setAllowsCustomColorSelection:(BOOL)allows {
  if(allows) {
    [customColorPicker setHidden:NO];
  } else {
    [customColorPicker setHidden:YES];
  }
  _allowsCustomColorSelection = allows;
  
  // forcing realignment of the pickers
  [self setColorPickersAlignmentLeft:_colorPickersAlignmentLeft];
}
@end
