module ui.FontButton;

import ui.Control;

class FontButton : Control {
    protected uiFontButton* _fontButton;

    mixin EventListenerMixin!("OnChanged", FontButton);

    this() {
        _fontButton = uiNewFontButton();
        super(cast(uiControl*) _fontButton);

        uiFontButtonOnChanged(_fontButton, &OnChangedCallback, cast(void*) this);
    }

    import ui.Draw : TextFont;

    TextFont font() {
        return TextFont(uiFontButtonFont(_fontButton));
    }
}
