//
//  DeviceHelper.h
//  BluetoothExplorer2
//
//  Created by Serg on 11/29/15.
//  Copyright (c) 2015 Vitaliy Horodecky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceHelper : NSObject

@property (strong, nonatomic, readonly) NSArray* favoritDevicesList;
@property (strong, nonatomic, readonly) NSArray* otherDevicesList;

- (void) procesDevicesArray:(NSArray*)listOfDevices;
- (void) moveDevicesFromFavoritsToOthers:(NSInteger) indexOfRow;
- (void) moveDevicesFromOtherToFavorits:(NSInteger) indexOfRow;
+ (DeviceHelper*) sharedInstance;

@end
