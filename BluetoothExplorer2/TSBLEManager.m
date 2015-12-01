//
//  TSBLEManager.m
//  BluetoothExplorer2
//
//  Created by Serg on 11/30/15.
//  Copyright (c) 2015 Vitaliy Horodecky. All rights reserved.
//

#import "TSBLEManager.h"
#import "DeviceHelper.h"
#import "AppDelegate.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBService.h>

@interface TSBLEManager () <CBCentralManagerDelegate, CBPeripheralDelegate>
{
    BOOL        searchInProgress;//прогрес пошуку
    
    NSMutableArray *findedDevices; // масив знайдених пристроїв
}

@property (strong, nonatomic) CBCentralManager *centralManager;// ініціалізація блютуза

@end


@implementation TSBLEManager

+ (id)sharedInstance // менеджер обєктив в єдиному екземплярі
{
    static TSBLEManager *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TSBLEManager alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    if ((self = [super init])) {
        
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        _centralManager.delegate = self;
        
        [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(scanForPeripherals) userInfo:nil repeats:YES];
    }
    return self;
}

#pragma mark - CBCentralManagerDelegate

// повертає девайс який знайде

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    if (!findedDevices) {
        findedDevices = [NSMutableArray array];
    }
    
    [findedDevices addObject:peripheral.name];
    
    NSLog(@"Received periferal :%@",peripheral);
    NSLog(@"Ad data :%@",advertisementData);
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central // перевіряє стан блютуза
{
    NSString *messtoshow;
    
    switch (central.state) {
        case CBCentralManagerStateUnknown:
        {
            messtoshow=[NSString stringWithFormat:@"State unknown, update imminent."];
            break;
        }
        case CBCentralManagerStateResetting:
        {
            messtoshow=[NSString stringWithFormat:@"The connection with the system service was momentarily lost, update imminent."];
            break;
        }
        case CBCentralManagerStateUnsupported:
        {
            messtoshow=[NSString stringWithFormat:@"The platform doesn't support Bluetooth Low Energy"];
            break;
        }
        case CBCentralManagerStateUnauthorized:
        {
            messtoshow=[NSString stringWithFormat:@"The app is not authorized to use Bluetooth Low Energy"];
            break;
        }
        case CBCentralManagerStatePoweredOff:
        {
            messtoshow=[NSString stringWithFormat:@"Bluetooth is currently powered off."];
            break;
        }
        case CBCentralManagerStatePoweredOn:
        {
            messtoshow=[NSString stringWithFormat:@"Bluetooth is currently powered on and available to use."];
            break;
        }
            
    }
    
    NSLog(@"centralManagerDidUpdateState = %@",messtoshow);
}

#pragma mark - Public methods

- (BOOL)searchInProgress {
    return searchInProgress;
}

- (BOOL)searchDevices // метод доступний ззовні
{
    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).isTestData == YES)
    {
        [self stopSearch];
    }
    return [self scanForPeripherals];
}

#pragma mark - Private Methods

- (BOOL) scanForPeripherals // скан девайсів
{
    if (_centralManager.state != CBCentralManagerStatePoweredOn) // перевіряє доступність блютуз
    {
        NSLog(@"CoreBluetooth is %li", (long)self.centralManager.state);
        return NO;
    }
    
    if (!searchInProgress) {
        
        NSArray *devices = nil;
        // ід моделей пристроїв
        devices = @[[CBUUID UUIDWithString:@"180D"],
                    [CBUUID UUIDWithString:@"1800"],
                    [CBUUID UUIDWithString:@"1813"],
                    [CBUUID UUIDWithString:@"180E"],
                    [CBUUID UUIDWithString:@"1825"],
                    [CBUUID UUIDWithString:@"1807"],
                    [CBUUID UUIDWithString:@"1820"],
                    [CBUUID UUIDWithString:@"1812"],
                    [CBUUID UUIDWithString:@"1801"],
                    [CBUUID UUIDWithString:@"180F"],
                    [CBUUID UUIDWithString:@"1815"],
                    [CBUUID UUIDWithString:@"1811"],
                    [CBUUID UUIDWithString:@"1810"],
                    [CBUUID UUIDWithString:@"181B"],
                    [CBUUID UUIDWithString:@"181E"],
                    [CBUUID UUIDWithString:@"181F"],
                    [CBUUID UUIDWithString:@"1805"],
                    [CBUUID UUIDWithString:@"1818"],
                    [CBUUID UUIDWithString:@"1816"],
                    [CBUUID UUIDWithString:@"180A"],
                    [CBUUID UUIDWithString:@"181A"],
                    [CBUUID UUIDWithString:@"1808"],
                    [CBUUID UUIDWithString:@"1809"],
                    [CBUUID UUIDWithString:@"1823"],
                    [CBUUID UUIDWithString:@"1802"],
                    [CBUUID UUIDWithString:@"1821"],
                    [CBUUID UUIDWithString:@"1803"],
                    [CBUUID UUIDWithString:@"1819"],
                    [CBUUID UUIDWithString:@"1822"],
                    [CBUUID UUIDWithString:@"1806"],
                    [CBUUID UUIDWithString:@"1814"],
                    [CBUUID UUIDWithString:@"1824"],
                    [CBUUID UUIDWithString:@"1804"],
                    [CBUUID UUIDWithString:@"181C"],
                    [CBUUID UUIDWithString:@"181D"]];
        
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], CBCentralManagerScanOptionAllowDuplicatesKey, nil]; // параматри для пошуку девайсів
        [self.centralManager scanForPeripheralsWithServices:devices options:options]; // запуск пошуку
        
        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(stopSearch) userInfo:nil repeats:NO];
        
        searchInProgress = YES;
    }
    
    return YES;
}

- (void)stopSearch {
    
    [self.centralManager stopScan]; //зупинка сканування
    
    searchInProgress = NO;
    if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).isTestData == YES)
    {
        for (int i = 0; i < 10; i++)
        {
            if (findedDevices == nil)
            {
                findedDevices = [NSMutableArray array];
            }
            
            [findedDevices addObject:[NSString stringWithFormat:@"Device with id = %i",i]];
        }
    }
    
    
    [[DeviceHelper sharedInstance] procesDevicesArray:[findedDevices copy]];
    
    //get list of devises and process it to devices array CBPeripheral
    
    //after call stopDevicesSearching and update table
    //метод передає в девайс менеджер спісок знайденіх девайсив
    
    [_delegate stopDevicesSearching];
    
    if (findedDevices) {
        [findedDevices removeAllObjects];
        findedDevices = nil;
    }
}
@end