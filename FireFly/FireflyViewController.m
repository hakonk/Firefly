/*
 FireflyViewController.m
 
 View controller, main window
 
 Håkon Knutzen 2014, Robin, Department of Informatics, University of Oslo
 
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
#pragma mark - Lazy instantiation
// lazy instantiation of array holding the two firefly images, image files for iphone 6 and iphone 6 plus not included yet
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
            // import image files here
        }
        else if(IS_SIXPLUS_RES){
            // import image files here
        }
        else
            _flyArray = nil;
    }
    return _flyArray;
}
#pragma mark - Selector methods
// toggling the navigation bar, invoked upon recognition of single tap
- (void)tappedScreen:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded)
        [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden
                                                 animated:YES];
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
#pragma mark - Life cycle related
// called in view did load. configuration of view, gesture recognizers, tab bar, pd
-(void)configureViewAndPd
{
    // toggle activity indicator on
    [self.activityIndicator startAnimating];
    // assign gesture recognizer
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(tappedScreen:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    // set initial background image
    self.background.image = [[self.flyArray objectAtIndex:0] copy];
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    [self.navigationController setNavigationBarHidden:YES
                                             animated:NO];
    // open patch on other queue
    dispatch_queue_t pdqueue= dispatch_queue_create("PD_QUEUE", NULL);
    dispatch_async(pdqueue, ^{
        Puredata *pd = (Puredata *)[Puredata sharedPuredata];
        [pd openPatch:@"newFirefly.pd"];
        [pd.audioController setActive:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            // toggle activity indicator off on main queue
            __weak FireflyViewController *weakSelf = self;
            [weakSelf.activityIndicator stopAnimating];
        });
    });
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

// remove listener when view controller is disappearing
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.listener removeObserver:self];
    self.listener = nil;
    self.flyArray=nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureViewAndPd];
}


@end
