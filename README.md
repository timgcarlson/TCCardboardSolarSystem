TCCardboardSolarSystem
======================

A demo project showing how to create Google Cardboard virtual reality experiences with iOS and SceneKit.

https://www.google.com/get/cardboard/

Even supports the magnetic trigger using a delegate protocol `TCCardboardMagneticSensorDelegate`. See below.

The project uses two custom classes that give you basic VR support for iOS (`TCCardboardCameraNode` and `TCCardboardMagneticSensor`).

## TCCardboardViewController

Use this class to draw two SCNScenes on the view, one for the left eye and one for the right. Adding a TCCardboardCameraNode to TCCardboardViewController will assign each camera to a SCNScene. This view controller will handle the Auto Layout constraints for you.

## TCCardboardCameraNode

Before creating a `TCCardboardCameraNode`, you will have to create a mirror image of two scenes. This project does this in the storyboard. Create the `TCCardboardCameraNode` and assign it's `leftCameraNode` to the left scene's `pointOfView` and the `rightCameraNode` to the right scene's `pointOfView`. This is now your camera that will handle all head tracking motion for you.


## TCCardboardMagneticSensor

Google Cardboard has a magnetic trigger on the left side. The ability to use this isn't unique to Android devices, as you just need to detect the disruption to the magnetic field around the device's compass. That is exatly what `TCCardboardMagneticSensor` handles for you. Simply inherit the `TCCardboardMagneticSensorDelegate` and create the method `onCardboardTrigger`, and you have yourself a basic input for your applicaiton.
