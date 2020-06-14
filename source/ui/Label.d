module ui.Label;

import ui.Control;

class Label : Control {
    import std.string : toStringz;

    protected uiLabel* _label;

    this(string text = "") {
        _label = uiNewLabel(text.toStringz);
        super(cast(uiControl*) _label);
    }

    string text() {
        return uiLabelText(_label).toString;
    }

    Label setText(string text) {
        uiLabelSetText(_label, text.toStringz);
        return this;
    }
}
