module ui.App;

import ui.Control;

struct App {
    private static bool _appRun = false;
    private static Control _main;

    mixin EventListenerMixin!("QueueMain", NoneTypeTag);
    mixin EventListenerMixin!("OnShouldQuit", NoneTypeTag, int);

    static this() {
        auto io = uiInitOptions();
        auto msg = uiInit(&io);
        if (msg) {
            scope (exit)
                uiFreeInitError(msg);
            import core.stdc.string : strlen;

            assert(false, "libui init error: " ~ msg[0 .. strlen(msg)]);
        }

        uiQueueMain(&QueueMainCallback, null);
        uiOnShouldQuit(&OnShouldQuitCallback, null);
    }

    static void init() {
        auto io = uiInitOptions();
        auto msg = uiInit(&io);
        if (msg) {
            scope (exit)
                uiFreeInitError(msg);
            import core.stdc.string : strlen;

            assert(false, "libui init error: " ~ msg[0 .. strlen(msg)]);
        }

        uiQueueMain(&QueueMainCallback, null);
        uiOnShouldQuit(&OnShouldQuitCallback, null);
    }

    static ~this() {
        uiUninit;
    }

    static void run(Control main) {
        import std.exception : enforce;

        if (_appRun) {
            enforce(false, "Application cannot be run twice");
        }
        if (main.parent) {
            enforce(false, "Application can only run with top level control");
        }
        _appRun = true;

        _main = main;
        OnShouldQuit(delegate() {
            if (!_main.parent) {
                uiControlDestroy(_main._control);
            }
        });
        uiMain;
    }

    static void quit() {
        uiQuit;
    }

    static bool step(bool wait) {
        uiMainSteps;
        return cast(bool) uiMainStep(cast(int) wait);
    }
}
