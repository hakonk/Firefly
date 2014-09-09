/*
 category intended to provide additional getters
 e.g. all subscribed listener names
 
 Håkon Knutzen, Robin, ifi, UIO 2014
 
 */

#import "PdDispatcher.h"

@interface PdDispatcher (additionalGetters)

-(NSEnumerator *)subscriptionKeys;


@end
