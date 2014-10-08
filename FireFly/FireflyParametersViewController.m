/*
 FireflyParametersViewController.m
 
 View controller, parameters
 
 Håkon Knutzen 2014, Robin, Department of Informatics, University of Oslo

 */

#import "FireflyParametersViewController.h"
#import "Puredata.h"

@interface FireflyParametersViewController ()

@property (weak, nonatomic) IBOutlet UILabel *pccLabel;
@property (weak, nonatomic) IBOutlet UILabel *thresholdLabel;
@property (weak, nonatomic) IBOutlet UISlider *pccSlider;
@property (weak, nonatomic) IBOutlet UISlider *thresholdSlider;
@property (weak, nonatomic) IBOutlet UISwitch *deafSwitch;
@property (weak, nonatomic) IBOutlet UISlider *deafPeriodSlider;
@property (weak, nonatomic) IBOutlet UILabel *deafPeriodLabel;
@property (weak, nonatomic) IBOutlet UILabel *bonkInputLabel;
@property(nonatomic,strong)NSNotificationCenter *listener;
@end

@implementation FireflyParametersViewController

#pragma mark - Methods invoked by UI
- (IBAction)thresholdAction:(UISlider *)sender {
    float sVal=roundf(sender.value*100)/100;
    self.thresholdLabel.text = [NSString stringWithFormat:@"Set %.2f",sVal];
    Puredata *pd = [Puredata sharedPuredata];
    [pd setValueInPd:sVal forKey:@"thresholdFromUI"];
}

- (IBAction)pccAction:(UISlider *)sender {
    float sVal=roundf(sender.value*100)/100;
    self.pccLabel.text = [NSString stringWithFormat:@"%.2f",sVal];
    Puredata *pd = [Puredata sharedPuredata];
    [pd setValueInPd:sVal forKey:@"pccFromUI"];
}
- (IBAction)deafSliderAction:(UISlider *)sender {
    float sVal=roundf(sender.value*100)/100;
    self.deafPeriodLabel.text=[NSString stringWithFormat:@"%.2f ms",sVal];
    Puredata *pd=[Puredata sharedPuredata];
    [pd setValueInPd:sVal forKey:@"deafPeriodFromUI"];
}
- (IBAction)deafEnableAction:(UISwitch *)sender {
    int sendVal=(sender.on)?1:0;
    Puredata *pd=[Puredata sharedPuredata];
    [pd setValueInPd:sendVal forKey:@"enableDeaf"];
}

#pragma mark - Method for assigning values from pd patch to elements in the UI

// handles the values that are received from pd as a list
-(void)setValuesFromPd:(NSNotification *)notification
{
    NSEnumerator *received = [(NSMutableDictionary *)[notification object] keyEnumerator];
    NSString *key;
    while (key = [received nextObject]) {
        if ([key isEqualToString:@"pcc"]) {
            float pccVal = [(NSNumber *)[(NSMutableDictionary *)[notification object] valueForKey:key] floatValue];
            self.pccSlider.value = pccVal;
            self.pccLabel.text = [NSString stringWithFormat:@"%.2f",pccVal];
        }
        if ([key isEqualToString:@"threshold"]) {
            float threshold = [(NSNumber *)[(NSMutableDictionary *)[notification object] valueForKey:key] floatValue];
            self.thresholdSlider.value = threshold;
            self.thresholdLabel.text = [NSString stringWithFormat:@"Set %.2f",threshold];
        }
        if ([key isEqualToString:@"deafPeriod"]){
            float deafPeriod=[(NSNumber *)[(NSMutableDictionary *)[notification object] valueForKey:key] floatValue];
            self.deafPeriodSlider.value=deafPeriod;
            self.deafPeriodLabel.text=[NSString stringWithFormat:@"%.2f ms",deafPeriod];
        }
        if([key isEqualToString:@"deafEnable"]){
            int deafEnable=(int)[(NSNumber *)[(NSMutableDictionary *)[notification object] valueForKey:key] integerValue];
            self.deafSwitch.on=(deafEnable==1) ? YES:NO;
        }
    }
}
// handles values that are received from the pd onset detection
-(void)setBonkInput:(NSNotification *)notification
{
    float received=[[notification object] floatValue];
    self.bonkInputLabel.text=[NSString stringWithFormat:@"Detected: %.2f",received];
}


#pragma mark - Life cycle related
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.listener removeObserver:self];
    self.listener = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.listener = [NSNotificationCenter defaultCenter];
    // adding listeners to "send objects" in pd
    [self.listener addObserver:self
                      selector:@selector(setValuesFromPd:)
                          name:@"fireflyParameters"
                        object:nil];
    [self.listener addObserver:self
                       selector:@selector(setBonkInput:)
                           name:@"bonkInput"
                         object:nil];
    // "poll" pd by sending a bang to the receiver "getParameters"
    Puredata *pd = (Puredata *)[Puredata sharedPuredata];
    [pd sendBangToReceiver:@"getParameters"];
}




#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    return 3;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    // Return the number of rows in the section.
//    return 1;
//}

@end
