//
//  FireflyViewController.m
//  FireFly
//
//  Created by Håkon on 15/08/14.
//  Copyright (c) 2014 Robin. All rights reserved.
//

#import "FireflyViewController.h"
#import "Puredata.h"
#define IS_TALL (self.view.bounds.size.height == 568.0)
#define IS_IPHONE ([[UIDevice currentDevice].model isEqualToString:@"iPhone"])
#define IS_IPOD ([[UIDevice currentDevice].model isEqualToString:@"iPod touch"])
#define IS_SIMULATOR ([[UIDevice currentDevice].model isEqualToString:@"iPhone Simulator"])
#define IS_SIMULATOR_4 (IS_SIMULATOR && !IS_TALL)
#define IS_SIMULATOR_5 (IS_SIMULATOR && IS_TALL)
#define IS_IPHONE5 (IS_TALL && IS_IPHONE)
#define IS_IPHONE4 (IS_IPHONE && !IS_TALL)

@interface FireflyViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *background;
@property(strong,nonatomic)NSArray *flyArray;
@property(strong,nonatomic)NSTimer *timer;

@end

@implementation FireflyViewController



-(NSArray *)flyArray
{
    NSString *path = [[NSBundle mainBundle] resourcePath];
    if (!_flyArray) {
        if (IS_IPHONE5 || IS_SIMULATOR_5 || IS_IPOD) {
            UIImage *on = [UIImage imageWithContentsOfFile: [NSString stringWithFormat:@"%@/FF_tall_off.png",path]];
            UIImage *off = [UIImage imageWithContentsOfFile: [NSString stringWithFormat:@"%@/FF_tall_on.png",path]];
            _flyArray = [[NSArray alloc] initWithObjects:on,off, nil];
        }
        else if (IS_IPHONE4 || IS_SIMULATOR_4) {
            UIImage *on = [UIImage imageWithContentsOfFile: [NSString stringWithFormat:@"%@/FFoff.png",path]];
            UIImage *off = [UIImage imageWithContentsOfFile: [NSString stringWithFormat:@"%@/FFon.png",path]];
            _flyArray = [[NSArray alloc] initWithObjects:on, off, nil];
        }
        else
            _flyArray = nil;
    }
    return _flyArray;
}


-(void)changePicture
{
    int test = ((int)[self.flyArray indexOfObject:self.background.image]+1)%2;
    self.background.image = [self.flyArray objectAtIndex:test];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    Puredata *pd = (Puredata *)[Puredata sharedPuredata];
    [pd openPatch:@"newFirefly.pd"];
    [pd.audioController setActive:YES];
    //self.background.image = [self.flyArray objectAtIndex:1];
    //self.timer = [NSTimer scheduledTimerWithTimeInterval:1. target:self selector:@selector(changePicture) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
