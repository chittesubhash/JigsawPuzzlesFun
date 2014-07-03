//
//  ScrollImageView.m
//  BookKingdom
//
//  Created by Rossitek_Ridhin on 21/02/14.
//
//

#import "ScrollImageView.h"

@implementation ScrollImageView

- (id)initWithFrame:(CGRect)frame WithImageSize:(CGSize)size
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageSize = size;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)dealloc {
    //NSLog(@"***ScrollImageView***");
    [super dealloc];
}

@end
