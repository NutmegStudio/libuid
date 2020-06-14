module ui.Separator;

import ui.Control;

class Separator : Control {
    protected uiSeparator* _separator;

    this(bool vertical = true) {
        if (vertical) {
            _separator = uiNewVerticalSeparator();
        } else {
            _separator = uiNewHorizontalSeparator();
        }

        super(cast(uiControl*) _separator);
    }
}
