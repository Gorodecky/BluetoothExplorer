//
//  ViewController.m
//  BluetoothExplorer2
//
//  Created by Serg on 11/28/15.
//  Copyright (c) 2015 Vitaliy Horodecky. All rights reserved.
//

#import "ViewController.h"
#import "DeviceHelper.h"
#import "TSBLEManager.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, TSBLEManagerDelegate>

@property (strong, nonatomic) NSArray* namesArray; // масив даних
@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) IBOutlet UIView* loadingView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView* activityIndicator;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [[TSBLEManager sharedInstance] setDelegate:self];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)stopDevicesSearching{
    if ([_activityIndicator isAnimating] == YES)
    {
        [self.activityIndicator stopAnimating];
        [self.view sendSubviewToBack:_loadingView];
        [self.loadingView setHidden:YES];
    }

    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0 ) {
        return @"Favorite devices";
    } else {
        return @"Other devices";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger result = 0;
    
    switch (section) {
        case 0: {
            result = [DeviceHelper sharedInstance].favoritDevicesList.count; // count від масиву
            break;
        }
            
        case 1:{
            result = [DeviceHelper sharedInstance].otherDevicesList.count; // ризниця між двома масивами
            break;
        }
            
        default:
            break;
    }
    
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = [[DeviceHelper sharedInstance].favoritDevicesList objectAtIndex:indexPath.row];
    } else {
    cell.textLabel.text = [[DeviceHelper sharedInstance].otherDevicesList objectAtIndex:indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        [[DeviceHelper sharedInstance] moveDevicesFromFavoritsToOthers:indexPath.row];
    }
    else
    {
        [[DeviceHelper sharedInstance] moveDevicesFromOtherToFavorits:indexPath.row];
    }
    
    [self.tableView reloadData];
}


// Кнопка перезавантаження
- (IBAction)refreshButton:(id)sender {
    
    if ([[TSBLEManager sharedInstance] searchInProgress] == NO) {
        if ([[TSBLEManager sharedInstance] searchDevices] == YES) {
            [self showLoadingView];
        }
        else{
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot load devices" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    } else {
        [self showLoadingView];
    }
}

- (void) showLoadingView {
    [self.activityIndicator startAnimating];
    [self.view bringSubviewToFront:_loadingView];
    [self.loadingView setHidden:NO];
}

@end
