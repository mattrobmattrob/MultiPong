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

@interface GameViewController () <GKMatchmakerViewControllerDelegate>

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // authenticate player
    __weak id weakSelf = self;
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer setAuthenticateHandler:^(UIViewController * _Nullable vc, NSError * _Nullable error) {
        NSLog(@"localPlayer authenticated!");
        [self hostMatch:weakSelf];
    }];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    GameScene *scene = [GameScene nodeWithFileNamed:@"GameScene"];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
//    [skView presentScene:scene];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

//    [self hostMatch:self];
}

- (IBAction)hostMatch:(id)sender
{
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = 2;
    request.maxPlayers = 2;

    GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
    mmvc.matchmakerDelegate = self;

    [self presentViewController:mmvc animated:YES completion:nil];
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
    NSLog(@"didFailWithError:");
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
