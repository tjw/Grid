## v0.1

* NxM grid of locations
* One player only, can drag out pieces from either hand
* Hands of pieces all the same emitter

## v0.2

* Extract model code to model
* Add drop support to change model

## v0.3

* Switch to SceneKit to display (since particle systems will be bad news with AppKit/auto layout).
  * Research hit testing
      * Array of `SCNHitTestResult` objects returned from `- hitTest:options:` (in the `SCNSceneRenderer` protocol, which `SCNView` conforms to).
  * Research particle systems
      * Can probably use a geometry with 'point' types
      * Can maybe use a node render delegate
    
* Switch all sub view-controllers to be 'node' controllers
* Merge `SceneKit` branch to master once this works again

## v.4

* Add game logic timer
* Add particles

## vN

* Switch away from AppKit/auto layout to SceneKit (particle systems seem like they'd be trouble in particular)
* Add influence (needs some notion of players)
* Write model in server language
* Add display timer
* Add more piece types
