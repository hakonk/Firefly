/*
 Puredata.m
 
 This class has pd related properties and is
 intended to be used as a singleton object. Thus,
 most of the pd related stuff is contained within one object
 
 Håkon Knutzen, Robin, ifi, UIO 2014
 
 */

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

// sets up pd and adds listeners to send objects in the patch
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

/* 
 the method below parses a list from pd and creates a dictionary that is sorted 
 in key/value pairs corresponding to the key/value pairs in the list in pd.
 The list is broadcasted using a notification that view controllers can listen to.
 */
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

// broadcasts messages when onsets are detected such that FireflyViewController can toggle images
-(void)receiveFloat:(float)received fromSource:(NSString *)source
{
    if ([source isEqualToString:@"fromPd"]) {
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotificationName:@"screenUpdate"
                                          object:@(received)];
    }
}



@end
