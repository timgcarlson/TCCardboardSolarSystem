//
//  TCVRCamera.m
//  VR-Experiment
//
//  Created by Tim Carlson on 12/14/14.
//  Copyright (c) 2014 Tim Carlson. All rights reserved.
//

#import "TCVRCamera.h"

@interface TCVRCamera ()

@property (nonatomic) SCNCamera *leftCamera;
@property (nonatomic) SCNCamera *rightCamera;

@property (nonatomic) SCNNode *camerasNode;

// Motion nodes
@property (nonatomic) SCNNode *rollNode;
@property (nonatomic) SCNNode *pitchNode;
@property (nonatomic) SCNNode *yawNode;
@property (nonatomic, readwrite) SCNNode *camerasMotionNode;

@property (nonatomic) CMMotionManager *motionManager;

@end

@implementation TCVRCamera

- (instancetype)init {
    if (self = [super init]) {
        _leftCamera = [SCNCamera camera];
        _leftCamera.xFov = 45;
        _leftCamera.yFov = 45;
        
        _rightCamera = [SCNCamera camera];
        _rightCamera.xFov = 45;
        _rightCamera.yFov = 45;
        
        self.leftCameraNode = [SCNNode node];
        self.leftCameraNode.camera = _leftCamera;
        self.leftCameraNode.position = SCNVector3Make(-.5, 0, 0);
        
        self.rightCameraNode = [SCNNode node];
        self.rightCameraNode.camera = _rightCamera;
        self.rightCameraNode.position = SCNVector3Make(.5, 0, 0);
        
        _camerasNode = [SCNNode node];
        [_camerasNode addChildNode:self.leftCameraNode];
        [_camerasNode addChildNode:self.rightCameraNode];
        _camerasNode.eulerAngles = SCNVector3Make([self degreesToRadians:-90.f], 0, 0);
        
        // Roll: up/down head movement
        _rollNode = [SCNNode node];
        [_rollNode addChildNode:_camerasNode];
        
        // Pitch: left/right head movement
        _pitchNode = [SCNNode node];
        [_pitchNode addChildNode:_rollNode];
        
        // Yaw: diagonal head movement
        _yawNode = [SCNNode node];
        [_yawNode addChildNode:_pitchNode];
        
        self.camerasMotionNode = _yawNode;
        
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
                                                            _rollNode.eulerAngles = SCNVector3Make(roll, 0, 0);
                                                            _pitchNode.eulerAngles = SCNVector3Make(0, 0, pitch);
                                                            _yawNode.eulerAngles = SCNVector3Make(0, yaw, 0);
                                                        }];

        
    }
    
    return self;
}


#pragma mark - Conversion Methods

- (CGFloat)degreesToRadians:(CGFloat)degrees {
    return (degrees * M_PI) / 180.0;
}

- (CGFloat)radiansToDegrees:(CGFloat)radians {
    return (180.0 / M_PI) * radians;
}

@end
