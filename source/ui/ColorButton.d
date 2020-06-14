module ui.ColorButton;

import ui.Control;

class ColorButton : Control {
    protected uiColorButton* _colorButton;

    mixin EventListenerMixin!("OnChanged", ColorButton);

    this() {
        _colorButton = uiNewColorButton();
        super(cast(uiControl*) _colorButton);

        uiColorButtonOnChanged(_colorButton, &OnChangedCallback, cast(void*) this);
    }

    auto color() {
        import std.typecons : Tuple;

        auto r = Tuple!(double, "r", double, "g", double, "b", double, "a")();
        uiColorButtonColor(_colorButton, &r.r, &r.g, &r.b, &r.a);
        return r;
    }

    ColorButton setColor(double r, double g, double b, double a) {
        uiColorButtonSetColor(_colorButton, r, g, b, a);
        return this;
    }
}
