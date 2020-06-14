module ui.MultilineEntry;

import ui.Control;

class MultilineEntry : Control {
    import std.string : toStringz;

    protected uiMultilineEntry* _multilineEntry;

    mixin EventListenerMixin!("OnChanged", MultilineEntry);

    this(bool wrap = true) {
        if (wrap) {
            _multilineEntry = uiNewMultilineEntry();
        } else {
            _multilineEntry = uiNewNonWrappingMultilineEntry();
        }
        super(cast(uiControl*) _multilineEntry);

        uiMultilineEntryOnChanged(_multilineEntry, &OnChangedCallback, cast(void*) this);
    }

    string text() {
        return uiMultilineEntryText(_multilineEntry).toString;
    }

    MultilineEntry setText(string text) {
        uiMultilineEntrySetText(_multilineEntry, text.toStringz);
        return this;
    }

    MultilineEntry append(string text) {
        uiMultilineEntryAppend(_multilineEntry, text.toStringz);
        return this;
    }

    bool readOnly() {
        return cast(bool) uiMultilineEntryReadOnly(_multilineEntry);
    }

    MultilineEntry setReadOnly(bool readonly) {
        uiMultilineEntrySetReadOnly(_multilineEntry, cast(int) readonly);
        return this;
    }
}
