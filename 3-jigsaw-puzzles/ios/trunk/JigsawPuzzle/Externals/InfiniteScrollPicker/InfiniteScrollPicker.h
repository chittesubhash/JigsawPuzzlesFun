//
//  InfiniteScrollPicker.h
//  InfiniteScrollPickerExample
//
//  Created by Philip Yu on 6/6/13.
//  Copyright (c) 2013 Philip Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollImageView.h"
#import "GameManager.h"

@protocol InfinteScrollDelegate <NSObject>

@required

//- (void)action;
- (void)btnClicked:(UIButton *)sender;

@end
@class InfiniteScrollPicker;



@interface InfiniteScrollPicker : UIScrollView<UIScrollViewDelegate>
{
    NSMutableArray *imageStore;
    bool snapping;
    float lastSnappingX;
    //id scollVCDelegate;
    NSMutableArray *btnArray;
    NSMutableArray *thumbImageArray;
    NSMutableArray *imageAry;
    id delegate;
    BOOL isFullVersion;
}

//@property (nonatomic, strong) NSArray *imageAry;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) float alphaOfobjs;

@property (nonatomic) float heightOffset;
@property (nonatomic) float positionRatio;

- (id)initWithFrame:(CGRect)frame WithDelegate:(id)deleg;
//@property (retain)id scollVCDelegate;

//- (void)setDelegate:(id<InfinteScrollDelegate>)delegate;

- (void)initInfiniteScrollView;
- (void)setSelectedItem:(int)index;
- (void)setImageAry;

@end
