//
//  TCVRCamera.h
//  VR-Experiment
//
//  Created by Tim Carlson on 12/14/14.
//  Copyright (c) 2014 Tim Carlson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import <CoreMotion/CoreMotion.h>

@interface TCVRCamera : NSObject

@property (nonatomic, readonly) SCNNode *camerasMotionNode;

@property (nonatomic) SCNNode *leftCameraNode;
@property (nonatomic) SCNNode *rightCameraNode;

@end
