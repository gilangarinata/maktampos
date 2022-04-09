import 'package:equatable/equatable.dart';

abstract class DasboardEvent extends Equatable {}

class GetSummary extends DasboardEvent {
  DateTime date;
  @override
  List<Object> get props => [];

  GetSummary(this.date);
}

class GetSelling extends DasboardEvent {
  DateTime date;
  @override
  List<Object> get props => [];

  GetSelling(this.date);
}

