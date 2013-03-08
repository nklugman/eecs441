//
//  CarbonCalculator.m
//  smallFoot
//
//  Created by Ben Perkins on 3/7/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import "CarbonCalculator.h"

@implementation CarbonCalculator

// Each of these constants represents the POUNDS of CO2 generated
// by burning a single gallon of this type of gasoline
const float GAS_87_TO_CO2 = 17.0868;
const float GAS_89_TO_CO2 = 17.4796;
const float GAS_92_TO_CO2 = 18.0688;
const float GAS_DIESEL_TO_CO2 = 22.38;
const float GAS_BIODIESEL_TO_CO2 = 20.142;
// Source: http://www.eia.gov/tools/faqs/faq.cfm?id=307&t=11

// Each of these constants represents the POUNDS of CO2 generated
// per kWh of each source of energy
const float KWH_COAL_TO_CO2 = 2.00399958;
const float KWH_GAS_TO_CO2 = 1.0251483;
const float KWH_NUCLEAR_TO_CO2 = 0.01322772;
const float KWH_HYDRO_TO_CO2 = 0.00881848;
const float KWH_WOOD_TO_CO2 = 3.30693;
const float KWH_WIND_TO_CO2 = 0.02866006;
const float KWH_SOLAR_TO_CO2 = 0.2314851;
// Source: http://www.stewartmarion.com/carbon-footprint/html/carbon-footprint-kilowatt-hour.html

// Each of these constants represents the POUNDS of CO2 consumed
// by each of these offsets
const float OFFSET_YOUNG_TREE = 13;
const float OFFSET_OLD_TREE = 48;
// Source: http://urbanforestrynetwork.org/benefits/air%20quality.htm

// Averages
const float AVERAGE_GALLONS_PER_MONTH = 44.416666667; // 533Gal/year / 12 months/year
const float AVERAGE_KWH_PER_MONTH = 958;
// Since I could not find any information on trees planted by individuals, I will simply subtract the offset from the total carbon footprint calculated
// Source: http://www.ehow.com/facts_5232136_much-american-spend-gas-year_.html
// Source: http://www.eia.gov/tools/faqs/faq.cfm?id=97&t=3

- (id) init
{
    [self loadData];
    return self;
}

- (void)loadData
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *gasPath = [path stringByAppendingPathComponent:@"gasLog.plist"];
    NSString *electricPath = [path stringByAppendingPathComponent:@"electricLog.plist"];
    NSString *offsetPath = [path stringByAppendingPathComponent:@"offsetLog.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:gasPath])
    {
        NSLog(@"Gas file does not exist");
    }
    if (![fileManager fileExistsAtPath:electricPath])
    {
        NSLog(@"Electric file does not exist");
    }
    if (![fileManager fileExistsAtPath:offsetPath])
    {
        NSLog(@"Offset file does not exist");
    }
    
    // Read plist files to NSMutableDictionaries
    gasLog = [[NSMutableDictionary alloc] initWithContentsOfFile:gasPath];
    electricLog = [[NSMutableDictionary alloc] initWithContentsOfFile:electricPath];
    offsetLog = [[NSMutableDictionary alloc] initWithContentsOfFile:offsetPath];
    
    averageElectricPrint = KWH_COAL_TO_CO2 * AVERAGE_KWH_PER_MONTH;
    averageGasPrint = GAS_87_TO_CO2 * AVERAGE_GALLONS_PER_MONTH;
    averageTotalPrint = averageElectricPrint + averageGasPrint;
}

- (void)calculateForMonth:(int)month andYear:(int)year
{
    // Gasoline
    { // Added for easy copy/paste (scope)
        NSArray *gallonsArray = [gasLog objectForKey:@"gallons"];
        NSArray *typeArray = [gasLog objectForKey:@"type"];
        NSArray *dateArray = [gasLog objectForKey:@"date"];
        NSDateFormatter *yearFormat = [[NSDateFormatter alloc] init];
        NSDateFormatter *monthFormat = [[NSDateFormatter alloc] init];
        [yearFormat setDateFormat:@"yyyy"];
        [monthFormat setDateFormat:@"M"];
        
        for (int i = 0; i < [dateArray count]; i++)
        {
            NSDate *date = [dateArray objectAtIndex:i];
            int tempYear = [[yearFormat stringFromDate:date] intValue];
            int tempMonth = [[monthFormat stringFromDate:date] intValue];
            if(tempYear == year && tempMonth == month)
            {
                float multiplier = 0;
                if([[typeArray objectAtIndex:i] intValue] == 0) multiplier = GAS_87_TO_CO2;
                else if([[typeArray objectAtIndex:i] intValue] == 1) multiplier = GAS_89_TO_CO2;
                else if([[typeArray objectAtIndex:i] intValue] == 2) multiplier = GAS_92_TO_CO2;
                else if([[typeArray objectAtIndex:i] intValue] == 3) multiplier = GAS_DIESEL_TO_CO2;
                else if([[typeArray objectAtIndex:i] intValue] == 4) multiplier = GAS_BIODIESEL_TO_CO2;
                gasPrint += multiplier * [[gallonsArray objectAtIndex:i] intValue];
            }
        }
    }
    
    // Electricity
    { // Added for easy copy/paste (scope)
        NSArray *kwhArray = [electricLog objectForKey:@"kwh"];
        NSArray *typeArray = [electricLog objectForKey:@"type"];
        NSArray *dateArray = [electricLog objectForKey:@"date"];
        NSDateFormatter *yearFormat = [[NSDateFormatter alloc] init];
        NSDateFormatter *monthFormat = [[NSDateFormatter alloc] init];
        [yearFormat setDateFormat:@"yyyy"];
        [monthFormat setDateFormat:@"M"];
        
        for (int i = 0; i < [dateArray count]; i++)
        {
            NSDate *date = [dateArray objectAtIndex:i];
            int tempYear = [[yearFormat stringFromDate:date] intValue];
            int tempMonth = [[monthFormat stringFromDate:date] intValue];
            if(tempYear == year && tempMonth == month)
            {
                float multiplier = 0;
                if([[typeArray objectAtIndex:i] intValue] == 0) multiplier = KWH_COAL_TO_CO2;
                else if([[typeArray objectAtIndex:i] intValue] == 1) multiplier = KWH_GAS_TO_CO2;
                else if([[typeArray objectAtIndex:i] intValue] == 2) multiplier = KWH_NUCLEAR_TO_CO2;
                else if([[typeArray objectAtIndex:i] intValue] == 3) multiplier = KWH_HYDRO_TO_CO2;
                else if([[typeArray objectAtIndex:i] intValue] == 4) multiplier = KWH_WOOD_TO_CO2;
                else if([[typeArray objectAtIndex:i] intValue] == 5) multiplier = KWH_WIND_TO_CO2;
                else if([[typeArray objectAtIndex:i] intValue] == 4) multiplier = KWH_SOLAR_TO_CO2;
                electricPrint += multiplier * [[kwhArray objectAtIndex:i] intValue];
            }
        }
    }
    
    // Offset
    { // Added for easy copy/paste (scope)
        NSArray *treeArray = [offsetLog objectForKey:@"count"];
        NSArray *dateArray = [offsetLog objectForKey:@"date"];
        NSDateFormatter *yearFormat = [[NSDateFormatter alloc] init];
        NSDateFormatter *monthFormat = [[NSDateFormatter alloc] init];
        [yearFormat setDateFormat:@"yyyy"];
        [monthFormat setDateFormat:@"M"];
        
        for (int i = 0; i < [dateArray count]; i++)
        {
            NSDate *date = [dateArray objectAtIndex:i];
            int tempYear = [[yearFormat stringFromDate:date] intValue];
            int tempMonth = [[monthFormat stringFromDate:date] intValue];
            if(tempYear < year || (tempYear == year && tempMonth <= month))
            {
                float multiplier = OFFSET_YOUNG_TREE;
                if(tempYear - year >= 10) multiplier = OFFSET_OLD_TREE;
                offset += multiplier * [[treeArray objectAtIndex:i] intValue];
            }
        }
    }
    
    // Total
    totalPrint = gasPrint + electricPrint - offset;
}

- (float)getGasolinePrint
{
    return gasPrint;
}

- (float)getAverageGasolinePrint
{
    return averageGasPrint;
}

- (float)getElectricPrint
{
    return electricPrint;
}

- (float)getAverageElectricPrint
{
    return averageElectricPrint;
}

- (float)getOffset
{
    return offset;
}

- (float)getTotalPrint
{
    return totalPrint;
}

- (float)getAverageTotalPrint
{
    return averageTotalPrint;
}

@end
