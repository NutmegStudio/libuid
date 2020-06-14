module ui.Group;

import ui.Control;

class Group : Control {
    import std.string : toStringz;

    protected uiGroup* _group;

    this(string title = "") {
        _group = uiNewGroup(title.toStringz);
        super(cast(uiControl*) _group);
    }

    string title() {
        return uiGroupTitle(_group).toString;
    }

    Group setTitle(string title) {
        uiGroupSetTitle(_group, title.toStringz);
        return this;
    }

    Group setChild(Control child) {
        if (child) {
            _children ~= child;
            child._parent = this;
            uiGroupSetChild(_group, child._control);
        } else {
            uiGroupSetChild(_group, null);
        }
        return this;
    }

    bool margined() {
        return cast(bool) uiGroupMargined(_group);
    }

    Group setMargined(bool margined) {
        uiGroupSetMargined(_group, cast(int) margined);
        return this;
    }
}
