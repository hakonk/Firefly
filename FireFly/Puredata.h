//
//  Puredata.h
//  FireFly
//
//  Created by Håkon on 03/09/14.
//  Copyright (c) 2014 Robin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PdBase.h"
#import "PdAudioController.h"
#import "PdDispatcher.h"

@interface Puredata : NSObject
@property(nonatomic,strong)PdAudioController *audioController;
@property(nonatomic,strong)PdDispatcher *dispatcher;
+(id)sharedPuredata;
-(void)openPatch:(NSString *)patchName;
@end
