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
        cell_gutter = 1
    }

    game.board = {
        cells = {}
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

    local bad_board = true

    while (bad_board) do
        for y = 1, game.constants.height, 1 do
            game.board.cells[y] = {}

            for x = 1, game.constants.width, 1 do
                local cell = build_block()
                cell.drawable.x = x
                cell.drawable.y = y

                game.board.cells[y][x] = cell
            end
        end

        game.board.height = #(game.board.cells)
        game.board.width = #(game.board.cells[1])

        local groups = board_all_matches(game.board)
        bad_board = #(groups) > 0
    end

    game.board.stable = true
end

function build_block (options)
    local options = options or {}
    local color = options.color or get_random_color()

    return {
        color = color,
        drawable = { x = 0, y = 0 }
    }
end
