module ui.Area;

import ui.Control;

class Area : Control {
    protected uiArea* _area;
    protected uiAreaHandler* _handler;

    private {
        void initHandler() {
            _handler = new uiAreaHandler();
            _handler.Draw = &DrawCallback;
            _handler.MouseEvent = &MouseEventCallback;
            _handler.MouseCrossed = &MouseCrossedCallback;
            _handler.DragBroken = &DragBrokenCallback;
            _handler.KeyEvent = &KeyEventCallback;
        }

        static Area[uiArea* ] _areaMap;
        void delegate(Area a, DrawParams params)[] DrawListeners;
        void delegate(Area a, MouseEvent event)[] MouseEventListeners;
        void delegate(Area a, int left)[] MouseCrossedListeners;
        void delegate(Area a)[] DragBrokenListeners;
        void delegate(Area a, KeyEvent event)[] KeyEventListeners;

        extern (C) static {
            void DrawCallback(uiAreaHandler* ah, uiArea* a, uiAreaDrawParams* p) {
                auto area = _areaMap[a];
                foreach (dlg; area.DrawListeners) {
                    dlg(area, DrawParams(p));
                }
            }

            void MouseEventCallback(uiAreaHandler* ah, uiArea* a, uiAreaMouseEvent* e) {
                auto area = _areaMap[a];
                foreach (dlg; area.MouseEventListeners) {
                    dlg(area, MouseEvent(e));
                }
            }

            void MouseCrossedCallback(uiAreaHandler* ah, uiArea* a, int left) {
                auto area = _areaMap[a];
                foreach (dlg; area.MouseCrossedListeners) {
                    dlg(area, left);
                }
            }

            void DragBrokenCallback(uiAreaHandler* ah, uiArea* a) {
                auto area = _areaMap[a];
                foreach (dlg; area.DragBrokenListeners) {
                    dlg(area);
                }
            }

            int KeyEventCallback(uiAreaHandler* ah, uiArea* a, uiAreaKeyEvent* e) {
                auto area = _areaMap[a];
                foreach (dlg; area.KeyEventListeners) {
                    dlg(area, KeyEvent(e));
                }
                return 1;
            }
        }
    }

    public {
        Area addDraw(void delegate(Area a, DrawParams params) f) {
            DrawListeners ~= f;
            return this;
        }

        Area addMouseEvent(void delegate(Area a, MouseEvent event) f) {
            MouseEventListeners ~= f;
            return this;
        }

        Area addMouseCrossed(void delegate(Area a, int left) f) {
            MouseCrossedListeners ~= f;
            return this;
        }

        Area addDragBroken(void delegate(Area a) f) {
            DragBrokenListeners ~= f;
            return this;
        }

        Area addKeyEvent(void delegate(Area a, KeyEvent event) f) {
            KeyEventListeners ~= f;
            return this;
        }
    }

    this(bool scrolling = false, int width = 240, int height = 180) {
        initHandler;
        if (!scrolling) {
            _area = uiNewArea(_handler);
        } else {
            _area = uiNewScrollingArea(_handler, width, height);
        }
        _areaMap[_area] = this;
        super(cast(uiControl*) _area);
    }

    Area setSize(int width, int height) {
        uiAreaSetSize(_area, width, height);
        return this;
    }

    Area queueRedrawAll() {
        uiAreaQueueRedrawAll(_area);
        return this;
    }

    Area scrollTo(double x, double y, double width, double height) {
        uiAreaScrollTo(_area, x, y, width, height);
        return this;
    }
}

struct DrawParams {
    private uiAreaDrawParams* _params;

    @property pragma(inline, true) {
        import ui.Draw : Context;

        auto context() {
            return Context(_params.Context);
        }

        void context(Context context) {
            _params.Context = context._context;
        }

        ref areaWidth() {
            return _params.AreaWidth;
        }

        ref areaHeight() {
            return _params.AreaHeight;
        }

        ref clipX() {
            return _params.ClipX;
        }

        ref clipY() {
            return _params.ClipY;
        }

        ref clipWidth() {
            return _params.ClipWidth;
        }

        ref clipHeight() {
            return _params.ClipHeight;
        }
    }

    this(uiAreaDrawParams* params) {
        _params = params;
    }
}

struct MouseEvent {
    private uiAreaMouseEvent* _event;

    @property pragma(inline, true) {
        ref x() {
            return _event.X;
        }

        ref y() {
            return _event.Y;
        }

        ref areaWidth() {
            return _event.AreaWidth;
        }

        ref areaHeight() {
            return _event.AreaHeight;
        }

        ref down() {
            return _event.Down;
        }

        ref up() {
            return _event.Up;
        }

        ref count() {
            return _event.Count;
        }

        ref modifiers() {
            return _event.Modifiers;
        }

        ref held1to64() {
            return _event.Held1To64;
        }
    }

    this(uiAreaMouseEvent* event) {
        _event = event;
    }
}

struct KeyEvent {
    private uiAreaKeyEvent* _event;

    @property pragma(inline, true) {
        ref key() {
            return _event.Key;
        }

        ref extKey() {
            return _event.ExtKey;
        }

        ref modifier() {
            return _event.Modifier;
        }

        ref modifiers() {
            return _event.Modifiers;
        }

        ref up() {
            return _event.Up;
        }
    }

    this(uiAreaKeyEvent* event) {
        _event = event;
    }
}
