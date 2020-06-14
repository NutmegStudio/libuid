module ui.MenuItem;

import ui.Core;
import ui.Window;

class MenuItem {
    protected uiMenuItem* _menuItem;

    private void delegate(MenuItem v)[] OnClickedListeners;
    private extern (C) static void OnClickedCallback(uiMenuItem*, uiWindow* window, void* data) {
        auto v = cast(MenuItem) data;
        foreach (dlg; v.OnClickedListeners) {
            dlg(v);
        }
    }

    public MenuItem addOnClicked(void delegate(MenuItem v) f) {
        OnClickedListeners ~= f;
        return this;
    }

    this(uiMenuItem* menuItem) {
        _menuItem = menuItem;

        uiMenuItemOnClicked(_menuItem, &OnClickedCallback, cast(void*) this);
    }

    MenuItem enable() {
        uiMenuItemEnable(_menuItem);
        return this;
    }

    MenuItem disable() {
        uiMenuItemDisable(_menuItem);
        return this;
    }

    size_t checked() {
        return cast(size_t) uiMenuItemChecked(_menuItem);
    }

    MenuItem setChecked(bool checked) {
        uiMenuItemSetChecked(_menuItem, cast(int) checked);
        return this;
    }
}
