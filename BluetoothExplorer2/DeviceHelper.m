//
//  DeviceHelper.m
//  BluetoothExplorer2
//
//  Created by Serg on 11/29/15.
//  Copyright (c) 2015 Vitaliy Horodecky. All rights reserved.
//

#import "DeviceHelper.h"
#import <CoreBluetooth/CBPeripheral.h>
@interface DeviceHelper ()
{
    NSMutableArray* favoritsNameDevices;
    NSMutableArray* otherDevices;
    NSMutableArray* favoritDevices;
}

@end
@implementation DeviceHelper

+ (DeviceHelper*)sharedInstance // менеджер обєктив в єдиному екземплярі
{
    static DeviceHelper *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DeviceHelper alloc] init];
    });
    
    return sharedInstance;
}

- (void) procesDevicesArray:(NSArray*)listOfDevices {
    
    [otherDevices removeAllObjects];
    [favoritDevices removeAllObjects];
    //CBPeripheral
    
    for (int i = 0; i < listOfDevices.count; i++) {
        NSString *device = [listOfDevices objectAtIndex:i];
       
        BOOL addDeviceToFavourite = NO;
        
        for (int j = 0; j < favoritsNameDevices.count; j++) {
            
            NSString *deviceName = [favoritsNameDevices objectAtIndex:j];
            
            if ([device isEqualToString:deviceName]) {
                
                addDeviceToFavourite = YES;
                break;
            }
        }
        
        if (addDeviceToFavourite == YES) {
            
            if (favoritDevices == nil) {
                favoritDevices = [NSMutableArray array];
            }
            
            [favoritDevices addObject:device];
        } else {
            
            if (otherDevices == nil) {
                
                otherDevices = [NSMutableArray array];
            }
            
            [otherDevices addObject:device];
        }
    }
}
// перенос елемента з общего в фаворіт

- (void) moveDevicesFromOtherToFavorits:(NSInteger) indexOfRow {
    
    if (favoritsNameDevices == nil) {
        favoritsNameDevices = [NSMutableArray array];
    }
    
    if (favoritDevices == nil) {
        favoritDevices = [NSMutableArray array];
    }
    
    NSString *deviceName = [otherDevices objectAtIndex:indexOfRow];
    
    [favoritDevices addObject:deviceName];
    [favoritsNameDevices addObject:deviceName];
    [otherDevices removeObjectAtIndex:indexOfRow];
}
// перенос девайсів з фаворіт в інші

- (void) moveDevicesFromFavoritsToOthers:(NSInteger) indexOfRow {
    
    NSString* deviceName = [favoritDevices objectAtIndex:indexOfRow];
    
    [favoritDevices removeObjectAtIndex:indexOfRow];
    [favoritsNameDevices removeObject:deviceName];
    
    if (otherDevices == nil) {
        otherDevices = [NSMutableArray array];
    }
    [otherDevices addObject:deviceName];
}


-(NSArray*)favoritDevicesList
{
    return favoritDevices;
}

-(NSArray*)otherDevicesList
{
    return otherDevices;
}

@end
