module ui.Slider;

import ui.Control;

class Slider : Control {
    protected uiSlider* _slider;

    mixin EventListenerMixin!("OnChanged", Slider);

    this(int min = -10, int max = 10) {
        _slider = uiNewSlider(min, max);
        super(cast(uiControl*) _slider);

        uiSliderOnChanged(_slider, &OnChangedCallback, cast(void*) this);
    }

    int value() {
        return uiSliderValue(_slider);
    }

    Slider setValue(int value) {
        uiSliderSetValue(_slider, value);
        return this;
    }
}
