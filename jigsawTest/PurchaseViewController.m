//
//  PurchaseViewController.m
//  Jigsaw Puzzle Fun
//
//  Created by admin on 7/24/14.
//  Copyright (c) 2014 BITLANTIC. All rights reserved.
//

#import "PurchaseViewController.h"
#import "CollectionsCell.h"
#import "CollectionDetailController.h"
#import "CategoryIAPHelper.h"
#import <StoreKit/StoreKit.h>


@interface PurchaseViewController ()
{
    UIButton *menuButtons;
//    UIButton *myPuzzlesButton;
//    UIButton *featuredPuzzles;
//    UIButton *puzzlesOfTheWeek;
    
    NSArray *menuItems;
    UILabel *headerLabel;
    
}

@property (nonatomic, strong) NSArray *products;

@property (nonatomic, strong) NSArray *arrCollectionsData;
@property (nonatomic, strong) NSMutableArray *arrCollectionsImages;

-(void)getImageDataFromURL:(NSURL *)imageDataUrl forIndex:(int)index;

@end

@implementation PurchaseViewController

- (void)backButtonClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"newhomebg_ipad.png"]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor colorWithRed:34.0/255.0 green:34.0/255.0 blue:34.0/255.0 alpha:1.0];
    scrollView.frame = CGRectMake(0, 1, 311, 766);
    [self.view addSubview:scrollView];
    
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButton.frame = CGRectMake(0, 1, 311, 60);
    backButton.tag = 10;
//    backButton.layer.borderColor = [UIColor grayColor].CGColor;
//    backButton.layer.borderWidth = 0.5f;
    backButton.titleLabel.font = [UIFont fontWithName:@"Marker Felt" size:28.0];
    [backButton setTitle:@"Back To Main" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"alert-yellow-button.png"] forState:UIControlStateNormal];
    backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:backButton];

    if(IS_IPHONE_5 || IS_IPHONE_4)
    {
        scrollView.frame = CGRectMake(0, 1, 111, 318);
        backButton.frame = CGRectMake(0, 1, 111, 40);
        backButton.titleLabel.font = [UIFont fontWithName:@"Marker Felt" size:16.0];

    }

    
    menuItems = [[NSArray alloc] initWithObjects: @"My Puzzles", @"Featured Puzzles", @"Puzzles of the week",  nil];
    for(int i=0; i<menuItems.count; i++)
    {
        menuButtons = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        menuButtons.tag = i;
//        menuButtons.layer.borderColor = [UIColor grayColor].CGColor;
//        menuButtons.layer.borderWidth = 0.5f;
        if(i == 0)
            [menuButtons setBackgroundImage:[UIImage imageNamed:@"button_grey.png"] forState:UIControlStateNormal];
        else
            [menuButtons setBackgroundImage:[UIImage imageNamed:@"button_red.png"] forState:UIControlStateNormal];
        menuButtons.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [menuButtons setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        [menuButtons setTitle:[menuItems objectAtIndex:i] forState:UIControlStateNormal];
        [menuButtons addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:menuButtons];
        
        
        if(IS_IPHONE_5 || IS_IPHONE_4)
        {
            menuButtons.frame = CGRectMake(0, 41+(i*40), 111, 40);
            menuButtons.titleLabel.font = [UIFont fontWithName:@"Marker Felt" size:12.0];
        }
        else
        {
            menuButtons.frame = CGRectMake(0, 61+(i*120), 311, 120);
            menuButtons.titleLabel.font = [UIFont fontWithName:@"Marker Felt" size:28.0];
        }

    }
   
    headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(311, 1, 613, 60);
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.text = _mainPuzzle;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName:@"Marker Felt" size:30.0];
    headerLabel.backgroundColor = [UIColor colorWithRed:45.0/255.0 green:45.0/255.0 blue:45.0/255.0 alpha:1.0];
    [self.view addSubview:headerLabel];
    
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    buyBtn.frame = CGRectMake(924, 1, 100, 60);
//    buyBtn.layer.borderColor = [UIColor grayColor].CGColor;
//    buyBtn.layer.borderWidth = 0.5f;
    buyBtn.tag = 10;
    buyBtn.titleLabel.font = [UIFont fontWithName:@"Marker Felt" size:28.0];
    [buyBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    buyBtn.backgroundColor = [UIColor colorWithRed:45.0/255.0 green:45.0/255.0 blue:45.0/255.0 alpha:1.0];
    [buyBtn setTitle:@"BUY" forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(buyButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:buyBtn];
    
    // Setup the layout for the collection view.
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize:CGSizeMake(191, 184)]; //for ipad
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [layout setSectionInset:UIEdgeInsetsMake(30, 30, 30, 30)];
    [layout setMinimumLineSpacing:30.0];
        
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(311, 61, 713, 707) collectionViewLayout:layout];
    _collectionView.layer.borderColor = [UIColor whiteColor].CGColor;
    _collectionView.layer.borderWidth = 1.0f;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = YES;
    _collectionView.backgroundColor = [UIColor colorWithRed:45.0/255.0 green:45.0/255.0 blue:45.0/255.0 alpha:1.0];
    UINib *collectionsCellNib = [UINib nibWithNibName:@"CollectionsCell" bundle:nil];
    [_collectionView registerNib:collectionsCellNib forCellWithReuseIdentifier:@"collectionsCell"];
    [_collectionView setCollectionViewLayout:layout];
    [self.view addSubview:_collectionView];
    
    if(IS_IPHONE_5)
    {
        [layout setItemSize:CGSizeMake(121, 114)]; //for iphone
        [layout setSectionInset:UIEdgeInsetsMake(10, 20, 10, 20)];
        [layout setMinimumLineSpacing:15.0];


        headerLabel.frame = CGRectMake(111, 1, 413, 40);
        headerLabel.font = [UIFont fontWithName:@"Marker Felt" size:18.0];

        buyBtn.frame = CGRectMake(568-80, 1, 80, 40);
        buyBtn.titleLabel.font = [UIFont fontWithName:@"Marker Felt" size:18.0];

        _collectionView.frame = CGRectMake(111, 41, 457, 280);
    }
    
    if(IS_IPHONE_4)
    {
        [layout setItemSize:CGSizeMake(121, 114)]; //for iphone
        [layout setSectionInset:UIEdgeInsetsMake(10, 40, 40, 40)];
        [layout setMinimumLineSpacing:15.0];
        
        
        headerLabel.frame = CGRectMake(111, 1, 413-88, 40);
        headerLabel.font = [UIFont fontWithName:@"Marker Felt" size:18.0];
        
        buyBtn.frame = CGRectMake(568-80-88, 1, 80, 40);
        buyBtn.titleLabel.font = [UIFont fontWithName:@"Marker Felt" size:18.0];
        
        _collectionView.frame = CGRectMake(111, 41, 457-88, 280);
    }

    // Initially make the collections data and images arrays nil.
    _arrCollectionsData = nil;
    _arrCollectionsImages = nil;
    
    
    if([_mainPuzzle isEqualToString:@"My Puzzles"])
    {
        [self getCollectionsData];
    }
}


- (void)viewWillAppear:(BOOL)animated {
//    [self reload];
//    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(reload) userInfo:nil repeats:YES];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];

}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)productPurchased:(NSNotification *)notification {
    
    NSString * productIdentifier = notification.object;

    
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
//            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            
            NSLog(@"PRODUCTS productIdentifier:: %@", product.productIdentifier);

            *stop = YES;
        }
    }];
}


- (void)reload {
    _products = nil;
//    [self.tableView reloadData];
    [[CategoryIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _products = products;
            NSLog(@"PRODUCTS:: %@", _products);
            
            if(_products.count != 0)
            {
                if([timer isValid])
                {
                    [timer invalidate];
                    timer = nil;
                }
            }

            [self reloaddata];
        }
//        [self.refreshControl endRefreshing];
    }];
}

- (void)reloaddata
{
    SKProduct *product;
    for(int i=0; i<self.products.count; i++)
    {
        product = [self.products objectAtIndex:i];
        NSLog(@"PRODUCTS 11:: %@", product);

        NSLog(@"PRODUCTS 22:: %@", product.localizedTitle);

        NSLog(@"PRODUCTS 33:: %@", product.priceLocale);

        NSLog(@"PRODUCTS 44:: %@", product.price);

    }
    
    
    if ([[CategoryIAPHelper sharedInstance] productPurchased:product.productIdentifier])
    {
   
        
    }
    else
    {
        UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        buyButton.frame = CGRectMake(0, 0, 72, 37);
        [buyButton setTitle:@"Buy" forState:UIControlStateNormal];

        [buyButton addTarget:self action:@selector(buyTapped:) forControlEvents:UIControlEventTouchUpInside];
   
        
    }

}

- (void)buyTapped:(id)sender {
    
    UIButton *buyButton = (UIButton *)sender;
    SKProduct *product = _products[buyButton.tag];
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[CategoryIAPHelper sharedInstance] buyProduct:product];
    
}


- (void)buyButtonClicked:(UIButton *)sender
{
    NSLog(@"BUY BTN CLICKED");
    
    [[CategoryIAPHelper sharedInstance] restoreCompletedTransactions];

}


- (void)getCollectionsData
{
    //Specify the data URL.
    NSURL *url = [NSURL URLWithString:@"http://www.appdesignvault.com/downloads/storemob/storemob.json"];
    
    // Use a NSURLSession session to get the data in combination with a NSURLSessionDataTask object.
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if(error)
        {
            NSLog(@"An error occured while getting Collections data.");
            NSLog(@"%@", [error localizedDescription]);
        }
        else
        {
            NSError *jsonError;
            
            //get a dictionary from the downloaded JSON data, using NSJsonSerialization class.
            NSDictionary *jsonDataDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
            if(jsonError)
            {
                NSLog(@"Unable to convert data.");
                NSLog(@"%@", [jsonError localizedDescription]);
            }
            else
            {
                /* Example JSON data
                {
                     "items" : 
                     [
                         {
                         "image" : "http://www.appdesignvault.com/downloads/storemob/collections1.png",
                         "name" : "Red Diesel T-Shirt",
                         "views" : 30,
                         "likes" : 24,
                         "purchases" : 14,
                         "longitude" : -0.116667,
                         "latitude" : 51.5072
                         },
                         {
                         "image" : "http://www.appdesignvault.com/downloads/storemob/collections2.png",
                         "name" : "Blue Diesel Polo",
                         "views" : 18,
                         "likes" : 14,
                         "purchases" : 32,
                         "longitude" : -0.1099,
                         "latitude" : 51.3727
                         }
                     ]
                 }
                 */
                
                // Initialize the _arrCollectionsData array with contents the array of the "items" key, of
                // the dictionary object.
                _arrCollectionsData = [[NSArray alloc] initWithArray:jsonDataDict[@"items"]];
                
                
                // Also, initialize the _arrCollectionsImages array and fill it with null objects.
                _arrCollectionsImages = [[NSMutableArray alloc] init];
                for(int i=0; i<[_arrCollectionsData count]; i++)
                {
                    [_arrCollectionsImages addObject:[NSNull null]];
                }
                
                
                //As NSURLSession tasks are asynchronous, reload the data of the collection view ushing the main thread.
                //Do that right now to allow any downloaded data to appear until all images are downloaded too.
                [_collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];

                // Using a loop, get each one image URL from the _arrCollectionsData array and download it by making use
                // of the getImageDataFromURL:forIndex: private method.
                
                for(int i=0; i<[_arrCollectionsData count]; i++)
                {
                    NSString *imageUrlString = _arrCollectionsData[i][@"image"];
                    // Call the next method to download the image.
                    // Provide the index value to specify the position where the downloaded image should be stored
                    // into the _arrCollectionsImages array.
                    [self getImageDataFromURL:[NSURL URLWithString:imageUrlString] forIndex:i];
                }
            }
        }
    }];
    
    // Begin downloading the JSON data.
    [task resume];
}

- (void)menuButtonClicked:(UIButton *)sender
{
    for(UIView *view in self.view.subviews)
    {
        UIButton *btnObj = (UIButton *)view;
        if([btnObj isKindOfClass:[UIButton class]])
        {
            if(btnObj.tag != 10)
                [btnObj setBackgroundImage:[UIImage imageNamed:@"button_red.png"] forState:UIControlStateNormal];
        }
    }
    
    [sender setBackgroundImage:[UIImage imageNamed:@"button_grey.png"] forState:UIControlStateNormal];

    if(sender.tag == 0)
    {
        // Download the Collections data.
        [self getCollectionsData];
        
        headerLabel.text = @"My Puzzles";
    }
        
        
    if(sender.tag == 1)
    {
        // Download the Collections data.
        [self getCollectionsData];
        
        headerLabel.text = @"Featured Puzzles";

    }
            
            
    if(sender.tag == 2)
    {
        // Download the Collections data.
        [self getCollectionsData];
        
        headerLabel.text = @"Puzzles of the Week";
    }
}

-(void)getImageDataFromURL:(NSURL *)imageDataUrl forIndex:(int)index
{
    // Use a NSURLSession object with a NSURLSessionDataTask object to download the image specified by the parameter URL value.
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:imageDataUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if(!error)
        {
            // If no error occurs, then get the NSHTTPURLResponse value of the response and make sure that
            // the status code is 200, which means that it's all OK.
            NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
            if([urlResponse statusCode] == 200)
            {
                // In that case, replace the null object at the position specified by the index parameter value with
                // a UIImage object created from the downloaded data.
                _arrCollectionsImages[index] = [[UIImage alloc] initWithData:data];
            }
            else
            {
                 _arrCollectionsImages[index] = @"";
            }
            
            
            [_collectionView performSelectorOnMainThread:@selector(reloadItemsAtIndexPaths:) withObject:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:index inSection:0]] waitUntilDone:NO];
            
        }
    }];

    // Begin downloading the image data.
    [task resume];

}

#pragma mark - UICollectionView Delegate and Datasource method implementation

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger totalItems = 0;
    
    if(_arrCollectionsData != nil)
    {
        totalItems = [_arrCollectionsData count];
    }
    
    return totalItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //dequeue the collections cell using the "CollectionsCell" identifier
    
    CollectionsCell *cell = (CollectionsCell *)[_collectionView dequeueReusableCellWithReuseIdentifier:@"collectionsCell" forIndexPath:indexPath];
    
    // First of all, show the image of the current cell.
    // Make sure that the _arrCollectionImages array doesn't have an object of NSNull class at the current position
    // and that the kind of class is of UIImage class.
    if (![_arrCollectionsImages[indexPath.row] isKindOfClass:[NSNull class]])
    {
        if ([_arrCollectionsImages[indexPath.row] isKindOfClass:[UIImage class]])
        {
            // Set the image at the imgSample image view object of the cell.
            [[cell imgSample] setImage:_arrCollectionsImages[indexPath.row]];
        }
        
        // Stop animating the activity indicator and make it dissapear.
        [[cell activityIndicator] stopAnimating];
        [[cell activityIndicator] setHidden:YES];
    }
    
    // Set the brand value.
    [[cell lblBrand] setText:_arrCollectionsData[indexPath.row][@"name"]];
    
    // Set the images of the views, likes and purchases into the respective image view objects of the cell.
    [[cell imgViews] setImage:[UIImage imageNamed:@"views"]];
    [[cell imgLikes] setImage:[UIImage imageNamed:@"likes"]];
    [[cell imgPurchases] setImage:[UIImage imageNamed:@"purchases"]];

    // Convert the number of the views, likes and purchases into NSString values and show them in the respective labels of
    // the cell.
    NSString *views = [NSString stringWithFormat:@"%d", [_arrCollectionsData[indexPath.row][@"views"] intValue]];
    [[cell lblViews] setText:views];
    
    NSString *likes = [NSString stringWithFormat:@"%d", [_arrCollectionsData[indexPath.row][@"likes"] intValue]];
    [[cell lblLikes] setText:likes];
    
    NSString *purchases = [NSString stringWithFormat:@"%d", [_arrCollectionsData[indexPath.row][@"purchases"] intValue]];
    [[cell lblPurchases] setText:purchases];

    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    
//    CollectionsCell *cell1 = (CollectionsCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    
//    NSLog(@"TET::: %@", cell1.te);
    
    

    PurchaseViewController *purchaseView = [[PurchaseViewController alloc] init];
    NSDictionary* data = menuItems[indexPath.row];
    purchaseView.mainPuzzle = menuItems[indexPath.row];
    purchaseView.data = data;
    [self.navigationController pushViewController:purchaseView animated:YES];
    
    
    
//    CollectionDetailController *detail = [[CollectionDetailController alloc] init];
//    
//    NSDictionary* data = _arrCollectionsData[indexPath.row];
//    detail.productImage = _arrCollectionsImages[indexPath.row];
//    detail.data = data;
//    [self.navigationController pushViewController:detail animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
