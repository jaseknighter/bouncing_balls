---bouncing balls
-- <version> @<author> and @jaseknighter
-- lines: llllllll.co/t/<lines thread id>
--
-- bouncing ball code based on code from Daniel Shiffman's The Nature of Code (https://natureofcode.com/book/chapter-2-forces/).

include "lib/includes"

------------------------------
-- init
------------------------------
function init()

  -- set sensitivity of the encoders
  norns.enc.sens(1,6)
  norns.enc.sens(2,6)
  norns.enc.sens(3,6)

  pages = UI.Pages.new(0, 5)
    
  set_redraw_timer()
  page_scroll(1)
  
  initializing = false
end

--------------------------
-- encoders and keys
--------------------------
function enc(n, delta)
  encoders_and_keys.enc(n, delta)
end

function key(n,z)
  encoders_and_keys.key(n, z)
end

--------------------------
-- redraw 
--------------------------
function set_redraw_timer()
  redrawtimer = metro.init(function() 
    local menu_status = norns.menu.status()
    if menu_status == false and initializing == false then
      bball_pages.update_pages()
    end
  end, SCREEN_FRAMERATE, -1)
  redrawtimer:start()  
end


function cleanup ()
  -- add cleanup code
end

