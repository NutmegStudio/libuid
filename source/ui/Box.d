module ui.Box;

import ui.Control;

class Box : Control {
    protected uiBox* _box;

    this(bool vertical = true) {
        if (vertical) {
            _box = uiNewVerticalBox();
        } else {
            _box = uiNewHorizontalBox();
        }
        super(cast(uiControl*) _box);
    }

    Box append(Control child, bool stretchy = false) {
        import std.exception : enforce;

        enforce(child, "atempt to append a child which is null.");
        _children ~= child;
        child._parent = this;
        uiBoxAppend(_box, child._control, cast(int) stretchy);
        return this;
    }

    Box deleteByIndex(size_t index) {
        import std.algorithm : remove;

        _children[index]._parent = null;
        _children.remove(index);
        uiBoxDelete(_box, cast(int) index);
        return this;
    }

    bool padded() {
        return cast(bool) uiBoxPadded(_box);
    }

    Box setPadded(bool padded) {
        uiBoxSetPadded(_box, cast(int) padded);
        return this;
    }
}
