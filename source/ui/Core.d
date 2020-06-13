module ui.Core;

public import ui.Def;

package:

string toString(char *source) {
    if (!source) {
        return null;
    }
    import core.stdc.string: strlen;
    auto s = source[0..strlen(source)].idup;
    uiFreeText(source);
    return s;
}

mixin template EventListenerMixin(string Event, TargetT = NoneTypeTag, ReturnT = void) {
    template Impl() {
        static if (is(ReturnT == void)) {
            enum RET = "";
        } else {
            enum RET = "return 1;";
        }
        import std.format: format;
        static if (is(TargetT == NoneTypeTag)) {
            enum Impl = q{
                private static void delegate()[] %1$sListeners;
                private extern (C) static %2$s %1$sCallback(void *data) {
                    foreach (dlg; %1$sListeners) {
                        dlg();
                    }
                    %3$s
                }
                public static void %1$s(void delegate() f) {
                    %1$sListeners ~= f;
                }
            }.format(Event, ReturnT.stringof, RET);
        } else {
            enum Impl = q{
                private void delegate(%2$s v)[] %1$sListeners;
                private extern (C) static %3$s %1$sCallback(ui%2$s *, void *data) {
                    auto v = cast(%2$s) data;
                    foreach (dlg; v.%1$sListeners) {
                        dlg(v);
                    }
                    %4$s
                }
                public %2$s add%1$s(void delegate(%2$s v) f) {
                    %1$sListeners ~= f;
                    return this;
                }
            }.format(Event, TargetT.stringof, ReturnT.stringof, RET);
        }
    }
    //pragma(msg, Impl!());
    mixin(Impl!());
}

struct NoneTypeTag {}



extern(C):

struct uiInitOptions {
    size_t Size;
};

const(char) *uiInit(uiInitOptions *options);
void uiUninit();
void uiFreeInitError(const(char) *err);

void uiMain();
void uiMainSteps();
int uiMainStep(int wait);
void uiQuit();

void uiQueueMain(void function(void *data) f, void *data);

void uiOnShouldQuit(int function(void *data) f, void *data);

void uiFreeText(char *text);

import core.stdc.stdint;

struct uiControl {
    uint32_t Signature;
    uint32_t OSSignature;
    uint32_t TypeSignature;
    void function(uiControl *) Destroy;
    uintptr_t function(uiControl *) Handle;
    uiControl *function(uiControl *) Parent;
    void function(uiControl *, uiControl *) SetParent;
    int function(uiControl *) Toplevel;
    int function(uiControl *) Visible;
    void function(uiControl *) Show;
    void function(uiControl *) Hide;
    int function(uiControl *) Enabled;
    void function(uiControl *) Enable;
    void function(uiControl *) Disable;
};
// TOOD add argument names to all arguments
void uiControlDestroy(uiControl *);
uintptr_t uiControlHandle(uiControl *);
uiControl *uiControlParent(uiControl *); // TODO: NO USE
void uiControlSetParent(uiControl *, uiControl *);
int uiControlToplevel(uiControl *);
int uiControlVisible(uiControl *);
void uiControlShow(uiControl *);
void uiControlHide(uiControl *);
int uiControlEnabled(uiControl *);
void uiControlEnable(uiControl *);
void uiControlDisable(uiControl *);

// TODO: NO USE
// TODO make sure all controls have these
uiControl *uiAllocControl(size_t n, uint32_t OSsig, uint32_t typesig, const(char)*typenamestr);
void uiFreeControl(uiControl *);

void uiControlVerifySetParent(uiControl *, uiControl *);
int uiControlEnabledToUser(uiControl *);

// TODO: NO USE
void uiUserBugCannotSetParentOnToplevel(const(char) *type);

struct uiWindow;
char *uiWindowTitle(uiWindow *w);
void uiWindowSetTitle(uiWindow *w, const(char) *title);
// void uiWindowPosition(uiWindow *w, int *x, int *y);
// void uiWindowSetPosition(uiWindow *w, int x, int y);
// void uiWindowCenter(uiWindow *w);
void uiWindowOnPositionChanged(uiWindow *w, void function(uiWindow *, void *) f, void *data);
void uiWindowContentSize(uiWindow *w, int *width, int *height);
void uiWindowSetContentSize(uiWindow *w, int width, int height);
int uiWindowFullscreen(uiWindow *w);
void uiWindowSetFullscreen(uiWindow *w, int fullscreen);
void uiWindowOnContentSizeChanged(uiWindow *w, void function(uiWindow *, void *) f, void *data);
void uiWindowOnClosing(uiWindow *w, int function(uiWindow *w, void *data) f, void *data);
int uiWindowBorderless(uiWindow *w);
void uiWindowSetBorderless(uiWindow *w, int borderless);
void uiWindowSetChild(uiWindow *w, uiControl *child);
int uiWindowMargined(uiWindow *w);
void uiWindowSetMargined(uiWindow *w, int margined);
uiWindow *uiNewWindow(const(char) *title, int width, int height, int hasMenubar);

struct uiButton;
char *uiButtonText(uiButton *b);
void uiButtonSetText(uiButton *b, const(char) *text);
void uiButtonOnClicked(uiButton *b, void function(uiButton *b, void *data) f, void *data);
uiButton *uiNewButton(const char *text);

struct uiBox;
void uiBoxAppend(uiBox *b, uiControl *child, int stretchy);
void uiBoxDelete(uiBox *b, int index);
int uiBoxPadded(uiBox *b);
void uiBoxSetPadded(uiBox *b, int padded);
uiBox *uiNewHorizontalBox();
uiBox *uiNewVerticalBox();

struct uiCheckbox;
char *uiCheckboxText(uiCheckbox *c);
void uiCheckboxSetText(uiCheckbox *c, const(char) *text);
void uiCheckboxOnToggled(uiCheckbox *c, void function(uiCheckbox *c, void *data) f, void *data);
int uiCheckboxChecked(uiCheckbox *c);
void uiCheckboxSetChecked(uiCheckbox *c, int checked);
uiCheckbox *uiNewCheckbox(const(char) *text);

struct uiEntry;
char *uiEntryText(uiEntry *e);
void uiEntrySetText(uiEntry *e, const(char) *text);
void uiEntryOnChanged(uiEntry *e, void function(uiEntry *e, void *data) f, void *data);
int uiEntryReadOnly(uiEntry *e);
void uiEntrySetReadOnly(uiEntry *e, int readonly);
uiEntry *uiNewEntry();
uiEntry *uiNewPasswordEntry();
uiEntry *uiNewSearchEntry();

struct uiLabel;
char *uiLabelText(uiLabel *l);
void uiLabelSetText(uiLabel *l, const(char) *text);
uiLabel *uiNewLabel(const(char) *text);

struct uiTab;
void uiTabAppend(uiTab *t, const(char) *name, uiControl *c);
void uiTabInsertAt(uiTab *t, const(char) *name, int before, uiControl *c);
void uiTabDelete(uiTab *t, int index);
int uiTabNumPages(uiTab *t);
int uiTabMargined(uiTab *t, int page);
void uiTabSetMargined(uiTab *t, int page, int margined);
uiTab *uiNewTab();

struct uiGroup;
char *uiGroupTitle(uiGroup *g);
void uiGroupSetTitle(uiGroup *g, const(char) *title);
void uiGroupSetChild(uiGroup *g, uiControl *c);
int uiGroupMargined(uiGroup *g);
void uiGroupSetMargined(uiGroup *g, int margined);
uiGroup *uiNewGroup(const(char) *title);

struct uiSpinbox;
int uiSpinboxValue(uiSpinbox *s);
void uiSpinboxSetValue(uiSpinbox *s, int value);
void uiSpinboxOnChanged(uiSpinbox *s, void function(uiSpinbox *s, void *data) f, void *data);
uiSpinbox *uiNewSpinbox(int min, int max);

struct uiSlider;
int uiSliderValue(uiSlider *s);
void uiSliderSetValue(uiSlider *s, int value);
void uiSliderOnChanged(uiSlider *s, void function(uiSlider *s, void *data) f, void *data);
uiSlider *uiNewSlider(int min, int max);

struct uiProgressBar;
int uiProgressBarValue(uiProgressBar *p);
void uiProgressBarSetValue(uiProgressBar *p, int n);
uiProgressBar *uiNewProgressBar();

struct uiSeparator;
uiSeparator *uiNewHorizontalSeparator();
uiSeparator *uiNewVerticalSeparator();

struct uiCombobox;
void uiComboboxAppend(uiCombobox *c, const(char) *text);
int uiComboboxSelected(uiCombobox *c);
void uiComboboxSetSelected(uiCombobox *c, int n);
void uiComboboxOnSelected(uiCombobox *c, void function(uiCombobox *c, void *data) f, void *data);
uiCombobox *uiNewCombobox();

struct uiEditableCombobox;
void uiEditableComboboxAppend(uiEditableCombobox *c, const(char) *text);
char *uiEditableComboboxText(uiEditableCombobox *c);
void uiEditableComboboxSetText(uiEditableCombobox *c, const(char) *text);
// TODO what do we call a function that sets the currently selected item and fills the text field with it? editable comboboxes have no consistent concept of selected item
void uiEditableComboboxOnChanged(uiEditableCombobox *c, void function(uiEditableCombobox *c, void *data) f, void *data);
uiEditableCombobox *uiNewEditableCombobox();

struct uiRadioButtons;
void uiRadioButtonsAppend(uiRadioButtons *r, const(char) *text);
int uiRadioButtonsSelected(uiRadioButtons *r);
void uiRadioButtonsSetSelected(uiRadioButtons *r, int n);
void uiRadioButtonsOnSelected(uiRadioButtons *r, void function(uiRadioButtons *, void *) f, void *data);
uiRadioButtons *uiNewRadioButtons();

struct tm;
struct uiDateTimePicker;
void uiDateTimePickerTime(uiDateTimePicker *d, tm *time);
void uiDateTimePickerSetTime(uiDateTimePicker *d, const tm *time);
void uiDateTimePickerOnChanged(uiDateTimePicker *d, void function(uiDateTimePicker *d, void *data) f, void *data);
uiDateTimePicker *uiNewDateTimePicker();
uiDateTimePicker *uiNewDatePicker();
uiDateTimePicker *uiNewTimePicker();

// TODO provide a facility for entering tab stops?
struct uiMultilineEntry;
char *uiMultilineEntryText(uiMultilineEntry *e);
void uiMultilineEntrySetText(uiMultilineEntry *e, const(char) *text);
void uiMultilineEntryAppend(uiMultilineEntry *e, const(char) *text);
void uiMultilineEntryOnChanged(uiMultilineEntry *e, void function(uiMultilineEntry *e, void *data) f, void *data);
int uiMultilineEntryReadOnly(uiMultilineEntry *e);
void uiMultilineEntrySetReadOnly(uiMultilineEntry *e, int readonly);
uiMultilineEntry *uiNewMultilineEntry();
uiMultilineEntry *uiNewNonWrappingMultilineEntry();

struct uiMenuItem;
void uiMenuItemEnable(uiMenuItem *m);
void uiMenuItemDisable(uiMenuItem *m);
void uiMenuItemOnClicked(uiMenuItem *m, void function(uiMenuItem *sender, uiWindow *window, void *data) f, void *data);
int uiMenuItemChecked(uiMenuItem *m);
void uiMenuItemSetChecked(uiMenuItem *m, int checked);

struct uiMenu;
uiMenuItem *uiMenuAppendItem(uiMenu *m, const(char) *name);
uiMenuItem *uiMenuAppendCheckItem(uiMenu *m, const(char) *name);
uiMenuItem *uiMenuAppendQuitItem(uiMenu *m);
uiMenuItem *uiMenuAppendPreferencesItem(uiMenu *m);
uiMenuItem *uiMenuAppendAboutItem(uiMenu *m);
void uiMenuAppendSeparator(uiMenu *m);
uiMenu *uiNewMenu(const(char) *name);

char *uiOpenFile(uiWindow *parent);
char *uiSaveFile(uiWindow *parent);
void uiMsgBox(uiWindow *parent, const(char) *title, const(char) *description);
void uiMsgBoxError(uiWindow *parent, const(char) *title, const(char) *description);

struct uiArea;
//struct uiAreaHandler;
//struct uiAreaDrawParams;
//struct uiAreaMouseEvent;
//struct uiAreaKeyEvent;

struct uiDrawContext;

struct uiAreaHandler {
    void function(uiAreaHandler *, uiArea *, uiAreaDrawParams *) Draw;
    // TODO document that resizes cause a full redraw for non-scrolling areas; implementation-defined for scrolling areas
    void function(uiAreaHandler *, uiArea *, uiAreaMouseEvent *) MouseEvent;
    // TODO document that on first show if the mouse is already in the uiArea then one gets sent with left=0
    // TODO what about when the area is hidden and then shown again?
    void function(uiAreaHandler *, uiArea *, int left) MouseCrossed;
    void function(uiAreaHandler *, uiArea *) DragBroken;
    int function(uiAreaHandler *, uiArea *, uiAreaKeyEvent *) KeyEvent;
}

// TODO give a better name
// TODO document the types of width and height
void uiAreaSetSize(uiArea *a, int width, int height);
// TODO uiAreaQueueRedraw()
void uiAreaQueueRedrawAll(uiArea *a);
void uiAreaScrollTo(uiArea *a, double x, double y, double width, double height);
uiArea *uiNewArea(uiAreaHandler *ah);
uiArea *uiNewScrollingArea(uiAreaHandler *ah, int width, int height);

struct uiAreaDrawParams {
    uiDrawContext *Context;

    // TODO document that this is only defined for nonscrolling areas
    double AreaWidth;
    double AreaHeight;

    double ClipX;
    double ClipY;
    double ClipWidth;
    double ClipHeight;
}

struct uiDrawPath;
//struct uiDrawBrush;
//struct uiDrawStrokeParams;
//struct uiDrawMatrix;

//struct uiDrawBrushGradientStop;

/+
 + enums:
 + uiDrawBrushType
 + uiDrawLineCap
 + uiDrawLineJoin
 +
 + defines:
 + uiDrawDefaultMiterLimit
 +
 + enums:
 + uiDrawFillMode
 +
 +/

struct uiDrawMatrix {
    double M11;
    double M12;
    double M21;
    double M22;
    double M31;
    double M32;
}

struct uiDrawBrush {
    BrushType Type;

    // solid brushes
    double R;
    double G;
    double B;
    double A;

    // gradient brushes
    double X0;      // linear: start X, radial: start X
    double Y0;      // linear: start Y, radial: start Y
    double X1;      // linear: end X, radial: outer circle center X
    double Y1;      // linear: end Y, radial: outer circle center Y
    double OuterRadius;     // radial gradients only
    uiDrawBrushGradientStop *Stops;
    size_t NumStops;
    // TODO extend mode
    // cairo: none, repeat, reflect, pad; no individual control
    // Direct2D: repeat, reflect, pad; no individual control
    // Core Graphics: none, pad; before and after individually
    // TODO cairo documentation is inconsistent about pad

    // TODO images

    // TODO transforms
}

struct uiDrawBrushGradientStop {
    double Pos;
    double R;
    double G;
    double B;
    double A;
}

struct uiDrawStrokeParams {
    LineCap Cap;
    LineJoin Join;
    // TODO what if this is 0? on windows there will be a crash with dashing
    double Thickness;
    double MiterLimit;
    double *Dashes;
    // TOOD what if this is 1 on Direct2D?
    // TODO what if a dash is 0 on Cairo or Quartz?
    size_t NumDashes;
    double DashPhase;
}

uiDrawPath *uiDrawNewPath(FillMode fillMode);
void uiDrawFreePath(uiDrawPath *p);

void uiDrawPathNewFigure(uiDrawPath *p, double x, double y);
void uiDrawPathNewFigureWithArc(uiDrawPath *p, double xCenter, double yCenter, double radius, double startAngle, double sweep, int negative);
void uiDrawPathLineTo(uiDrawPath *p, double x, double y);
// notes: angles are both relative to 0 and go counterclockwise
// TODO is the initial line segment on cairo and OS X a proper join?
// TODO what if sweep < 0?
void uiDrawPathArcTo(uiDrawPath *p, double xCenter, double yCenter, double radius, double startAngle, double sweep, int negative);
void uiDrawPathBezierTo(uiDrawPath *p, double c1x, double c1y, double c2x, double c2y, double endX, double endY);
// TODO quadratic bezier
void uiDrawPathCloseFigure(uiDrawPath *p);

// TODO effect of these when a figure is already started
void uiDrawPathAddRectangle(uiDrawPath *p, double x, double y, double width, double height);

void uiDrawPathEnd(uiDrawPath *p);

void uiDrawStroke(uiDrawContext *c, uiDrawPath *path, uiDrawBrush *b, uiDrawStrokeParams *p);
void uiDrawFill(uiDrawContext *c, uiDrawPath *path, uiDrawBrush *b);

// TODO primitives:
// - rounded rectangles
// - elliptical arcs
// - quadratic bezier curves

void uiDrawMatrixSetIdentity(uiDrawMatrix *m);
void uiDrawMatrixTranslate(uiDrawMatrix *m, double x, double y);
void uiDrawMatrixScale(uiDrawMatrix *m, double xCenter, double yCenter, double x, double y);
void uiDrawMatrixRotate(uiDrawMatrix *m, double x, double y, double amount);
void uiDrawMatrixSkew(uiDrawMatrix *m, double x, double y, double xamount, double yamount);
void uiDrawMatrixMultiply(uiDrawMatrix *dest, uiDrawMatrix *src);
int uiDrawMatrixInvertible(uiDrawMatrix *m);
int uiDrawMatrixInvert(uiDrawMatrix *m);
void uiDrawMatrixTransformPoint(uiDrawMatrix *m, double *x, double *y);
void uiDrawMatrixTransformSize(uiDrawMatrix *m, double *x, double *y);

void uiDrawTransform(uiDrawContext *c, uiDrawMatrix *m);

// TODO add a uiDrawPathStrokeToFill() or something like that
void uiDrawClip(uiDrawContext *c, uiDrawPath *path);

void uiDrawSave(uiDrawContext *c);
void uiDrawRestore(uiDrawContext *c);

// TODO manage the use of Text, Font, and TextFont, and of the uiDrawText prefix in general

///// TODO reconsider this
struct uiDrawFontFamilies;

uiDrawFontFamilies *uiDrawListFontFamilies();
int uiDrawFontFamiliesNumFamilies(uiDrawFontFamilies *ff);
char *uiDrawFontFamiliesFamily(uiDrawFontFamilies *ff, int n);
void uiDrawFreeFontFamilies(uiDrawFontFamilies *ff);
///// END TODO

struct uiDrawTextLayout;
struct uiDrawTextFont;
//struct uiDrawTextFontDescriptor;
//struct uiDrawTextFontMetrics;

/+
 + enums:
 + uiDrawTextWeight
 + uiDrawTextItalic
 + uiDrawTextStretch
 +
 +/

struct uiDrawTextFontDescriptor {
    const(char) *Family;
    double Size;
    TextWeight Weight;
    TextItalic Italic;
    TextStretch Stretch;
}

struct uiDrawTextFontMetrics {
    double Ascent;
    double Descent;
    double Leading;
    // TODO do these two mean the same across all platforms?
    double UnderlinePos;
    double UnderlineThickness;
}

// uiDrawTextFont *uiDrawLoadClosestFont(const(uiDrawTextFontDescriptor) *desc);
void uiDrawFreeTextFont(uiDrawTextFont *font);
uintptr_t uiDrawTextFontHandle(uiDrawTextFont *font);
void uiDrawTextFontDescribe(uiDrawTextFont *font, uiDrawTextFontDescriptor *desc);
// TODO make copy with given attributes methods?
// TODO yuck this name
void uiDrawTextFontGetMetrics(uiDrawTextFont *font, uiDrawTextFontMetrics *metrics);

// TODO initial line spacing? and what about leading?
uiDrawTextLayout *uiDrawNewTextLayout(const(char) *text, uiDrawTextFont *defaultFont, double width);
void uiDrawFreeTextLayout(uiDrawTextLayout *layout);
// TODO get width
void uiDrawTextLayoutSetWidth(uiDrawTextLayout *layout, double width);
void uiDrawTextLayoutExtents(uiDrawTextLayout *layout, double *width, double *height);

// and the attributes that you can set on a text layout
void uiDrawTextLayoutSetColor(uiDrawTextLayout *layout, int startChar, int endChar, double r, double g, double b, double a);

void uiDrawText(uiDrawContext *c, double x, double y, uiDrawTextLayout *layout);

/+
 + enums:
 + uiModifiers
 +
 +/

// TODO document drag captures
struct uiAreaMouseEvent {
    // TODO document what these mean for scrolling areas
    double X;
    double Y;

    // TODO see draw above
    double AreaWidth;
    double AreaHeight;

    int Down;
    int Up;

    int Count;

    ModifiersT Modifiers;

    uint64_t Held1To64;
}

/+
 + enums:
 + uiExtKey
 +
 +/

struct uiAreaKeyEvent {
    char Key;
    ExtKeyT ExtKey;
    ModifiersT Modifier;

    ModifiersT Modifiers;

    int Up;
}

struct uiFontButton;
// TODO document this returns a new font
uiDrawTextFont *uiFontButtonFont(uiFontButton *b);
// TOOD SetFont, mechanics
void uiFontButtonOnChanged(uiFontButton *b, void function(uiFontButton *, void *) f, void *data);
uiFontButton *uiNewFontButton();

struct uiColorButton;
void uiColorButtonColor(uiColorButton *b, double *r, double *g, double *bl, double *a);
void uiColorButtonSetColor(uiColorButton *b, double r, double g, double bl, double a);
void uiColorButtonOnChanged(uiColorButton *b, void function(uiColorButton *, void *) f, void *data);
uiColorButton *uiNewColorButton();

struct uiForm;
void uiFormAppend(uiForm *f, const(char) *label, uiControl *c, int stretchy);
void uiFormDelete(uiForm *f, int index);
int uiFormPadded(uiForm *f);
void uiFormSetPadded(uiForm *f, int padded);
uiForm *uiNewForm();

/+
 + enums:
 + uiAlign
 + uiAt
 +
 +/

struct uiGrid;
void uiGridAppend(uiGrid *g, uiControl *c, int left, int top, int xspan, int yspan, int hexpand, Align halign, int vexpand, Align valign);
void uiGridInsertAt(uiGrid *g, uiControl *c, uiControl *existing, At at, int xspan, int yspan, int hexpand, Align halign, int vexpand, Align valign);
int uiGridPadded(uiGrid *g);
void uiGridSetPadded(uiGrid *g, int padded);
uiGrid *uiNewGrid();
