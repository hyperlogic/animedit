animedit
-------------

WIP animation.json editor for High Fidelity.

TODO: rightHandPane editors for the following node types:
* DONE: clip
* DONE: blendLinear
* DONE: blendLinearMove - (float[] field)
* DONE: overlay
* stateMachine - (raw json blob edit field) for states and transitions.
* randomStateMachine - (raw json blob edit field) for states
* manipulator - (list of joints)
* inverseKinematics - (raw json blob edit field)
* DONE: defaultPose
* twoBoneIK - (vec3 field)
* splineIK - (float[] field)
* poleVectorConstraint - (float[] field)

* implement raw json edit field with syntax checking.
* output poses support.
* implement support for stateMachine, randomStateMachine, inverseKinematics, twoBoneIK, splineIK and poleVectorConstraint nodes.
* "save" - serialize model back out to pretty-printed json
* add children, remove children
* shift click to expand children
* middle click drag to manipulate heirarchy
* find

