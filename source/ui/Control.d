module ui.Control;

public import ui.Core;

class Control {
    package uiControl* _control;
    package Control _parent;
    package Control[] _children;

    protected this(uiControl* other) {
        _control = other;
    }

    uintptr_t handle() {
        return uiControlHandle(_control);
    }

    Control parent() {
        return _parent;
    }

    Control setParent(Control parent) {
        if (_parent) {
            import std.algorithm : remove;

            _parent._children.remove!(e => e is this);
        }
        _parent = parent;
        if (_parent) {
            _parent._children ~= this;
            uiControlSetParent(_control, parent._control);
        } else {
            uiControlSetParent(_control, null);
        }
        return this;
    }

    bool topLevel() {
        return cast(bool) uiControlToplevel(_control);
    }

    bool visible() {
        return cast(bool) uiControlVisible(_control);
    }

    Control show() {
        uiControlShow(_control);
        return this;
    }

    Control hide() {
        uiControlHide(_control);
        return this;
    }

    bool enabled() {
        return cast(bool) uiControlEnabled(_control);
    }

    Control enable() {
        uiControlEnable(_control);
        return this;
    }

    Control disable() {
        uiControlDisable(_control);
        return this;
    }

    Control verifySetParent(Control other) {
        // TODO: what is the meaning?
        uiControlVerifySetParent(_control, other._control);
        return this;
    }

    bool enabledToUser() {
        return cast(bool) uiControlEnabledToUser(_control);
    }
}
