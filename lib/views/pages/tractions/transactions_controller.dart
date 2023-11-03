import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';

mixin TransactionsController {
  Rx<PageState> state = PageState.initial.obs;


  final RxInt selectedTransactionTag = TagProduct.all.number.obs;

  final RxList<TransactionReadDto> list = <TransactionReadDto>[].obs;
  final RxList<TransactionReadDto> filteredList = <TransactionReadDto>[].obs;

  final TextEditingController controllerTitle = TextEditingController();
  final TextEditingController controllerTitleTr1 = TextEditingController();

  final TransactionDataSource _transactionDataSource = TransactionDataSource(baseUrl: AppConstants.baseUrl);

  void init() {
    if (list.isEmpty)
      read();
    else
      state.loaded();
  }

  void filter() {}

  void read() {
    _transactionDataSource.filter(
      dto: TransactionFilterDto(),
      onResponse: (final GenericResponse<TransactionReadDto> response) {
        list(response.resultList);
        filteredList(list);
        state.loaded();
      },
      onError: (final GenericResponse<dynamic> response) {},
    );
  }

  void changeTag({required final int value}) {

  }
}
