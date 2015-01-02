//
//  TCCardboardViewController.h
//  TCCardboardSolarSystem
//
//  Created by Tim Carlson on 1/1/15.
//  Copyright (c) 2015 Tim Carlson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>

@class TCCardboardCameraNode;

/** A view controller for virtual reality Scene Kit applications. Displays on view with Auto Layout. */
@interface TCCardboardViewController : UIViewController

/** The scene for the left eye. (readonly) */
@property (nonatomic, strong, readonly) SCNView *leftSceneView;
/** The scene for the right eye. (readonly) */
@property (nonatomic, strong, readonly) SCNView *rightSceneView;

/** The main scene for the view controller. This will be initialized for you. Add nodes to your scene with scene's rootNode property. */
@property (nonatomic, strong) SCNScene *scene;


/** Adds a TCCardboardCameraNode to the scene and sets the point of view for each camera.
 @param vrCamera The TCCardboardCameraNode to be added.
 */
- (void)addVRCamera:(TCCardboardCameraNode *)vrCamera;

@end
