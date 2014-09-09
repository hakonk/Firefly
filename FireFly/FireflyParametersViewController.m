/*
 FireflyParametersViewController.m
 
 View controller, parameters
 
 Håkon Knutzen, Robin, ifi, UIO 2014
 
 */

#import "FireflyParametersViewController.h"
#import "Puredata.h"

@interface FireflyParametersViewController ()

@property (weak, nonatomic) IBOutlet UILabel *pccLabel;
@property (weak, nonatomic) IBOutlet UILabel *thresholdLabel;
@property (weak, nonatomic) IBOutlet UISlider *pccSlider;
@property (weak, nonatomic) IBOutlet UISlider *thresholdSlider;
@property(nonatomic,strong)NSNotificationCenter *listener;
@end

@implementation FireflyParametersViewController

- (IBAction)thresholdAction:(UISlider *)sender {
    self.thresholdLabel.text = [NSString stringWithFormat:@"Threshold: %.2f",sender.value];
    Puredata *pd = [Puredata sharedPuredata];
    [pd setValueInPd:sender.value forKey:@"thresholdFromUI"];
}

- (IBAction)pccAction:(UISlider *)sender {
    self.pccLabel.text = [NSString stringWithFormat:@"PCC: %.2f",sender.value];
    Puredata *pd = [Puredata sharedPuredata];
    [pd setValueInPd:sender.value forKey:@"pccFromUI"];
}

-(void)setValuesFromPd:(NSNotification *)notification
{
    NSEnumerator *received = [(NSMutableDictionary *)[notification object] keyEnumerator];
    NSString *key;
    while (key = [received nextObject]) {
        if ([key isEqualToString:@"pcc"]) {
            float pccVal = [(NSNumber *)[(NSMutableDictionary *)[notification object] valueForKey:key] floatValue];
            self.pccSlider.value = pccVal;
            self.pccLabel.text = [NSString stringWithFormat:@"PCC: %.2f",pccVal];
        }
        if ([key isEqualToString:@"threshold"]) {
            float threshold = [(NSNumber *)[(NSMutableDictionary *)[notification object] valueForKey:key] floatValue];
            self.thresholdSlider.value = threshold;
            self.thresholdLabel.text = [NSString stringWithFormat:@"Threshold: %.2f",threshold];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.listener = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.listener = [NSNotificationCenter defaultCenter];
    [self.listener addObserver:self
                      selector:@selector(setValuesFromPd:)
                          name:@"fireflyParameters"
                        object:nil];
    Puredata *pd = (Puredata *)[Puredata sharedPuredata];
    [pd sendBangToReceiver:@"getParameters"];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

@end
