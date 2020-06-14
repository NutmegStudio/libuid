import ui;

Control makeBasicControlPage() {
    auto vbox = new Box().setPadded(1);

    auto hbox = new Box(false).setPadded(1);
    vbox.append(hbox);

    hbox.append(new Button("Button")).append(new Checkbox("Checkbox"));
    vbox.append(new Label("This is a label. Right now, labels can only span one line."))
        .append(new Separator(false));

    auto group = new Group("Entries").setMargined(true);
    vbox.append(group, true);

    auto entryForm = new Form().setPadded(true);
    group.setChild(entryForm);

    entryForm.append("Entry", new Entry()).append("Password Entry",
            new Entry(EntryStyle.Password)).append("Search Entry",
            new Entry(EntryStyle.Search)).append("Multiline Entry",
            new MultilineEntry, true).append("Multiline Entry No Wrap",
            new MultilineEntry(false), true);

    return vbox;
}

Control makeNumbersPage() {
    auto hbox = new Box(false).setPadded(true);

    auto group = new Group("Numbers").setMargined(true);
    hbox.append(group, true);

    auto vbox = new Box().setPadded(true);
    group.setChild(vbox);

    auto spinbox = new Spinbox(0, 100);
    auto slider = new Slider(0, 100);
    auto pbar = new ProgressBar();
    spinbox.addOnChanged(delegate(Spinbox self) {
        slider.setValue(self.value);
        pbar.setValue(self.value);
    });
    slider.addOnChanged(delegate(Slider self) {
        spinbox.setValue(self.value);
        pbar.setValue(self.value);
    });
    vbox.append(spinbox).append(slider).append(pbar);

    auto ip = new ProgressBar().setValue(-1); // moving ProgressBar
    vbox.append(ip);

    group = new Group("Lists").setMargined(true);
    hbox.append(group, true);

    vbox = new Box().setPadded(true);
    group.setChild(vbox);

    auto cbox = new Combobox().append("Combobox Item 1")
        .append("Combobox Item 2").append("Combobox Item 3");
    vbox.append(cbox);

    auto ecbox = new EditableCombobox().append("Editable Item 1")
        .append("Editable Item 2").append("Editable Item 3");
    vbox.append(ecbox);

    auto rb = new RadioButtons().append("Radio Button 1")
        .append("Radio Button 2").append("Radio Button 3");
    vbox.append(rb);

    return hbox;
}

Control makeDataChoosersPage(Window win) {
    auto hbox = new Box(false).setPadded(true);

    auto vbox = new Box().setPadded(true);
    hbox.append(vbox);

    vbox.append(new DateTimePicker(DateTimePickerStype.Date)).append(new DateTimePicker(
            DateTimePickerStype.Time)).append(new DateTimePicker(DateTimePickerStype.DateTime))
        .append(new FontButton).append(new ColorButton);

    hbox.append(new Separator);

    vbox = new Box().setPadded(true);
    hbox.append(vbox, true);

    auto grid = new Grid().setPadded(true);
    vbox.append(grid);

    auto button = new Button("Open File");
    auto entry = new Entry().setReadOnly(true);
    button.addOnClicked(delegate(Button btn) {
        auto filename = win.openFile;
        if (filename is null) {
            entry.setText("(cancelled)");
            return;
        }
        entry.setText(filename);
    });

    grid.append(button, 0, 0).append(entry, 1, 0, 1, 1, true);

    button = new Button("Save File");
    auto entry2 = new Entry().setReadOnly(true);
    button.addOnClicked(delegate(Button btn) {
        auto filename = win.saveFile();
        if (filename is null) {
            entry2.setText("(cancelled)");
            return;
        }
        entry.setText(filename);
    });

    grid.append(button, 0, 1).append(entry2, 1, 1, 1, 1, true);

    auto msggrid = new Grid().setPadded(true);
    grid.append(msggrid, 0, 2, 2, 1, false, Align.Center, false, Align.Start);

    button = new Button("Message Box");
    button.addOnClicked(delegate(Button btn) {
        win.msgBox("This is a normal message box.", "More detailed information can be shown here.");
    });
    msggrid.append(button, 0, 0);

    button = new Button("Error Box");
    button.addOnClicked(delegate(Button btn) {
        win.msgBoxError("This message box describes an error.",
            "More detailed information can be shown here.");
    });
    msggrid.append(button, 1, 0);
    return hbox;
}

void main() {
    // as design in libui now, menu must be created before window has been created
    auto menu = new Menu("File");
    auto openMenuItem = menu.appendItem("Open");
    auto saveMenuItem = menu.appendItem("Save");

    menu = new Menu("Edit");
    menu.appendCheckItem("Checkable Item");
    menu.appendSeparator.appendItem("Disabled Item").disable();
    menu.appendPreferencesItem;

    menu = new Menu("Help");
    menu.appendItem("Help");
    menu.appendAboutItem;

    auto win = new Window("libuid Control Gallery", 640, 480, true).setMargined(true);
    win.addOnClosing(_ => App.quit);

    openMenuItem.addOnClicked(delegate(MenuItem self) {
        auto filename = win.openFile();
        if (filename is null) {
            win.msgBoxError("No file selected", "Don't be alarmed!");
            return;
        }
        win.msgBox("File selected", filename);
    });
    saveMenuItem.addOnClicked(delegate(MenuItem self) {
        auto filename = win.openFile();
        if (filename is null) {
            win.msgBoxError("No file selected", "Don't be alarmed!");
            return;
        }
        win.msgBox("File selected (don't worry, it's still there)", filename);
    });

    auto tab = new Tab;
    win.setChild(tab);

    tab.append("Basic Controls", makeBasicControlPage).setMargined(0, true)
        .append("Numbers add Lists", makeNumbersPage).setMargined(1, true)
        .append("Data Choosers", makeDataChoosersPage(win)).setMargined(2, true);

    win.show;

    App.run(win);
}
