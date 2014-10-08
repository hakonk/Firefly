/**
 This class has libpd related properties and is
 intended to be used as a singleton object. Thus,
 most of the pd related stuff can be handled with this object.
 
 Håkon Knutzen 2014, Robin, Department of Informatics, University of Oslo
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
