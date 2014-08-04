

#import "ScrollImageView.h"

@implementation ScrollImageView

- (id)initWithFrame:(CGRect)frame WithImageSize:(CGSize)size
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageSize = size;
        self.layer.cornerRadius = 4.0f;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 2.0f;
        self.layer.masksToBounds = YES;
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

//-(void)dealloc {
//    //NSLog(@"***ScrollImageView***");
//    [super dealloc];
//}

@end
