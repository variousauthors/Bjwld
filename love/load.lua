EMPTY = 'empty'
RED = 'red'
BLUE = 'blue'
PURPLE = 'purple'
ORANGE = 'orange'
YELLOW = 'yellow'
GREEN = 'yellow'

COLORS = { RED, GREEN, BLUE, PURPLE, ORANGE, YELLOW }

COLOR_RGB = {
    red = { 200, 0, 0 },
    blue = { 0, 0, 200 },
    green = { 0, 200, 0 },
    purple = { 200, 0, 200 },
    yellow = { 200, 200, 0 },
    orange = { 0, 200, 200 },
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

    game.cursor = {
        x = math.ceil(game.constants.width / 2),
        y = math.ceil(game.constants.height / 2),
    }

    print(game.cursor.x, game.cursor.y)

    for y = 1, game.constants.height, 1 do
        game.board.cells[y] = {}

        for x = 1, game.constants.width, 1 do
            game.board.cells[y][x] = get_random_color()
        end
    end
end
