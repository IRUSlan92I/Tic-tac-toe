//
//  RIAppDelegate.m
//  Tic-Tac-Toe
//
//  Created by RUSlan on 23.03.14.
//  Copyright (c) 2014 RUSlan. All rights reserved.
//

#import "RIAppDelegate.h"


NSString *playerMove;
NSString *computerMove;
NSString *player1Move;
NSString *player2Move;

bool gameWasEnded;
bool computerPlaysFirst;
bool firstPlayerMove;
bool twoPlayerMode;

NSInteger wins;
NSInteger loses;
NSInteger draws;
NSInteger player1Wins;
NSInteger player2Wins;
NSInteger dualDraws;


@implementation RIAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    playerMove = [NSString new];
    computerMove = [NSString new];
    player1Move = [NSString new];
    player2Move = [NSString new];
    
    player1Move = @"X";
    player2Move = @"O";
    
    
    gameWasEnded = false;
    
    wins = 0;
    loses = 0;
    draws = 0;
    player1Wins = 0;
    player2Wins = 0;
    dualDraws = 0;
    
    [_ButtonChangeFirstMove selectItemAtIndex: 0];
    [self FirstMoveChange: NULL];
    
    [self NewGame: NULL];
}

- (IBAction)NewGame:(id)sender {
    [_Text setStringValue: @"New Game"];
    
    firstPlayerMove = true;
    
    [_ButtonChangeFirstMove setEnabled: true];
    
    [self StatsUpdate: NULL];
    gameWasEnded = false;
    
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            [[_Buttons cellAtRow: i column: j] setTitle: @""];
        }
    }
    if (computerPlaysFirst) {
        computerMv(_Buttons, _Text);
    }
}

- (IBAction)ClickMatrix:(id)sender {
    
    if (gameWasEnded) {
        [self NewGame: NULL];
    }
    else {
        [_Text setStringValue: @""];
        
        [_ButtonChangeFirstMove setEnabled: false];
        
        if ([[[sender selectedCell] title] compare: @""]) {
            [_Text setStringValue: @"Illegal move!"];
        }
        else {
            [self Checking];
            if (!gameWasEnded) {
                [self CheckingDraw];
            }
            if (twoPlayerMode) {
                [[sender selectedCell] setTitle: (firstPlayerMove) ? player1Move : player2Move];
                [self Checking];
                if (!gameWasEnded) {
                    [self CheckingDraw];
                }
                firstPlayerMove = !firstPlayerMove;
            }
            else {
                [[sender selectedCell] setTitle: playerMove];
                [self Checking];
                if (!gameWasEnded) {
                    [self CheckingDraw];
                }
                if (!gameWasEnded) {
                    computerMv(sender, _Text);
                    [self Checking];
                    if (!gameWasEnded) {
                        [self CheckingDraw];
                    }
                }
            }
        }
    }
}

- (IBAction)Checking {
    if ( (cellEq(_Buttons, 0, 0, 1, 1) && cellEq(_Buttons, 0, 0, 2, 2)) ||
        (cellEq(_Buttons, 0, 2, 1, 1) && cellEq(_Buttons, 0, 2, 2, 0)) ) {
        if (twoPlayerMode) {
            if ([[_Buttons cellAtRow: 1 column: 1] title] == player1Move) {
                [_Text setStringValue: @"Player 1 won!"];
                player1Wins++;
            }
            else {
                [_Text setStringValue: @"Player 2 won!"];
                player2Wins++;
            }
        }
        else {
            if ([[_Buttons cellAtRow: 1 column: 1] title] == playerMove) {
                [_Text setStringValue: @"Player won!"];
                wins++;
            }
            else {
                [_Text setStringValue: @"Computer won!"];
                loses++;
            }
        }
        gameWasEnded = true;
    }
    for (int i = 0; i < 3; i++) {
        if ( cellEq(_Buttons, 0, i, 1, i) && cellEq(_Buttons, 0, i, 2, i) ) {
            if (twoPlayerMode) {
                if ([[_Buttons cellAtRow: 0 column: i] title] == player1Move) {
                    [_Text setStringValue: @"Player 1 won!"];
                    player1Wins++;
                }
                else {
                    [_Text setStringValue: @"Player 2 won!"];
                    player2Wins++;
                }
            }
            else {
                if ([[_Buttons cellAtRow: 0 column: i] title] == playerMove) {
                    [_Text setStringValue: @"Player won!"];
                    wins++;
                }
                else {
                    [_Text setStringValue: @"Computer won!"];
                    loses++;
                }

            }
            gameWasEnded = true;
            break;
        }
        if ( cellEq(_Buttons, i, 0, i, 1) && cellEq(_Buttons, i, 0, i, 2) ) {
            if (twoPlayerMode) {
                if ([[_Buttons cellAtRow: i column: 0] title] == player1Move) {
                    [_Text setStringValue: @"Player 1 won!"];
                    player1Wins++;
                }
                else {
                    [_Text setStringValue: @"Player 2 won!"];
                    player2Wins++;
                }
            }
            else {
                if ([[_Buttons cellAtRow: i column: 0] title] == playerMove) {
                    [_Text setStringValue: @"Player won!"];
                    wins++;
                }
                else {
                    [_Text setStringValue: @"Computer won!"];
                    loses++;
                }
            }
            gameWasEnded = true;
            break;
        }
    }
}

- (IBAction)CheckingDraw {
    bool full = true;
    
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            full = full && ![[[_Buttons cellAtRow: i column: j] title]  isEqual: @""];
        }
    }
    
    if (full) {
        [_Text setStringValue: @"Draw!"];
        gameWasEnded = true;
        if (twoPlayerMode) {
            dualDraws++;
        }
        else {
            draws++;
        }
    }
}

- (IBAction)FirstMoveChange:(id)sender {
    
    switch ([_ButtonChangeFirstMove indexOfSelectedItem]) {
        case 0:
            computerPlaysFirst = false;
            twoPlayerMode = false;
            break;
        case 1:
            computerPlaysFirst = true;
            twoPlayerMode = false;
            break;
        case 2:
            computerPlaysFirst = false;
            twoPlayerMode = true;
            firstPlayerMove = true;
            break;
    }
    changeXO();
    
    [self NewGame: NULL];
    [self StatsUpdate: NULL];
}

- (IBAction)StatsUpdate:(id)sender {
    NSInteger percentW;
    NSInteger percentL;
    NSInteger games;
    if (twoPlayerMode) {
        games = wins + loses + draws;
        
        if (games) {
            percentW = round( ((double)wins)/(games) * 100 );
            percentL = round( ((double)loses)/(games) * 100 );
        }
        else {
            percentW = 0;
            percentL = 0;
        }
        [[_Stats cellAtRow: 0 column: 0] setStringValue: @"P1 wins:"];
        [[_Stats cellAtRow: 1 column: 0] setStringValue: @"P2 wins:"];
        [[_Stats cellAtRow: 2 column: 0] setStringValue: @"Draws:"];
        [[_Stats cellAtRow: 3 column: 0] setStringValue: @"P1 Win rate:"];
        [[_Stats cellAtRow: 4 column: 0] setStringValue: @"P2 Win rate:"];
        
        [[_Stats cellAtRow: 0 column: 1] setIntegerValue: player1Wins];
        [[_Stats cellAtRow: 1 column: 1] setIntegerValue: player2Wins];
        [[_Stats cellAtRow: 2 column: 1] setIntegerValue: dualDraws];
        [[_Stats cellAtRow: 3 column: 1] setStringValue:
         [NSString stringWithFormat: @"%ld%c", (long)percentW, '%']];
        [[_Stats cellAtRow: 4 column: 1] setStringValue:
         [NSString stringWithFormat: @"%ld%c", (long)percentL, '%']];
    }
    else {
        games = wins + loses + draws;
        
        if (games) {
            percentW = round( ((double)wins)/(games) * 100 );
            percentL = round( ((double)loses)/(games) * 100 );
        }
        else {
            percentW = 0;
            percentL = 0;
        }
        [[_Stats cellAtRow: 0 column: 0] setStringValue: @"Wins:"];
        [[_Stats cellAtRow: 1 column: 0] setStringValue: @"Loses:"];
        [[_Stats cellAtRow: 2 column: 0] setStringValue: @"Draws:"];
        [[_Stats cellAtRow: 3 column: 0] setStringValue: @"Win rate:"];
        [[_Stats cellAtRow: 4 column: 0] setStringValue: @"Lose rate:"];
        
        
        [[_Stats cellAtRow: 0 column: 1] setIntegerValue: wins];
        [[_Stats cellAtRow: 1 column: 1] setIntegerValue: loses];
        [[_Stats cellAtRow: 2 column: 1] setIntegerValue: draws];
        [[_Stats cellAtRow: 3 column: 1] setStringValue:
         [NSString stringWithFormat: @"%ld%c", (long)percentW, '%']];
        [[_Stats cellAtRow: 4 column: 1] setStringValue:
         [NSString stringWithFormat: @"%ld%c", (long)percentL, '%']];
    }
}


bool cellEq(id array, int firstRow, int firstColumn, int secondRow, int secondColumn) {
    
    if (![[[array cellAtRow: firstRow column: firstColumn] title]  isEqual: @""]) {
        if ([[array cellAtRow: firstRow column: firstColumn] title] ==
            [[array cellAtRow: secondRow column: secondColumn] title]) {
            return true;
        }
        else {
            return false;
        }
    }
    else {
        return false;
    }
}

void computerMv(id array, id Text) {
    
    id cellC = NULL;
    id cellP = NULL;
    
    for (int i = 0; i < 3; i++) {
        if ((cellEq(array, i, 0, i, 1)) &&
            ([[[array cellAtRow: i column: 2] title] isEqual: @""]))
        {
            if ([[[array cellAtRow: i column: 0] title] isEqual: computerMove]) {
                cellC = [array cellAtRow: i column: 2];
            }
            else  {
                cellP = [array cellAtRow: i column: 2];
            }
            break;
        }
        else if ((cellEq(array, i, 0, i, 2)) &&
                 ([[[array cellAtRow: i column: 1] title] isEqual: @""]))
        {
            if (([[[array cellAtRow: i column: 0] title] isEqual: computerMove])) {
                cellC = [array cellAtRow: i column: 1];
            }
            else  {
                cellP = [array cellAtRow: i column: 1];
            }
            break;
        }
        else if ((cellEq(array, i, 2, i, 1)) &&
                 ([[[array cellAtRow: i column: 0] title] isEqual: @""]))
        {
            if ([[[array cellAtRow: i column: 1] title] isEqual: computerMove]) {
                cellC = [array cellAtRow: i column: 0];
            }
            else  {
                cellP = [array cellAtRow: i column: 0];
            }
            break;
        }
    }
    for (int i = 0; i < 3; i++) {
        if ((cellEq(array, 0, i, 1, i)) &&
            ([[[array cellAtRow: 2 column: i] title] isEqual: @""]))
        {
            if ([[[array cellAtRow: 0 column: i] title] isEqual: computerMove]) {
                cellC = [array cellAtRow: 2 column: i];
            }
            else {
                cellP = [array cellAtRow: 2 column: i];
            }
            break;
        }
        else if ((cellEq(array, 0, i, 2, i)) &&
                 ([[[array cellAtRow: 1 column: i] title] isEqual: @""]))
        {
            if ([[[array cellAtRow: 0 column: i] title] isEqual: computerMove]) {
                cellC = [array cellAtRow: 1 column: i];
            }
            else {
                cellP = [array cellAtRow: 1 column: i];
            }
            break;
        }
        else if ((cellEq(array, 2, i, 1, i)) &&
                 ([[[array cellAtRow: 0 column: i] title] isEqual: @""]))
        {
            if ([[[array cellAtRow: 2 column: i] title] isEqual: computerMove]) {
                cellC = [array cellAtRow: 0 column: i];
            }
            else {
                cellP = [array cellAtRow: 0 column: i];
            }
            break;
        }
    }

    if ((cellEq(array, 0, 0, 1, 1)) &&
        ([[[array cellAtRow: 2 column: 2] title] isEqual: @""]))
    {
        if ([[[array cellAtRow: 0 column: 0] title] isEqual: computerMove]) {
            cellC = [array cellAtRow: 2 column: 2];
        }
        else {
            cellP = [array cellAtRow: 2 column: 2];
        }
    }
    else if ((cellEq(array, 0, 0, 2, 2)) &&
             ([[[array cellAtRow: 1 column: 1] title] isEqual: @""]))
    {
        if ([[[array cellAtRow: 0 column: 0] title] isEqual: computerMove]) {
            cellC = [array cellAtRow: 1 column: 1];
        }
        else {
            cellP = [array cellAtRow: 1 column: 1];
        }
    }
    else if ((cellEq(array, 2, 2, 1, 1)) &&
             ([[[array cellAtRow: 0 column: 0] title] isEqual: @""]))
    {
        if ([[[array cellAtRow: 2 column: 2] title] isEqual: computerMove]) {
            cellC = [array cellAtRow: 0 column: 0];
        }
        else {
            cellP = [array cellAtRow: 0 column: 0];
        }
    }
    else if ((cellEq(array, 0, 2, 1, 1)) &&
             ([[[array cellAtRow: 2 column: 0] title] isEqual: @""]))
    {
        if ([[[array cellAtRow: 0 column: 2] title] isEqual: computerMove]) {
            cellC = [array cellAtRow: 2 column: 0];
        }
        else {
            cellP = [array cellAtRow: 2 column: 0];
        }
    }
    else if ((cellEq(array, 2, 0, 0, 2)) &&
             ([[[array cellAtRow: 1 column: 1] title] isEqual: @""]))
    {
        if ([[[array cellAtRow: 0 column: 2] title] isEqual: computerMove]) {
            cellC = [array cellAtRow: 1 column: 1];
        }
        else {
            cellP = [array cellAtRow: 1 column: 1];
        }
    }
    else if ((cellEq(array, 2, 0, 1, 1)) &&
             ([[[array cellAtRow: 0 column: 2] title] isEqual: @""]))
    {
        if ([[[array cellAtRow: 1 column: 1] title] isEqual: computerMove]) {
            cellC = [array cellAtRow: 0 column: 2];
        }
        else {
            cellP = [array cellAtRow: 0 column: 2];
        }
    }
    
    if (cellC) {
        [cellC setTitle: computerMove];
    }
    else if (cellP) {
        [cellP setTitle: computerMove];
    }
    else {
        while (true) {
            int i = random() % 3;
            int j = random() % 3;
            
            if ([[[array cellAtRow: i column: j] title] isEqualToString: @""]) {
                [[array cellAtRow: i column: j] setTitle: computerMove];
                return;
            }
        }
    }
}


void changeXO()
{
    playerMove = (computerPlaysFirst) ? @"O" : @"X";
    computerMove = (computerPlaysFirst) ? @"X" : @"O";
}

@end

