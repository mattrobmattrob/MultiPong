//
//  GameViewController.m
//  MultiPong
//
//  Created by Matt Robinson on 12/23/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "GameViewController.h"

#import <GameKit/GameKit.h>

#import "GameScene.h"
#import "PlayfieldScene.h"

@interface GameViewController () <GKMatchmakerViewControllerDelegate>

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // authenticate player
    __weak GameViewController *weakSelf = self;
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer setAuthenticateHandler:^(UIViewController * _Nullable vc, NSError * _Nullable error) {
        NSLog(@"localPlayer authenticated!");
        if (weakSelf.isViewLoaded) {
            [weakSelf hostMatch:weakSelf];
        }
    }];

    // Do any additional setup after loading the view.
    SKView *spriteView = (SKView *)self.view;
    spriteView.showsDrawCount = YES;
    spriteView.showsNodeCount = YES;
    spriteView.showsFPS = YES;
#if !TARGET_OS_TV
    spriteView.multipleTouchEnabled = YES;
#endif

    // MSR TODO: Implement menu buttons for game actions
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    tapGestureRecognizer.allowedPressTypes = @[@(UIPressTypeMenu)];
    [self.view addGestureRecognizer:tapGestureRecognizer];

    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
}

- (void)tapped:(UIGestureRecognizer *)gestureRecognizer {
    SKView *spriteView = (SKView *)self.view;
    PlayfieldScene *playfield = (PlayfieldScene *)spriteView.scene;
    [playfield pause];
}

-(void)panned:(UIGestureRecognizer *)gestureRecognizer
{
    UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)gestureRecognizer;
    SKView *spriteView = (SKView *)self.view;
    PlayfieldScene *playfield = (PlayfieldScene *)spriteView.scene;
    CGPoint translation = [panGesture translationInView:self.view];
    [playfield translateLeftPaddeInView:translation];
}

- (void)resumeGame {
    SKView *spriteView = (SKView *)self.view;
    PlayfieldScene *playfield = (PlayfieldScene *)spriteView.scene;
    [playfield resume];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    PlayfieldScene *playfield = [[PlayfieldScene alloc] init];
    SKView *spriteView = (SKView *)self.view;
    [spriteView presentScene:playfield];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if ([GKLocalPlayer localPlayer].authenticated) {
        [self hostMatch:self];
    }
}

- (IBAction)hostMatch:(id)sender
{
    static BOOL hosted = NO;

    if (!hosted) {
//        GKMatchRequest *request = [[GKMatchRequest alloc] init];
//        request.minPlayers = 2;
//        request.maxPlayers = 8;
//
//        GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
//        mmvc.matchmakerDelegate = self;
//
//        [self presentViewController:mmvc animated:YES completion:nil];
    }
    
    hosted = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - GKMatchmakerViewControllerDelegate

// The user has cancelled matchmaking
- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController
{
    NSLog(@"matchmakerViewControllerWasCancelled:");
}

// Matchmaking has failed with an error
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
}

// A peer-to-peer match has been found, the game should start
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)match
{
    NSLog(@"didFindMatch:");
}

// Players have been found for a server-hosted game, the game should start
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindHostedPlayers:(NSArray<GKPlayer *> *)players
{
    NSLog(@"didFindHostedPlayers:");
}

// An invited player has accepted a hosted invite.  Apps should connect through the hosting server and then update the player's connected state (using setConnected:forHostedPlayer:)
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController hostedPlayerDidAccept:(GKPlayer *)player
{
    NSLog(@"hostedPlayerDidAccept:");
}

@end
