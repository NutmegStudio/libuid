module ui.Menu;

import ui.Core;
import ui.MenuItem;

class Menu {
    import std.string : toStringz;

    // Notice: now libui's menu implicit attached to window, it's not OO.
    // this makes Menu and MenuItem do not destroy anyhow.
    private static Object[] _menuAndItems;

    protected uiMenu* _menu;

    this(string name = "") {
        _menuAndItems ~= this;
        _menu = uiNewMenu(name.toStringz);
    }

    MenuItem appendItem(string name) {
        auto item = new MenuItem(uiMenuAppendItem(_menu, name.toStringz));
        _menuAndItems ~= item;
        return item;
    }

    MenuItem appendCheckItem(string name) {
        auto item = new MenuItem(uiMenuAppendCheckItem(_menu, name.toStringz));
        _menuAndItems ~= item;
        return item;
    }

    MenuItem appendQuitItem() {
        auto item = new MenuItem(uiMenuAppendQuitItem(_menu));
        _menuAndItems ~= item;
        return item;
    }

    MenuItem appendPreferencesItem() {
        auto item = new MenuItem(uiMenuAppendPreferencesItem(_menu));
        _menuAndItems ~= item;
        return item;
    }

    MenuItem appendAboutItem() {
        auto item = new MenuItem(uiMenuAppendAboutItem(_menu));
        _menuAndItems ~= item;
        return item;
    }

    Menu appendSeparator() {
        uiMenuAppendSeparator(_menu);
        return this;
    }
}
