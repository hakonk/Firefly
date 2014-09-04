//
//  PdDispatcher+additionalGetters.m
//  FireFly
//
//  Created by Håkon on 04/09/14.
//  Copyright (c) 2014 Robin. All rights reserved.
//

#import "PdDispatcher+additionalGetters.h"

@implementation PdDispatcher (additionalGetters)
-(NSEnumerator *)subscriptionKeys
{
    return [[subscriptions allKeys] objectEnumerator];
}

@end
