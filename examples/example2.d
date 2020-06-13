import ui;

import std.typecons: Tuple, tuple;

Spinbox[] datapoints;
int currentPoint = -1;

enum xoffLeft = 20;
enum yoffTop = 20;
enum xoffRight = 20;
enum yoffBottom = 20;
enum pointRadius = 5;

enum colorWhite = 0xFFFFFF;
enum colorBlack = 0x000000;
enum colorDodgerBlue = 0x1E90FF;

void setSolidBrush(ref Brush brush, uint color, double alpha) {
    ubyte component;
    brush.type = BrushType.Solid;
    brush.r = (cast(double) (cast(ubyte) ((color >> 16) & 0xFF))) / 255;
    brush.g = (cast(double) (cast(ubyte) ((color >> 8) & 0xFF))) / 255;
    brush.b = (cast(double) (cast(ubyte) (color & 0xFF))) / 255;
    brush.a = alpha;
}

auto graphSize(double clientWidth, double clientHeight) {
    auto ret = Tuple!(double, "width", double, "height")();
    ret.width = clientWidth - xoffLeft - xoffRight;
    ret.height = clientHeight - yoffTop - yoffBottom;
    return ret;
}

void main() {
    auto win = new Window("libuid Histogram Example", 640, 480, 1)
        .setMargined(true)
        .addOnClosing(_ => App.quit);

    void delegate(Area a, DrawParams params)[] DrawListeners;
    void delegate(Area a, MouseEvent event)[] MouseEventListeners;
    void delegate(Area a, int left)[] MouseCrossedListeners;
    void delegate(Area a)[] DragBrokenListeners;
    void delegate(Area a, KeyEvent event)[] KeyEventListeners;

    auto histogram = new Area;

    auto hbox = new Box(false)
        .setPadded(true);
    win.setChild(hbox);

    auto vbox = new Box()
        .setPadded(true);

    hbox.append(vbox);

    foreach (i; 0..10) {
        import std.random: uniform;
        auto spinbox = new Spinbox(0, 100)
            .setValue(uniform(0, 101))
            .addOnChanged(delegate(Spinbox) { histogram.queueRedrawAll; });
        vbox.append(spinbox);
        datapoints ~= spinbox;
    }

    auto colorButton = new ColorButton;
    Brush brush = new Brush;
    brush.setSolidBrush(colorDodgerBlue, 1.0);
    colorButton.setColor(brush.r, brush.g, brush.b, brush.a)
        .addOnChanged(delegate(ColorButton) { histogram.queueRedrawAll; });
    vbox.append(colorButton);

    hbox.append(histogram, true);

    auto pointLocations(double width, double height) {
        auto xincr = width / 9;
        auto yincr = height / 100;

        auto ret = Tuple!(double[10], "xs", double[10], "ys")();

        foreach (i; 0..10) {
            auto n = 100 - datapoints[i].value;
            ret.xs[i] = xincr * i;
            ret.ys[i] = yincr * n;
        }
        return ret;
    }

    histogram.addDraw(delegate(Area a, DrawParams p) {
            Brush brush = new Brush;
            brush.setSolidBrush(colorWhite, 1.0);
            auto path = Path(FillMode.Winding);
            path.addRectangle(0, 0, p.areaWidth, p.areaHeight)
                .end;
            p.context.fill(path, brush);
            
            auto gs = graphSize(p.areaWidth, p.areaHeight);
            
            StrokeParams sp = new StrokeParams;
            sp.cap = LineCap.Flat;
            sp.join = LineJoin.Miter;
            sp.thickness = 2;
            sp.miterLimit = DrawDefaultMiterLimit;
            
            brush.setSolidBrush(colorBlack, 1.0);
            path = Path(FillMode.Winding);
            path.newFigure(xoffLeft, yoffTop)
                .lineTo(xoffLeft, yoffTop + gs.height)
                .lineTo(xoffLeft + gs.width, yoffTop + gs.height)
                .end;
            p.context.stroke(path, brush, sp);
            
            Matrix m = new Matrix();
            m.setIdentity.translate(xoffLeft, yoffTop);
            p.context.transform(m);
            
            auto color = colorButton.color;
            brush.type = BrushType.Solid;
            brush.r = color.r;
            brush.g = color.g;
            brush.b = color.b;

            auto constructGraph(double width, double height, bool extend) {
                auto path = Path(FillMode.Winding);
                auto loc = pointLocations(width, height);
                path.newFigure(loc.xs[0], loc.ys[0]);
                foreach (i; 1..10) {
                    path.lineTo(loc.xs[i], loc.ys[i]);
                }

                if (extend) {
                    path.lineTo(width, height)
                        .lineTo(0, height)
                        .closeFigure;
                }
                path.end;
                return path;
            }

            path = constructGraph(gs.width, gs.height, true);
            brush.a = color.a / 2;
            p.context.fill(path, brush);

            path = constructGraph(gs.width, gs.height, false);
            brush.a = color.a;
            p.context.stroke(path, brush, sp);

            if (currentPoint != -1) {
                auto loc = pointLocations(gs.width, gs.height);
                path = Path(FillMode.Winding)
                    .newFigureWithArc(
                        loc.xs[currentPoint], loc.ys[currentPoint],
                        pointRadius, 0, 6.23, 0
                        ).end;
                p.context.fill(path, brush);
            }
        }).addMouseEvent(delegate(Area a, MouseEvent e) {
            auto gs = graphSize(e.areaWidth, e.areaHeight);
            auto loc = pointLocations(gs.width, gs.height);

            bool inPoint(double x, double y, double xtest, double ytest) {
                x -= xoffLeft;
                y -= yoffTop;
                return (x >= xtest - pointRadius) &&
                    (x <= xtest + pointRadius) &&
                        (y >= ytest - pointRadius) &&
                        (y <= ytest + pointRadius);
            }

            int i = 0;
            for (; i < 10; i++) {
                if (inPoint(e.x, e.y, loc.xs[i], loc.ys[i])) {
                    break;
                }
            }
            
            if (i == 10) {
                i = -1;
            }

            currentPoint = i;
            histogram.queueRedrawAll;
        }).addMouseCrossed(delegate(Area a, int left) {
        }).addDragBroken(delegate(Area a) {
        }).addKeyEvent(delegate(Area a, KeyEvent event) {
        });

    App.run(win.show);
}
