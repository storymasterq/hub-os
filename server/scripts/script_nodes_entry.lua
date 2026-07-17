local ScriptNodes = require("scripts/libs/script_nodes")
local Direction = require("scripts/libs/direction")

local scripts = ScriptNodes:new()

-- define consumable items
Net.register_item("MiniEnrg", {
  name = "MiniEnrg",
  description = "Recovers 50HP!",
  consumable = true
})

Net.register_item("FullEnrg", {
  name = "FullEnrg",
  description = "Recovers max HP!",
  consumable = true
})

Net.register_item("SneakRun", {
  name = "SneakRun",
  description = "No weak viruses for a while.",
  consumable = true
})

-- load areas after defining items (allows shops to cache item names)
for _, area_id in ipairs(Net.list_areas()) do
  scripts:load(area_id)
end

-- define universal handlers (avoid to use custom handling for each area)
local item_use_map = {
  MiniEnrg = function(event)
    local health = Net.get_player_health(event.player_id)
    local max_health = Net.get_player_max_health(event.player_id)
    Net.set_player_health(event.player_id, math.min(health + 50, max_health))
  end,
  FullEnrg = function(event)
    local max_health = Net.get_player_max_health(event.player_id)
    Net.set_player_health(event.player_id, max_health)
  end,
  -- SneakRun is handled per map.
}

Net:on("item_use", function(event)
  local callback = item_use_map[event.item_id]

  if callback then
    Net.give_player_item(event.player_id, event.item_id, -1)
    callback(event)
  end
end)

-- Moves a map object one full isometric tile in the requested direction.
--
-- Expected event fields:
--   player_id: player whose current area contains the object
--   object_id: object id in the area
--   direction: a Direction value, such as Direction.UP or Direction.UP_LEFT
Net:on("gate_open", function(event)
  if not event.player_id or not event.object_id or not event.direction then
    print("[gate_open] Missing player_id, object_id, or direction")
    return
  end

  local area_id = Net.get_actor_area(event.player_id)
  local object = Net.get_object_by_id(area_id, event.object_id)

  if not object then
    print("[gate_open] Object not found: " .. tostring(event.object_id))
    return
  end

  local direction = tostring(event.direction):upper():gsub("_", " ")
  local tile_x, tile_y = Direction.vector_multi(direction)

  if not tile_x then
    print("[gate_open] Invalid direction: " .. tostring(event.direction))
    return
  end

  local tile_width = Net.get_tile_width(area_id)
  local tile_height = tile_width / 2
  local offset_x = (tile_x - tile_y) * tile_width / 2
  local offset_y = (tile_x + tile_y) * tile_height / 2

  Net.move_object(
    area_id,
    event.object_id,
    object.x + offset_x,
    object.y + offset_y,
    object.z
  )
end)

-- handle battle results (never called if `Forget Results` is set to true on `Encounter` nodes)
scripts:on_encounter_result(function(result)
  local player_id = result.player_id

  if result.health <= 0 then
    -- handle deletion
    Net.set_player_health(player_id, 1)
    return
  end

  local health = math.min(Net.get_player_max_health(player_id), result.health)
  Net.set_player_health(player_id, health)
  Net.set_player_emotion(player_id, result.emotion)
end)

scripts:on_inventory_update(function(player_id, item_id)
  -- update save data
end)

scripts:on_money_update(function(player_id)
  -- update save data
end)

-- create custom script nodes
-- scripts:implement_node("custom", function(context, object)
--   scripts:execute_next_node(context, context.area_id, object)
-- end)

-- listen to areas added by :load(), including dynamically instanced areas
-- scripts:on_load(function(area_id)
-- end)
