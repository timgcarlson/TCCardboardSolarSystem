//
//  ViewController.m
//  VR-Experiment
//
//  Created by Tim Carlson on 12/11/14.
//  Copyright (c) 2014 Tim Carlson. All rights reserved.
//
//  Using planet bitmaps from http://freebitmaps.blogspot.com/search?updated-max=2010-12-16T19:40:00-08:00&max-results=3
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
    scene.background.contents = @[[UIImage imageNamed:@"stars_right1"], [UIImage imageNamed:@"stars_left2"], [UIImage imageNamed:@"stars_top3"], [UIImage imageNamed:@"stars_bottom4"], [UIImage imageNamed:@"stars_back6"], [UIImage imageNamed:@"stars_front5"]];
    
    
    // Create camera and add to the scene and views
    TCVRCameraNode *vrCameraNode = [[TCVRCameraNode alloc] initWithCameraMotion:YES];
    [scene.rootNode addChildNode:vrCameraNode];
    _leftSceneView.pointOfView = vrCameraNode.leftCameraNode;
    _rightSceneView.pointOfView = vrCameraNode.rightCameraNode;
    
    // Create the central orbit point
    SCNNode *orbitPoint = [SCNNode node];
    orbitPoint.position = SCNVector3Make(vrCameraNode.position.x, vrCameraNode.position.y, vrCameraNode.position.z);
    [scene.rootNode addChildNode:orbitPoint];
    
    
    /////// Add the sun
    orbitPoint.geometry = [SCNSphere sphereWithRadius:3.0];
    SCNNode *sunHaloNode = [SCNNode node];
    sunHaloNode.geometry = [SCNPlane planeWithWidth:40 height:40];
    sunHaloNode.rotation = SCNVector4Make(1, 0, 0, M_PI / 180.0);
    sunHaloNode.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:@"sun-halo"];
    sunHaloNode.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant;
    sunHaloNode.geometry.firstMaterial.writesToDepthBuffer = NO;
    sunHaloNode.opacity = 0.3;
    [orbitPoint addChildNode:sunHaloNode];
    
    orbitPoint.geometry.firstMaterial.multiply.contents = [UIImage imageNamed:@"sun"];
    orbitPoint.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:@"sun"];
    orbitPoint.geometry.firstMaterial.multiply.intensity = 0.5;
    orbitPoint.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant;
    
    orbitPoint.geometry.firstMaterial.multiply.wrapS =
    orbitPoint.geometry.firstMaterial.diffuse.wrapS  =
    orbitPoint.geometry.firstMaterial.multiply.wrapT =
    orbitPoint.geometry.firstMaterial.diffuse.wrapT  = SCNWrapModeRepeat;
    orbitPoint.geometry.firstMaterial.locksAmbientWithDiffuse   = YES;
    
    // Achieve a lava effect by animating textures
    CABasicAnimation *sunAnimation = [CABasicAnimation animationWithKeyPath:@"contentsTransform"];
    sunAnimation.duration = 10.0;
    sunAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(0, 0, 0), CATransform3DMakeScale(3, 3, 3))];
    sunAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(1, 0, 0), CATransform3DMakeScale(3, 3, 3))];
    sunAnimation.repeatCount = FLT_MAX;
    [orbitPoint.geometry.firstMaterial.diffuse addAnimation:sunAnimation forKey:@"sun-texture"];
    
    sunAnimation = [CABasicAnimation animationWithKeyPath:@"contentsTransform"];
    sunAnimation.duration = 30.0;
    sunAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(0, 0, 0), CATransform3DMakeScale(5, 5, 5))];
    sunAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(1, 0, 0), CATransform3DMakeScale(5, 5, 5))];
    sunAnimation.repeatCount = FLT_MAX;
    [orbitPoint.geometry.firstMaterial.multiply addAnimation:sunAnimation forKey:@"sun-texture2"];
    ////////
    
    
    // Create misc planets
    for (int i = 0; i < 13; i++) {
        NSDictionary *planet3Textures = @{@"diffuse" : [NSString stringWithFormat: @"miscPlanet_%d", i]};
        
        float pRadius = (((float)arc4random()/0x100000000) * 3);
        float oRadius = 10 + arc4random() % 40;
        float tilt = -(M_PI/4) + (((float)arc4random()/0x100000000) * (M_PI/2));
        float oDuration = 5 + arc4random() % 75;
        float rDuration = 5 + arc4random() % 15;
        
        [self createPlanetNodeAboutOrbitNode:orbitPoint withPlanetRadius:pRadius orbitRadius:oRadius tiltRadians:tilt orbitDuration:oDuration rotationDuration:rDuration withTextures:planet3Textures];
    }

    // Add light to scene
    SCNNode *omnilightNode = [SCNNode node];
    omnilightNode.light = [SCNLight light];
    omnilightNode.light.color = [UIColor whiteColor];
    omnilightNode.light.type = SCNLightTypeOmni;
    [orbitPoint addChildNode:omnilightNode];    // Orbiting from point of sun
    
    // Set the viewing position
    vrCameraNode.position = SCNVector3Make(0, 0, 75);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Helper Methods

- (SCNNode *)createPlanetNodeAboutOrbitNode:(SCNNode *)orbitNode withPlanetRadius:(CGFloat)planetRadius orbitRadius:(CGFloat)orbitRadius tiltRadians:(CGFloat)tilt orbitDuration:(CGFloat)orbitDuration rotationDuration:(CGFloat)rotationDuration withTextures:(NSDictionary *)texturesDict {
    
    SCNNode *planetRotationNode = [SCNNode node];
    [orbitNode addChildNode:planetRotationNode];
    
    SCNNode *planetGroupNode = [SCNNode node];
    planetGroupNode.position = SCNVector3Make(-orbitRadius + (((float)arc4random()/0x100000000) * (2 * orbitRadius)), 0, -(orbitRadius));
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
    if (texturesDict) {
        planetNode.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:texturesDict[@"diffuse"]];
        planetNode.geometry.firstMaterial.locksAmbientWithDiffuse = YES;
        planetNode.geometry.firstMaterial.shininess = 0.1;
        planetNode.geometry.firstMaterial.specular.intensity = 0.5;
    } else {
        planetNode.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:@"earth-diffuse-mini"];
        planetNode.geometry.firstMaterial.emission.contents = [UIImage imageNamed:@"earth-emissive-mini"];
        planetNode.geometry.firstMaterial.specular.contents = [UIImage imageNamed:@"earth-specular-mini"];
        planetNode.geometry.firstMaterial.locksAmbientWithDiffuse = YES;
        planetNode.geometry.firstMaterial.shininess = 0.1;
        planetNode.geometry.firstMaterial.specular.intensity = 0.5;
    }
    
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
