//
//  RSSTableHeaderView.h
//  smallFoot
//
//  Created by Noah Klugman on 4/10/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableHeaderView : UIImageView
- (id)initWithText:(NSString*)text;
- (void)setText:(NSString*)text;
@end