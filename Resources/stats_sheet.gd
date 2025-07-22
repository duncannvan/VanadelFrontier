class_name StatsSheet extends Resource

const INVALID: int = -1
const MAX_SPEED_CAP: int = 100
const MIN_SPEED_CAP: int = 0
const MAX_HEALTH_CAP: int = 30
const MIN_HEALTH_CAP: int = 1

@export_range(INVALID, MAX_SPEED_CAP) var speed: int = INVALID
@export_range(INVALID, MAX_HEALTH_CAP) var health: int = INVALID
