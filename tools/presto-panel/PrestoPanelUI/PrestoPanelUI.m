//
//  PrestoPanelUI.m
//  JuspayPanel
//
//  Created by Sachin Sharma on 11/07/17.
//  Copyright © 2017 Juspay Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrestoPanelUI.h"
#import <CocoaScript/COScript.h>
#import "PrestoPanelUISketchPanelController.h"
@import JavaScriptCore;
#import <Mocha/Mocha.h>
#import <Mocha/MOClosure.h>
#import <Mocha/MOJavaScriptObject.h>
#import <Mocha/MochaRuntime_Private.h>

@interface PrestoPanelUI : NSObject
    
@property (nonatomic, strong) PrestoPanelUISketchPanelController *panelController;
@property (nonatomic, strong) id <PrestoPanelUIMSDocument> document;
@property (nonatomic, copy) NSString *panelControllerClassName;

+ (instancetype)onSelectionChanged:(id)context artboards:(NSArray *)artboards currentPage:(id)page;
+ (void)onContextChanged:(id)context;
- (void)onSelectionChange:(NSArray *)selection;
+ (void)setSharedCommand:(id)command;
@end



@implementation PrestoPanelUI
    
static id _command;
static NSArray *_artboards;
static id _page;
    
+ (void)setSharedCommand:(id)command {
    _command = command;
}
    
+ (id)sharedCommand {
    return _command;
}
    
- (void)context:(id)context{
    [_panelController selection:context];
}

+ (COScript*) saveContext: (id) context {
    COScript *coscript = [COScript currentCOScript];
    [coscript setShouldKeepAround:YES];
    [[Mocha sharedRuntime] setValue: coscript forKey: @"__script"];
    
    [[Mocha sharedRuntime] setValue:context forKey:@"__currentContext"];
    
    return coscript;
}

+ (instancetype)onSelectionChanged:(id)context artboards:(NSArray *)artboards currentPage:(id)page {
    COScript* coscript = [PrestoPanelUI saveContext: context];
    _artboards = artboards;
    _page = page;
    id <PrestoPanelUIMSDocument> document = [context valueForKeyPath:@"actionContext.document"];
    if ( ! [document isKindOfClass:NSClassFromString(@"MSDocument")]) {
        document = nil;  // be safe
        return nil;
    }
    
    if ( ! [self sharedCommand]) {
        [self setSharedCommand:[context valueForKeyPath:@"command"]]; // MSPluginCommand
    }
    
    NSString *key = [NSString stringWithFormat:@"%@-PrestoPanelUI", [document description]];
    __block PrestoPanelUI *instance = [[Mocha sharedRuntime] valueForKey:key];
    
    if ( ! instance) {
        [coscript setShouldKeepAround:YES];
        instance = [[self alloc] initWithDocument:document:context];
        [[Mocha sharedRuntime] setValue:instance forKey:key];
    }
    
    NSArray *selection = [context valueForKeyPath:@"actionContext.document.selectedLayers"];
    
    //    NSLog(@"selection %p %@ %@", instance, key, selection);
    [instance onSelectionChange:selection];
    return instance;
}
    
- (instancetype)initWithDocument:(id <PrestoPanelUIMSDocument>)document :(id) context {
    COScript* coscript = [COScript currentCOScript];
    [coscript callFunctionNamed: @"initProps" withArguments: @[context]];
    
    if (self = [super init]) {
        _document = document;
        _panelController = [[PrestoPanelUISketchPanelController alloc] initWithDocument:_document];
        
//        [NSEvent addGlobalMonitorForEventsMatchingMask:(NSFlagsChangedMask) handler:^(NSEvent *event){
//            
//            if ([event modifierFlags] & NSCommandKeyMask) {
//                NSString *character = [event charactersIgnoringModifiers];
//                if ([character isEqualToString:@"c"]) {
//                    NSLog(@"Capture Copy&Paste Key");
//                }
//            }
//        }];
    }
    return self;
}
    
- (void)onSelectionChange:(NSArray *)selection {
    [_panelController setArtboards:_artboards];
    [_panelController setCurrentPage: _page];
    [_panelController selectionDidChange:selection:_command];
}
    
@end
