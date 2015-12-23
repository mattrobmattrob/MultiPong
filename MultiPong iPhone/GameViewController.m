//
//  GameViewController.m
//  MultiPong iPhone
//
//  Created by Matt Robinson on 12/23/15.
//  Copyright (c) 2015 Robinson Bros. All rights reserved.
//

#import "GameViewController.h"

#import <GameKit/GameKit.h>

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

//    // create a new scene
//    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];
//
//    // create and add a camera to the scene
//    SCNNode *cameraNode = [SCNNode node];
//    cameraNode.camera = [SCNCamera camera];
//    [scene.rootNode addChildNode:cameraNode];
//    
//    // place the camera
//    cameraNode.position = SCNVector3Make(0, 0, 15);
//    
//    // create and add a light to the scene
//    SCNNode *lightNode = [SCNNode node];
//    lightNode.light = [SCNLight light];
//    lightNode.light.type = SCNLightTypeOmni;
//    lightNode.position = SCNVector3Make(0, 10, 10);
//    [scene.rootNode addChildNode:lightNode];
//    
//    // create and add an ambient light to the scene
//    SCNNode *ambientLightNode = [SCNNode node];
//    ambientLightNode.light = [SCNLight light];
//    ambientLightNode.light.type = SCNLightTypeAmbient;
//    ambientLightNode.light.color = [UIColor darkGrayColor];
//    [scene.rootNode addChildNode:ambientLightNode];
//    
//    // retrieve the ship node
//    SCNNode *ship = [scene.rootNode childNodeWithName:@"ship" recursively:YES];
//    
//    // animate the 3d object
//    [ship runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
//    
//    // retrieve the SCNView
//    SCNView *scnView = (SCNView *)self.view;
//    
//    // set the scene to the view
//    scnView.scene = scene;
//    
//    // allows the user to manipulate the camera
//    scnView.allowsCameraControl = YES;
//        
//    // show statistics such as fps and timing information
//    scnView.showsStatistics = YES;
//
//    // configure the view
//    scnView.backgroundColor = [UIColor blackColor];
//    
//    // add a tap gesture recognizer
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//    NSMutableArray *gestureRecognizers = [NSMutableArray array];
//    [gestureRecognizers addObject:tapGesture];
//    [gestureRecognizers addObjectsFromArray:scnView.gestureRecognizers];
//    scnView.gestureRecognizers = gestureRecognizers;
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
        GKMatchRequest *request = [[GKMatchRequest alloc] init];
        request.minPlayers = 2;
        request.maxPlayers = 2;

        GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
        mmvc.matchmakerDelegate = self;

        [self presentViewController:mmvc animated:YES completion:nil];
    }

    hosted = YES;
}

- (void) handleTap:(UIGestureRecognizer*)gestureRecognize
{
    // retrieve the SCNView
    SCNView *scnView = (SCNView *)self.view;
    
    // check what nodes are tapped
    CGPoint p = [gestureRecognize locationInView:scnView];
    NSArray *hitResults = [scnView hitTest:p options:nil];
    
    // check that we clicked on at least one object
    if([hitResults count] > 0){
        // retrieved the first clicked object
        SCNHitTestResult *result = [hitResults objectAtIndex:0];
        
        // get its material
        SCNMaterial *material = result.node.geometry.firstMaterial;
        
        // highlight it
        [SCNTransaction begin];
        [SCNTransaction setAnimationDuration:0.5];
        
        // on completion - unhighlight
        [SCNTransaction setCompletionBlock:^{
            [SCNTransaction begin];
            [SCNTransaction setAnimationDuration:0.5];
            
            material.emission.contents = [UIColor blackColor];
            
            [SCNTransaction commit];
        }];
        
        material.emission.contents = [UIColor redColor];
        
        [SCNTransaction commit];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
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

    [viewController dismissViewControllerAnimated:YES completion:nil];
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
