//
//  FruitIAPHelper.m
//  BuyFruit
//
//  Created by Michael Beyer on 16.09.13.
//  Copyright (c) 2013 Michael Beyer. All rights reserved.
//

#import "CategoryIAPHelper.h"

static NSString *kIdentifierApple       = @"com.bitlantic.jigsawpuzzle.iap1";
static NSString *kIdentifierBlackberry  = @"com.bitlantic.jigsawpuzzle.iap1";
static NSString *kIdentifierOrange      = @"com.bitlantic.jigsawpuzzle.iap1";
static NSString *kIdentifierPear        = @"com.bitlantic.jigsawpuzzle.iap1";
static NSString *kIdentifierTomato      = @"com.bitlantic.jigsawpuzzle.iap1";

@implementation CategoryIAPHelper

// Obj-C Singleton pattern
+ (CategoryIAPHelper *)sharedInstance {
    static CategoryIAPHelper *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSSet *productIdentifiers = [NSSet setWithObjects:
                                     kIdentifierApple,
                                     kIdentifierBlackberry,
                                     kIdentifierOrange,
                                     kIdentifierPear,
                                     kIdentifierTomato,
                                     nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

- (NSString *)imageNameForProduct:(SKProduct *)product
{
    if ([product.productIdentifier isEqualToString:kIdentifierApple]) {
        return @"image_apple";
    }
    if ([product.productIdentifier isEqualToString:kIdentifierBlackberry]) {
        return @"image_blackberry";
    }
    if ([product.productIdentifier isEqualToString:kIdentifierOrange]) {
        return @"image_orange";
    }
    if ([product.productIdentifier isEqualToString:kIdentifierPear]) {
        return @"image_pear";
    }
    if ([product.productIdentifier isEqualToString:kIdentifierTomato]) {
        return @"image_tomato";
    }
    return nil;
}

- (NSString *)descriptionForProduct:(SKProduct *)product
{
    
    if ([product.productIdentifier isEqualToString:kIdentifierApple]) {
        return product.localizedDescription;
    }
    if ([product.productIdentifier isEqualToString:kIdentifierBlackberry]) {
        return product.localizedDescription;
    }
    if ([product.productIdentifier isEqualToString:kIdentifierOrange]) {
        return product.localizedDescription;
    }
    if ([product.productIdentifier isEqualToString:kIdentifierPear]) {
        return product.localizedDescription;
    }
    if ([product.productIdentifier isEqualToString:kIdentifierTomato]) {
        return product.localizedDescription;
    }
    return nil;
}

@end
