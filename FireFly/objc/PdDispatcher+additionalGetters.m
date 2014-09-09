/*
 category intended to provide additional getters
 e.g. all subscribed listener names
 
 Håkon Knutzen, Robin, ifi, UIO 2014

 */
#import "PdDispatcher+additionalGetters.h"

@implementation PdDispatcher (additionalGetters)
-(NSEnumerator *)subscriptionKeys
{
    return [[subscriptions allKeys] objectEnumerator];
}

@end
