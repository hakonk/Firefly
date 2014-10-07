/*
 FireflyViewController.m
 
 View controller, main window
 
 Håkon Knutzen, Robin, ifi, UIO 2014
 
 */

#import "FireflyViewController.h"
#import "FireflyParametersViewController.h"
#import "Puredata.h"
#define IS_FOUR_RES ((int)self.view.bounds.size.height==480)
#define IS_FIVE_RES ((int)self.view.bounds.size.height==568)
#define IS_SIX_RES ((int)self.view.bounds.size.height==667)
#define IS_SIXPLUS_RES ((int)self.view.bounds.size.height==736)

@interface FireflyViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *background;
@property(strong,nonatomic)NSArray *flyArray;
@property(nonatomic,strong)NSNotificationCenter *listener;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation FireflyViewController

// toggle tab bar visible
- (void)tappedScreen:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded)
        [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden
                                                 animated:YES];
}

// lazy instantiation of array holding the two firefly images
-(NSArray *)flyArray
{
    NSString *path = [[NSBundle mainBundle] resourcePath];
    if (!_flyArray) {
        if (IS_FIVE_RES) {
            UIImage *on = [UIImage imageWithContentsOfFile: [NSString stringWithFormat:@"%@/FF_tall_off@2x.png",path]];
            UIImage *off = [UIImage imageWithContentsOfFile: [NSString stringWithFormat:@"%@/FF_tall_on@2x.png",path]];
            _flyArray = [[NSArray alloc] initWithObjects:on,off, nil];
        }
        else if (IS_FOUR_RES) {
            UIImage *on = [UIImage imageWithContentsOfFile: [NSString stringWithFormat:@"%@/FFoff@2x.png",path]];
            UIImage *off = [UIImage imageWithContentsOfFile: [NSString stringWithFormat:@"%@/FFon@2x.png",path]];
            _flyArray = [[NSArray alloc] initWithObjects:on, off, nil];
        }
        else if(IS_SIX_RES){
            
        }
        else if(IS_SIXPLUS_RES){
            
        }
        else
            _flyArray = nil;
    }
    return _flyArray;
}

//setting the view controller up to listen to messages from pd that are broadcasted from the Puredata singleton object
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.listener = [NSNotificationCenter defaultCenter];
    [self.listener addObserver:self
                      selector:@selector(changePicture:)
                          name:@"screenUpdate"
                        object:nil];
}

// remove listener when disappearing
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.listener removeObserver:self];
    self.listener = nil;
    self.flyArray=nil;
}

// method for changing between active and passive firefly
-(void)changePicture:(NSNotification *)notification
{
    int index = [[notification object] isKindOfClass:[NSNumber class]] ? (int)[[notification object] integerValue] : -1;
    if (index==0 || index==1)
        self.background.image = [[self.flyArray objectAtIndex:index] copy];
    else
        NSLog(@"Background image error: Value from pd not a number or out of array bounds");
}

// called in view did load. configuration of view, gesture recognizers, tab bar, pd
-(void)configureViewAndPd
{
    [self.activityIndicator startAnimating];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(tappedScreen:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    self.background.image = [[self.flyArray objectAtIndex:0] copy];
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    [self.navigationController setNavigationBarHidden:YES
                                             animated:NO];
    dispatch_queue_t pdqueue= dispatch_queue_create("PD_QUEUE", NULL);
    dispatch_async(pdqueue, ^{
        Puredata *pd = (Puredata *)[Puredata sharedPuredata];
        [pd openPatch:@"newFirefly.pd"];
        [pd.audioController setActive:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            // avoid retain cycle by assigning self to a weak pointer before passing it to the block
            __weak FireflyViewController *weakSelf = self;
            [weakSelf.activityIndicator stopAnimating];
        });
    });
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureViewAndPd];
}


@end
