module ui.Grid;

import ui.Control;

class Grid : Control {
    protected uiGrid* _grid;

    this() {
        _grid = uiNewGrid();
        super(cast(uiControl*) _grid);
    }

    Grid append(Control child, int left, int top, int xspan = 1, int yspan = 1,
            bool hexpand = false, Align halign = Align.Fill, bool vexpand = false,
            Align valign = Align.Fill,) {
        import std.exception : enforce;

        enforce(child, "atempt to append a child which is null.");
        _children ~= child;
        child._parent = this;
        uiGridAppend(_grid, child._control, left, top, xspan, yspan,
                cast(int) hexpand, halign, cast(int) vexpand, valign);
        return this;
    }

    Grid insertAt(Control child, Control existing, At at = At.Trailing,
            int xspan = 1, int yspan = 1, bool hexpand = false, Align halign = Align.Fill,
            bool vexpand = false, Align valign = Align.Fill,) {
        import std.exception : enforce;

        enforce(child, "atempt to insert a child which is null.");
        _children ~= child;
        child._parent = this;
        uiGridInsertAt(_grid, child._control, existing._control, at, xspan,
                yspan, cast(int) hexpand, halign, cast(int) vexpand, valign);
        return this;
    }

    bool padded() {
        return cast(bool) uiGridPadded(_grid);
    }

    Grid setPadded(bool padded) {
        uiGridSetPadded(_grid, cast(int) padded);
        return this;
    }
}
