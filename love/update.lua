
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

function board_swap_cells(board, c1, c2)
    local x1 = c1.x
    local y1 = c1.y

    local x2 = c2.x
    local y2 = c2.y

    local cells = board.cells

    local tmp = cells[y1][x1]
    cells[y1][x1] = cells[y2][x2]
    cells[y2][x2] = tmp
end

function love.update(dt)
    local should_swap = false

    --Update here

    if (game.active_cursor.input ~= nil) then

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

    board_update(game.board)
end

function board_find_match(board, p)
    local x = p.x
    local y = p.y
    local cell = board_get_cell(board, x, y)

    local left = board_get_cell(board, x + 1, y)
    local left2 = board_get_cell(board, x + 2, y)
    local right = board_get_cell(board, x - 1, y)
    local right2 = board_get_cell(board, x - 2, y)

    local up = board_get_cell(board, x, y + 1)
    local up2 = board_get_cell(board, x, y + 2)
    local down = board_get_cell(board, x, y - 1)
    local down2 = board_get_cell(board, x, y - 2)

    cross_match = (left == cell and right == cell) or (up == cell and down == cell)
    x_match = (left == cell and left2 == cell) or (right == cell and right2 == cell)
    y_match = (up == cell and up2 == cell) or (down == cell and down2 == cell)

    return cross_match or x_match or y_match
end

function board_update(board)
    local groups = board_all_matches(board)

    -- clear matches
    for i = 1, #(groups), 1 do
        local group = groups[i]

        for j = 1, #(group), 1 do
            local cell = group[j]

            game.board.cells[cell.y][cell.x] = 'empty'
        end
    end
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

                while (neighbour and neighbour == cell) do
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

function build_entry(color, x, y)
    return {
         color = color,
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
