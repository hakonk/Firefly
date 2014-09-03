//
//  Puredata.m
//  FireFly
//
//  Created by Håkon on 03/09/14.
//  Copyright (c) 2014 Robin. All rights reserved.
//

#import "Puredata.h"

@implementation Puredata

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
    }
    return self;
}



@end
