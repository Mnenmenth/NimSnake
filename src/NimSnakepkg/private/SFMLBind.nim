# TODO: Document and Organize this mess into seperate files

{.passL: "-lsfml-graphics -lsfml-system -lsfml-window".}
include SFMLKeys, SFMLEvents
# Import SFML functions
const HEADER = "<SFML/Graphics.hpp>"
type
    CppString* {.importcpp: "std::string", header: "<string>".} = object    
    VideoMode* {.importcpp: "sf::VideoMode", header: HEADER.} = object
    RenderWindow* {.importcpp: "sf::RenderWindow", byref, header: HEADER.} = object
    KeyEvent* {.importcpp: "sf::Event::KeyEvent", header: HEADER.} = object
        code*: Key
    Event* {.importcpp: "sf::Event", header: HEADER.} = object
        `type`*: EventType
        key*: KeyEvent
    Style* = enum
        # Easier to declare Enum this way rather than import from SFML lib
        None = 0.uint32,
        Titlebar = (1 shl 0).uint32,
        Resize = (1 shl 1).uint32,
        Close = (1 shl 2).uint32,
        Fullscreen = (1 shl 3).uint32
    ContextSettings* {.importcpp: "sf::ContextSettings", header: HEADER.} = object
        antialiasingLevel*: cuint
        depthBits*: cuint
        stencilBits*: cuint
    Color* {.importcpp: "sf::Color", header: HEADER.} = object
    Drawable* {.importcpp: "sf::Drawable", header: HEADER.} = object
    Vector2u* {.importcpp: "sf::Vector2u", header: HEADER.} = object
        x*: cuint
        y*: cuint
    Vector2f* {.importcpp: "sf::Vector2f", header: HEADER.} = object
        x*: cfloat
        y*: cfloat
    Vector2i* {.importcpp: "sf::Vector2i", header: HEADER.} = object
        x*: cint
        y*: cint
    # TODO: Research more into nim->cpp ffi templating - check if it is actually broken or not
    FloatRect* {.importcpp: "sf::FloatRect", header: HEADER.} = object
        left*: cfloat
        right*: cfloat
        width*: cfloat
        height*: cfloat
    IntRect* {.importcpp: "sf::IntRect", header: HEADER.} = object
        left*: cint
        right*: cint
        width*: cint
        height*: cint
    RectangleShape* {.importcpp: "sf::RectangleShape", header: HEADER.} = object
    Clock* {.importcpp: "sf::Clock", header: HEADER.} = object
    Time* {.importcpp: "sf::Time", header: HEADER.} = object
    Font* {.importcpp: "sf::Font", header: HEADER.} = object
    Text* {.importcpp: "sf::Text", header: HEADER.} = object
    Image* {.importcpp: "sf::Image", header: HEADER.} = object

proc newCppString*(str: cstring): CppString
    {.importcpp: "std::string(@)", header: "<string>".}

proc newVideoMode*(width, height: cuint, bitsPerPixel: cuint = 32): VideoMode
    {.importcpp: "sf::VideoMode(@)", constructor, header: HEADER.}

# For multile styles, ex: Close.ord or Titlebar.ord or Resize.ord
proc newRenderWindow(mode: VideoMode, title: cstring, style: uint32, settings: ContextSettings): RenderWindow
    {.importcpp: "sf::RenderWindow(@)", constructor, header: HEADER.}

# For single style, ex: Close
proc newRenderWindow*(mode: VideoMode, title: cstring, style: Style, settings: ContextSettings): RenderWindow
    {.importcpp: "sf::RenderWindow(@)", constructor, header: HEADER.}

proc isOpen*(window: RenderWindow): bool
    {.importcpp: "#.isOpen(@)", header: HEADER.}

proc close*(window: RenderWindow)
    {.importcpp: "#.close(@)", header: HEADER.}

proc display*(window: RenderWindow)
    {.importcpp: "#.display(@)", header: HEADER.}

proc clear*(window: RenderWindow, color: Color)
    {.importcpp: "#.clear(@)", header: HEADER.}

# !! T MUST INHERIT SFML DRAWABLE
# TODO: Figure out nim->cpp inheritance ffi so objects can inherit drawable in nim
proc draw*[T](window: RenderWindow, drawable: T)
    {.importcpp: "#.draw(@)", header: HEADER.}

proc setFramerateLimit*(window: RenderWindow, fps: cint)
    {.importcpp: "#.setFramerateLimit(@)", header: HEADER.}

proc getSize*(window: RenderWindow): Vector2u
    {.importcpp: "#.getSize(@)", header: HEADER.}

proc newEvent*(): Event
    {.importcpp: "sf::Event(@)", header: HEADER.}

proc pollEvent*(window: RenderWindow, event: Event): bool
    {.importcpp: "#.pollEvent(@)", header: HEADER.}

proc setIcon*(window: RenderWindow, width, height: cuint, pixels: ptr uint8)
    {.importcpp: "#.setIcon(@)", header: HEADER.}

proc newContextSettings*(): ContextSettings
    {.importcpp: "sf::ContextSettings(@)", header: HEADER.}

proc newColor*(red, green, blue: uint8): Color
    {.importcpp: "sf::Color(@)", header: HEADER.}

proc isKeyPressed*(key: Key): bool
    {.importcpp: "sf::Keyboard::isKeyPressed(@)", header: HEADER.}

proc newVector2u*(x, y: cuint): Vector2u
    {.importcpp: "sf::Vector2u(@)", header: HEADER.}

proc newVector2f*(x, y: cfloat): Vector2f
    {.importcpp: "sf::Vector2f(@)", header: HEADER.}

proc newVector2i*(x, y: cint): Vector2i
    {.importcpp: "sf::Vector2i(@)", header: HEADER.}

proc newFloatRect*(left, right, width, height: cfloat): FloatRect
    {.importcpp: "sf::Rect<float>(@)", header: HEADER.}

proc newIntRect*(left, right, width, height: cint): IntRect
    {.importcpp: "sf::Rect<int>(@)", header: HEADER.}

proc contains*(rect: FloatRect, vec: Vector2f): bool
    {.importcpp: "#.contains(@)", header: HEADER.}

proc intersects*(rect, rect1: FloatRect): bool
    {.importcpp: "#.intersects(@)", header: HEADER.}

proc contains*(rect: IntRect, vec: Vector2i): bool
    {.importcpp: "#.contains(@)", header: HEADER.}

proc intersects*(rect, rect1: IntRect): bool
    {.importcpp: "#.intersects(@)", header: HEADER.}

proc newRectangleShape*(size: Vector2f): RectangleShape
    {.importcpp: "sf::RectangleShape(@)", header: HEADER.}

proc setSize*(shape: RectangleShape, size: Vector2f)
    {.importcpp: "#.setSize(@)", header: HEADER.}

proc getSize*(shape: RectangleShape): Vector2f
    {.importcpp: "#.getSize(@)", header: HEADER.}

proc getLocalBounds*(shape: RectangleShape): FloatRect
    {.importcpp: "#.getLocalBounds(@)", header: HEADER.}

proc getGlobalBounds*(shape: RectangleShape): FloatRect
    {.importcpp: "#.getGlobalBounds(@)", header: HEADER.}

proc setPosition*(shape: RectangleShape, pos: Vector2f)
    {.importcpp: "#.setPosition(@)", header: HEADER.}

proc setPosition*(shape: RectangleShape, x, y: cfloat)
    {.importcpp: "#.setPosition(@)", header: HEADER.}

proc getPosition*(shape: RectangleShape): Vector2f
    {.importcpp: "#.getPosition(@)", header: HEADER.}

proc setOrigin*(shape: RectangleShape, origin: Vector2f)
    {.importcpp: "#.setOrigin(@)", header: HEADER.}

proc setOrigin*(shape: RectangleShape, x, y: cfloat)
    {.importcpp: "#.setOrigin(@)", header: HEADER.}

proc newClock*(): Clock
    {.importcpp: "sf::Clock(@)", header: HEADER.}

proc getElapsedTime*(clock: Clock): Time
    {.importcpp: "#.getElapsedTime(@)", header: HEADER.}

proc restart*(clock: Clock): Time
    {.importcpp: "#.restart(@)", header: HEADER.}

proc asSeconds*(time: Time): cfloat
    {.importcpp: "#.asSeconds(@)", header: HEADER.}

proc newFont*(): Font
    {.importcpp: "sf::Font(@)", header: HEADER.}

proc loadFromFile*(font: Font, str: CppString): bool
    {.importcpp: "#.loadFromFile(@)", header: HEADER.}

proc newText*(): Text
    {.importcpp: "sf::Text(@)", header: HEADER.}

proc setFont*(text: Text, font: Font)
    {.importcpp: "#.setFont(@)", header: HEADER.}

proc setCharacterSize*(text: Text, size: cuint)
    {.importcpp: "#.setCharacterSize(@)", header: HEADER.}

proc setString*(text: Text, str: CppString)
    {.importcpp: "#.setString(@)", header: HEADER.}

proc getGlobalBounds*(text: Text): FloatRect
    {.importcpp: "#.getGlobalBounds(@)", header: HEADER.}

proc setPosition*(text: Text, x, y: cfloat)
    {.importcpp: "#.setPosition(@)", header: HEADER.}

proc setOrigin*(text: Text, origin: Vector2f)
    {.importcpp: "#.setOrigin(@)", header: HEADER.}

proc setOrigin*(text: Text, x, y: cfloat)
    {.importcpp: "#.setOrigin(@)", header: HEADER.}

proc newImage*(): Image
    {.importcpp: "sf::Image", header: HEADER.}

proc loadFromFile*(img: Image, path: CppString): bool
    {.importcpp: "#.loadFromFile(@)", header: HEADER.}

proc getPixelsPtr*(img: Image): ptr uint8
    {.importcpp: "#.getPixelsPtr(@)", header: HEADER.}

proc getSize*(img: Image): Vector2u
    {.importcpp: "#.getSize()", header: HEADER.}