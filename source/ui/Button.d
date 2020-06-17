module ui.Button;

import ui.Control;

class Button : Control {
    import std.string : toStringz;

    protected uiButton* _button;

    mixin EventListenerMixin!("OnClicked", Button);

    this(string text = "") {
        _button = uiNewButton(text.toStringz);
        super(cast(uiControl*) _button);

        uiButtonOnClicked(_button, &OnClickedCallback, cast(void*) this);
    }

    string text() {
        return uiButtonText(_button).toString;
    }

    Button setText(string text) {
        uiButtonSetText(_button, text.toStringz);
        return this;
    }
}
