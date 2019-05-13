//
//  AppDelegate.m
//  TestColorPicker
//
//  Created by Yuri on 5/13/19.
//  Copyright © 2019 https://yuriydev.com, Inc. All rights reserved.
//

#import "AppDelegate.h"

#import "HSColorPickerBar/HSColorPickerBar.h"
@interface AppDelegate () <HSColorPickerBarDelegate>
@property (weak) IBOutlet HSColorPickerBar *colorPickerBar;

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  // Insert code here to initialize your application
  
  self.colorPickerBar.delegate = self;
  
}

- (void) colorPickerBar: (HSColorPickerBar*) colorPickerBar
   selectedColorChanged: (NSColor*) color {
  NSLog(@"Color picker clicked with color %@", color);
}

- (IBAction)toggleAlignment:(id)sender {
  self.colorPickerBar.colorPickersAlignmentLeft = !self.colorPickerBar.colorPickersAlignmentLeft;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
  // Insert code here to tear down your application
}

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {return YES;}

- (IBAction)toggleCustomColorPicker:(id)sender {
  self.colorPickerBar.allowsCustomColorSelection = !self.colorPickerBar.allowsCustomColorSelection;
}
@end
