//
//  SceneViewController.m
//  BLOXZ
//
//  Created by Pminu on 6/5/14.
//  Copyright (c) 2014 LGMRA Studios. All rights reserved.
//

#import "AppDelegate.h"
#import "SceneViewController.h"
#import "GameScene.h"
#import "Music.h"
#import "Sound.h"
#import "Score.h"
#import "NSUserDefaults+MPSecureUserDefaults.h"

#define kRanGameFirstTime @"FirstRun"
#define kRanNumberTimes @"RunTimes"
#define kCurrentRunTimes @"CurrentRuns"


@interface SceneViewController ()

/*START VIEW*/
@property (weak, nonatomic) IBOutlet UIView *startMenuView;
/*START OVER VIEW*/
@property (weak, nonatomic) IBOutlet UIView *startOverView;
/*SETTINGS VIEW*/

/*RATE GAME VIEW*/
@property (weak, nonatomic) IBOutlet UIView *rateGameView;
@property (weak, nonatomic) IBOutlet UIWebView *rateGameWebView;
@property (weak, nonatomic) IBOutlet UIButton *backToApp;
//links to web url, no actual view

/*SCENE VIEW*/
@property (weak, nonatomic) IBOutlet SKView *skView;
@property (nonatomic, retain) GameScene *scene;

//shared buttons
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *musicButton;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *soundButton;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *rateButton;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *helpButton;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *shareButton;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *rankingsButton;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *startButton;

//Score
@property (nonatomic, assign) NSInteger userCurrentScore;
@property (nonatomic, assign) NSInteger userHighScore;
@property (nonatomic) int64_t score;

//scoring labels
@property (strong, nonatomic) IBOutlet UILabel *lastScoreLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *bestScoreLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *timesPlayedLabel;

//iAd tracking
//@property(nonatomic, assign) NSInteger timesGamePlayed;
@property(nonatomic, strong) IBOutlet ADBannerView *adBanner;
@property BOOL _bannerIsVisible;
@property(nonatomic, assign) BOOL _inGame;

@property(nonatomic, retain) GADInterstitial *intersitial;
@property(nonatomic, retain) GADRequest *request;

//GameCenter
@property (nonatomic) BOOL gameCenterEnabled;
@property (nonatomic) BOOL reportAchievements;
@property (nonatomic, strong) NSString *leaderboardIdentifier;

//Music
@property (nonatomic, retain) Music *musicPlayer;
@property (nonatomic, assign) BOOL musicOn;

//Sound
@property (nonatomic, assign) BOOL soundOn;

//general
@property (nonatomic, assign) BOOL firstRound;
@end

@implementation SceneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self setNeedsStatusBarAppearanceUpdate];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    //run the first time game runs defaults
    if(![[NSUserDefaults standardUserDefaults] boolForKey:kRanGameFirstTime]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kRanGameFirstTime];
    }
   
    for( UIButton *btn in self.startButton)
    {
        [btn setImage:[UIImage imageNamed:@"playNotPressed"]forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(loadGameScene:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //start the music and sounds
    self.musicPlayer = [[Music alloc]init];

    //set initial game variables
    self.userHighScore = [self userHighestScore];
    self.userCurrentScore = 0;
    
    for( UILabel *lbl in self.bestScoreLabel)
    {
     [lbl setText:[NSString stringWithFormat:@"%ld", (long)[self userHighestScore]]];
    }
    for( UILabel *lbl in self.timesPlayedLabel)
    {
        [lbl setText:[NSString stringWithFormat:@"%ld", (long)[self timesGamePlayed]]];
    }

    //stats settings
    self.skView = (SKView *)self.view;
    self.skView.showsFPS = NO;
    self.skView.showsNodeCount = NO;
    
    //enable iAds by default
    self.adBanner.delegate = self;
    //disable standard iAd banner
    self._bannerIsVisible = NO;
    //not in a game at startup
    self._inGame = NO;
    //set the first round yes
    self.firstRound = YES;
    
    self.skView.alpha = 1;
    self.adBanner.alpha = 0;
    self.startMenuView.alpha = 1;
    self.startOverView.alpha = 0;
    self.rateGameView.alpha = 0;
    
    _gameCenterEnabled = NO;
    _leaderboardIdentifier = @"board.0001";
    [self authenticateLocalPlayer];
    
    //swap layout sizes for i4||i5
    
    self.scene = [GameScene sceneWithSize:self.skView.bounds.size];
    self.scene.scaleMode = SKSceneScaleModeAspectFill;
    self.scene.delegate = self;
    //partially loads the games scene, just the boarder blocks
    [self.skView presentScene:self.scene];

}
- (void)loadIntersitialAdMob {
    self.intersitial = [[GADInterstitial alloc] init];
    self.intersitial.adUnitID = @"ca-app-pub-7655917860679243/6309566611";
    self.intersitial.delegate = self;
    
    self.request = [[GADRequest alloc]init];
    //self.request.testDevices = @[@"dd154bda70d282dea18ea0d5050aae0b"];
    [self.intersitial loadRequest:self.request];
    
    if(self.intersitial.isReady){
        NSLog(@"ready to display an ad");
    }
}
//Load Start Menu View
- (void)loadStartMenuView {
    //set alpha layers
    self.startMenuView.alpha = 1;
    self.startOverView.alpha = 0;
    self.rateGameView.alpha = 0;
}
//Load Start Over View
- (void)loadStartOverView {
    //set alpha layers
    self.startMenuView.alpha = 0;
    self.startOverView.alpha = 1;
    self.rateGameView.alpha = 0;
}
// Load Rate View
- (void)loadRateView {
    //set alpha layers
    self.startMenuView.alpha = 0;
    self.startOverView.alpha = 0;
    self.rateGameView.alpha = 1;
    
    //setup the page, history , navigation and back button
    NSURL *rateUrl = [NSURL URLWithString:@"http://lgmra.com/bloxz2d"];
    NSMutableURLRequest *url = [[NSMutableURLRequest alloc]initWithURL:rateUrl];
    [self.rateGameWebView loadRequest:url];
    [self.backToApp addTarget:self action:@selector(loadStartMenuView) forControlEvents:UIControlEventTouchUpInside];
}
// Load Game Scene
- (void)loadGameScene:(id)sender {
    //set alpha layers
    self.adBanner.alpha = 0;
    self.startMenuView.alpha = 0;
    self.startOverView.alpha = 0;
    self.rateGameView.alpha = 0;
    self._inGame = YES;
    self.firstRound = NO;
}

// Return the users highest saved score
- (NSInteger)userHighestScore {
    return [Score bestScore];
}
- (NSInteger)timesGamePlayed {
    BOOL valid = NO;
    NSInteger num = [[NSUserDefaults standardUserDefaults] secureIntegerForKey:kRanNumberTimes valid:&valid];
    if (valid) {
        return num;
    }else {
        return 0;
    }
}
- (void)incrementRanTimes {
    BOOL valid = NO;
    NSInteger num = [[NSUserDefaults standardUserDefaults] secureIntegerForKey:kRanNumberTimes valid:&valid];
    if (valid) {
        [[NSUserDefaults standardUserDefaults] setSecureInteger:num+1 forKey:kRanNumberTimes];
    }
}
- (NSInteger)timesCurrentRun {
    BOOL valid = NO;
    NSInteger num = [[NSUserDefaults standardUserDefaults] secureIntegerForKey:kCurrentRunTimes valid:&valid];
    if (valid) {
        return num;
    }else {
        return 0;
    }
}
- (void)incrementCurrentRuns {
    BOOL valid = NO;
    NSInteger num = [[NSUserDefaults standardUserDefaults] secureIntegerForKey:kCurrentRunTimes valid:&valid];
    if (valid) {
        [[NSUserDefaults standardUserDefaults] setSecureInteger:num+1 forKey:kCurrentRunTimes];
    }
}
- (void)resetCurrentRuns {
    [[NSUserDefaults standardUserDefaults] setSecureInteger:0 forKey:kCurrentRunTimes];
}
// Load the Game Over View
- (void)loadGameOverView :(NSInteger)playerScore{
    //take in the score from the game
    if(__bannerIsVisible){
        self.adBanner.alpha = 1;
    }
    self._inGame = NO;
    
    [self incrementRanTimes];
    [self incrementCurrentRuns];
    
    [self.lastScoreLabel setText:[NSString stringWithFormat:@"%ld", (long)playerScore]];
    
    for( UILabel *lbl in self.bestScoreLabel)
    {
        [lbl setText:[NSString stringWithFormat:@"%ld", (long)[self userHighestScore]]];
    }
    for( UILabel *lbl in self.timesPlayedLabel)
    {
        [lbl setText:[NSString stringWithFormat:@"%ld", (long)[self timesGamePlayed]]];
    }
    
    if(self.gameCenterEnabled) {
        [self reportScore:playerScore forLeaderboardID:@"board.0001"];
    }

    self.scene = [GameScene sceneWithSize:self.skView.bounds.size];
    self.scene.scaleMode = SKSceneScaleModeAspectFill;
    self.scene.delegate = self;
    [self.skView presentScene:self.scene];
    
    if(playerScore > [self userHighestScore] || [self timesCurrentRun] > 4) {
        [self loadIntersitialAdMob];
        [self resetCurrentRuns];
        //[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kCurrentRunTimes];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.startOverView.alpha = 1;
        });
    }else{
        self.startOverView.alpha = 1;

    }

}
#pragma mark - Audio State Handlers

#pragma mark - Button State Handlers
- (IBAction) soundState:(id)sender {
    if([Sound soundOn]){
        [Sound setSoundOn:NO];
    }else{
        [Sound setSoundOn:YES];
    }
}
- (IBAction) musicState:(id)sender {
    if([Music musicOn]){
        [Music setMusicOn:NO];
        [self.musicPlayer stopMusicPlayer];
    }else{
        [Music setMusicOn:YES];
        [self.musicPlayer playFirstMusic];
    }
}
#pragma mark - Player Data Handlers
- (void) authenticateLocalPlayer {
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController) {
            NSLog(@"No player signed in, presenting login view");
            [self presentViewController:viewController animated:YES completion:nil];
        }
        else{
            if ([GKLocalPlayer localPlayer].authenticated) {
                NSLog(@"found a player");
                _gameCenterEnabled = YES;
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                    if (error != nil) {
                        NSLog(@"%@", [error localizedDescription]);
                    }
                    else{
                        _leaderboardIdentifier = leaderboardIdentifier;
                    }
                }];
            }
            else{
                NSLog(@"Could not setup game center");
                _gameCenterEnabled = NO;
            }
        }
    };
}
- (void) reportScore: (int64_t)score forLeaderboardID: (NSString*)identifier {
    GKScore *scoreReporter = [[GKScore alloc]initWithLeaderboardIdentifier:identifier];
    scoreReporter.value = score;
    scoreReporter.context = 0;
    
    NSArray *scores = @[scoreReporter];
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
        if(error) {
            NSLog(@"Error :%@", error);
        } else {
            NSLog(@"Reported score of %lld without error", score);
        }
    }];
    
}
- (void) gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    NSLog(@"finished gameCenterController");
    self.skView.alpha = 1;
}
- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    //tags are number 1 - ***
    // tag 1 = 
    if(alertView.tag == 1 && buttonIndex == 1){
    }
}
#pragma mark - BOOL Action Handlers
- (BOOL) allowActionToRun {
    return TRUE;
}
- (void) hidesBanner {
    [self.adBanner setAlpha:0];
    self._bannerIsVisible = NO;
}
- (void) showsBanner {
    [self.adBanner setAlpha:1];
    self._bannerIsVisible = YES;
}
#pragma mark - Banner Ad Handlers
- (void) bannerViewDidLoadAd:(ADBannerView *)adBanner {
    NSLog(@"banner did load");
    if(!self._bannerIsVisible && !self._inGame){
        [self showsBanner];
    }
}
- (void) adBanner:(ADBannerView *)adBanner didFailToReceiveAdWithError:(NSError *)error {
    if (self._bannerIsVisible) {
        [self hidesBanner];
    }
}
- (void) bannerViewWillLoadAd:(ADBannerView *)banner {
    NSLog(@"banner will load");
}
- (BOOL) bannerViewActionShouldBegin:(ADBannerView *)adBanner willLeaveApplication:(BOOL)willLeave {
    BOOL shouldExecuteAction = [self allowActionToRun];
    if(!willLeave && shouldExecuteAction && !self._inGame)
    {
        if([Music musicOn]){
            [self.musicPlayer pauseMusicPlayer];
        }
        
        SKView *view = (SKView *)self.skView.window.rootViewController.view;
        view.paused = YES;
    
    }
    return shouldExecuteAction;
}
- (void) bannerViewActionDidFinish:(ADBannerView *)adBanner {
    
    SKView *view = (SKView *)self.skView.window.rootViewController.view;
    view.paused = NO;
    if([Music musicOn]){
        [self.musicPlayer resumeMusicPlayback];
    }
}
#pragma mark - Intersitial AdMob Handlers
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    NSLog(@"recieved the ad :%@", ad);
    [ad presentFromRootViewController:self];
}
- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"failed to recieve ad :%@", error);
}
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    NSLog(@"will present the ad :%@", ad);
    if([Music musicOn]){
        [self.musicPlayer pauseMusicPlayer];
    }
}
- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    NSLog(@"will leave app :%@", ad);
    if([Music musicOn]){
        [self.musicPlayer pauseMusicPlayer];
    }
}
- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    NSLog(@"will dismiss screen :%@", ad);
    if([Music musicOn]){
        [self.musicPlayer resumeMusicPlayback];
    }
}
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    NSLog(@"did dismiss screen:%@", ad);
}
#pragma mark - Memory Warning Handlers
- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Support Portrait Only Orientations
- (NSUInteger) supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskPortrait;
    } else {
        return UIInterfaceOrientationPortrait;
    }
}
@end
