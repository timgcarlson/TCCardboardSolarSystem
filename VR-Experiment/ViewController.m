//
//  ViewController.m
//  VR-Experiment
//
//  Created by Tim Carlson on 12/11/14.
//  Copyright (c) 2014 Tim Carlson. All rights reserved.
//

#import "ViewController.h"
#import "TCVRCameraNode.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _leftSceneView.backgroundColor = [UIColor blackColor];
    _rightSceneView.backgroundColor = [UIColor blackColor];
    
    // Create the scene
    SCNScene *scene = [SCNScene scene];
    _leftSceneView.scene = scene;
    _rightSceneView.scene = scene;
    
    // Create camera and add to the scene and views
    TCVRCameraNode *vrCameraNode = [[TCVRCameraNode alloc] initWithCameraMotion:YES];
    [scene.rootNode addChildNode:vrCameraNode];
    _leftSceneView.pointOfView = vrCameraNode.leftCameraNode;
    _rightSceneView.pointOfView = vrCameraNode.rightCameraNode;
    
    
    // Have a planet orbit the camera
    SCNNode *orbitPoint = [SCNNode node];
    orbitPoint.position = vrCameraNode.position;
    [vrCameraNode addChildNode:orbitPoint];
    
    // Create the ball
    SCNSphere *planet = [SCNSphere sphereWithRadius:1.0];
    SCNNode *planetNode = [SCNNode nodeWithGeometry:planet];
    planetNode.position = SCNVector3Make(0, 3, -10);
    
    // Add a pattern to the ball
    SCNMaterial *planetMaterial = [SCNMaterial material];
    planetMaterial.diffuse.contents = [UIImage imageNamed:@"linesPattern"];
    planetMaterial.specular.contents = [UIColor whiteColor];
    planetMaterial.shininess = 1.f;
    planet.materials = @[planetMaterial];
    [orbitPoint addChildNode:planetNode];

    // Rotate ball around orbit point
    CABasicAnimation *planetRotationAnimation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    planetRotationAnimation.duration = 10.0;
    planetRotationAnimation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
    planetRotationAnimation.repeatCount = FLT_MAX;
    [orbitPoint addAnimation:planetRotationAnimation forKey:@"planet rotation around orbit point"];
    
    // Rotate the Earth
    planetRotationAnimation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    planetRotationAnimation.duration = 1.0;
    planetRotationAnimation.fromValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, 0)];
    planetRotationAnimation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
    planetRotationAnimation.repeatCount = FLT_MAX;
    [planetNode addAnimation:planetRotationAnimation forKey:@"planet rotation"];
    
    // Add material to planet
    planetNode.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:@"earth-diffuse-mini"];
    planetNode.geometry.firstMaterial.emission.contents = [UIImage imageNamed:@"earth-emissive-mini"];
    planetNode.geometry.firstMaterial.specular.contents = [UIImage imageNamed:@"earth-specular-mini"];
    planetNode.geometry.firstMaterial.locksAmbientWithDiffuse = YES;
    planetNode.geometry.firstMaterial.shininess = 0.1;
    planetNode.geometry.firstMaterial.specular.intensity = 0.5;
    
    // Add light to scene
    SCNNode *omnilightNode = [SCNNode node];
    omnilightNode.light = [SCNLight light];
    omnilightNode.light.color = [UIColor whiteColor];
    omnilightNode.light.type = SCNLightTypeOmni;
    [orbitPoint addChildNode:omnilightNode];    // Orbiting from point of sun
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Helper Methods


#pragma mark - Conversion Methods

- (CGFloat)degreesToRadians:(CGFloat)degrees {
    return (degrees * M_PI) / 180.0;
}

- (CGFloat)radiansToDegrees:(CGFloat)radians {
    return (180.0 / M_PI) * radians;
}

@end
