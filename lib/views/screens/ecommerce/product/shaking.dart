import 'dart:math';

import 'package:flutter/material.dart';

class ShakingIconExample extends StatefulWidget {
  @override
  _ShakingIconExampleState createState() => _ShakingIconExampleState();
}
class _ShakingIconExampleState extends State<ShakingIconExample>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 8).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _simulateAddToCart() async {
    setState(() {
      isLoading = true;
      _controller.forward();
    });

    // Simulate a loading delay
    await Future.delayed(Duration(seconds: 3));

    setState(() {
      isLoading = false;
      _controller.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shaking Icon Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    sin(_animation.value),   // Shake left and right
                    cos(_animation.value),   // Shake up and down
                  ),
                  child: Icon(
                    Icons.shopping_cart,
                    size: 100,
                    color: isLoading ? Colors.blue : Colors.green,
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : _simulateAddToCart,
              child: isLoading ? CircularProgressIndicator() : Text("Add to Cart"),
            ),
          ],
        ),
      ),
    );
  }
}
