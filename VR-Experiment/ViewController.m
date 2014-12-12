//
//  ViewController.m
//  VR-Experiment
//
//  Created by Tim Carlson on 12/11/14.
//  Copyright (c) 2014 Tim Carlson. All rights reserved.
//

#import "ViewController.h"

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
    
    // Create the cameras
    SCNCamera *leftCamera = [SCNCamera camera];
    leftCamera.xFov = 45;
    leftCamera.yFov = 45;
    
    SCNCamera *rightCamera = [SCNCamera camera];
    rightCamera.xFov = 45;
    rightCamera.yFov = 45;
    
    // Attach the cameras to nodes
    // TODO: The offset value at which the cameras should be shifted is open for customization
    SCNNode *leftCameraNode = [SCNNode node];
    leftCameraNode.camera = leftCamera;
    leftCameraNode.position = SCNVector3Make(-.25, 0, 0);
    
    SCNNode *rightCameraNode = [SCNNode node];
    rightCameraNode.camera = rightCamera;
    rightCameraNode.position = SCNVector3Make(.25, 0, 0);
    
    SCNNode *camerasNode = [SCNNode node];
    [camerasNode addChildNode:leftCameraNode];
    [camerasNode addChildNode:rightCameraNode];
    
    // Need to adjust the initial orientation to be the position the user will be holding their phone (in front of face)
    camerasNode.eulerAngles = SCNVector3Make([self degreesToRadians:-90.f], 0, 0);
    
    // Roll: up/down head movement
    SCNNode *cameraRollNode = [SCNNode node];
    [cameraRollNode addChildNode:camerasNode];
    
    // Pitch: left/right head movement
    SCNNode *cameraPitchNode = [SCNNode node];
    [cameraPitchNode addChildNode:cameraRollNode];
    
    // Yaw: diagonal head movement
    SCNNode *cameraYawNode = [SCNNode node];
    [cameraYawNode addChildNode:cameraPitchNode];
    
    [scene.rootNode addChildNode:cameraYawNode];
    
    _leftSceneView.pointOfView = leftCameraNode;
    _rightSceneView.pointOfView = rightCameraNode;
    
    // Add ambient lighting
    SCNLight *ambientLight = [SCNLight light];
    ambientLight.type =SCNLightTypeAmbient;
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
    [camerasNode addChildNode:spotLightNode];
    
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
    
    
    
    // Respond to head movements
    _motionManager = [[CMMotionManager alloc] init];
    _motionManager.deviceMotionUpdateInterval = 1.0 / 60.0;
    [_motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical
                                                        toQueue:[NSOperationQueue mainQueue]
                                                    withHandler:^(CMDeviceMotion *motion, NSError *error) {
                                                        CMAttitude *currentAttitude = motion.attitude;
                                                        double roll = currentAttitude.roll;
                                                        double pitch = currentAttitude.pitch;
                                                        double yaw = currentAttitude.yaw;
                                                        
                                                        // update the cameras
                                                        cameraRollNode.eulerAngles = SCNVector3Make(roll, 0, 0);
                                                        cameraPitchNode.eulerAngles = SCNVector3Make(0, 0, pitch);
                                                        cameraYawNode.eulerAngles = SCNVector3Make(0, yaw, 0);
                                                    }];
    
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
