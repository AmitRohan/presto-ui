//
//  PrestoPanelUISketchPanelCellDefault.h
//  PrestoPanel
//
//  Created by Sachin Sharma on 11/07/17.
//  Copyright © 2017 Juspay Technologies. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PrestoPanelUISketchPanelCellDefault.h"

@interface PrestoPanelUISketchPanelCellAlignment : PrestoPanelUISketchPanelCellDefault

@property (strong) IBOutlet NSView *topBackgroundView;

@property (strong) IBOutlet NSButton* leftAlign;
@property (strong) IBOutlet NSButton* topAlign;
@property (strong) IBOutlet NSButton* rightAlign;
@property (strong) IBOutlet NSButton* bottomAlign;
@property (strong) IBOutlet NSButton* centerVerticalAlign;
@property (strong) IBOutlet NSButton* centerHorizontalAlign;
@property (strong) IBOutlet NSButton *center;
@property (strong) IBOutlet NSButton *width;
@property (strong) IBOutlet NSButton *height;

- (void) clicked: (id) sender;

@end
