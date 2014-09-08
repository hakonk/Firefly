//
//  Puredata.m
//  FireFly
//
//  Created by Håkon on 03/09/14.
//  Copyright (c) 2014 Robin. All rights reserved.
//

#import "Puredata.h"
#import "PdDispatcher+additionalGetters.h"


@implementation Puredata

-(void)setValueInPd:(float)value forKey:(NSString *)key
{
    [PdBase sendFloat:value toReceiver:key];
}

-(void)openPatch:(NSString *)patchName
{
    [PdBase openFile:patchName
                path:[[NSBundle mainBundle] resourcePath]];
}

+(id)sharedPuredata
{
    static Puredata *sharedPuredata = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPuredata = [[self alloc] init];
    });
    return sharedPuredata;
}

-(void)sendBangToReceiver:(NSString *)receiver
{
    [PdBase sendBangToReceiver:receiver];
}

void bonk_tilde_setup();

-(id)init {
    if (self = [super init]) {
        self.audioController = [[PdAudioController alloc] init];
        [self.audioController configurePlaybackWithSampleRate:44100
                                               numberChannels:2
                                                 inputEnabled:YES
                                                mixingEnabled:YES];
        bonk_tilde_setup();
        self.dispatcher = [[PdDispatcher alloc] init];
        [PdBase setDelegate:self.dispatcher];
        [self.dispatcher addListener:self
                           forSource:@"fromPd"];
        [self.dispatcher addListener:self
                           forSource:@"listFromPd"];
    }
    return self;
}

// creates a dictionary that is sorted in key/value pairs corresponding to the list in pd
-(void)receiveList:(NSArray *)list fromSource:(NSString *)source
{
    if ([source isEqualToString:@"listFromPd"] && [list count] > 1) {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        for (int i=0;i<[list count];i+=2)
            [dictionary setObject:[list objectAtIndex:i+1] forKey:[list objectAtIndex:i]];
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotificationName:@"fireflyParameters"
                                              object:dictionary];
    }
    else
        NSLog(@"Unrecognized sender or list from pd does not contain even a single key/value pair");
}

// make this information available to objects that are listeners to a corresponding NSNotification
-(void)receiveFloat:(float)received fromSource:(NSString *)source
{
    if ([source isEqualToString:@"fromPd"]) {
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotificationName:@"screenUpdate"
                                          object:@(received)];
    }
    
}



@end
