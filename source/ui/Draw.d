module ui.Draw;

import ui.Core;

struct Context {
    package uiDrawContext* _context;

    this(uiDrawContext* context) {
        _context = context;
    }

    ref stroke(Path path, Brush brush, StrokeParams params) {
        uiDrawStroke(_context, path._path, brush._brush, params._params);
        return this;
    }

    ref fill(Path path, Brush brush) {
        uiDrawFill(_context, path._path, brush._brush);
        return this;
    }

    ref transform(Matrix matrix) {
        uiDrawTransform(_context, matrix._matrix);
        return this;
    }

    ref clip(Path path) {
        uiDrawClip(_context, path._path);
        return this;
    }

    ref save() {
        uiDrawSave(_context);
        return this;
    }

    ref restore() {
        uiDrawRestore(_context);
        return this;
    }

    ref text(double x, double y, TextLayout layout) {
        uiDrawText(_context, x, y, layout._layout);
        return this;
    }
}

struct Path {
    private uiDrawPath* _path;
    static int[uiDrawPath* ] _ref;

    this(FillMode mode) {
        _path = uiDrawNewPath(mode);
        _ref[_path] = 1;
    }

    ~this() {
        _ref[_path]--;
        if (_ref[_path] == 0) {
            uiDrawFreePath(_path);
            _ref.remove(_path);
        }
    }

    this(this) {
        _ref[_path]++;
    }

    ref newFigure(double x, double y) {
        uiDrawPathNewFigure(_path, x, y);
        return this;
    }

    ref newFigureWithArc(double xCenter, double yCenter, double radius,
            double startAngle, double sweep, bool negative) {
        uiDrawPathNewFigureWithArc(_path, xCenter, yCenter, radius, startAngle,
                sweep, cast(int) negative);
        return this;
    }

    ref lineTo(double x, double y) {
        uiDrawPathLineTo(_path, x, y);
        return this;
    }

    ref arcTo(double xCenter, double yCenter, double radius, double startAngle,
            double sweep, bool negative) {
        uiDrawPathArcTo(_path, xCenter, yCenter, radius, startAngle, sweep, cast(int) negative);
        return this;
    }

    ref bezierTo(double c1x, double c1y, double c2x, double c2y, double endX, double endY) {
        uiDrawPathBezierTo(_path, c1x, c1y, c2x, c2y, endX, endY);
        return this;
    }

    ref closeFigure() {
        uiDrawPathCloseFigure(_path);
        return this;
    }

    ref addRectangle(double x, double y, double width, double height) {
        uiDrawPathAddRectangle(_path, x, y, width, height);
        return this;
    }

    ref end() {
        uiDrawPathEnd(_path);
        return this;
    }
}

class Matrix {
    private uiDrawMatrix* _matrix;
    this() {
        _matrix = new uiDrawMatrix;
    }

    @property pragma(inline, true) {
        ref m11() {
            return _matrix.M11;
        }

        ref m12() {
            return _matrix.M12;
        }

        ref m21() {
            return _matrix.M21;
        }

        ref m22() {
            return _matrix.M22;
        }

        ref m31() {
            return _matrix.M31;
        }

        ref m32() {
            return _matrix.M32;
        }
    }

    Matrix setIdentity() {
        uiDrawMatrixSetIdentity(_matrix);
        return this;
    }

    Matrix translate(double x, double y) {
        uiDrawMatrixTranslate(_matrix, x, y);
        return this;
    }

    Matrix scale(double xCenter, double yCenter, double x, double y) {
        uiDrawMatrixScale(_matrix, xCenter, yCenter, x, y);
        return this;
    }

    Matrix rotate(double x, double y, double amount) {
        uiDrawMatrixRotate(_matrix, x, y, amount);
        return this;
    }

    Matrix skew(double x, double y, double xamount, double yamount) {
        uiDrawMatrixSkew(_matrix, x, y, xamount, yamount);
        return this;
    }

    Matrix multiply(ref Matrix other) {
        uiDrawMatrixMultiply(_matrix, other._matrix);
        return this;
    }

    bool invertible() {
        return cast(bool) uiDrawMatrixInvertible(_matrix);
    }

    bool invert() {
        return cast(bool) uiDrawMatrixInvert(_matrix);
    }

    Matrix transformPoint(ref double x, ref double y) {
        uiDrawMatrixTransformPoint(_matrix, &x, &y);
        return this;
    }

    Matrix transformSize(ref double x, ref double y) {
        uiDrawMatrixTransformSize(_matrix, &x, &y);
        return this;
    }
}

class Brush {
    private uiDrawBrush* _brush;

    this() {
        _brush = new uiDrawBrush;
    }

    @property pragma(inline, true) {
        ref type() {
            return _brush.Type;
        }

        ref r() {
            return _brush.R;
        }

        ref g() {
            return _brush.G;
        }

        ref b() {
            return _brush.B;
        }

        ref a() {
            return _brush.A;
        }

        ref x0() {
            return _brush.X0;
        }

        ref y0() {
            return _brush.X1;
        }

        ref x1() {
            return _brush.Y0;
        }

        ref y1() {
            return _brush.Y1;
        }

        ref oterRadius() {
            return _brush.OuterRadius;
        }

        auto stops() {
            return new BrushGradientStop(_brush.Stops);
        }

        void stops(BrushGradientStop stop) {
            _brush.Stops = stop._stop;
        }

        ref numStops() {
            return _brush.NumStops;
        }
    }
}

class BrushGradientStop {
    private uiDrawBrushGradientStop* _stop;
    this() {
        _stop = new uiDrawBrushGradientStop;
    }

    this(uiDrawBrushGradientStop* _stops) {
        _stop = _stops;
    }

    @property pragma(inline, true) {
        ref pos() {
            return _stop.Pos;
        }

        ref r() {
            return _stop.R;
        }

        ref g() {
            return _stop.G;
        }

        ref b() {
            return _stop.B;
        }

        ref a() {
            return _stop.A;
        }
    }
}

class StrokeParams {
    private uiDrawStrokeParams* _params;
    this() {
        _params = new uiDrawStrokeParams;
    }

    @property pragma(inline, true) {
        ref cap() {
            return _params.Cap;
        }

        ref join() {
            return _params.Join;
        }

        ref thickness() {
            return _params.Thickness;
        }

        ref miterLimit() {
            return _params.MiterLimit;
        }

        ref dashes() {
            return _params.Dashes;
        }

        ref numDashes() {
            return _params.NumDashes;
        }

        ref dashPhase() {
            return _params.DashPhase;
        }
    }
}

struct FontFamilies {
    private uiDrawFontFamilies* _families;
    static int[uiDrawFontFamilies* ] _ref;

    static FontFamilies create() {
        return FontFamilies(uiDrawListFontFamilies);
    }

    private this(uiDrawFontFamilies* families) {
        _families = families;
        _ref[_families] = 1;
    }

    ~this() {
        _ref[_families]--;
        if (_ref[_families] == 0) {
            uiDrawFreeFontFamilies(_families);
            _ref.remove(_families);
        }
    }

    @disable this();

    this(this) {
        _ref[_families]++;
    }

    size_t numFamilies() {
        return cast(size_t) uiDrawFontFamiliesNumFamilies(_families);
    }

    string family(size_t n) {
        return uiDrawFontFamiliesFamily(_families, cast(int) n).toString;
    }
}

class TextFontDescriptor {
    private uiDrawTextFontDescriptor* _descriptor;
    this() {
        _descriptor = new uiDrawTextFontDescriptor;
    }

    @property pragma(inline, true) {
        string family() {
            import core.stdc.string : strlen;

            auto c = _descriptor.Family;
            return c[0 .. strlen(c)].idup;
        }

        void family(string text) {
            import std.string : toStringz;

            _descriptor.Family = text.toStringz;
        }

        ref size() {
            return _descriptor.Size;
        }

        ref weight() {
            return _descriptor.Weight;
        }

        ref italic() {
            return _descriptor.Italic;
        }

        ref stretch() {
            return _descriptor.Stretch;
        }
    }

    // TextFont loadClosestFont() {
    //     return TextFont(uiDrawLoadClosestFont(_descriptor));
    // }
}

class TextFontMetrics {
    private uiDrawTextFontMetrics* _metrics;
    this() {
        _metrics = new uiDrawTextFontMetrics;
    }

    @property pragma(inline, true) {
        ref ascent() {
            return _metrics.Ascent;
        }

        ref descent() {
            return _metrics.Descent;
        }

        ref leading() {
            return _metrics.Leading;
        }

        ref underlinePos() {
            return _metrics.UnderlinePos;
        }

        ref underlineThickness() {
            return _metrics.UnderlineThickness;
        }
    }
}

struct TextFont {
    private uiDrawTextFont* _font;
    static int[uiDrawTextFont* ] _ref;

    this(uiDrawTextFont* font) {
        _font = font;
        _ref[_font] = 1;
    }

    ~this() {
        _ref[_font]--;
        if (_ref[_font] == 0) {
            uiDrawFreeTextFont(_font);
            _ref.remove(_font);
        }
    }

    this(this) {
        _ref[_font]++;
    }

    auto handle() {
        return uiDrawTextFontHandle(_font);
    }

    ref describe(TextFontDescriptor descriptor) {
        uiDrawTextFontDescribe(_font, descriptor._descriptor);
        return this;
    }

    ref getMetrics(TextFontMetrics metrics) {
        uiDrawTextFontGetMetrics(_font, metrics._metrics);
        return this;
    }
}

struct TextLayout {
    private uiDrawTextLayout* _layout;
    static int[uiDrawTextLayout* ] _ref;

    this(string text, TextFont font, double width) {
        import std.string : toStringz;

        _layout = uiDrawNewTextLayout(text.toStringz, font._font, width);
        _ref[_layout] = 1;
    }

    ~this() {
        _ref[_layout]--;
        if (_ref[_layout] == 0) {
            uiDrawFreeTextLayout(_layout);
            _ref.remove(_layout);
        }
    }

    this(this) {
        _ref[_layout]++;
    }

    ref setWidth(double width) {
        uiDrawTextLayoutSetWidth(_layout, width);
        return this;
    }

    ref extents(ref double width, ref double height) {
        uiDrawTextLayoutExtents(_layout, &width, &height);
        return this;
    }

    ref setColor(int startChar, int endChar, double r, double g, double b, double a) {
        uiDrawTextLayoutSetColor(_layout, startChar, endChar, r, g, b, a);
        return this;
    }
}
