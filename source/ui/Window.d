module ui.Window;

import ui.Control;

class Window : Control {
    import std.typecons: Tuple;
    import std.string: toStringz;

    protected uiWindow * _window;

    mixin EventListenerMixin!("OnPositionChanged", Window);
    mixin EventListenerMixin!("OnContentSizeChanged", Window);
    mixin EventListenerMixin!("OnClosing", Window, int);

public:
    this(string title = "", int width = 240, int height = 180, bool hasMenubar = false) {
        _window = uiNewWindow(title.toStringz, width, height, cast(int) hasMenubar);
        super(cast(uiControl *) _window);

        // uiWindowOnPositionChanged(_window, &OnPositionChangedCallback, cast(void*) this);
        uiWindowOnContentSizeChanged(_window, &OnContentSizeChangedCallback, cast(void*) this);
        uiWindowOnClosing(_window, &OnClosingCallback, cast(void *) this);
    }

    string title() {
        return uiWindowTitle(_window).toString;
    }

    Window setTitle(string title) {
        uiWindowSetTitle(_window, title.toStringz);
        return this;
    }

    // auto position() {
    //     auto pos = Tuple!(int, "x", int, "y")();
    //     uiWindowPosition(_window, &pos.x, &pos.y);
    //     return pos;
    // }

    // Window setPosition(int x, int y) {
    //     uiWindowSetPosition(_window, x, y);
    //     return this;
    // }

    // Window center() {
    //     uiWindowCenter(_window);
    //     return this;
    // }

    auto contentSize() {
        auto size = Tuple!(int, "width", int, "height")();
        uiWindowContentSize(_window, &size.width, &size.height);
        return size;
    }

    Window setContentSize(int width, int height) {
        uiWindowSetContentSize(_window, width, height);
        return this;
    }

    bool fullScreen() {
        return cast(bool) uiWindowFullscreen(_window);
    }

    Window setFullScreen(bool fullscreen) {
        uiWindowSetFullscreen(_window, cast(int) fullscreen);
        return this;
    }

    bool borderless() {
        return cast(bool) uiWindowBorderless(_window);
    }

    Window setBorderless(bool borderless) {
        uiWindowSetBorderless(_window, cast(int) borderless);
        return this;
    }

    Window setChild(Control child) {
        if (child) {
            _children ~= child;
            child._parent = this;
            uiWindowSetChild(_window, child._control);
        } else {
            uiWindowSetChild(_window, null);
        }
        return this;
    }

    bool margined() {
        return cast(bool) uiWindowMargined(_window);
    }

    Window setMargined(bool margined) {
        uiWindowSetMargined(_window, cast(int) margined);
        return this;
    }

    string openFile() {
        return uiOpenFile(_window).toString;
    }

    string saveFile() {
        return uiSaveFile(_window).toString;
    }

    Window msgBox(string title, string discription) {
        uiMsgBox(_window, title.toStringz, discription.toStringz);
        return this;
    }

    Window msgBoxError(string title, string discription) {
        uiMsgBoxError(_window, title.toStringz, discription.toStringz);
        return this;
    }
}
