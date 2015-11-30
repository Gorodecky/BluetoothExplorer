//
//  ViewController.m
//  BluetoothExplorer2
//
//  Created by Serg on 11/28/15.
//  Copyright (c) 2015 Vitaliy Horodecky. All rights reserved.
//

#import "ViewController.h"
#import "DeviceHelper.h"

@interface ViewController ()

@property (strong, nonatomic) NSArray* namesArray; // масив даних

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    if ([tableView isEqual:self.view]) {
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
// Кнопка перезавантаження
- (IBAction)refreshButton:(id)sender {
    
}
@end
