//
//  HSColorPickerColorHelper.m
//  HSColorPickerBar
//
//  Created by Kyle Hankinson on 2019-05-14.
//  Copyright © 2019 Hankinsoft Development, Inc. All rights reserved.
//

#import "HSColorPickerColorHelper.h"

@implementation HSColorPickerColorHelper

+ (BOOL) isDark: (NSColor*) targetColor
{
    size_t count = CGColorGetNumberOfComponents(targetColor.CGColor);
    const CGFloat *componentColors = CGColorGetComponents(targetColor.CGColor);

    CGFloat darknessScore = 0;
    if (count == 2)
    {
        darknessScore = (((componentColors[0]*255) * 299) + ((componentColors[0]*255) * 587) + ((componentColors[0]*255) * 114)) / 1000;
    }
    else if (count == 4)
    {
        darknessScore = (((componentColors[0]*255) * 299) + ((componentColors[1]*255) * 587) + ((componentColors[2]*255) * 114)) / 1000;
    }
    
    if (darknessScore >= 125) {
        return NO;
    }
    
    return YES;
} // End of isDark:

+ (NSColor *) darkerColor: (NSColor*) targetColor
{
    CGFloat h, s, b, a;
    
    NSColor *outColor = nil;
    @try
    {
        NSColor * tempColor = [targetColor colorUsingColorSpace: [NSColorSpace sRGBColorSpace]];
        [tempColor getHue:&h saturation:&s brightness:&b alpha:&a];
        
        outColor = [NSColor colorWithHue:h
                              saturation:s
                              brightness:b * 0.75
                                   alpha:a];
        
    }
    @catch (NSException *exception)
    {
        outColor = [NSColor darkGrayColor];
    }
    
    return outColor;
}

+ (NSColor *) lighterColor: (NSColor*) targetColor
{
    CGFloat h, s, b, a;
    NSColor *outColor = nil;
    
    @try
    {
        NSColor * tempColor = [targetColor colorUsingColorSpace: [NSColorSpace sRGBColorSpace]];

        [tempColor getHue:&h saturation:&s brightness:&b alpha:&a];
        
        
        outColor = [NSColor colorWithHue:h
                              saturation:s
                              brightness:MIN(b * 1.3, 1.0)
                                   alpha:a];
    }
    @catch(NSException *colorException)
    {
        outColor = [NSColor lightGrayColor];
    }
    return outColor;
}

@end
