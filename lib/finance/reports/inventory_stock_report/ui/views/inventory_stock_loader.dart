import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/containers/elevated_container.dart';
import 'package:wallpost/_common_widgets/shimmer/shimmer_effect.dart';

import '../../../../../_common_widgets/containers/performance_container.dart';

class InventoryStockLoaderTop extends StatelessWidget {
  const InventoryStockLoaderTop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: 52,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerEffect(child: _emptyContainer(height: 12, width: 120)),
              SizedBox(height: 4),
              ShimmerEffect(child: _emptyContainer(height: 20, width: 180)),
            ],
          ),
        ),
        Container(
          height: 114,
          child: Column(
            children: [
              Container(
                height: 52,
                color: Colors.white,
                padding: EdgeInsets.only(top: 8),
                child: ShimmerEffect(
                  child: Center(
                    child: SizedBox(
                      height: 28,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          SizedBox(width: 20),
                          _emptyContainer(height: 28, width: 28),
                          SizedBox(width: 12),
                          _emptyContainer(height: 28, width: 120),
                          SizedBox(width: 12),
                          _emptyContainer(height: 28, width: 120),
                          SizedBox(width: 12),
                          _emptyContainer(height: 28, width: 120),
                          SizedBox(width: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 58,
                padding: EdgeInsets.only(top: 2, bottom: 12, left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30)),
                ),
                child: Center(
                  child: ShimmerEffect(child: _emptyContainer(height: 44)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _emptyContainer({required double height, double width = double.infinity, double cornerRadius = 10}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(cornerRadius),
      ),
    );
  }
}

class InventoryStockLoaderBottom extends StatelessWidget {
  const InventoryStockLoaderBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedContainer(
          child: ShimmerEffect(
            child: PerformanceContainer(
              title: '',
              subtitle: '',
              showLargeTitle: true,
            ),
          ),
        ),
        ElevatedContainer(
          child: Column(
            children: [
              _tile(),
              Divider(height: 1),
              _tile(),
              Divider(height: 1),
              _tile(),
              Divider(height: 1),
              _tile(),
              Divider(height: 1),
              _tile(),
              Divider(height: 1),
              _tile(),
              Divider(height: 1),
              _tile(),
              Divider(height: 1),
              _tile(),
              Divider(height: 1),
              _tile(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tile() {
    return Container(
      height: 56,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: ShimmerEffect(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _emptyContainer(height: 16, width: 120),
            _emptyContainer(height: 16, width: 60),
            _emptyContainer(height: 16, width: 60),
          ],
        ),
      ),
    );
  }

  _emptyContainer({required double height, double width = double.infinity, double cornerRadius = 10}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(cornerRadius),
      ),
    );
  }
}
