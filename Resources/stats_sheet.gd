class_name StatsSheet extends Resource

const MIN_HEALTH: int = 1
const MAX_HEALTH: int = 30
const MIN_SPEED: int = 0
const MAX_SPEED: int = 200

@export_range(MIN_SPEED, MAX_SPEED) var _speed: int
@export_range(MIN_HEALTH, MAX_HEALTH) var _full_health: int
