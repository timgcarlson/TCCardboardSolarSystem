//
//  TCVRCameraNode.m
//  VR-Experiment
//
//  Created by Tim Carlson on 12/14/14.
//  Copyright (c) 2014 Tim Carlson. All rights reserved.
//

#import "TCVRCameraNode.h"

@interface TCVRCameraNode ()

@property (nonatomic) SCNCamera *leftCamera;
@property (nonatomic) SCNCamera *rightCamera;

// Motion nodes
@property (nonatomic) SCNNode *rollNode;
@property (nonatomic) SCNNode *pitchNode;
@property (nonatomic) SCNNode *yawNode;

// Camera Nodes
@property (nonatomic, readwrite) SCNNode *leftCameraNode;
@property (nonatomic, readwrite) SCNNode *rightCameraNode;

@property (nonatomic) CMMotionManager *motionManager;

@end

@implementation TCVRCameraNode

- (instancetype)init {
    return [self initWithCameraMotion:YES];
}

- (instancetype)initWithCameraMotion:(BOOL)addCameraMotion {
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
        
        SCNNode *camerasNode = [SCNNode node];
        [camerasNode addChildNode:self.leftCameraNode];
        [camerasNode addChildNode:self.rightCameraNode];
        camerasNode.eulerAngles = SCNVector3Make([self degreesToRadians:-90.f], 0, 0);
        
        // Roll: (1, 0, 0)
        _rollNode = [SCNNode node];
        [_rollNode addChildNode:camerasNode];
        
        // Pitch: (0, 0, 1)
        _pitchNode = [SCNNode node];
        [_pitchNode addChildNode:_rollNode];
        
        // Yaw: (0, 1, 0)
        _yawNode = [SCNNode node];
        [_yawNode addChildNode:_pitchNode];
        
        [self addChildNode:_yawNode];
        
        
        // Respond to head movements
        if (addCameraMotion) {
            [self startCameraMotion];
        }
    }
    
    return self;
}


#pragma mark - Motion Updates

- (void)startCameraMotion {
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.deviceMotionUpdateInterval = 1.0 / 60.0;
    }
    
    [_motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical
                                                        toQueue:[[NSOperationQueue alloc] init]
                                                    withHandler:^(CMDeviceMotion *motion, NSError *error) {
                                                        CMAttitude *currentAttitude = motion.attitude;
                                                        double roll = currentAttitude.roll;
                                                        double pitch = currentAttitude.pitch;
                                                        double yaw = currentAttitude.yaw;
                                                        
                                                        // update the cameras (roll, yaw, pitch)
                                                        _rollNode.eulerAngles = SCNVector3Make(roll, 0, 0);
                                                        _pitchNode.eulerAngles = SCNVector3Make(0, 0, pitch);
                                                        _yawNode.eulerAngles = SCNVector3Make(0, yaw, 0);
                                                    }];
}

- (void)stopCameraMotion {
    if (_motionManager) {
        [_motionManager stopDeviceMotionUpdates];
    }
}


#pragma mark - Conversion Methods

- (CGFloat)degreesToRadians:(CGFloat)degrees {
    return (degrees * M_PI) / 180.0;
}

- (CGFloat)radiansToDegrees:(CGFloat)radians {
    return (180.0 / M_PI) * radians;
}

@end
