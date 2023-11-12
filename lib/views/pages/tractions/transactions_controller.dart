import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';

mixin TransactionsController {
  Rx<PageState> state = PageState.initial.obs;
  late final String? userId;
  final RxInt selectedTransactionTag = TagProduct.all.number.obs;
  final RxList<TransactionReadDto> list = <TransactionReadDto>[].obs;
  final RxList<TransactionReadDto> filteredList = <TransactionReadDto>[].obs;

  final TextEditingController controllerTitle = TextEditingController();
  final TransactionDataSource _transactionDataSource = TransactionDataSource(baseUrl: AppConstants.baseUrl);

  void init() {
    if (list.isEmpty)
      filter();
    else
      state.loaded();
  }

  void filter() {
    _transactionDataSource.filter(
      dto: TransactionFilterDto(
        userId: userId,
      ),
      onResponse: (final GenericResponse<TransactionReadDto> response) {
        list(response.resultList);
        filteredList(list);
        state.loaded();
      },
      onError: (final GenericResponse<dynamic> response) {},
    );
  }

  void create({required final VoidCallback action, final String? userId}) {
    final TextEditingController controllerAmount = TextEditingController();
    final TextEditingController controllerDescription = TextEditingController();
    final TextEditingController controllerCardNumber = TextEditingController();
    bottomSheet(
      child: column(
        mainAxisSize: MainAxisSize.min,
        height: 500,
        children: <Widget>[
          textField(text: "مقدار", controller: controllerAmount),
          textField(text: "توضیحات", controller: controllerDescription),
          textField(text: "شماره کارت", controller: controllerCardNumber),
          button(
            width: 400,
            title: "ثبت",
            onTap: () {
              showEasyLoading();
              _transactionDataSource.create(
                dto: TransactionCreateDto(
                  userId: userId ?? Core.user.id,
                  amount: controllerAmount.text.toInt(),
                  cardNumber: controllerCardNumber.text,
                  descriptions: controllerDescription.text,
                  tags: <int>[TagCategory.category.number],
                ),
                onResponse: (final GenericResponse<TransactionReadDto> response) {
                  back();
                  action();
                },
                onError: (final GenericResponse<dynamic> response) {},
              );
            },
          ),
        ],
      ),
    );
  }
}
