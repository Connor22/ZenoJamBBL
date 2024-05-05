extends Resource
class_name Morale

@export_category("States")
## How long in seconds to wait after being hit to start going home again
@export_range(0.1, 5.0, 0.1, "suffix:s") var RecoveryTime: float

@export_category("Speeds")
## How fast should the VIP move towards the target
@export_range(0, 100, 1) var VIPTowardsTargetSpeed: float
## How fast the target moves along the path towards the VIP when pulled
@export_range(0, 100, 1) var TargetPullSpeed: float
## How fast should the VIP push its target back along the path
@export_range(0, 100, 1) var TargetBackwardsSpeed: float

@export_category("Forces")
## How much force the player has when bashing the VIP around
@export_range(1000, 100000, 1000) var PlayerImpactImpulse: float
## How fast in seconds the VIP should take to come to a stop when at the DecelerationDistance
@export_range(0.1, 1.0, 0.1, "suffix:s") var SecondsToStop: float

@export_category("Distances")
## At what distance should the VIP pull the target towards itself
@export_range(0, 1000, 10) var TargetPullDistance: float
## At what distance should the target pull the VIP towards itself
@export_range(0, 1000, 10) var VipMinPullDistance: float
## How far from the target should the VIP really slow itself down while being flung 
@export_range(0, 1000, 10) var DecelerationDistance: float
## How close should the VIP need to be to start pushing the target back
@export_range(0, 1000, 10) var PathMoveDistance: float

