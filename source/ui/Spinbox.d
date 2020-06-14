module ui.Spinbox;

import ui.Control;

class Spinbox : Control {
    protected uiSpinbox* _spinbox;

    mixin EventListenerMixin!("OnChanged", Spinbox);

    this(int min = -10, int max = 10) {
        _spinbox = uiNewSpinbox(min, max);
        super(cast(uiControl*) _spinbox);

        uiSpinboxOnChanged(_spinbox, &OnChangedCallback, cast(void*) this);
    }

    int value() {
        return uiSpinboxValue(_spinbox);
    }

    Spinbox setValue(int value) {
        uiSpinboxSetValue(_spinbox, value);
        return this;
    }
}
