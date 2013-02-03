//
//  PXSSLexer.h
//  PXEngine
//
// !WARNING!  Do not include this header file directly in your application. 
//            This file is not part of the public Pixate API and will likely change.
//
//  Created by Kevin Lindsey on 6/23/12.
//  Copyright (c) 2012 Pixate, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXLexeme.h"

/**
 *  The PXStylesheetLexerDelegate protocol defines a set of events that will fire during the lifetime of a
 *  PXStylesheetLexer
 */
@protocol PXStylesheetLexerDelegate <NSObject>

@optional

/**
 *  A method fired when the lexer pops the current source (and other state) when encountered the end of the current
 *  string it is processing
 */
- (void)lexerDidPopSource;

@end

/**
 *  PXStylesheetLexer is responsible for converting an NSString into a stream of PXLexemes. Eacn PXLexeme represents an
 *  instance of a CSS token.
 */
@interface PXStylesheetLexer : NSObject

/**
 *  The source string being tokenized by this lexer. Note that setting this value resets the lexer state
 */
@property (nonatomic, strong) NSString *source;

/**
 *  A delegate to call when various events occur within the lexer
 */
@property (nonatomic, strong) id<PXStylesheetLexerDelegate> delegate;

/**
 *  Initializer a new instance with the specified source value
 *
 *  @param source The source string to lex
 */
- (id)initWithString:(NSString *)source;

/**
 *  Return the next lexeme in the source string from where the last lex ended. This will return nil once the source
 *  string has been completed consumed.
 */
- (PXLexeme *)nextLexeme;

/**
 *  Push the specified lexeme onto internal stack. Lexemes will first be removed from this stack when calling
 *  nextLexeme. Once the stack has been depleted, lexing continues from the last successful scan not involving the
 *  lexeme stack.
 *
 *  @param lexeme The lexeme to push on to the stack
 */
- (void)pushLexeme:(PXLexeme *)lexeme;

/**
 *  This lexer returns different lexemes for the same source depending on if the lexer is inside or outside of a
 *  delcaration body. This method allows code to indicate that lexing should proceed as if the lexer is inside a block.
 *  This is typically used when processing styles that are associated directly with a styleable object as opposed to
 *  coming from a stylesheet.
 */
- (void)increaseNesting;

/**
 *  This is the complementary method to increaseNesting. This is used to indicate that a block has been completely
 *  lexed.
 */
- (void)decreaseNesting;

/**
 *  Save the current context of the lexer, re-initialize the lexer, and begin lexing the specified source. This is
 *  useful for handling "import" statements, where another file needs to be processed inline with the current file
 *  being processed
 *
 *  @param source The new source
 */
- (void)pushSource:(NSString *)source;

@end
