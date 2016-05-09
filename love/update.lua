
function update_cursor()
    if (game.select_cursor.active == true) then
        -- move the select cursor freely around the board

        if (game.active_cursor.input == 'up') then game.active_cursor.y = game.active_cursor.y - 1 end
        if (game.active_cursor.input == 'down') then game.active_cursor.y = game.active_cursor.y + 1 end
        if (game.active_cursor.input == 'left') then game.active_cursor.x = game.active_cursor.x - 1 end
        if (game.active_cursor.input == 'right') then game.active_cursor.x = game.active_cursor.x + 1 end

    elseif (game.swap_cursor.active == true) then
        -- set the swap cursor to a cardinal offset from the select cursor

        if (game.active_cursor.input == 'up') then
            game.active_cursor.y = game.select_cursor.y - 1
            game.active_cursor.x = game.select_cursor.x
        end
        if (game.active_cursor.input == 'down') then
            game.active_cursor.y = game.select_cursor.y + 1
            game.active_cursor.x = game.select_cursor.x
        end
        if (game.active_cursor.input == 'left') then
            game.active_cursor.y = game.select_cursor.y
            game.active_cursor.x = game.select_cursor.x - 1
        end
        if (game.active_cursor.input == 'right') then
            game.active_cursor.y = game.select_cursor.y
            game.active_cursor.x = game.select_cursor.x + 1
        end
    end
end

function toggle_cursor()
    local should_swap = false

    if (game.select_cursor.active == true) then
        -- change to the swap cursor

        game.select_cursor.active = false
        game.swap_cursor.x = game.select_cursor.x
        game.swap_cursor.y = game.select_cursor.y

        game.swap_cursor.active = true
        game.active_cursor = game.swap_cursor
    elseif game.swap_cursor.active == true then
        -- remove the swap cursor, perform the swap, etc

        game.swap_cursor.active = false

        game.select_cursor.active = true
        game.active_cursor = game.select_cursor

        if (game.swap_cursor.x ~= game.select_cursor.x or game.swap_cursor.y ~= game.select_cursor.y) then
            should_swap = true
        end
    end

    return should_swap
end

function board_swap_cells(board, a, b)
    local x1 = a.x
    local y1 = a.y

    local x2 = b.x
    local y2 = b.y

    local cells = board.cells

    local tmp = cells[y1][x1]
    local cell = cells[y2][x2]
    cells[y1][x1] = cells[y2][x2]
    cells[y2][x2] = tmp

    tmp.drawable.x = x2
    tmp.drawable.y = y2
    cell.drawable.x = x1
    cell.drawable.y = y1
end

function board_find_match(board, p)
    local x = p.x
    local y = p.y
    local cell = board_get_cell(board, x, y)

    if cell == nil or cell.color == EMPTY then return false end

    -- TODO this needs to be rewritten as a nice loop so that we can use nil cells
    -- we can iterate over DIRECTIONS again
    -- if any of the blocks is nil or the color doesn't match, abort the direction

    -- matches like []X[]
    for i = 1, #(DIRECTIONS), 1 do
        local dir = DIRECTIONS[i]

        -- check two neighbours

    end

    -- matches like X[][]
    for i = 1, #(DIRECTIONS), 1 do
        local dir = DIRECTIONS[i]

        -- check up to two blocks in dir

    end

    local left = board_get_cell_color(board, x + 1, y)
    local left2 = board_get_cell_color(board, x + 2, y)
    local right = board_get_cell_color(board, x - 1, y)
    local right2 = board_get_cell_color(board, x - 2, y)

    local up = board_get_cell_color(board, x, y + 1)
    local up2 = board_get_cell_color(board, x, y + 2)
    local down = board_get_cell_color(board, x, y - 1)
    local down2 = board_get_cell_color(board, x, y - 2)

    local color = cell.color

    cross_match = (left == color and right == color) or (up == color and down == color)
    x_match = (left == color and left2 == color) or (right == color and right2 == color)
    y_match = (up == color and up2 == color) or (down == color and down2 == color)

    return cross_match or x_match or y_match
end

function board_update(board, dt)
    local groups = board_all_matches(board)
    local matches = #(groups)

    if (board.stable) then
        -- clear matches
        for i = 1, #(groups), 1 do
            local group = groups[i]

            for j = 1, #(group), 1 do
                local entry = group[j]

                game.board.cells[entry.y][entry.x] = build_block({ color = EMPTY })
            end
        end
    end

    -- start the physics
    local cells = board.cells
    local motion = false

    board.stable = false

    for y = #(cells), 1, -1 do

        for x = 1, #(cells[y]), 1 do
            local cell = board_get_cell(board, x, y)

            cell, x, y = cell_update(cell, board, x, y, dt)

            if cell.motion ~= nil then
                motion = true
            end
        end
    end

    if (not motion) then board.stable = true end
end

function adjust (start, last)
    local n = 0
    local diff = last - start

    if diff ~= 0 then
        n = diff / math.abs(diff)
    end

    return n
end

function board_all_matches(board)
    local cells = board.cells
    local groups = {}

    for y = 1, #(cells), 1 do
        for x = 1, #(cells[y]), 1 do
            local cell = cells[y][x]

            for i = 1, #(DIRECTIONS), 1 do
                local dir = DIRECTIONS[i]
                local dx = dir.x
                local dy = dir.y
                local nx = x + dx
                local ny = y + dy

                local neighbour = board_get_cell(game.board, nx, ny)
                local group = { build_entry(cell, x, y) }

                while (neighbour and neighbour.color == cell.color) do
                    table.insert(group, build_entry(neighbour, nx, ny))

                    nx = nx + dx
                    ny = ny + dy
                    neighbour = board_get_cell(game.board, nx, ny)
                end

                if #(group) > 2 then
                    table.insert(groups, group)
                end
            end
        end
    end

    return groups
end

function build_entry(cell, x, y)
    return {
         cell = cell,
         x = x,
         y = y
    }
end

function board_get_cell(board, x, y)
    local cell = nil

    if (x > 0 and x < board.width + 1) and (y > 0 and y < board.height + 1) then
        cell = board.cells[y][x]
    end

    return cell
end

function board_get_cell_color(board, x, y)
    local color = nil

    if (x > 0 and x < board.width + 1) and (y > 0 and y < board.height + 1) then
        local cell = board.cells[y][x]

        if cell ~= nil then
            color = cell.color
        end
    end

    return color
end

function love.update(dt)
    local should_swap = false

    if (game.board.stable and game.active_cursor.input ~= nil) then

        update_cursor()

        if (game.active_cursor.input == 'select') then
            should_swap = toggle_cursor()
        end
    end

    game.active_cursor.input = nil

    if (should_swap) then
        board_swap_cells(game.board, game.select_cursor, game.swap_cursor)

        if (board_find_match(game.board, game.swap_cursor) or board_find_match(game.board, game.select_cursor)) then
            -- NOP

            game.select_cursor.x = game.swap_cursor.x
            game.select_cursor.y = game.swap_cursor.y
        else
            -- the change was not significant, so unswap them
            board_swap_cells(game.board, game.select_cursor, game.swap_cursor)
        end

    end

    -- TODO check the board for rows or cols

    board_update(game.board, dt)
end

function cell_update(cell, board, x, y, dt)
    local cells = board.cells

    -- check for empty cells at the top of the board and replace them
    --          if y == 1 then
    --              if cell ~= nil and cell.color == EMPTY then
    --                  cell = build_block()
    --                  cell.drawable.x = x
    --                  cell.drawable.y = y - 1
    --                  cell.motion = { x = x, y = y }

    --                  cells[y][x] = cell
    --              end
    --          end

    if (cell ~= nil and cell.color ~= EMPTY) then

        -- check if we need to start the cell moving
        local below = board_get_cell(board, x, y + 1)

        if (below ~= nil and below.color == EMPTY) then
            -- mark as falling
            -- empty the cell
            cells[y][x] = build_block({ color = EMPTY })

            x = x
            y = y + 1

            cells[y][x] = cell

            cell.motion = { x = x, y = y }
        end

        -- update the cell's draw position based on the motion

        if cell.motion ~= nil then
            local nx = adjust(cell.drawable.x, cell.motion.x)
            local ny = adjust(cell.drawable.y, cell.motion.y)

            cell.drawable.x = cell.drawable.x + nx * dt * game.constants.block_fall_speed
            cell.drawable.y = cell.drawable.y + ny * dt * game.constants.block_fall_speed

            local dist = math.pow(cell.motion.x - cell.drawable.x, 2) + math.pow(cell.motion.y - cell.drawable.y, 2)

            if dist < (dt / 10) then
                cell.drawable.x = cell.motion.x
                cell.drawable.y = cell.motion.y
                cell.motion = nil
            end
        end
    end

    return cell, x, y
end
