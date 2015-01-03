//
//  TCSolarSystemViewController.m
//  VR-Experiment
//
//  Created by Tim Carlson on 12/11/14.
//  Copyright (c) 2014 Tim Carlson. All rights reserved.
//
//  Using planet bitmaps from http://freebitmaps.blogspot.com/search?updated-max=2010-12-16T19:40:00-08:00&max-results=3
//

#import "TCSolarSystemViewController.h"
#import "TCCardboardCameraNode.h"
#import "TCPlanetNode.h"

@interface TCSolarSystemViewController ()

@property (nonatomic) SCNNode *orbitPoint;

@property (nonatomic) TCCardboardCameraNode *vrCameraNode;

@property (nonatomic) TCCardboardMagneticSensor *magneticSensor;

@property (nonatomic) SCNVector3 cameraPosition1;
@property (nonatomic) SCNVector3 cameraPosition2;
@property (nonatomic) SCNVector3 cameraPosition3;
@property (nonatomic) SCNVector3 cameraPosition4;
@property (nonatomic) NSInteger currentCameraPosition;

@property (nonatomic) NSMutableArray *currentPlanets;

@end


@implementation TCSolarSystemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Set up the scene
    self.scene.background.contents = @[[UIImage imageNamed:@"stars_right1"], [UIImage imageNamed:@"stars_left2"], [UIImage imageNamed:@"stars_top3"], [UIImage imageNamed:@"stars_bottom4"], [UIImage imageNamed:@"stars_back6"], [UIImage imageNamed:@"stars_front5"]];
    
    // Create camera and add to the scene
    _vrCameraNode = [[TCCardboardCameraNode alloc] initWithCameraMotion:YES];
    [self addVRCamera:_vrCameraNode];
    
    // Create the central orbit point
    _orbitPoint = [SCNNode node];
    _orbitPoint.position = SCNVector3Make(0, 0, 0);
    [self.scene.rootNode addChildNode:_orbitPoint];
    
    // Add the sun
    _orbitPoint.geometry = [SCNSphere sphereWithRadius:3.0];
    SCNNode *sunHaloNode = [SCNNode node];
    sunHaloNode.geometry = [SCNPlane planeWithWidth:40 height:40];
    sunHaloNode.rotation = SCNVector4Make(1, 0, 0, M_PI / 180.0);
    sunHaloNode.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:@"sun-halo"];
    sunHaloNode.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant;
    sunHaloNode.geometry.firstMaterial.writesToDepthBuffer = NO;
    sunHaloNode.opacity = 0.3;
    [_orbitPoint addChildNode:sunHaloNode];
    
    _orbitPoint.geometry.firstMaterial.multiply.contents = [UIImage imageNamed:@"sun"];
    _orbitPoint.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:@"sun"];
    _orbitPoint.geometry.firstMaterial.multiply.intensity = 0.5;
    _orbitPoint.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant;
    
    _orbitPoint.geometry.firstMaterial.multiply.wrapS =
    _orbitPoint.geometry.firstMaterial.diffuse.wrapS  =
    _orbitPoint.geometry.firstMaterial.multiply.wrapT =
    _orbitPoint.geometry.firstMaterial.diffuse.wrapT  = SCNWrapModeRepeat;
    _orbitPoint.geometry.firstMaterial.locksAmbientWithDiffuse   = YES;
    
    // Achieve a lava effect by animating textures
    CABasicAnimation *sunAnimation = [CABasicAnimation animationWithKeyPath:@"contentsTransform"];
    sunAnimation.duration = 10.0;
    sunAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(0, 0, 0), CATransform3DMakeScale(3, 3, 3))];
    sunAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(1, 0, 0), CATransform3DMakeScale(3, 3, 3))];
    sunAnimation.repeatCount = FLT_MAX;
    [_orbitPoint.geometry.firstMaterial.diffuse addAnimation:sunAnimation forKey:@"sun-texture"];
    
    sunAnimation = [CABasicAnimation animationWithKeyPath:@"contentsTransform"];
    sunAnimation.duration = 30.0;
    sunAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(0, 0, 0), CATransform3DMakeScale(5, 5, 5))];
    sunAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(1, 0, 0), CATransform3DMakeScale(5, 5, 5))];
    sunAnimation.repeatCount = FLT_MAX;
    [_orbitPoint.geometry.firstMaterial.multiply addAnimation:sunAnimation forKey:@"sun-texture2"];
    
    // Add light to scene
    SCNNode *omnilightNode = [SCNNode node];
    omnilightNode.light = [SCNLight light];
    omnilightNode.light.color = [UIColor whiteColor];
    omnilightNode.light.type = SCNLightTypeOmni;
    omnilightNode.light.attenuationStartDistance = 0.f;
    omnilightNode.light.attenuationEndDistance = 100.f;
    omnilightNode.light.attenuationFalloffExponent = 2.f;
    [_orbitPoint addChildNode:omnilightNode];    // Orbiting from point of sun
    
    // Create misc planets
    _currentPlanets = [NSMutableArray array];
    [self createNewSolarSystemWith:13];
    
    // Set the viewing positions
    _currentCameraPosition = 0;
    _cameraPosition1 = SCNVector3Make(0, 0, -50);
    _cameraPosition2 = SCNVector3Make(0, 0, -40);
    _cameraPosition3 = SCNVector3Make(0, 0, -30);
    _cameraPosition4 = SCNVector3Make(0, 0, -20);
    [self changeCameraPosition];
    
    // Magnetic Sensor Trigger
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

- (void)createNewSolarSystemWith:(NSUInteger)numberOfPlanets {
    if (_currentPlanets.count) {
        // Remove all existing planets...
        for (TCPlanetNode *planet in _currentPlanets) {
            [planet removeFromParentNode];
        }
        _currentPlanets = [NSMutableArray array];
    }
    for (int i = 0; i < numberOfPlanets; i++) {
        TCPlanetNode *aPlanetNode = [[TCPlanetNode alloc] initWithPlanetAttributes:nil aboutOrbitNode:_orbitPoint];
        [_currentPlanets addObject:aPlanetNode];
        [aPlanetNode startAnimating];
    }
}

#pragma mark - TCCardboardMagneticSensorDelegate

- (void)onCardboardTrigger {
//    [self changeCameraPosition];
    
//    if (_scene.paused) {
//        [_scene setPaused:NO];
//    } else {
//        [_scene setPaused:YES];
//    }
    
    [self createNewSolarSystemWith:13];
}


#pragma mark - Conversion Methods

- (CGFloat)degreesToRadians:(CGFloat)degrees {
    return (degrees * M_PI) / 180.0;
}

- (CGFloat)radiansToDegrees:(CGFloat)radians {
    return (180.0 / M_PI) * radians;
}

@end
