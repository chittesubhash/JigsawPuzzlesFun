//
//  CollectionDetailController.h
//  StoreMob
//
//  Created by Tope Abayomi on 06/12/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionDetailController : UIViewController

@property (nonatomic, strong) IBOutlet UIImageView* productImageView;

@property (nonatomic, strong) IBOutlet UILabel* titleLabel;

@property (nonatomic, strong) IBOutlet UILabel* likesLabel;
@property (nonatomic, strong) IBOutlet UILabel* likesCountLabel;

@property (nonatomic, strong) IBOutlet UILabel* purchasesLabel;
@property (nonatomic, strong) IBOutlet UILabel* purchasesCountLabel;

@property (nonatomic, strong) IBOutlet UILabel* viewsLabel;
@property (nonatomic, strong) IBOutlet UILabel* viewsCountLabel;

@property (nonatomic, strong) IBOutlet UIView* overlayView;

@property (nonatomic, strong) NSDictionary* data;
@property (nonatomic, strong) UIImage* productImage;

@end
