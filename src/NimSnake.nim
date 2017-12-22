import NimSnakepkg/private/SFMLBind, NimSnakepkg/private/Snake, NimSnakepkg/private/Food, strutils
{.link: "../snake.res".}

proc snakeInBounds(snake: RectangleShape, window: FloatRect): bool =
    ## Calculates each of the corners of the rectangle that 
    ## makes the head of the snake and checks if it is inside of the window
    let snakePos = snake.getPosition()
    let snakeSize = snake.getSize()
    let halfSizeX = snakeSize.x/2
    let halfSizeY = snakeSize.y/2
    let leftX = snakePos.x - halfSizeX
    let rightX = snakePos.x + halfSizeX
    let topY = snakePos.y - halfSizeY
    let bottomY = snakePos.y + halfSizeY
    let topLeft = newVector2f(leftX, topY)
    let topRight = newVector2f(rightX, topY)
    let bottomLeft = newVector2f(leftX, bottomY)
    let bottomRight = newVector2f(rightX, bottomY)
    if window.contains(topLeft) and window.contains(topRight) and window.contains(bottomLeft) and window.contains(bottomRight):
        return true
    return false

proc main() =
    # Create new settings for window
    var settings = newContextSettings()
    settings.antialiasingLevel = 16
    settings.depthBits = 24
    settings.stencilBits = 8

    # Create new window
    let window = newRenderWindow(newVideoMode(1280, 720), "Snake", Style.Close, settings)
    let img = newImage()
    if not img.loadFromFile(newCppString("snake.png")):
        window.setIcon(img.getSize().x, img.getSize().y, img.getPixelsPtr())
    # Set the clear color to black
    let clearColor = newColor(0, 0, 0)
    
    # Create new snake
    let snake = newSnake(newVector2f(200, 200))
    # Create new food
    let food = newFood(window.getSize())
    # Create new clock
    let clock = newClock()

    # Variables for loop
    var render = true
    var move = false    
    var win = false
    var lose = false
    var score = 0
    let maxScore = 5

    # Load font for text
    let font = newFont()
    discard font.loadFromFile(newCppString("font.ttf"))

    # Create new text from font
    let text = newText()
    text.setFont(font)
    # Set text to 'Score: score/max'
    text.setString(newCppString("Score: " & score.intToStr & "/" & maxScore.intToStr))

    # Bounding box of window
    let windowRect = newFloatRect(0, 0, window.getSize().x.cfloat, window.getSize().y.cfloat)

    # While the window is open, and the user has not lost or won
    while window.isOpen() and not win and not lose:
        # Controls FPS and speed of snake
        if clock.getElapsedTime().asSeconds() >= 0.1:
            render = true
            discard clock.restart()

        # Poll window for events
        let event = newEvent()
        while window.pollEvent(event):
            # If close is requested, then close
            if event.type == Closed or isKeyPressed(Escape):
                window.close()
            
            # If a snake control button is pressed, then send the input to snake for snake movement
            # If Up key is pressed
            if (isKeyPressed(Up) and not isKeyPressed(Down) and not isKeyPressed(Left) and not isKeyPressed(Right)) or 
                # If Down key is pressed
                (not isKeyPressed(Up) and isKeyPressed(Down) and not isKeyPressed(Left) and not isKeyPressed(Right)) or 
                # If Left key is pressed
                (not isKeyPressed(Up) and not isKeyPressed(Down) and isKeyPressed(Left) and not isKeyPressed(Right)) or 
                # If Right key is pressed
                (not isKeyPressed(Up) and not isKeyPressed(Down) and not isKeyPressed(Left) and isKeyPressed(Right)):
                snake.moveSnake(event.key.code)
            

        # If the window should be updated
        if render:
            # Clear the screen
            window.clear(clearColor)

            # If the snake exists the window, user has lost
            if not snakeInBounds(snake.headRect(), windowRect):
                lose = true
            
            # Draw the food
            food.draw(window)

            # If the snake should stop being draw, the user lost
            # Is triggered by events such as collision with own tail segments
            if not snake.draw(window):
                lose = true
            
            # If the food touches the snakes head
            if food.isEaten(snake.headRect()):
                # Add segment to the snake
                snake.addSegment()
                # Generate a new position for the food
                food.newPos(window.getSize())
                # Increment score
                score += 1
                # Update the score counter
                text.setString(newCppString("Score: " & score.intToStr & "/" & maxScore.intToStr))
                # If the score reaches the max, the user won
                if score >= maxScore:
                    win = true

            # Draw the score counter
            window.draw(text)
            # Draw everything to the window             
            window.display()
            render = false

    # If the user has lost or won, set the appropriate text
    if lose:
        text.setString(newCppString("Game Over"))
    if win:
        text.setString(newCppString("You Win!"))
    
    # Set the character size, origin and position of the text
    text.setCharacterSize(30);
    text.setOrigin(text.getGlobalBounds().width / 2, text.getGlobalBounds().height / 2)
    text.setPosition(window.getSize().x.int / 2.int, window.getSize().y.int / 2.int)

    # Update window
    window.display()
    # Draw text
    window.draw(text)
    # Update window
    window.display()

    # Keep the window open until exit is requested
    while window.isOpen():
        let event = newEvent()
        while window.pollEvent(event):
            if event.type == Closed or isKeyPressed(Escape):
                window.close()
    
# If something crashes, print out the message
try:
    main()
except:
    echo getCurrentExceptionMsg()