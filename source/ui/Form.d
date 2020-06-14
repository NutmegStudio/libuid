module ui.Form;

import ui.Control;

class Form : Control {
    protected uiForm* _form;

    this() {
        _form = uiNewForm();
        super(cast(uiControl*) _form);
    }

    Form append(string label, Control child, bool stretchy = false) {
        import std.exception : enforce;

        enforce(child, "atempt to append a child which is null.");
        _children ~= child;
        child._parent = this;
        import std.string : toStringz;

        uiFormAppend(_form, label.toStringz, child._control, cast(int) stretchy);
        return this;
    }

    Form deleteByIndex(size_t index) {
        import std.algorithm : remove;

        _children[index]._parent = null;
        _children.remove(index);
        uiFormDelete(_form, cast(int) index);
        return this;
    }

    bool padded() {
        return cast(bool) uiFormPadded(_form);
    }

    Form setPadded(bool padded) {
        uiFormSetPadded(_form, cast(int) padded);
        return this;
    }
}
