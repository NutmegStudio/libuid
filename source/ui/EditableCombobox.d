module ui.EditableCombobox;

import ui.Control;

class EditableCombobox : Control {
    import std.string : toStringz;

    protected uiEditableCombobox* _editableCombobox;

    mixin EventListenerMixin!("OnChanged", EditableCombobox);

    this() {
        _editableCombobox = uiNewEditableCombobox();
        super(cast(uiControl*) _editableCombobox);

        uiEditableComboboxOnChanged(_editableCombobox, &OnChangedCallback, cast(void*) this);
    }

    EditableCombobox append(string text) {
        uiEditableComboboxAppend(_editableCombobox, text.toStringz);
        return this;
    }

    string test() {
        return uiEditableComboboxText(_editableCombobox).toString;
    }

    EditableCombobox setText(string text) {
        uiEditableComboboxSetText(_editableCombobox, text.toStringz);
        return this;
    }
}
