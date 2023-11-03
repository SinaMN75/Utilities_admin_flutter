import 'package:flutter/material.dart';
import 'package:utilities/components/components.dart';
import 'package:utilities/data/data.dart';

class TransactionDetailPage extends StatefulWidget {
  const TransactionDetailPage({required this.transactionReadDto, super.key});

  final TransactionReadDto transactionReadDto;

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {

  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(final BuildContext context) => scaffold(body: Container());
}
