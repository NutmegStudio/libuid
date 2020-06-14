module ui.Tab;

import ui.Control;

class Tab : Control {
    import std.string : toStringz;

    protected uiTab* _tab;

    this() {
        _tab = uiNewTab();
        super(cast(uiControl*) _tab);
    }

    Tab append(string name, Control child) {
        import std.exception : enforce;

        enforce(child, "atempt to append a child which is null.");
        _children ~= child;
        child._parent = this;
        uiTabAppend(_tab, name.toStringz, child._control);
        return this;
    }

    Tab insertAt(string name, size_t before, Control child) {
        import std.exception : enforce;

        enforce(child, "atempt to insert a child which is null.");
        _children = _children[0 .. before] ~ child ~ _children[before .. $];
        child._parent = this;
        uiTabInsertAt(_tab, name.toStringz, cast(int) before, child._control);
        return this;
    }

    Tab deleteByIndex(size_t index) {
        import std.algorithm : remove;

        _children[index]._parent = null;
        _children.remove(index);
        uiTabDelete(_tab, cast(int) index);
        return this;
    }

    size_t numPages() {
        return cast(size_t) uiTabNumPages(_tab);
    }

    bool margined(size_t page) {
        return cast(bool) uiTabMargined(_tab, cast(int) page);
    }

    Tab setMargined(size_t page, bool margined) {
        uiTabSetMargined(_tab, cast(int) page, cast(int) margined);
        return this;
    }
}
