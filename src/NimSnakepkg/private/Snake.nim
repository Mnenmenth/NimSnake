import SFMLBind, sequtils, algorithm

type
    Snake* = ref object
        ## Snake head. Stores head position, the tail segments, and the velocity of the snake
        headPos: Vector2f
        segments: seq[RectangleShape]
        velocity: Vector2i

# Distance between each segment of the snake
const PositionDifference: float = 20.0
# Is the game over
var gameOver: bool = false
# Holds size and origin of every segment. Is copied when new segment is created
let defaultRect = newRectangleShape(newVector2f(10, 10))
# Place the origin of the shape in the center
defaultRect.setOrigin(defaultRect.getSize().x/2, defaultRect.getSize().y/2)

proc newSnake*(startPos: Vector2f): Snake =
    ## Creates a new snake
    let snake = Snake(
        headPos: startPos,
        velocity: newVector2i(0, -1),
        segments: @[]
    )
    # Snake has 4 segments by default. So loop 4 times
    for i in 0..3:
        # Copy default rect for new segment
        var segment = defaultRect
        # Create each segment directly below the last
        segment.setPosition(startPos.x, startPos.y + (PositionDifference*i.float))
        # Add the new segment to segments
        snake.segments.add(segment)
    return snake

proc segmentsCollide(snake: Snake): bool =
    ## Have any of the segments of the snake collided with each other

    # Loop through each segment
    for segment in snake.segments:
        # Keep track of the number of collisions
        var collisions = 0
        # Loop through each of the segments again
        # This is so every segment is checked against every other segment for collision
        for segment1 in snake.segments:
            # If the segments have collided, then add another collision
            if segment.getGlobalBounds().intersects(segment1.getGlobalBounds()):
                collisions += 1
            # The head of the snake will always collide with itself, so return true when there is 2 collisions
            if collisions >= 2:
                return true
    return false

proc updateSegments(snake: Snake, newHead: Vector2f) =
    ## Move all of the segments in accordance with the velocity

    # Copy the current segments into a new variable
    var lastSegments: seq[RectangleShape] = @[]
    for s in snake.segments:
        lastSegments.add(s)
    # Update the head of the snake to the new position
    snake.segments[0].setPosition(newHead)
    snake.headPos = newHead
    # Update every other segment ot the position of the segment in front of it
    for i in 1..lastSegments.len-1:
        snake.segments[i].setPosition(lastSegments[i-1].getPosition())
    
proc addSegment*(snake: Snake) =
    ## Add a segment to the snake

    # Copy the last segment of the snake
    let lastSegment = snake.segments[snake.segments.len-1]
    # Copy the second to last segment of the snake
    let secondlastSegment = snake.segments[snake.segments.len-2]
    # Create a new segment from the default specifications
    let newSegment = defaultRect
    # Copy the position of the last segment
    var pos = lastSegment.getPosition()

    # If the snake is vertical, then modify the y position of the new segment
    if lastSegment.getPosition().x == secondlastSegment.getPosition().x:
        # If the snake is heading down, add a new segment towards the top of the screen
        if lastSegment.getPosition().y < secondlastSegment.getPosition().y:
            pos.y = lastSegment.getPosition().y - PositionDifference
        # Otherwise, the snake must be going up, so add a new segment towards the bottom of the screen
        else:
            pos.y = lastSegment.getPosition().y + PositionDifference
    # If the snake is horizontal, then modify the x position of the new segment
    elif lastSegment.getPosition().y == secondlastSegment.getPosition().y:
        # If the snake is heading right, then add a new segment towards the left of the screen
        if lastSegment.getPosition().x < secondlastSegment.getPosition().x:
            pos.x = lastSegment.getPosition().x - PositionDifference
        # Otherwise, the snake must be heading left, so add a new segment towards the right of the screen
        else:
            pos.x = lastSegment.getPosition().x + PositionDifference
    # Update the new segment with its new position
    newSegment.setPosition(pos)
    # Add the new segment to the snake
    snake.segments.add(newSegment)

proc headRect*(snake: Snake): RectangleShape =
    ## Returns the head of the snake
    snake.segments[0]

proc moveSnake*(snake: Snake, key: Key) =
    ## Adjusts the velocity of the snake based on user input

    # If key pressed is Up and snake is not already going up
    if key == Up and snake.velocity.y != 1:
        snake.velocity.x = 0
        snake.velocity.y = -1
    # If key pressed is Down and snake is not already going down
    elif key == Down and snake.velocity.y != -1:
        snake.velocity.x = 0
        snake.velocity.y = 1
    # If key pressed is Left and snake is not already going left
    elif key == Left and snake.velocity.x != 1:
        snake.velocity.x = -1
        snake.velocity.y = 0
    # If key pressed is Right and snake is not already going right
    elif key == Right and snake.velocity.x != -1:
        snake.velocity.x = 1
        snake.velocity.y = 0

proc draw*(snake: Snake, window: RenderWindow): bool =
    ## Draws the snake. Returns if the snake should continue being drawn
    result = false
    # Do this if the game has not ended
    if not gameOver:
        # Update the segments with the new head position based on the snakes velocity
        snake.updateSegments(newVector2f(
            snake.headPos.x + PositionDifference * snake.velocity.x.float, 
            snake.headPos.y + PositionDifference * snake.velocity.y.float))
        # If the snake collides with itself, end the game
        if snake.segmentsCollide:
            gameOver = true
        # Draw each of the segments of the snake
        for segment in snake.segments:
            window.draw(segment)
        # 
        result = true
        