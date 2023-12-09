import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';

class TransactionDetailPage extends StatefulWidget {
  const TransactionDetailPage({required this.transactionReadDto, super.key});

  @override
  Key? get key => const Key("توضیحات تراکنش");
  final TransactionReadDto transactionReadDto;

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late TransactionReadDto transactionReadDto;
  late OrderReadDto orderReadDto;

  @override
  void initState() {
    transactionReadDto = widget.transactionReadDto;
    orderReadDto = transactionReadDto.order!;
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    super.build(context);
    return scaffold(
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              image(transactionReadDto.user?.media.getImage() ?? '', placeholder: AppImages.profilePlaceholder, borderRadius: 40, width: 64, height: 64),
              const SizedBox(width: 8),
              Text(transactionReadDto.user?.fullName ?? '').bodyMedium(fontSize: 18),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: screenWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('شماره سفارش:12455 ').bodyLarge(color: context.theme.primaryColorDark.withOpacity(0.5)),
                Text(transactionReadDto.createdAt?.toJalaliDateString() ?? '').bodyLarge(color: context.theme.primaryColorDark.withOpacity(0.5)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: orderReadDto.orderDetails!.length,
            itemBuilder: (final BuildContext context, final int index) => _itemOrderDetail(orderDetail: orderReadDto.orderDetails![index], index: index),
          ),
          const Divider(height: 1),
          const SizedBox(height: 8),
          _productInfo(order: orderReadDto),
        ],
      ),
    );
  }

  Widget _productInfo({required final OrderReadDto order}) {
    int totalPrice = 0;
    order.orderDetails?.forEach((final OrderDetail element) {
      final int price = element.product?.price ?? 0;
      final int discount = element.product?.discountPercent ?? 0;
      final int count = element.count ?? 1;
      final double total = (price - ((discount / 100) * price)) * count;
      totalPrice = totalPrice + total.toInt();
    });

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            const Icon(
              Icons.add_circle,
              size: 24,
            ),
            Text(totalPrice.toString()).bodyMedium(),
          ],
        )
      ],
    );
  }

  Widget _itemOrderDetail({required final int index, required final OrderDetail orderDetail}) => Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        width: screenWidth - 50,
        child: Row(
          children: <Widget>[
            Card(
              child: image(orderDetail.product?.parent?.media.getImage(tag: TagMedia.post.number) ?? '', width: 64, height: 64),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(orderDetail.product?.parent?.title ?? '').bodyMedium(),
                  const SizedBox(height: 8),
                  Text(orderDetail.product?.price?.toString() ?? '').bodyMedium(),
                ],
              ),
            ),
            Text("${orderDetail.count} عدد ").bodyMedium(color: Colors.green),
          ],
        ),
      );
}
