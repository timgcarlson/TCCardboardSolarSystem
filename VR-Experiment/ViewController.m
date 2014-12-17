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
    
    // Create the scene
    SCNScene *scene = [SCNScene scene];
    _leftSceneView.scene = scene;
    _rightSceneView.scene = scene;
    
    // right, left, top, bottom, back, front (+X, -X, +Y, -Y, +Z, -Z)
    scene.background.contents = @[[UIImage imageNamed:@"space_right1"], [UIImage imageNamed:@"space_left2"], [UIImage imageNamed:@"space_top3"], [UIImage imageNamed:@"space_bottom4"], [UIImage imageNamed:@"space_back6"], [UIImage imageNamed:@"space_front5"]];
    
    // Create camera and add to the scene and views
    TCVRCameraNode *vrCameraNode = [[TCVRCameraNode alloc] initWithCameraMotion:YES];
    [scene.rootNode addChildNode:vrCameraNode];
    _leftSceneView.pointOfView = vrCameraNode.leftCameraNode;
    _rightSceneView.pointOfView = vrCameraNode.rightCameraNode;
    
    // Create the central orbit point
    SCNNode *orbitPoint = [SCNNode node];
    orbitPoint.position = vrCameraNode.position;
    [vrCameraNode addChildNode:orbitPoint];
    
    // Demo Planets
    SCNNode *planet1 = [self createPlanetNodeAboutOrbitNode:orbitPoint withPlanetRadius:1.0 orbitRadius:15.0 tiltRadians:0 orbitDuration:75.0 rotationDuration:1.0];
    SCNNode *planet1_moon1 = [self createPlanetNodeAboutOrbitNode:planet1 withPlanetRadius:.35 orbitRadius:5.0 tiltRadians:M_PI/2 orbitDuration:3.0 rotationDuration:6.0];
    SCNNode *planet1_moon2 = [self createPlanetNodeAboutOrbitNode:planet1 withPlanetRadius:.75 orbitRadius:13.0 tiltRadians:0 orbitDuration:8.0 rotationDuration:9.0];
    SCNNode *planet1_moon1_1 = [self createPlanetNodeAboutOrbitNode:planet1_moon1 withPlanetRadius:.25 orbitRadius:2.0 tiltRadians:-M_PI/2 orbitDuration:2.0 rotationDuration:3.0];
    
    SCNNode *planet2 = [self createPlanetNodeAboutOrbitNode:orbitPoint withPlanetRadius:4.0 orbitRadius:30.0 tiltRadians:M_PI/8 orbitDuration:100.0 rotationDuration:15.0];


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

- (SCNNode *)createPlanetNodeAboutOrbitNode:(SCNNode *)orbitNode withPlanetRadius:(CGFloat)planetRadius orbitRadius:(CGFloat)orbitRadius tiltRadians:(CGFloat)tilt orbitDuration:(CGFloat)orbitDuration rotationDuration:(CGFloat)rotationDuration {
    
    SCNNode *planetRotationNode = [SCNNode node];
    [orbitNode addChildNode:planetRotationNode];
    
    SCNNode *planetGroupNode = [SCNNode node];
    planetGroupNode.position = SCNVector3Make(0, 0, -(orbitRadius));
    [planetRotationNode addChildNode:planetGroupNode];
    
    SCNSphere *planet = [SCNSphere sphereWithRadius:planetRadius];
    SCNNode *planetNode = [SCNNode nodeWithGeometry:planet];
    planetNode.position = SCNVector3Make(0, 0, 0);
    [planetGroupNode addChildNode:planetNode];
    
    // Rotate ball around orbit node
    CABasicAnimation *planetRotationAnimation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    planetRotationAnimation.duration = orbitDuration;
    planetRotationAnimation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(tilt, 1, 0, M_PI * 2)];
    planetRotationAnimation.repeatCount = FLT_MAX;
    [planetRotationNode addAnimation:planetRotationAnimation forKey:@"planet rotation around orbit point"];
    
    // Rotate the Planet
    planetRotationAnimation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    planetRotationAnimation.duration = rotationDuration;
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
    
    return planetGroupNode;
}


#pragma mark - Conversion Methods

- (CGFloat)degreesToRadians:(CGFloat)degrees {
    return (degrees * M_PI) / 180.0;
}

- (CGFloat)radiansToDegrees:(CGFloat)radians {
    return (180.0 / M_PI) * radians;
}

@end
