part of 'bucket_bloc.dart';
abstract class BucketEvent {
  const BucketEvent();
}

class BucketCreationEvent extends BucketEvent{

}

class BucketDeletionEvent extends BucketEvent{}

class BucketUpdateEvent  extends BucketEvent{}

class BucketListEvent extends BucketEvent{}