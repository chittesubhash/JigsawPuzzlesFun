//
//  ScrollImageView.h
//  BookKingdom
//
//  Created by Rossitek_Ridhin on 21/02/14.
//
//

#import <UIKit/UIKit.h>

@interface ScrollImageView : UIImageView


@property (nonatomic, readwrite) CGSize imageSize;
@property (nonatomic, strong)UIImageView *lockImageView;
@property (nonatomic, strong)UIButton *btn;
//@property (nonatomic, readwrite)BOOL needLock;

- (id)initWithFrame:(CGRect)frame WithImageSize:(CGSize)size;
@end
