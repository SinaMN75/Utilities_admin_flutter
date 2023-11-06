import 'package:flutter/material.dart';
import 'package:utilities/components/components.dart';
import 'package:utilities/data/data.dart';
import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';

class TransactionDetailPage extends StatefulWidget {
  const TransactionDetailPage({required this.transactionReadDto, super.key});

  final TransactionReadDto transactionReadDto;

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  late TransactionReadDto transactionReadDto;
  late OrderReadDto orderReadDto;

  @override
  void initState() {
    transactionReadDto=widget.transactionReadDto;
    orderReadDto=transactionReadDto.order!;
    super.initState();
  }
  @override
  Widget build(final BuildContext context) => scaffold(body: Column(
    children: <Widget>[
      Row(
        children: <Widget>[
          image(
            transactionReadDto.user?.media.getImage()??'',
            placeholder: AppImages.profilePlaceholder,
            borderRadius: 40, //
            width: 64,
            height: 64
              ),
          // ).onTap(() => push(ProfilePage(userId: order.orderDetails?.first.product?.user?.id ?? ''))),
          const SizedBox(width: 8),
           Text(transactionReadDto.user?.fullName??'').bodyMedium(fontSize: 18),
        ],
      ),
      const SizedBox(height: 8),
      SizedBox(
        width: screenWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text('شماره سفارش:12455 ').bodyLarge(color: context.theme.primaryColorDark.withOpacity(0.5)),
             Text(transactionReadDto.createdAt?.toJalaliDateString()??'').bodyLarge(color: context.theme.primaryColorDark.withOpacity(0.5)),
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
  ));

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
        Row(children: <Widget>[
          const Icon(Icons.add_circle,size: 24,),
          Text( totalPrice.toString()).bodyMedium(),
        ],)
        // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(s.orderPrice), Text("963,000 تومان")]).marginSymmetric(vertical: 8),
        // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(s.shippingCost), Text("0 تومان")]).marginSymmetric(vertical: 8),
        // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(s.discount), Text("14,000 تومان")]).marginSymmetric(vertical: 8),
        // _price(price: totalPrice.toString(), title: s.amountPaid, color: AppColors.green),
        // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(s.totalPrice), Text("${getPrice(totalPrice.toString())} ${s.toman}")]).marginSymmetric(vertical: 8),
      ],
    );
  }
  Widget _itemOrderDetail({required final int index, required final OrderDetail orderDetail}) => Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      width: screenWidth - 50,
      child: Row(
        children: <Widget>[
          Card(
            child: image(orderDetail.product?.parent?.media.getImage(tagUseCase: TagMedia.post.number) ?? '', width: 64, height: 64),
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
      // child: ListTile(
      //   leading: image(orderDetail.product!.parent!.media.getImage()),
      //   title: Text(orderDetail.product?.title ?? ''),
      //   subtitle: Text('${orderDetail.count} عدد'),
      //   trailing: Text("${getPrice(totalPrice.toString())} T"),
      // ),
    );



}
