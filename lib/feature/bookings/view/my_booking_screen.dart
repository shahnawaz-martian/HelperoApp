import 'package:flutter/material.dart';
import 'package:helpero/feature/auth/controllers/auth_controller.dart';
import 'package:helpero/feature/bookings/view/booking_details.dart';
import 'package:provider/provider.dart';
import '../controllers/order_controller.dart';
import 'package:sizer/sizer.dart';

import '../widget/booking_card.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderController>(context, listen: false).getOrderList(
        Provider.of<AuthController>(context, listen: false).getUserId(),
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderController>(context, listen: false).getOrderList(
        Provider.of<AuthController>(context, listen: false).getUserId(),
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final provider = Provider.of<OrderController>(context, listen: false);
      if (provider.hasMore && !provider.isLoading) {
        provider.getOrderList(
          Provider.of<AuthController>(context, listen: false).userId,
        );
      }
    }
  }

  Future<void> _refreshFeeds() async {
    await Provider.of<OrderController>(context, listen: false).getOrderList(
      Provider.of<AuthController>(context, listen: false).userId,
      isRefresh: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<OrderController>(
          builder: (context, provider, child) {
            return RefreshIndicator(
              onRefresh: _refreshFeeds,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My Orders",
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                    ),
                    SizedBox(height: 2.h),
                    Expanded(child: _buildOrderList(provider)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderList(OrderController provider) {
    if (provider.isLoading && provider.orderList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.orderList.isEmpty) {
      return Center(
        child: Text(
          "No orders found",
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(letterSpacing: 1.0),
        ),
      );
    }

    return Consumer<OrderController>(
      builder: (context, provider, child) {
        final orderList = provider.orderList;
        return ListView.builder(
          controller: _scrollController,
          itemCount: orderList.length + (provider.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < orderList.length) {
              final order = orderList[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BookingDetails(
                        bookingId: order.orderId ?? '',
                        isFromBookingScreen: true,
                      ),
                    ),
                  ),
                  child: BookingCard(booking: order),
                ),
              );
            }

            return provider.hasMore
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox();
          },
        );
      },
    );
  }
}
