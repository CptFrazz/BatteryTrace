struct _rawData { 
    BOOL itemIsEnabled[25]; 
    BOOL timeString[64]; 
    int gsmSignalStrengthRaw; 
    int gsmSignalStrengthBars; 
    BOOL serviceString[100]; 
    BOOL serviceCrossfadeString[100]; 
    BOOL serviceImages[2][100]; 
    BOOL operatorDirectory[1024]; 
    unsigned int serviceContentType; 
    int wifiSignalStrengthRaw; 
    int wifiSignalStrengthBars; 
    unsigned int dataNetworkType; 
    int batteryCapacity;
    unsigned int batteryState; 
    BOOL batteryDetailString[150]; 
    int bluetoothBatteryCapacity; 
    int thermalColor; 
    unsigned int thermalSunlightMode : 1;  
    unsigned int slowActivity : 1;  
    unsigned int syncActivity : 1;  
    BOOL activityDisplayId[256]; 
    unsigned int bluetoothConnected : 1;  
    unsigned int displayRawGSMSignal : 1;  
    unsigned int displayRawWifiSignal : 1;  
    unsigned int locationIconType : 1;  
    unsigned int quietModeInactive : 1;
    unsigned int tetheringConnectionCount;
    NSString *_doubleHeightStatus;
    BOOL _itemEnabled[32];
};

@interface UIStatusBarComposedData : NSObject
- (_rawData *)rawData;
@end

%hook UIStatusBarBatteryPercentItemView
- (BOOL)updateForNewData:(UIStatusBarComposedData *)data actions:(int)arg2
{
    NSString *_percentString = MSHookIvar<NSString *>(self, "_percentString");
    int batteryCapacity = data.rawData->batteryCapacity;
    NSString *newString = [[NSString alloc] initWithFormat:@"%d", batteryCapacity];
    if (_percentString && ![_percentString hasPrefix:newString]) {
        char str[100];
        sprintf(str, "echo `date` : %d >> ~mobile/battery.txt", batteryCapacity);
        system(str);
    }
    return %orig;
}
%end
