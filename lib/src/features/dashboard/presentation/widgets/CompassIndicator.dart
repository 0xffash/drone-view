import 'dart:async';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class CompassIndicator extends StatefulWidget {
  final double width;
  final double initialDegree;
  final Stream<double>? degreeStream;

  const CompassIndicator({
    super.key,
    this.width = 300,
    this.initialDegree = 0,
    this.degreeStream,
  });

  @override
  State<CompassIndicator> createState() => _CompassIndicatorState();
}

class _CompassIndicatorState extends State<CompassIndicator> {
  late double _currentDegree;
  final ScrollController _scrollController = ScrollController();
  StreamSubscription<double>? _degreeSubscription;
  final Map<int, String> _directionLabels = {
    0: 'شمال',
    45: '',
    90: 'شرق',
    135: '',
    180: 'جنوب',
    225: '',
    270: 'غرب',
    315: '',
  };

  final GlobalKey _measureKey = GlobalKey();
  double? _segmentWidth;

  @override
  void initState() {
    super.initState();
    _currentDegree = widget.initialDegree;
    _subscribeToDegreeStream();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureSegmentWidthAndCenter();
    });
  }

  @override
  void didUpdateWidget(CompassIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.degreeStream != oldWidget.degreeStream) {
      _degreeSubscription?.cancel();
      _subscribeToDegreeStream();
    }
    if (widget.initialDegree != oldWidget.initialDegree) {
      _currentDegree = widget.initialDegree;
      _centerCompass(); // Will only work if _segmentWidth is set
    }
  }

  void _subscribeToDegreeStream() {
    if (widget.degreeStream != null) {
      _degreeSubscription = widget.degreeStream!.listen((degree) {
        if (mounted) {
          setState(() {
            _currentDegree = degree;
          });
          _centerCompass();
        }
      });
    }
  }

  void _measureSegmentWidthAndCenter() {
    Future.delayed(Duration(milliseconds: 100), () {
      final ctx = _measureKey.currentContext;
      if (ctx != null) {
        final box = ctx.findRenderObject() as RenderBox;
        setState(() {
          _segmentWidth = box.size.width;
        });
        _centerCompass();
      }
    });
  }

  void _centerCompass() {
    if (_segmentWidth == null) return;

    final nearestDirection = (_currentDegree / 45).round() * 45 % 360;
    final segmentIndex = nearestDirection ~/ 45;

    final double tallLineWidth = 2 + 3; // line + margins

    // Total content width without padding
    final totalContentWidth =
        _segmentWidth! * _directionLabels.length +
        tallLineWidth * (_directionLabels.length - 1);

    // Padding on both sides
    final horizontalPadding = widget.width / 2;

    // Calculate offset:
    // Start with all previous direction segments + tall lines width before the current segment
    final offset =
        (segmentIndex * (_segmentWidth! + tallLineWidth)) +
        horizontalPadding -
        (widget.width / 2) +
        (_segmentWidth! / 2);

    // Max scroll includes padding
    final maxScroll = totalContentWidth + 2 * horizontalPadding - widget.width;

    _scrollController.animateTo(
      offset.clamp(0.0, maxScroll),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _degreeSubscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: 50,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: widget.width / 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < _directionLabels.length; i++) ...[
                _buildDirectionSegment(
                  _directionLabels.entries.elementAt(i).value,
                  key: i == 0 ? _measureKey : null,
                ),
                if (i < _directionLabels.length - 1) _buildVerticalLine(20),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDirectionSegment(String direction, {Key? key}) {
    return Row(
      key: key,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildVerticalLine(5),
        _buildVerticalLine(5),
        _buildVerticalLine(13),
        _buildVerticalLine(5),
        _buildVerticalLine(5),
        Stack(
          clipBehavior: Clip.none,
          children: [
            _buildVerticalLine(10),
            Positioned(
              top: 10,
              left: -20,
              right: -20,
              child: Text(
                direction,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        _buildVerticalLine(5),
        _buildVerticalLine(5),
        _buildVerticalLine(13),
        _buildVerticalLine(5),
        _buildVerticalLine(5),
      ],
    );
  }

  Widget _buildVerticalLine(double height) {
    return Container(
      height: height,
      width: 2,
      margin: const EdgeInsets.symmetric(horizontal: 1.5),
      color: Colors.white,
    );
  }
}
