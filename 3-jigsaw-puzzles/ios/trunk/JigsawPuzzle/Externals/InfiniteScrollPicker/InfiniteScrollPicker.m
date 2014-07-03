//
//  InfiniteScrollPicker.m
//  InfiniteScrollPickerExample
//
//  Created by Philip Yu on 6/6/13.
//  Copyright (c) 2013 Philip Yu. All rights reserved.
//

#import "InfiniteScrollPicker.h"
//#import "UIView+viewController.h"
#import "GameConfig.h"

@implementation InfiniteScrollPicker

//@synthesize imageAry = _imageAry;
@synthesize itemSize = _itemSize;
@synthesize alphaOfobjs;
@synthesize heightOffset;
@synthesize positionRatio;
//@synthesize scollVCDelegate;

- (id)initWithFrame:(CGRect)frame WithDelegate:(id)deleg
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
            
        alphaOfobjs = 1.0;
        heightOffset = 0.0;
        positionRatio = 1.0;
        delegate = deleg;
        imageAry = [[NSMutableArray alloc] init];
        imageStore = [[NSMutableArray alloc] init];
        NSLog(@"**InitializingInfiniteScrollPicker***");
       
    }
    return self;
}

- (void)initInfiniteScrollView
{
    [self initInfiniteScrollViewWithSelectedItem:0];
    //[self setImageAry];
}


- (void)initInfiniteScrollViewWithSelectedItem:(int)index
{
    NSLog(@"***ItemSize = %@", NSStringFromCGSize(_itemSize));
    if (_itemSize.width == 0 && _itemSize.height == 0) {
        if (imageAry.count > 0) _itemSize = [(UIImage *)[imageAry objectAtIndex:0] size];
        else _itemSize = CGSizeMake(self.frame.size.height/2, self.frame.size.height/2);
    }
    
    NSAssert((_itemSize.height < self.frame.size.height), @"item's height must not bigger than scrollpicker's height");
    CGSize size;
    self.pagingEnabled = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    [self setUserInteractionEnabled:YES];
    if (imageAry.count > 0)
    {
        // Init 5 set of images, 3 for user selection, 2 for
        for (int i = 0; i < (imageAry.count*5); i++)
        {
            int pos = i % imageAry.count;
            size = ((UIImage *)[imageAry objectAtIndex:pos]).size;
            _itemSize = size;
            
            ScrollImageView *temp = [[ScrollImageView alloc] initWithFrame:CGRectMake(i * _itemSize.width, self.frame.size.height - _itemSize.height-20, _itemSize.width, _itemSize.height) WithImageSize:_itemSize];
            
            temp.btn = [UIButton buttonWithType:UIButtonTypeCustom];
            temp.btn.frame = temp.frame;
            temp.btn.backgroundColor = [UIColor clearColor];
            temp.btn.tag = i;
            [temp.btn addTarget:delegate action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [temp.btn setUserInteractionEnabled:YES];
            
            temp.image = [imageAry objectAtIndex:i % imageAry.count];
            [imageStore addObject:temp];
            [self addSubview:temp];
            [self addSubview:temp.btn];
            if ([self isNeedLock:temp.image]) {
                temp.btn.observationInfo = (__bridge void *)(@"LOCKED");
                temp.lockImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lockBig.png"]];
                temp.lockImageView.frame = CGRectMake(temp.frame.origin.x + 200, temp.frame.origin.y, temp.lockImageView.frame.size.width, temp.lockImageView.frame.size.height);
                [self addSubview:temp.lockImageView];
            }
            else {
                temp.btn.observationInfo = (__bridge void *)(@"UNLOCKED");
            }
            
        }
        self.contentSize = CGSizeMake(imageAry.count * 5 * _itemSize.width, self.frame.size.height);
        
        float viewMiddle = imageAry.count * 2 * _itemSize.width - self.frame.size.width/2 + _itemSize.width + (_itemSize.width * index);
        [self setContentOffset:CGPointMake(viewMiddle, 0)];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^ {
            [self reloadView:viewMiddle];
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self snapToAnEmotion];
            });
        });
        
    }
}



- (BOOL)isNeedLock:(UIImage *)image {
    
    if (isFullVersion)
        return NO;
    for (int i = 1; i < 14; i++) {
        if ([image isEqual:[UIImage imageNamed:[NSString stringWithFormat:@"Thumbnail_%d.png", i]]])
            return NO;
    }
    return YES;
}

- (void)removeLocks {
    
    NSLog(@"**RemoveLocks***");
    for (ScrollImageView *imageView in imageStore) {
        NSLog(@"**LockeRemoving***");
        imageView.btn.observationInfo = (__bridge void *)(@"UNLOCKED");
        [imageView.lockImageView removeFromSuperview];
        [imageView.lockImageView release];
        imageView.lockImageView = nil;
    }
}

- (void)setImageAry
{
    for (int i = 1; i <= 14; i++) {
        NSString *thumbImgName = [NSString stringWithFormat:@"Thumbnail_%d.png", i];
        UIImage *image = [UIImage imageNamed:thumbImgName];
        [imageAry addObject:image];
    }
    [self initInfiniteScrollView];
}

- (void)setItemSize:(CGSize)itemSize
{
    itemSize = itemSize;
    [self initInfiniteScrollView];
}

- (void)setSelectedItem:(int)index
{
    [self initInfiniteScrollViewWithSelectedItem:index];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.contentOffset.x > 0)
    {
        float sectionSize = imageAry.count * _itemSize.width;
        
        if (self.contentOffset.x <= (sectionSize - sectionSize/2))
        {
            self.contentOffset = CGPointMake(sectionSize * 2 - sectionSize/2, 0);
        } else if (self.contentOffset.x >= (sectionSize * 3 + sectionSize/2)) {
            self.contentOffset = CGPointMake(sectionSize * 2 + sectionSize/2, 0);
        }
        
        [self reloadView:self.contentOffset.x];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == 0 && !snapping) [self snapToAnEmotion];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!snapping) [self snapToAnEmotion];
}

- (void)reloadView:(float)offset
{
    float biggestSize = 0;
    id biggestView = nil;
    
    for (int i = 0; i < imageStore.count; i++) {
        
        ScrollImageView *view = [imageStore objectAtIndex:i];
        _itemSize = view.imageSize;
        if (view.center.x > (offset - _itemSize.width ) && view.center.x < (offset + self.frame.size.width + _itemSize.width))
        {
            float tOffset = (view.center.x - offset) - self.frame.size.width/4;
            
            if (tOffset < 0 || tOffset > self.frame.size.width) tOffset = 0;
            float addHeight = [self calculateFrameHeightByOffset:tOffset];
            
            if (addHeight < 0) addHeight = 0;
            
            view.frame = CGRectMake(view.frame.origin.x,
                                    self.frame.size.height - _itemSize.height - heightOffset - (addHeight/positionRatio),
                                    _itemSize.width + addHeight,
                                    _itemSize.height + addHeight);
            
            if (((view.frame.origin.x + view.frame.size.width) - view.frame.origin.x) > biggestSize)
            {
                biggestSize = ((view.frame.origin.x + view.frame.size.width) - view.frame.origin.x);
                biggestView = view;
            }
            
        } else {
            view.frame = CGRectMake(view.frame.origin.x, self.frame.size.height, _itemSize.width, _itemSize.height);
            for (ScrollImageView *imageView in view.subviews)
            {
                imageView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
            }
        }
    }
    
    for (int i = 0; i < imageStore.count; i++)
    {
        UIView *cBlock = [imageStore objectAtIndex:i];
        cBlock.alpha = alphaOfobjs;
        
        if (i > 0)
        {
            UIView *pBlock = [imageStore objectAtIndex:i-1];
            cBlock.frame = CGRectMake(pBlock.frame.origin.x + pBlock.frame.size.width, cBlock.frame.origin.y, cBlock.frame.size.width, cBlock.frame.size.height);
        }
    }
    
    [(UIView *)biggestView setAlpha:1.0];
}

-(float)calculateFrameHeightByOffset:(float)offset
{
    return (-1 * fabsf((offset)*2 - self.frame.size.width/2) + self.frame.size.width/2)/4;
}

- (void)snapToAnEmotion
{
    float biggestSize = 0;
    ScrollImageView *biggestView = nil;
    
    snapping = YES;
    
    float offset = self.contentOffset.x;
    
    for (int i = 0; i < imageStore.count; i++) {
        ScrollImageView *view = [imageStore objectAtIndex:i];
        
        if (view.center.x > offset && view.center.x < (offset + self.frame.size.width))
        {
            if (((view.center.x + view.frame.size.width) - view.center.x) > biggestSize)
            {
                biggestSize = ((view.frame.origin.x + view.frame.size.width) - view.frame.origin.x);
                biggestView = view;
            }
            
        }
    }
    
    float biggestViewX = biggestView.frame.origin.x + biggestView.frame.size.width/2 - self.frame.size.width/2;
    float dX = self.contentOffset.x - biggestViewX;
    float newX = self.contentOffset.x - dX/1.4;
    
    // Disable scrolling when snapping to new location
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^ {
        [self setScrollEnabled:NO];
        [self scrollRectToVisible:CGRectMake(newX, 0, self.frame.size.width, 1) animated:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            
            SEL selector = @selector(infiniteScrollPicker:didSelectAtImage:);
            if ([[self firstAvailableUIViewController] respondsToSelector:selector])
            {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [[self firstAvailableUIViewController] performSelector:selector withObject:self withObject:biggestView];
#pragma clang diagnostic pop
            }
            
            [self setScrollEnabled:YES];
            snapping = 0;
        });
    });
}

-(void)dealloc {
    
    NSLog(@"***InfiniteScrollView_DEalloc**");
    
    if (!isFullVersion) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        //NSLog(@"**RemoveLocks***");
        for (ScrollImageView *imageView in imageStore) {
            imageView.btn.observationInfo = (__bridge void *)(@"UNLOCKED");
            [imageView.lockImageView removeFromSuperview];
            [imageView.lockImageView release];
            imageView.lockImageView = nil;
            [imageView release];
            imageView = nil;
        }
    }
    else {
        for (ScrollImageView *imageView in imageStore) {
            [imageView release];
            imageView = nil;
        }
    }
    [imageStore release];
    [imageAry release];
    [super dealloc];
}

@end
