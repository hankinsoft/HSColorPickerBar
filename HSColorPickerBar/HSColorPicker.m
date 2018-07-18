//
//  HSColorPicker.m
//  ColorPicker
//
//  Created by kylehankinson on 2018-06-29.
//  Copyright © 2018 kylehankinson. All rights reserved.
//

#import "HSColorPicker.h"


@implementation NSColor (DarkLight)

- (NSColor *) lighterColor
{
    CGFloat h, s, b, a;
    
    [self getHue:&h saturation:&s brightness:&b alpha:&a];
    
    return [NSColor colorWithHue:h
                      saturation:s
                      brightness:MIN(b * 1.3, 1.0)
                           alpha:a];
}

- (NSColor *) darkerColor
{
    CGFloat h, s, b, a;
    
    [self getHue:&h saturation:&s brightness:&b alpha:&a];
    
    return [NSColor colorWithHue:h
                      saturation:s
                      brightness:b * 0.75
                           alpha:a];
}

@end

@implementation HSColorPicker
{
    NSTrackingArea  * trackingArea;
    BOOL            mouseOver;
} // End of HSColorPicker

//Add this to Your imageView subclass

- (void) mouseEntered: (NSEvent *) theEvent
{
    mouseOver = true;
    [self setNeedsDisplay: true];
}

- (void) mouseExited: (NSEvent *) theEvent
{
    mouseOver = false;
    [self setNeedsDisplay: true];
}

- (void) updateTrackingAreas
{
    [super updateTrackingAreas];

    if(trackingArea != nil)
    {
        [self removeTrackingArea: trackingArea];
    }
    
    int opts = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways);
    trackingArea = [ [NSTrackingArea alloc] initWithRect:[self bounds]
                                                 options:opts
                                                   owner:self
                                                userInfo:nil];
    [self addTrackingArea: trackingArea];
} // End of updateTrackingArea

- (void) setIsSelected: (BOOL) isSelected
{
    _isSelected = isSelected;
    [self setNeedsDisplay: YES];
} // End of setIsSelected:

- (void) mouseUp: (NSEvent *) theEvent
{
    if ([theEvent clickCount] == 1)
    {
        if(self.delegate && [self.delegate respondsToSelector: @selector(colorPickerWasClicked:)])
        {
            [self.delegate colorPickerWasClicked: self];
        } // End of we respond to the selector
    } // End of single clicked
} // End of mouseUp:

- (void) drawRect: (NSRect) dirtyRect
{
    // Get the graphics context that we are currently executing under
    NSGraphicsContext* gc = [NSGraphicsContext currentContext];

    // Save the current graphics context settings
    [gc saveGraphicsState];
/*
    [[NSColor blackColor] setFill];
    NSRectFill(dirtyRect);
*/
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
    else if(mouseOver)
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
    [[self.backgroundColor darkerColor] setStroke];
    [self.backgroundColor setFill];

    // Create our circle path
    CGFloat size = self.bounds.size.width - 8;
    CGFloat offset = (self.bounds.size.width / 2) - (size / 2);

    NSRect rect = NSMakeRect(offset, offset, size, size);
    NSBezierPath* circlePath = [NSBezierPath bezierPath];
    [circlePath appendBezierPathWithOvalInRect: rect];
    
    // Outline and fill the path
    [circlePath setLineWidth: 2.0f];
    [circlePath stroke];
    [circlePath fill];
    
    // Restore the context to what it was before we messed with it
    [gc restoreGraphicsState];
}

@end
