//
//  TCCardboardViewController.m
//  TCCardboardSolarSystem
//
//  Created by Tim Carlson on 1/1/15.
//  Copyright (c) 2015 Tim Carlson. All rights reserved.
//

#import "TCCardboardViewController.h"
#import "TCCardboardCameraNode.h"

@interface TCCardboardViewController ()

/** The scene for the left eye. */
@property (nonatomic, strong, readwrite) SCNView *leftSceneView;
/** The scene for the right eye. */
@property (nonatomic, strong, readwrite) SCNView *rightSceneView;

@end

@implementation TCCardboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat sceneWidth = self.view.frame.size.width / 2;
    self.leftSceneView = [[SCNView alloc] initWithFrame:CGRectMake(0, 0, sceneWidth, self.view.frame.size.height)];
    self.rightSceneView = [[SCNView alloc] initWithFrame:CGRectMake(sceneWidth, 0, sceneWidth, self.view.frame.size.height)];
    [self.view addSubview:self.leftSceneView];
    [self.view addSubview:self.rightSceneView];
    
    self.scene = [SCNScene scene];
    self.leftSceneView.scene = self.scene;
    self.rightSceneView.scene = self.scene;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.leftSceneView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeadingMargin
                                                         multiplier:1.0
                                                           constant:-16]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.rightSceneView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.leftSceneView
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.rightSceneView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.leftSceneView
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.rightSceneView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.leftSceneView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeTrailingMargin
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.rightSceneView
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:-16]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.rightSceneView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.bottomLayoutGuide
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.rightSceneView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.leftSceneView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.rightSceneView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    
}

- (void)setPointOfViewLeft:(SCNNode *)leftPOV andPointOfViewRight:(SCNNode *)rightPOV {
    self.leftSceneView.pointOfView = leftPOV;
    self.rightSceneView.pointOfView = rightPOV;
}

- (void)setPointOfViewWithCamera:(TCCardboardCameraNode *)vrCamera {
    self.leftSceneView.pointOfView = vrCamera.leftCameraNode;
    self.rightSceneView.pointOfView = vrCamera.rightCameraNode;
}

- (void)addVRCamera:(TCCardboardCameraNode *)vrCamera {
    [self.scene.rootNode addChildNode:vrCamera];
    [self setPointOfViewWithCamera:vrCamera];
}

@end


















