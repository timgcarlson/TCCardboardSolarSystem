//
//  ViewController.m
//  VR-Experiment
//
//  Created by Tim Carlson on 12/11/14.
//  Copyright (c) 2014 Tim Carlson. All rights reserved.
//

#import "ViewController.h"
#import "TCVRCamera.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _leftSceneView.backgroundColor = [UIColor lightGrayColor];
    _rightSceneView.backgroundColor = [UIColor lightGrayColor];
    
    // Create the scene
    SCNScene *scene = [SCNScene scene];
    _leftSceneView.scene = scene;
    _rightSceneView.scene = scene;
    
    // Create camera and add to the scene and views
    TCVRCamera *vrCamera = [[TCVRCamera alloc] initWithCameraMotion:YES];
    [scene.rootNode addChildNode:vrCamera.camerasMotionNode];
    _leftSceneView.pointOfView = vrCamera.leftCameraNode;
    _rightSceneView.pointOfView = vrCamera.rightCameraNode;
    
    // Add ambient lighting
    SCNLight *ambientLight = [SCNLight light];
    ambientLight.type = SCNLightTypeAmbient;
    ambientLight.color = [UIColor colorWithWhite:0.1 alpha:1.0];
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = ambientLight;
    [scene.rootNode addChildNode:ambientLightNode];
    
    // Omni/Point Light
    SCNLight *omniLight = [SCNLight light];
    omniLight.type = SCNLightTypeOmni;
    omniLight.color = [UIColor colorWithWhite:1.0 alpha:1.0];
    SCNNode *omniLightNode = [SCNNode node];
    omniLightNode.light = omniLight;
    omniLightNode.position = SCNVector3Make(-30, 30, 50);
    [scene.rootNode addChildNode:omniLightNode];
    
    // Spot Light
    SCNLight *spotLight = [SCNLight light];
    spotLight.type = SCNLightTypeSpot;
    spotLight.color = [UIColor redColor];
    SCNNode *spotLightNode = [SCNNode node];
    spotLightNode.light = spotLight;
    spotLightNode.position = SCNVector3Make([self degreesToRadians:-90.f], 0, 0);
    [scene.rootNode addChildNode:spotLightNode];
    
    // Spotlight Color Animation
    CAKeyframeAnimation *colorBallAnimation = [CAKeyframeAnimation animationWithKeyPath:@"color"];
    colorBallAnimation.values = @[[UIColor redColor], [UIColor blueColor], [UIColor greenColor], [UIColor redColor]];
    colorBallAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    colorBallAnimation.repeatCount = INFINITY;
    colorBallAnimation.duration = 3.0;
    [spotLight addAnimation:colorBallAnimation forKey:@"ChangeTheColorOfTheSpotLight"];
    
    // Create the floor
    SCNFloor *floor = [SCNFloor floor];
    floor.reflectivity = 0.15;
    SCNMaterial *floorMaterial = [SCNMaterial material];
    floorMaterial.diffuse.contents = [UIColor blueColor];
    floorMaterial.specular.contents = [UIColor blueColor];
    floor.materials = @[floorMaterial];
    SCNNode *floorNode = [SCNNode nodeWithGeometry:floor];
    floorNode.position = SCNVector3Make(0, -1, 0);
    [scene.rootNode addChildNode:floorNode];
    
    // Create the ball
    SCNSphere *ball = [SCNSphere sphereWithRadius:1.0];
    SCNNode *ballNode = [SCNNode nodeWithGeometry:ball];
    ballNode.position = SCNVector3Make(0, 3, -10);
    [scene.rootNode addChildNode:ballNode];
    // Add a pattern to the ball
    SCNMaterial *ballMaterial = [SCNMaterial material];
    ballMaterial.diffuse.contents = [UIImage imageNamed:@"linesPattern"];
    ballMaterial.specular.contents = [UIColor whiteColor];
    ballMaterial.shininess = 1.f;
    ball.materials = @[ballMaterial];
    
    // Bounce the ball
    CABasicAnimation *bounceBallAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    bounceBallAnimation.byValue = [NSValue valueWithSCNVector3:SCNVector3Make(0, -3.05, 0)];
    bounceBallAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    bounceBallAnimation.autoreverses = YES;
    bounceBallAnimation.repeatCount = HUGE_VALF;
    bounceBallAnimation.duration = 0.5;
    // Add the animation to the ball
    [ballNode addAnimation:bounceBallAnimation forKey:@"bounce"];
    
    // Spin
    CABasicAnimation *spinBallAnimation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    spinBallAnimation.fromValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 0, 1, 0)];
    spinBallAnimation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(2 * M_PI, 0, 1, 2 * M_PI)];
    spinBallAnimation.duration = 3.0;
    spinBallAnimation.repeatCount = HUGE_VALF;
    [ballNode addAnimation:spinBallAnimation forKey:@"spin"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Conversion Methods

- (CGFloat)degreesToRadians:(CGFloat)degrees {
    return (degrees * M_PI) / 180.0;
}

- (CGFloat)radiansToDegrees:(CGFloat)radians {
    return (180.0 / M_PI) * radians;
}

@end
