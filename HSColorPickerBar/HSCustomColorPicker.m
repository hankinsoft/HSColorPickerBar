//
//  HSCustomColorPicker.m
//  HSColorPickerBar
//
//  Created by Mike on 5/11/19.
//  Copyright © 2019 Hankinsoft Development, Inc. All rights reserved.
//

#import "HSCustomColorPicker.h"

@implementation HSCustomColorPicker

- (void) drawRect: (NSRect) dirtyRect
{
  if(self.backgroundColor) {
    // Drawing a regular solid filled circle, as an HSColorPicker would do
    [super drawRect:dirtyRect];
  } else {
    // The custom color is not specified. Drawing the "wheel.png" image instead
    
    // Get the graphics context that we are currently executing under
    NSGraphicsContext* gc = [NSGraphicsContext currentContext];
    
    // Save the current graphics context settings
    [gc saveGraphicsState];

    NSRect highlightRect = NSMakeRect(1, 1, self.bounds.size.width - 2, self.bounds.size.height - 2);
    NSBezierPath* highlightPath = [NSBezierPath bezierPath];
    [highlightPath appendBezierPathWithOvalInRect: highlightRect];
    
    if(self.isSelected)
    {
      // Outline and fill the path
      [[NSColor colorWithRed: 200.0f / 255.0f
                       green: 200.0f / 255.0f
                        blue: 200.0f / 255.0f
                       alpha: 0.5] setFill];
      
      [[NSColor darkGrayColor] setStroke];
      [highlightPath setLineWidth: 1.0f];
      [highlightPath stroke];
      [highlightPath fill];
    } // End of isSelected
    else if(self->mouseOver)
    {
      // Outline and fill the path
      [[NSColor colorWithRed: 243.0f / 255.0f
                       green: 243.0f / 255.0f
                        blue: 243.0f / 255.0f
                       alpha: 1] setFill];
      
      [[NSColor darkGrayColor] setStroke];
      [highlightPath setLineWidth: 1.0f];
      [highlightPath stroke];
      [highlightPath fill];
    } // End of mouseOver
    
    // Set the color in the current graphics context for future draw operations
    [[NSColor lightGrayColor] setStroke];
    
    // Create our circle path
    CGFloat size = self.bounds.size.width - 8;
    CGFloat offset = (self.bounds.size.width / 2) - (size / 2);
    
    NSRect rect = NSMakeRect(offset, offset, size, size);
    NSBezierPath* circlePath = [NSBezierPath bezierPath];
    [circlePath appendBezierPathWithOvalInRect: rect];
    
    // Outline and fill the path
    [circlePath setLineWidth: 2.0f];
    [circlePath stroke];
    
    NSImage *wheelImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForImageResource:@"wheel.png"]];
    [wheelImage drawInRect:rect];
    
    // Restore the context to what it was before we messed with it
    [gc restoreGraphicsState];
  }
}

- (void) mouseUp: (NSEvent *) theEvent
{
  if ([theEvent clickCount] == 1)
  {
    NSColorPanel *colorPanel = [NSColorPanel sharedColorPanel];
    [colorPanel orderFront:nil];
    [colorPanel setTarget:self];
    [colorPanel setAction:@selector(colorPanelColorSelected:)];
    
    if(self.delegate && [self.delegate respondsToSelector: @selector(colorPickerWasClicked:)])
    {
      [self.delegate colorPickerWasClicked: self];
    } // End of we respond to the selector
  } // End of single clicked
} // End of mouseUp:

-(void)colorPanelColorSelected:(NSColorPanel*)colorPanel
{
  NSColor *newCustomColor = colorPanel.color;
  //NSLog(@"Yuri color: %@", newCustomColor);
  self.backgroundColor = newCustomColor;
  [self setNeedsDisplay:YES];
  
  if(self.delegate && [self.delegate respondsToSelector: @selector(colorPickerWasClicked:)])
  {
    [self.delegate customColorPickerUpdateColor: self];
  } // End of we respond to the selector

}

@end
