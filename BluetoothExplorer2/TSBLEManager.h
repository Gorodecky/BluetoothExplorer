//
//  TSBLEManager.h
//  BluetoothExplorer2
//
//  Created by Serg on 11/30/15.
//  Copyright (c) 2015 Vitaliy Horodecky. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TSBLEManagerDelegate <NSObject>

- (void)stopDevicesSearching;

@end

@interface TSBLEManager : NSObject

@property (nonatomic, weak) id<TSBLEManagerDelegate> delegate;

+ (id)sharedInstance;

- (BOOL)searchDevices;
- (BOOL)searchInProgress;

@end


