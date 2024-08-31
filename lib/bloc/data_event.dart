// data_event.dart
import 'package:equatable/equatable.dart';
import '../data/models/data_model.dart';

abstract class DataEvent extends Equatable {
  const DataEvent();

  @override
  List<Object?> get props => [];
}

class GetEventById extends DataEvent {
  final int id;

  const GetEventById(this.id);

  @override
  List<Object?> get props => [id];
}

class LoadDataEvent extends DataEvent {}

class AddDataEvent extends DataEvent {
  final DataModel data;

  const AddDataEvent(this.data);

  @override
  List<Object?> get props => [data];
}

class DeleteDataEvent extends DataEvent {
  final int id;

  const DeleteDataEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class FetchAllEvents extends DataEvent {}

class UpdateEvent extends DataEvent {
  final DataModel updatedEvent;

  const UpdateEvent(this.updatedEvent);

  @override
  List<Object> get props => [updatedEvent];
}
