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
#import "TCPlanetNode.h"

@interface ViewController ()

@property (nonatomic) TCVRCameraNode *vrCameraNode;

@property (nonatomic) TCCardboardMagneticSensor *magneticSensor;

@property (nonatomic) SCNVector3 cameraPosition1;
@property (nonatomic) SCNVector3 cameraPosition2;
@property (nonatomic) SCNVector3 cameraPosition3;
@property (nonatomic) SCNVector3 cameraPosition4;
@property (nonatomic) NSInteger currentCameraPosition;


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
    _vrCameraNode = [[TCVRCameraNode alloc] initWithCameraMotion:YES];
    [scene.rootNode addChildNode:_vrCameraNode];
    _leftSceneView.pointOfView = _vrCameraNode.leftCameraNode;
    _rightSceneView.pointOfView = _vrCameraNode.rightCameraNode;
    
    // Create the central orbit point
    SCNNode *orbitPoint = [SCNNode node];
    orbitPoint.position = SCNVector3Make(0, 0, 0);
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
        TCPlanetNode *aPlanetNode = [[TCPlanetNode alloc] initWithPlanetAttributes:nil aboutOrbitNode:orbitPoint];
        [aPlanetNode startAnimating];
    }

//    TCPlanetNode *aPlanetNode = [[TCPlanetNode alloc] initWithPlanetAttributes:nil aboutOrbitNode:orbitPoint];
//    [aPlanetNode startAnimating];
//    
//    TCPlanetNode *aMoonNode = [[TCPlanetNode alloc] initWithPlanetAttributes:nil aboutOrbitNode:aPlanetNode];
//    [aMoonNode startAnimating];
    

    // Add light to scene
    SCNNode *omnilightNode = [SCNNode node];
    omnilightNode.light = [SCNLight light];
    omnilightNode.light.color = [UIColor whiteColor];
    omnilightNode.light.type = SCNLightTypeOmni;
    omnilightNode.light.attenuationStartDistance = 0.f;
    omnilightNode.light.attenuationEndDistance = 100.f;
    omnilightNode.light.attenuationFalloffExponent = 2.f;
    [orbitPoint addChildNode:omnilightNode];    // Orbiting from point of sun
    
    // Set the viewing position
    _currentCameraPosition = 0;
    _cameraPosition1 = SCNVector3Make(0, 0, -50);
    _cameraPosition2 = SCNVector3Make(0, 0, -40);
    _cameraPosition3 = SCNVector3Make(0, 0, -30);
    _cameraPosition4 = SCNVector3Make(0, 0, -20);
    [self changeCameraPosition];

//    _vrCameraNode.position = SCNVector3Make(0, 0, 50);
    
    // Magnetic Sensor
    _magneticSensor = [[TCCardboardMagneticSensor alloc] init];
    _magneticSensor.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods

- (void)changeCameraPosition {
    switch (_currentCameraPosition) {
        case 0:
            _vrCameraNode.position = _cameraPosition1;
            _currentCameraPosition = 1;
            break;
        case 1:
            _vrCameraNode.position = _cameraPosition2;
            _currentCameraPosition = 2;
            break;
        case 2:
            _vrCameraNode.position = _cameraPosition3;
            _currentCameraPosition = 3;
            break;
        case 3:
            _vrCameraNode.position = _cameraPosition4;
            _currentCameraPosition = 4;
            break;
        case 4:
            _vrCameraNode.position = _cameraPosition1;
            _currentCameraPosition = 1;
            break;
        default:
            break;
    }
}


#pragma mark - TCCardboardMagneticSensorDelegate

- (void)onCardboardTrigger {
    [self changeCameraPosition];
}


#pragma mark - Conversion Methods

- (CGFloat)degreesToRadians:(CGFloat)degrees {
    return (degrees * M_PI) / 180.0;
}

- (CGFloat)radiansToDegrees:(CGFloat)radians {
    return (180.0 / M_PI) * radians;
}

@end
