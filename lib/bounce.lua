
local UI = require "ui"

screen.aa(1)

------------------------------
-- define variables
------------------------------

local movers = {}
local num_movers = 3

-- local wind = vector:new(0.5,0);
local wind = vector:new(0,0);

------------------------------
-- Mover class 
-- Scales gravity by mass to be more accurate
----
local Mover = {}
Mover.__index = Mover

function Mover:new(vol, mass, x, y, id)
  local m = {}
  setmetatable(m, Mover)
  m.location = vector:new(x,y)
  m.velocity = vector:new(0,0)
  m.vol = vol
  m.mass = mass
  m.acceleration = vector:new(0,0)
  
  m.gravity = vector:new(0,5);
  
  m.id = id

  function m.apply_force(force)
    local x = force.x > 0 and force.x / m.mass or 0
    local y = force.y > 0 and force.y / m.mass or 0
    f = vector:new(x,y)
    m.acceleration:add(f)
  end
  
  function m.update()
    m.apply_force(wind)
    m.apply_force(m.gravity);
  
  
    m.velocity:add(m.acceleration)
    m.location:add(m.velocity)
    m.acceleration:mult(vector:new(0,0))
  end
  
  function m.display()
    screen.circle(m.location.x, m.location.y, m.vol) -- scaling the size according to volume (vol).
    -- print(vol)
    screen.level(screen_level_graphics - (id*4))
    screen.fill()
    screen.stroke()
  end
  m.check_edges = check_edges  
  return m
end

------------------------------
-- init
------------------------------
local function init()
  for i=1, num_movers, 1
  do
    local vol = 5
    local mass = 10*i
    local circle_spacing = screen_size.x/num_movers
    movers[i] = Mover:new(vol, mass, circle_spacing * i - circle_spacing/2,15,i)
  end
end

-- function g.key(x, y, z) 
  -- noc.handle_grid_input(x, y, z)
-- end

--------------------------
-- utilities
--------------------------
function check_edges(mover)
  if (mover.location.x > screen_size.x) then
    mover.location.x = screen_size.x;
    mover.velocity:mult(vector:new(-1,1))
    print("boink", mover.id)
  end
  if (mover.location.y > screen_size.y) then
    mover.location.y = screen_size.y;
    mover.velocity:mult(vector:new(1,-1))
    print("boink", mover.id)
  end
end


--------------------------
-- update
--------------------------
local function update()
  local menu_status = norns.menu.status()

  for i = 1, num_movers, 1
  do
    movers[i].update()
    movers[i].check_edges(movers[i])
  end
  
  if menu_status == false and initializing == false then
    screen.clear()
    screen.level(screen_level_graphics)
    for i = 1, num_movers, 1
    do
      movers[i].display()
    end
    screen.update()
  end
end

init()

return {
  update = update
}
