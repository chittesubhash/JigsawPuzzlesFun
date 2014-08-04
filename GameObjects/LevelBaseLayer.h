#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Piece.h"
#import "LevelSelectionLayer.h"

#import <Social/Social.h>
#import <Accounts/ACAccountType.h>
#import <Accounts/ACAccountCredential.h>

#import <MessageUI/MessageUI.h>

@interface LevelBaseLayer : CCLayer <MFMailComposeViewControllerDelegate> {
    CGSize screenSize;
    NSMutableArray* pieces;
    Piece* selectedPiece;
    int zIndex;
    int totalPieceFixed;
    CCSprite* puzzleImage;
    CCSpriteFrameCache* sceneSpriteBatchNode;
    CCSpriteFrameCache* piecesSpriteBatchNode;
    CCSpriteFrameCache* bevelSpriteBatchNode;
    
    UISwitch *switchControl;
    UILabel *hintLabel;
    
    UIView *topView;
    UIButton *playNext;
    UIButton *homePageBtn;
    UILabel *congratsLabel;
    
    CCMenuItemSprite *backButton;
    
    CCSprite *congrats;
    
    SimpleAudioEngine *bgSoundEngine;

    int currentTime;
    BOOL isGameOver;
    
    NSString *imageName;
    
    BOOL zoomPerformed;
}
-(void) enableTouch:(ccTime)dt;
-(BOOL) isPieceInRightPlace:(Piece*)piece;
-(BOOL) isPuzzleComplete;
-(Piece*) selectPieceForTouch:(CGPoint)touchLocation;
-(void) movePieceToFinalPosition:(Piece*)piece;
-(void) loadLevelSprites:(NSString*)dimension;

-(void) removeAllPieces;
-(void) loadPieces:(NSString*)level withCols:(int)cols andRols:(int)rows;
-(float) getDeltaX:(int)hAlign withIndex:(int)index andPieceWidth:(float)pieceWidth andCols:(int)cols andRows:(int)rows;
-(float) getDeltaY:(int)vAlign withIndex:(int)index andPieceHeight:(float)pieceHeight andCols:(int)cols andRows:(int)rows;
-(void) loadPuzzleImage:(NSString*)name;
-(void) resetScreen;
@end
