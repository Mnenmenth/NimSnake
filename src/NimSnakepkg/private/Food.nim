import SFMLBind, random, times

type
    Food* = ref object of RootObj
        ## Food for snake. Holds randomly generated position and rect that is drawn on screen
        randx, randy: int
        rect: RectangleShape

const RectSize = 15

proc rand(min, max: int): int = 
    ## Generate random number between max and min
    random((max-min)+1)+min

proc newPos*(food: Food, windowSize: Vector2u)
# Forward declaration of newPos

proc newFood*(windowSize: Vector2u): Food =
    ## Create a new Food object
    result = Food(
        randx: 0,
        randy: 0,
        rect: newRectangleShape(newVector2f(RectSize, RectSize))
    )
    result.newPos(windowSize)

proc newPos*(food: Food, windowSize: Vector2u) =
    ## Generate new random position
    randomize(epochTime().int64)
    food.rect.setPosition(rand(20, windowSize.x.int-20).cfloat, rand(20, windowSize.y.int-20).cfloat)

proc getRect*(food: Food): RectangleShape =
    ## Return rectangle that is drawn
    return food.rect    

proc isEaten*(food: Food, snakeHead: RectangleShape): bool =
    ## Has the food touched the snake head
    return food.getRect().getGlobalBounds().intersects(snakeHead.getGlobalBounds())

proc draw*(food: Food, window: RenderWindow) =
    ## Draw the food
    window.draw(food.getRect())