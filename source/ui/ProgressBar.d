module ui.ProgressBar;

import ui.Control;

class ProgressBar : Control {
    protected uiProgressBar* _progressBar;

    this() {
        _progressBar = uiNewProgressBar();
        super(cast(uiControl*) _progressBar);
    }

    int value() {
        return uiProgressBarValue(_progressBar);
    }

    ProgressBar setValue(int value) {
        uiProgressBarSetValue(_progressBar, value);
        return this;
    }
}
