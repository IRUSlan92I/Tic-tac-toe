//
//  RIAppDelegate.h
//  Tic-Tac-Toe
//
//  Created by RUSlan on 23.03.14.
//  Copyright (c) 2014 RUSlan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RIAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;


- (IBAction)NewGame:(id)sender;

- (IBAction)ClickMatrix:(id)sender;

- (IBAction)Checking;

- (IBAction)CheckingDraw;

- (IBAction)FirstMoveChange:(id)sender;

- (IBAction)StatsUpdate:(id)sender;

@property (weak) IBOutlet NSMatrix *Buttons;
@property (weak) IBOutlet NSTextField *Text;
@property (weak) IBOutlet NSMatrix *Stats;
@property (weak) IBOutlet NSButton *FirstMoveMenu;
@property (weak) IBOutlet NSComboBox *ButtonChangeFirstMove;

bool cellEq(id array, int firstRow, int firstColumn, int secondRow, int secondColumn);

void computerMv(id array, id Text);

void changeXO();


@end
