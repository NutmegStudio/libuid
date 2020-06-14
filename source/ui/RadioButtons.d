module ui.RadioButtons;

import ui.Control;

class RadioButtons : Control {
    protected uiRadioButtons* _radioButtons;

    mixin EventListenerMixin!("OnSelected", RadioButtons);

    this() {
        _radioButtons = uiNewRadioButtons();
        super(cast(uiControl*) _radioButtons);

        uiRadioButtonsOnSelected(_radioButtons, &OnSelectedCallback, cast(void*) this);
    }

    RadioButtons append(string text) {
        import std.string : toStringz;

        uiRadioButtonsAppend(_radioButtons, text.toStringz);
        return this;
    }

    size_t selected() {
        return cast(size_t) uiRadioButtonsSelected(_radioButtons);
    }

    RadioButtons setSelected(size_t index) {
        uiRadioButtonsSetSelected(_radioButtons, cast(int) index);
        return this;
    }
}
