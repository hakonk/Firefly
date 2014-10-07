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
@property (weak, nonatomic) IBOutlet UISwitch *deafSwitch;
@property (weak, nonatomic) IBOutlet UILabel *deafEnabledLabel;
@property (weak, nonatomic) IBOutlet UISlider *deafPeriodSlider;
@property (weak, nonatomic) IBOutlet UILabel *deafPeriodLabel;
@property (weak, nonatomic) IBOutlet UILabel *bonkInputLabel;
@property(nonatomic,strong)NSNotificationCenter *listener;
@end

@implementation FireflyParametersViewController

- (IBAction)thresholdAction:(UISlider *)sender {
    self.thresholdLabel.text = [NSString stringWithFormat:@"Set %.2f",sender.value];
    Puredata *pd = [Puredata sharedPuredata];
    [pd setValueInPd:sender.value forKey:@"thresholdFromUI"];
}

- (IBAction)pccAction:(UISlider *)sender {
    self.pccLabel.text = [NSString stringWithFormat:@"%.2f",sender.value];
    Puredata *pd = [Puredata sharedPuredata];
    [pd setValueInPd:sender.value forKey:@"pccFromUI"];
}
- (IBAction)deafSliderAction:(UISlider *)sender {
    self.deafPeriodLabel.text=[NSString stringWithFormat:@"%.2f ms",sender.value];
    Puredata *pd=[Puredata sharedPuredata];
    [pd setValueInPd:sender.value forKey:@"deafPeriodFromUI"];
}
- (IBAction)deafEnableAction:(UISwitch *)sender {
    int sendVal=(sender.on)?1:0;
    self.deafEnabledLabel.text=(sender.on)?@"Enabled":@"Disabled";
    Puredata *pd=[Puredata sharedPuredata];
    [pd setValueInPd:sendVal forKey:@"enableDeaf"];
}

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
            self.deafPeriodLabel.text=[NSString stringWithFormat:@"Period %.2f",deafPeriod];
        }
        if([key isEqualToString:@"deafEnable"]){
            int deafEnable=(int)[(NSNumber *)[(NSMutableDictionary *)[notification object] valueForKey:key] integerValue];
            self.deafEnabledLabel.text=(deafEnable==1) ? @"Enabled":@"Disabled";
            self.deafSwitch.on=(deafEnable==1) ? YES:NO;
        }
    }
}

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
    [self.listener addObserver:self
                      selector:@selector(setValuesFromPd:)
                          name:@"fireflyParameters"
                        object:nil];
    [self.listener addObserver:self
                       selector:@selector(setBonkInput:)
                           name:@"bonkInput"
                         object:nil];
    Puredata *pd = (Puredata *)[Puredata sharedPuredata];
    [pd sendBangToReceiver:@"getParameters"];
}

-(void)setBonkInput:(NSNotification *)notification
{
    float received=[[notification object] floatValue];
    self.bonkInputLabel.text=[NSString stringWithFormat:@"Detected: %.2f",received];
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
