import 'package:flutter_bloc/flutter_bloc.dart';
part 'bucket_event.dart';
part 'bucket_state.dart';

class BucketCreationBloc extends Bloc<BucketEvent, BucketState> {
  BucketCreationBloc() : super(BucketCreationInitialState()) {
    on<BucketCreationEvent>((event, emit) {});
    on<BucketListEvent>((event, emit) {});
    on<BucketUpdateEvent>((event, emit) {});
    on<BucketDeletionEvent>((event, emit) {});
  }
}
