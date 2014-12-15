//
//  TCVRCameraNode.h
//  VR-Experiment
//
//  Created by Tim Carlson on 12/14/14.
//  Copyright (c) 2014 Tim Carlson. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import <SceneKit/SceneKit.h>
#import <CoreMotion/CoreMotion.h>

/** A camera node for SceneKit that handles movement via the device-motion in a virtual reality space. Provides camera motion to simulate head movement (roll, pitch and yaw).
 */
@interface TCVRCameraNode : SCNNode

#pragma mark - Properties

/** The point of view for the left view (the left eye).
 @abstract Assign this node as the pointOfView for the left scene.
 */
@property (nonatomic, readonly) SCNNode *leftCameraNode;

/** The point of view for the left view (the left eye).
 @abstract Assign this node as the pointOfView for the right scene.
 */
@property (nonatomic, readonly) SCNNode *rightCameraNode;


#pragma mark - Instance Methods

/** Initializes a new TCVRCamera object.
 @param addCameraMotion Passing YES will begin camera motion immediately after creating the object.
 */
- (instancetype)initWithCameraMotion:(BOOL)addCameraMotion;

/** Starts camera-motion based on the device motion.
 @abstract This will run NOT run on the main operation queue.
 */
- (void)startCameraMotion;

/** Stops camera-motion based on the device motion.
 */
- (void)stopCameraMotion;


@end
