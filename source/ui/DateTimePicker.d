module ui.DateTimePicker;

import ui.Control;

enum DateTimePickerStype {
    DateTime,
    Date,
    Time,
}

uiDateTimePicker* toDateTimePicker(DateTimePickerStype stype) {
    final switch (stype) with (DateTimePickerStype) {
    case DateTime:
        return uiNewDateTimePicker();
    case Date:
        return uiNewDatePicker();
    case Time:
        return uiNewTimePicker();
    }
}

class DateTimePicker : Control {
    protected uiDateTimePicker* _dateTimePicker;

    this(DateTimePickerStype stype = DateTimePickerStype.DateTime) {
        _dateTimePicker = stype.toDateTimePicker;
        super(cast(uiControl*) _dateTimePicker);
    }
}
