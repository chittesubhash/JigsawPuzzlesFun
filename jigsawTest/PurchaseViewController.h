//
//  PurchaseViewController.h
//  Jigsaw Puzzle Fun
//
//  Created by admin on 7/24/14.
//  Copyright (c) 2014 BITLANTIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchaseViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSTimer *timer;
    
}
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSString *mainPuzzle;
@property (nonatomic, strong) NSDictionary *data;
@end
