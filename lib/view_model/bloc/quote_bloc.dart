import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/quotable.dart';
import '../../models/repositories/radnom_repository.dart';


part 'quote_event.dart';

part 'quote_state.dart';

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  QuoteBloc() : super(QuoteInitial()) {
    on<QuoteEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<GetRandom>(_mapGetRandomEventToState);
    on<GetQuotesList>((event, emit) {});
    on<GetAuthorsList>((event, emit) {});
  }

  void _mapGetRandomEventToState(
      GetRandom event, Emitter<QuoteState> emit) async {
    emit(QuoteLoading());
    try {
      final quote = await RandomRepository().fetchRandom();
      emit(QuoteSuccess(quote));
    } catch (e) {
      print(e.toString());
      emit(QuoteError(e.toString()));
    }
  }
}