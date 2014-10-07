/*
 Puredata.h
 
 This class has pd related properties and is
 intended to be used as a singleton object. Thus,
 most of the pd related stuff can be handled with one object
 
 Håkon Knutzen, Robin, ifi, UIO 2014
 
 */

#import <Foundation/Foundation.h>
#import "PdBase.h"
#import "PdAudioController.h"
#import "PdDispatcher.h"


@interface Puredata : NSObject <PdListener>
@property(nonatomic,strong)PdAudioController *audioController;
@property(nonatomic,strong)PdDispatcher *dispatcher;
+(id)sharedPuredata;
-(void)openPatch:(NSString *)patchName;
-(void)sendBangToReceiver:(NSString *)receiver;

// supply an array of strings that correponds to the send objects of patch
//-(void)addListenerKeys:(NSArray *)array;
-(void)setValueInPd:(float)value forKey:(NSString *)key;


@end
