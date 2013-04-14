//
//  CPDStockPriceStore.m
//  CorePlotDemo
//


#import "CPDStockPriceStore.h"

@interface CPDStockPriceStore ()


@end

@implementation CPDStockPriceStore

#pragma mark - Class methods

+ (CPDStockPriceStore *)sharedInstance
{
    static CPDStockPriceStore *sharedInstance;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];      
    });
    
    return sharedInstance;
}

#pragma mark - API methods

- (NSArray *)tickerSymbols
{
    static NSArray *symbols = nil;
    if (!symbols)
    {
        symbols = [NSArray arrayWithObjects:
                   @"AAPL", 
                   nil];
    }
    return symbols;
}

- (NSArray *)dailyPortfolioPrices
{
    static NSArray *prices = nil;
    if (!prices)
    {
        prices = [NSArray arrayWithObjects:
                  [NSDecimalNumber numberWithFloat:582.13], 
                  [NSDecimalNumber numberWithFloat:604.43], 
                  [NSDecimalNumber numberWithFloat:32.01], 
                  nil];
    }
    return prices;
}

- (NSArray *)datesInWeek
{
    static NSArray *dates = nil;
    if (!dates)
    {
        dates = [NSArray arrayWithObjects:
                 @"4/23", 
                 @"4/24", 
                 @"4/25",
                 @"4/26", 
                 @"4/27",                   
                 nil];
    }
    return dates;
}

- (NSArray *)weeklyPrices:(NSString *)tickerSymbol
{

        return [self weeklyAaplPrices];

}

- (NSArray *)datesInMonth
{
    static NSArray *dates = nil;
    if (!dates)
    {
        dates = [NSArray arrayWithObjects:
                 @"2", 
                 @"3", 
                 @"4",
                 @"5",
                 @"9", 
                 @"10", 
                 @"11",
                 @"12", 
                 @"13",
                 @"16", 
                 @"17", 
                 @"18",
                 @"19", 
                 @"20", 
                 @"23", 
                 @"24", 
                 @"25",
                 @"26", 
                 @"27",
                 @"30",                   
                 nil];
    }
    return dates;
}

- (NSArray *)monthlyPrices:(NSString *)tickerSymbol
{

    return [self monthlyAaplPrices];
}

#pragma mark - Private behavior

- (NSArray *)weeklyAaplPrices
{
    static NSArray *prices = nil;
    if (!prices)
    {
        prices = [NSArray arrayWithObjects:
                  [NSDecimalNumber numberWithFloat:571.70], 
                  [NSDecimalNumber numberWithFloat:560.28], 
                  [NSDecimalNumber numberWithFloat:610.00], 
                  [NSDecimalNumber numberWithFloat:607.70], 
                  [NSDecimalNumber numberWithFloat:603.00],                   
                  nil];
    }
    return prices;
}

- (NSArray *)monthlyAaplPrices
{
    static NSArray *prices = nil;
    if (!prices)
    {
        prices = [NSArray arrayWithObjects:
                  [NSDecimalNumber numberWithFloat:618.63], 
                  [NSDecimalNumber numberWithFloat:629.32], 
                  [NSDecimalNumber numberWithFloat:624.31], 
                  [NSDecimalNumber numberWithFloat:633.68], 
                  [NSDecimalNumber numberWithFloat:636.23], 
                  [NSDecimalNumber numberWithFloat:628.44], 
                  [NSDecimalNumber numberWithFloat:626.20], 
                  [NSDecimalNumber numberWithFloat:622.77], 
                  [NSDecimalNumber numberWithFloat:605.23],
                  [NSDecimalNumber numberWithFloat:580.13], 
                  [NSDecimalNumber numberWithFloat:609.70], 
                  [NSDecimalNumber numberWithFloat:608.34], 
                  [NSDecimalNumber numberWithFloat:587.44], 
                  [NSDecimalNumber numberWithFloat:572.98],
                  [NSDecimalNumber numberWithFloat:571.70], 
                  [NSDecimalNumber numberWithFloat:560.28], 
                  [NSDecimalNumber numberWithFloat:610.00], 
                  [NSDecimalNumber numberWithFloat:607.70], 
                  [NSDecimalNumber numberWithFloat:603.00],
                  [NSDecimalNumber numberWithFloat:583.98],                  
                  nil];
    }
    return prices;
}




@end
