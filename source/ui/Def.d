module ui.Def;

static immutable Pi = 3.14159265358979323846264338327950288419716939937510582097494459;

enum BrushType : uint {
    Solid,
    LinearGradient,
    RadialGradient,
    Image,
}

enum LineCap : uint {
    Flat,
    Round,
    Square,
}

enum LineJoin : uint {
    Miter,
    Round,
    Bevel,
}

static immutable DrawDefaultMiterLimit = 10.0;

enum FillMode : uint {
    Winding,
    Alternate,
}

enum TextWeight : uint {
    Thin,
    UltraLight,
    Light,
    Book,
    Normal,
    Medium,
    SemiBold,
    Bold,
    UtraBold,
    Heavy,
    UltraHeavy,
}

enum TextItalic : uint {
    Normal,
    Oblique,
    Italic,
}

enum TextStretch : uint {
    UltraCondensed,
    ExtraCondensed,
    Condensed,
    SemiCondensed,
    Normal,
    SemiExpanded,
    Expanded,
    ExtraExpanded,
    UltraExpanded,
}

enum ModifiersT : uint {
    Ctrl = 1 << 0,
    Alt = 1 << 1,
    Shift = 1 << 2,
    Super = 1 << 3,
}

enum ExtKeyT : uint {
    Escape = 1,
    Insert, // equivalent to "Help" on Apple keyboards
    Delete,
    Home,
    End,
    PageUp,
    PageDown,
    Up,
    Down,
    Left,
    Right,
    F1, // F1..F12 are guaranteed to be consecutive
    F2,
    F3,
    F4,
    F5,
    F6,
    F7,
    F8,
    F9,
    F10,
    F11,
    F12,
    N0, // numpad keys; independent of Num Lock state
    N1, // N0..N9 are guaranteed to be consecutive
    N2,
    N3,
    N4,
    N5,
    N6,
    N7,
    N8,
    N9,
    NDot,
    NEnter,
    NAdd,
    NSubtract,
    NMultiply,
    NDivide,
}

enum Align : uint {
    Fill,
    Start,
    Center,
    End,
}

enum At : uint {
    Leading,
    Top,
    Trailing,
    Bottom,
}
