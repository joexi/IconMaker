//
//  AppDelegate.m
//  iIcon
//
//  Created by Joe on 14-4-30.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "AppDelegate.h"
#import "MainView.h"
@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSWindow *window = [self window];
    
    NSScreen *screen = [NSScreen mainScreen];
    NSRect appRect = NSMakeRect(screen.visibleFrame.size.width/2 - 300/2,
                                screen.visibleFrame.size.height/2 - 300/2,
                                300,
                                300);
    [window setFrame:appRect display:YES animate:YES];
    NSView *contentView = (NSView *)window.contentView;
    
    MainView *mainView = [[MainView alloc] initWithFrame:NSMakeRect(0, 0, appRect.size.width, appRect.size.height)];
    [contentView addSubview:mainView];
    // Insert code here to initialize your application
}


@end
