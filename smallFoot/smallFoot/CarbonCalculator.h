//
//  CarbonCalculator.h
//  smallFoot
//
//  Created by Ben Perkins on 3/7/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarbonCalculator : NSObject
{
    NSMutableDictionary *gasLog;
    NSMutableDictionary *electricLog;
    NSMutableDictionary *offsetLog;
    
    float gasPrint;
    float averageGasPrint;
    float electricPrint;
    float averageElectricPrint;
    float offset;
    float totalPrint;
    float averageTotalPrint;
}

// Each of these constants represents the POUNDS of CO2 generated
// by burning a single gallon of this type of gasoline
extern const float GAS_87_TO_CO2;
extern const float GAS_89_TO_CO2;
extern const float GAS_92_TO_CO2;
extern const float GAS_DIESEL_TO_CO2;
extern const float GAS_BIODIESEL_TO_CO2;

// Each of these constants represents the POUNDS of CO2 generated
// per kWh of each source of energy
extern const float KWH_COAL_TO_CO2;
extern const float KWH_GAS_TO_CO2;
extern const float KWH_NUCLEAR_TO_CO2;
extern const float KWH_HYDRO_TO_CO2;
extern const float KWH_WOOD_TO_CO2;
extern const float KWH_WIND_TO_CO2;
extern const float KWH_SOLAR_TO_CO2;

// Each of these constants represents the POUNDS of CO2 consumed
// by each of these offsets
extern const float OFFSET_YOUNG_TREE;
extern const float OFFSET_OLD_TREE;

// Averages
extern const float AVERAGE_GALLONS_PER_MONTH;
extern const float AVERAGE_KWH_PER_MONTH;

- (void)loadData;
- (void)calculateForMonth:(int)month andYear:(int)year;
- (float)getGasolinePrint;
- (float)getAverageGasolinePrint;
- (float)getElectricPrint;
- (float)getAverageElectricPrint;
- (float)getOffset;
- (float)getTotalPrint;
- (float)getAverageTotalPrint;

@end
