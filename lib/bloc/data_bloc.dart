import 'package:bloc/bloc.dart';
import '../services/Database_service.dart';
import 'data_event.dart';
import 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  DataBloc() : super(DataInitial()) {
    on<LoadDataEvent>(_onLoadData);
    on<AddDataEvent>(_onAddData);
    on<DeleteDataEvent>(_onDeleteData);
    on<GetEventById>(_onGetEventById);
    on<FetchAllEvents>(_onFetchAllEvents);
     on<UpdateEvent>(_onUpdateEvent);
  }

  Future<void> _onLoadData(LoadDataEvent event, Emitter<DataState> emit) async {
    emit(DataLoading());
    try {
      final data = await _dbHelper.fetchData();
      emit(DataLoaded(data));
    } catch (e) {
      emit(DataError(e.toString()));
    }
  }

  Future<void> _onAddData(AddDataEvent event, Emitter<DataState> emit) async {
    try {
      await _dbHelper.insertData(event.data);
      add(LoadDataEvent());
    } catch (e) {
      emit(DataError(e.toString()));
    }
  }

  Future<void> _onDeleteData(
      DeleteDataEvent event, Emitter<DataState> emit) async {
    try {
      await _dbHelper.deleteData(event.id);
      add(LoadDataEvent()); 
    } catch (e) {
      emit(DataError(e.toString()));
    }
  }

  Future<void> _onGetEventById(
      GetEventById event, Emitter<DataState> emit) async {
    emit(DataLoading());
    try {
      final data = await _dbHelper.getEventById(event.id);
      if (data != null) {
        emit(DataLoaded([data])); 
      } else {
        emit(const DataError('Event not found'));
      }
    } catch (e) {
      emit(DataError(e.toString()));
    }
  }
 Future<void> _onFetchAllEvents(
      FetchAllEvents event, Emitter<DataState> emit) async {
    emit(DataLoading());
    try {
      final events = await _dbHelper.getAllEvents(); 
      emit(DataLoaded(events));
    } catch (e) {
      emit(DataError(e.toString()));
    }
  }

  Future<void> _onUpdateEvent(
      UpdateEvent event, Emitter<DataState> emit) async {
    try {
      await _dbHelper.updateEvent(event.updatedEvent);
      add(LoadDataEvent());
    } catch (e) {
      emit(DataError(e.toString()));
    }
  }

}


