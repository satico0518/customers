import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Signature canvas. Controller is required, other parameters are optional. It expands by default.
/// This behaviour can be overridden using width and/or height parameters.
class Signature extends StatefulWidget {
  static final String routeName = 'signaturePad';
  Signature({
    Key key,
    @required this.controller,
    this.backgroundColor = Colors.grey,
    this.width,
    this.height,
  })  : assert(controller != null),
        super(key: key);

  final SignatureController controller;
  final double width;
  final double height;
  final Color backgroundColor;

  @override
  State createState() => SignatureState();
}

class SignatureState extends State<Signature> {
  /// Helper variable indicating that user has left the canvas so we can prevent linking next point
  /// with straight line.
  bool _isOutsideDrawField = false;

  get controller => this.controller;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    var maxWidth = widget.width ?? double.infinity;
    var maxHeight = MediaQuery.of(context).size.height / 3;
    var signatureCanvas = GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails details) {
        //NO-OP
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Firma'),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment(0.8, 0.0),
                colors: [
                  const Color(0xffa4b9f3),
                  const Color(0xFF000000)
                ], // whitish to gray
                tileMode:
                    TileMode.mirror, // repeats the gradient over the canvas
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SizedBox(height: 30),
                Text(
                  'Por favor registre su firma',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 6,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(239, 239, 239, .8),
                      border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 5),
                          top: BorderSide(color: Colors.grey, width: 5))),
                  child: Listener(
                    onPointerDown: (event) =>
                        _addPoint(event, PointType.tap, maxWidth, maxHeight),
                    onPointerUp: (event) =>
                        _addPoint(event, PointType.tap, maxWidth, maxHeight),
                    onPointerMove: (event) =>
                        _addPoint(event, PointType.move, maxWidth, maxHeight),
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: _SignaturePainter(
                            widget.controller.points,
                            widget.controller.penColor,
                            widget.controller.penStrokeWidth),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              minWidth: maxWidth,
                              minHeight: maxHeight,
                              maxWidth: maxWidth,
                              maxHeight: maxHeight),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () async {
                        if (widget.controller.isNotEmpty) {
                          
                        } else {
                          SnackBar snackBar = new SnackBar(
                            content: new Text('No se ha registrado una firma', textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                            backgroundColor: Colors.orangeAccent,
                          );
                          _scaffoldKey.currentState.showSnackBar(snackBar);
                        }
                      },
                      child: Text(
                        'Confirmar',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      textColor: Theme.of(context).primaryColor,
                    ),
                    FlatButton(
                        onPressed: () =>
                            setState(() => widget.controller.clear()),
                        child: Text(
                          'Borrar',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );

    if (maxWidth != null || maxHeight != null) {
      //IF DOUNDARIES ARE DEFINED, USE LIMITED BOX
      return Center(
          child: LimitedBox(
              maxWidth: maxWidth,
              maxHeight: maxHeight,
              child: signatureCanvas));
    } else {
      //IF NO BOUNDARIES ARE DEFINED, USE EXPANDED
      return Flex(
          direction: Axis.horizontal,
          children: <Widget>[Expanded(child: signatureCanvas)]);
    }
  }

  void _addPoint(
      PointerEvent event, PointType type, double maxWidth, double maxHeight) {
    Offset o = event.localPosition;
    print(o);
    //SAVE POINT ONLY IF IT IS IN THE SPECIFIED BOUNDARIES
    if ((maxWidth == null || o.dx > 0 && o.dx < maxWidth) &&
        (maxHeight == null || o.dy > 0 && o.dy < maxHeight)) {
      // IF USER LEFT THE BOUNDARY AND AND ALSO RETURNED BACK
      // IN ONE MOVE, RETYPE IT AS TAP, AS WE DO NOT WANT TO
      // LINK IT WITH PREVIOUS POINT
      if (_isOutsideDrawField) {
        type = PointType.tap;
      }
      setState(() {
        //IF USER WAS OUTSIDE OF CANVAS WE WILL RESET THE HELPER VARIABLE AS HE HAS RETURNED
        _isOutsideDrawField = false;
        widget.controller.addPoint(Point(o, type));
      });
    } else {
      //NOTE: USER LEFT THE CANVAS!!! WE WILL SET HELPER VARIABLE
      //WE ARE NOT UPDATING IN setState METHOD BECAUSE WE DO NOT NEED TO RUN BUILD METHOD
      _isOutsideDrawField = true;
    }
  }
}

enum PointType { tap, move }

class Point {
  Offset offset;
  PointType type;

  Point(this.offset, this.type);
}

class _SignaturePainter extends CustomPainter {
  List<Point> _points;
  Paint _penStyle;

  _SignaturePainter(this._points, Color penColor, double penStrokeWidth) {
    this._penStyle = Paint()
      ..color = penColor
      ..strokeWidth = penStrokeWidth;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_points == null || _points.isEmpty) return;
    for (int i = 0; i < (_points.length - 1); i++) {
      if (_points[i + 1].type == PointType.move) {
        canvas.drawLine(
          _points[i].offset,
          _points[i + 1].offset,
          _penStyle,
        );
      } else {
        canvas.drawCircle(
          _points[i].offset,
          2.0,
          _penStyle,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter other) => true;
}

class SignatureController extends ValueNotifier<List<Point>> {
  final Color penColor;
  final double penStrokeWidth;

  SignatureController(
      {List<Point> points,
      this.penColor = Colors.black,
      this.penStrokeWidth = 3.0})
      : super(points ?? List<Point>());

  List<Point> get points => value;

  set points(List<Point> value) {
    value = value.toList();
  }

  addPoint(Point point) {
    value.add(point);
    this.notifyListeners();
  }

  bool get isEmpty {
    return value.length == 0;
  }

  bool get isNotEmpty {
    return value.length > 0;
  }

  clear() {
    value = List<Point>();
  }

  Future<ui.Image> toImage() async {
    if (isEmpty) return null;

    double minX = double.infinity, minY = double.infinity;
    double maxX = 0, maxY = 0;
    points.forEach((point) {
      if (point.offset.dx < minX) minX = point.offset.dx;
      if (point.offset.dy < minY) minY = point.offset.dy;
      if (point.offset.dx > maxX) maxX = point.offset.dx;
      if (point.offset.dy > maxY) maxY = point.offset.dy;
    });

    var recorder = ui.PictureRecorder();
    var canvas = Canvas(recorder);
    canvas.translate(-(minX - penStrokeWidth), -(minY - penStrokeWidth));
    _SignaturePainter(points, penColor, penStrokeWidth).paint(canvas, null);
    var picture = recorder.endRecording();
    return picture.toImage((maxX - minX + penStrokeWidth * 2).toInt(),
        (maxY - minY + penStrokeWidth * 2).toInt());
  }

  Future<Uint8List> toPngBytes() async {
    var image = await toImage();
    var bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return bytes.buffer.asUint8List();
  }
}
