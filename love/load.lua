EMPTY = 0

function love.load()
    require('game/controls')
    require('game/sounds')

    game = {
        scale = 2
    }

    game.constants = {
        height = 18,
        width = 7,
        cell_dim = 5,
        cell_gutter = 1
    }

    game.board = {
        cells = {}
    }

    game.cursor = {
        x = math.ceil(game.constants.width / 2),
        y = game.constants.height / 2,
    }

    print(game.cursor.x, game.cursor.y)

    for y = 1, game.constants.height, 1 do
        game.board.cells[y] = {}

        for x = 1, game.constants.width, 1 do
            game.board.cells[y][x] = EMPTY
        end
    end
end
