EMPTY = 'empty'
RED = 'red'
GREEN = 'green'
BLUE = 'blue'
YELLOW = 'yellow'
PURPLE = 'purple'
CYAN = 'cyan'

COLORS = { RED, GREEN, BLUE, YELLOW, PURPLE, CYAN }

COLOR_RGB = {
    red = { 200, 0, 0 },
    green = { 0, 200, 0 },
    blue = { 0, 0, 200 },
    yellow = { 200, 200, 0 },
    purple = { 200, 0, 200 },
    cyan = { 0, 200, 200 },
}

DIRECTIONS = {
    { x = 0, y = 1 },
    { x = 1, y = 0 },
    { x = -1, y = 0 },
    { x = 0, y = -1 },
}

function get_random_color()
   return math.random(1, #(COLORS))
end

function love.load()
    require('game/controls')
    require('game/sounds')

    game = {
        scale = 3
    }

    game.constants = {
        height = 7,
        width = 7,
        cell_dim = 7,
        cell_gutter = 1,
        block_fall_speed = 2,
    }

    game.select_cursor = {
        x = math.ceil(game.constants.width / 2),
        y = math.ceil(game.constants.height / 2),
        active = true,
        input = nil,
    }

    game.swap_cursor = {
        x = game.select_cursor.x,
        y = game.select_cursor.y,
        active = false,
        input = nil,
    }

    game.active_cursor = game.select_cursor

    game.board = build_board()
    game.board.stable = true

end

function build_board (options)
    local options = options or {}
    local board = { cells = {} }
    local bad_board = true

    board.height = game.constants.height
    board.width = game.constants.width

    while (bad_board) do
        -- the top half is the buffer
        for y = 1, 2*game.constants.height, 1 do
            board.cells[y] = {}

            for x = 1, game.constants.width, 1 do
                local cell = build_block()
                cell.drawable.x = x
                cell.drawable.y = y

                board.cells[y][x] = cell
            end
        end

        local groups = board_all_matches(board)
        bad_board = #(groups) > 0
    end

    return board
end

function build_block (options)
    local options = options or {}
    local color = options.color or get_random_color()
    local attributes = options.attributes or {}

    return {
        color = color,
        drawable = { x = 0, y = 0 },
        attributes = attributes
    }
end
