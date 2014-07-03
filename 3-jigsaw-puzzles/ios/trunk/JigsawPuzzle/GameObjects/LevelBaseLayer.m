#import "LevelBaseLayer.h"
#import "GameManager.h"
#import "GameHelper.h"
#import "ImageHelper.h"
#import "AudioHelper.h"
@implementation LevelBaseLayer


-(void)playPieceMatch{
    if(totalPieceFixed % 5 == 0){
        [AudioHelper playGreat];
    }else if( totalPieceFixed % 8 == 0){
        [AudioHelper playCongratulations];
    }else if( totalPieceFixed % 11 == 0){
        [AudioHelper playWoohoo];
    }else{
        [AudioHelper playClick];
    }
}

-(void) movePieceToFinalPosition:(Piece*)piece{
    piece.fixed = YES;
    [piece setScale:1.0f];
    [piece setZOrder:200-piece.order];
    id action = [CCMoveTo actionWithDuration:0.5f 
                                    position:CGPointMake(piece.xTarget, 
                                                         piece.yTarget)];
    id ease = [CCEaseIn actionWithAction:action rate:0.7f];
    totalPieceFixed++;
    [piece runAction:ease];
    [self createExplosionAtPosition:ccp(piece.xTarget+piece.width/2,
                                        piece.yTarget-piece.height/2)];
    [self playPieceMatch];
    
}

-(void) createExplosionAtPosition:(CGPoint)point{
    CCParticleSystem * sun = [[CCParticleSun alloc] initWithTotalParticles:50];
    sun.texture = [[CCTextureCache sharedTextureCache] addImage:@"snow.png"];
    sun.autoRemoveOnFinish = YES;
    sun.speed = 30.0f;
    sun.duration = 0.5f;
    sun.emitterMode = 1;
    sun.startSize = 20;
    sun.endSize = 80;
    sun.life = 0.6;
    sun.endRadius = 120;
    sun.position = point;
    [self addChild:sun z:900];
}

- (BOOL) isPieceInRightPlace:(Piece*)piece {
    BOOL result = NO;
    if(piece && piece.fixed == NO){
        int radius = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 50 : 25;
        if(piece.position.x < piece.xTarget + radius &&
           piece.position.x > piece.xTarget - radius &&
           piece.position.y < piece.yTarget + radius &&
           piece.position.y > piece.yTarget - radius){
            result = YES;
        }
    }
    return result;
}

-(BOOL) isPuzzleComplete {
    for (Piece *piece in pieces) {
        if(piece.fixed == NO){
            return NO;
        }
    }
    return YES;
}

-(void) loadPuzzleImage:(NSString*)name {
    
//    puzzleImage = [[CCSprite alloc] initWithFile:[GameHelper getResourcePathByName:name]];
    
    NSLog(@"NAME:: %@", name);
    
    puzzleImage = [CCSprite spriteWithFile:name];

//    puzzleImage = [[CCSprite alloc] initWithFile:[[NSBundle mainBundle] pathForResource:@"rabbit" ofType:@"jpg"]];
    

    puzzleImage.anchorPoint = ccp(0,0);
    puzzleImage.opacity = 40;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        puzzleImage.position = ccp(screenSize.width - puzzleImage.contentSize.width - 41,
                               screenSize.height - puzzleImage.contentSize.height - 39);
    }else{
        puzzleImage.position = ccp(screenSize.width - puzzleImage.contentSize.width - 20,
                                   screenSize.height - puzzleImage.contentSize.height - 15);
    }
	[self addChild: puzzleImage z:1 tag:10];
}


-(void) loadLevelSprites:(NSString*)dimension{
    NSString *plistPuzzle = [NSString stringWithFormat:@"pieces_%@.plist", dimension];
    NSString *plistBevel = [NSString stringWithFormat:@"pieces_%@_bevel.plist", dimension];
    NSString *spritePuzzle = [NSString stringWithFormat:@"pieces_%@.png", dimension];
    NSString *spriteBevel = [NSString stringWithFormat:@"pieces_%@_bevel.png", dimension];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:plistPuzzle];
    piecesSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:spritePuzzle];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:plistBevel];
    bevelSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:spriteBevel];
}

-(float) getDeltaX:(int)hAlign withIndex:(int)index andPieceWidth:(float)pieceWidth andCols:(int)cols andRows:(int)rows{
    float qWidth = puzzleImage.contentSize.width/cols;
    float deltaX = 0;
    switch (hAlign) {
        case kHAlignCENTER:
            deltaX = (ceil(index%cols) * qWidth) - pieceWidth/2 + qWidth/2;//center
            break;
        case kHAlignLEFT:
            deltaX = ceil(index%cols) * qWidth;
            break;
        case kHAlignRIGHT:
            deltaX = (ceil(index%cols) * qWidth) - pieceWidth + qWidth;
            break;
    }
    return deltaX;    
}

-(float) getDeltaY:(int)vAlign withIndex:(int)index andPieceHeight:(float)pieceHeight andCols:(int)cols andRows:(int)rows{
    float qHeight = puzzleImage.contentSize.height/rows;
    float deltaY = 0;
    switch (vAlign) {
        case kVAlignCENTER:
            deltaY = -(floor(index/cols) * qHeight) + pieceHeight/2 - qHeight/2;
            break;
        case kVAlignTOP:
            deltaY = -(floor(index/cols) * qHeight);
            break;
        case kVAlignBOTTOM:
            deltaY = -(floor(index/cols) * qHeight) + pieceHeight - qHeight;
            break;
    }
    return deltaY;    
}

-(void) resetScreen {
    [self removeAllPieces];
    [self removeAllChildrenWithCleanup:TRUE];
    if(pieces){
        [self removeAllPieces];
    }
}
//
//-(void) onClickBack {
//    [AudioHelper playBack];
//    [[GameManager sharedGameManager] runSceneWithID:kHomeScreen];
//}
//

-(void) onClickNewGame {
    [AudioHelper playNewGame];
    [[GameManager sharedGameManager] runSceneWithID:kCategorySelection withParameter:nil];
}

-(void) removeAllPieces{
    if(pieces){
        for (Piece *piece in pieces) {
            [self removeChild:piece cleanup:YES];
        }
        [pieces removeAllObjects];
    }
}


-(void) showPuzzleComplete{
    NSArray* congratsFile = [[NSArray alloc] initWithObjects:@"congrats-eng.png",@"congrats-pt.png", @"congrats-esp.png", nil ];
    CCSprite *congrats = [[CCSprite alloc] initWithFile:
                          [congratsFile objectAtIndex:[GameManager sharedGameManager].language]];
    [congrats setScale:0.1f];

    [AudioHelper playYouWin];
    [self createExplosionAtPosition:puzzleImage.position];
    [self createExplosionAtPosition:ccp(puzzleImage.position.x+ puzzleImage.contentSize.width/2,
                                        puzzleImage.position.x+ puzzleImage.contentSize.height/2)];
    [self createExplosionAtPosition:ccp(puzzleImage.contentSize.width,
                                        puzzleImage.contentSize.height)];

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [congrats setPosition:ccp(100, 50)];
    }else{
        [congrats setPosition:ccp(60, 20)];
    }
    [congrats runAction:[CCSequence actions:
                         [CCScaleTo actionWithDuration:0.5f scale:1.3f],
                         [CCScaleTo actionWithDuration:0.5f scale:1.0f], nil]];
    congrats.anchorPoint = ccp(0,0);

    [self addChild:congrats z:10000 tag:4];
    
    
   

}

-(void) loadPieces:(NSString*)level withCols:(int)cols andRols:(int)rows {
    float posInitialX = puzzleImage.position.x;
    float posInitialY = puzzleImage.position.y;
    float deltaX = 0;
    float deltaY = 0;
    int totalPieces = cols*rows;
    int i = 0;
    float randX, randY, wlimit, hlimit, xlimit, ylimit;
    NSDictionary* levelInfo = [GameHelper getPlist:level];
    UIImage* tempPuzzle = [ImageHelper convertSpriteToImage:
                           [CCSprite spriteWithTexture:[puzzleImage texture]]];
    for (int c = 1; c<=totalPieces; c++, i++) {
        NSString *pName = [NSString stringWithFormat:@"p%d.png", c];
        NSString *sName = [NSString stringWithFormat:@"s%d.png", c];
        NSString *fullName = [NSString stringWithFormat:@"Piece:%@-Puzzle:%@-D:%d", pName,[GameManager sharedGameManager].currentPuzzle, totalPieces];
        Piece* item = [[Piece alloc] initWithName:pName andMetadata:[levelInfo objectForKey:pName]];
        [item setName: fullName];
        deltaX = [self getDeltaX:item.hAlign withIndex:i andPieceWidth:item.width andCols:cols andRows:rows];
        deltaY = [self getDeltaY:item.vAlign withIndex:i andPieceHeight:item.height andCols:cols andRows:rows];
        [item createMaskWithPuzzle:tempPuzzle
                         andOffset:ccp(deltaX, tempPuzzle.size.height + deltaY - item.height)];
        item.anchorPoint = ccp(0,1);
        [item setScale:0.8f];
        item.xTarget = posInitialX + deltaX;
        item.yTarget = posInitialY + tempPuzzle.size.height + deltaY;
        [item addBevel:sName];
        wlimit = screenSize.width-item.width-30;
        hlimit = screenSize.height-item.height-50;
        ylimit = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 150 : 60;
        xlimit = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 90 : 40;
        if (c % (int)[GameHelper randomBetween:2.0f and:4.0f] == 0){
            randX = [GameHelper randomBetween:item.width and:wlimit];
            randY = [GameHelper randomBetween:item.height and: ylimit];
        }else{
            randX = [GameHelper randomBetween:10 and:xlimit];
            randY = [GameHelper randomBetween:item.height and: hlimit];
        }
        [item setPosition:ccp(item.xTarget, item.yTarget)];
        [item runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(randX,randY)]];
        [self addChild:item z:1000+c tag:1000+c];
        [pieces addObject:item];
    }
}

- (Piece*) selectPieceForTouch:(CGPoint)touchLocation {
    for (int i = pieces.count; i--;) {
        Piece *piece = [pieces objectAtIndex:i];
        if (CGRectContainsPoint(piece.getRealBoundingBox, touchLocation) && piece.fixed == NO) {
            return piece;
        }
    }
    return nil;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    selectedPiece = [self selectPieceForTouch:touchLocation];
    if(selectedPiece == nil) return NO;
    [selectedPiece setScale:1.0f];
    [selectedPiece setZOrder:++zIndex];
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    if (selectedPiece != nil && selectedPiece.fixed == NO) {
        selectedPiece.position = ccp(touchLocation.x - (selectedPiece.width/2), 
                                     touchLocation.y + (selectedPiece.height/2));
        
//        selectedPiece.anchorPoint = ccp(0, 0);
//        [selectedPiece runAction:[CCRotateBy actionWithDuration:1 angle:90]];
//        [self runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCCallFunc actionWithTarget:self selector:@selector(rotate)], [CCDelayTime actionWithDuration:0.1], nil]]];
    
    
    }
}

//- (void)rotate
//{
//    self.position = ccpAdd(selectedPiece.position, selectedPiece.anchorPoint);
//}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    if(selectedPiece != nil && selectedPiece.fixed) return;
    if([self isPieceInRightPlace:selectedPiece]){
        [self movePieceToFinalPosition:selectedPiece];
        if(self.isPuzzleComplete){
            [self showPuzzleComplete];
        }
    }else{
        if(selectedPiece != nil && ((selectedPiece.position.x+([selectedPiece getRealBoundingBox].size.width/2)) < puzzleImage.position.x || (selectedPiece.position.y+([selectedPiece getRealBoundingBox].size.height/2)) < puzzleImage.position.y)){
            [selectedPiece setScale:0.8f];
        }
    }
}


-(void) enableTouch:(ccTime)dt{
    self.isTouchEnabled = YES;
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
}

@end