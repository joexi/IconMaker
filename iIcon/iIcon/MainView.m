//
//  MainView.m
//  iIcon
//
//  Created by Joe on 14-4-30.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "MainView.h"

@implementation MainView
- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        
        [self registerForDraggedTypes:@[NSFilenamesPboardType]];
//        imgView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, 150, 150)];
//        [self addSubview:imgView];
    }
    return self;
}

- (NSImage *)imageResize:(NSImage*)anImage
                 newSize:(NSSize)newSize
{
    NSImage *sourceImage = anImage;
    [sourceImage setScalesWhenResized:YES];
    
    // Report an error if the source isn't a valid image
    if (![sourceImage isValid])
    {
        NSLog(@"Invalid Image");
    }
    else
    {
        NSImage *smallImage = [[NSImage alloc] initWithSize: newSize];
        [smallImage lockFocus];
        [sourceImage setSize: newSize];
        [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
        [sourceImage compositeToPoint:NSZeroPoint operation:NSCompositeCopy];
        [smallImage unlockFocus];
        return smallImage;
    }
    return nil;
}
         
- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
     NSLog(@"11111");
	NSPasteboard *pboard;
	NSDragOperation sourceDragMask;
	sourceDragMask = [sender draggingSourceOperationMask];
	pboard = [sender draggingPasteboard];
	return NSDragOperationLink;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
     NSLog(@"11111");
	NSPasteboard *pboard = [sender draggingPasteboard];
	if ([sender draggingSource] != self) {
		if ([[pboard types] containsObject:NSFilenamesPboardType]) {
			NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
			NSString *filePath = [files objectAtIndex:0];
            NSString *dirPath = [self getDirPath:filePath];
            NSString *fileName = [[[filePath lastPathComponent] componentsSeparatedByString:@"."] objectAtIndex:0];
            dirPath = [dirPath stringByAppendingPathComponent:fileName];
            NSImage *img = [[NSImage alloc] initWithContentsOfFile:filePath];
//            imgView.image = img;
            NSLog(@"%@",dirPath);
            
            if (img) {
                if([[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:nil])
                {
                    [[NSFileManager defaultManager] removeItemAtPath:dirPath error:nil];
                }
                BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:nil];
                NSLog(@"%d",success);
                NSArray *sizeList = @[
                                      [NSValue valueWithRect:NSMakeRect(0, 0, 29, 29)],
                                      [NSValue valueWithRect:NSMakeRect(0, 0, 40, 40)],
                                      [NSValue valueWithRect:NSMakeRect(0, 0, 57, 57)],
                                      [NSValue valueWithRect:NSMakeRect(0, 0, 60, 60)],
                                      [NSValue valueWithRect:NSMakeRect(0, 0, 50, 50)],
                                      [NSValue valueWithRect:NSMakeRect(0, 0, 72, 72)],
                                      [NSValue valueWithRect:NSMakeRect(0, 0, 76, 76)]];
                for (NSValue *rect in sizeList) {
                    NSRect r = [rect rectValue];
                    NSString *fName = [NSString stringWithFormat:@"%@_%dx%d.png",fileName,(int)r.size.width,(int)r.size.height];
                    NSImage *image = [self imageResize:img newSize:r.size];
                    
                    NSData *imageData = [image TIFFRepresentation];
                    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
                    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
                    imageData = [imageRep representationUsingType:NSJPEGFileType properties:imageProps];
                    [imageData writeToFile:[dirPath stringByAppendingPathComponent:fName] atomically: NO];
                }
            }
		}
	}
	return YES;
}

- (NSString *)getDirPath:(NSString *)fullPath
{
    NSMutableArray *ary = [NSMutableArray arrayWithArray:[fullPath pathComponents]];
    [ary removeLastObject];
    NSString *dirPath = [ary componentsJoinedByString:@"/"];
    dirPath = [dirPath stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    return dirPath;
}
@end
