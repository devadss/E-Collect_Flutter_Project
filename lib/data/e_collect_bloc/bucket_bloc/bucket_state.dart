part of 'bucket_bloc.dart';

abstract class BucketState {const BucketState();}
//******************BUCKET-CREATION*******************************
class BucketCreationInitialState extends BucketState {
  const BucketCreationInitialState();
}
class BucketCreationLoaderState extends BucketState {
  const BucketCreationLoaderState();
}
class BucketCreationSuccessState extends BucketState {
  const BucketCreationSuccessState();
}
class BucketCreationFailureState extends BucketState {
  const BucketCreationFailureState();
}
//******************BUCKET-LISTING*******************************
class BucketListInitialState extends BucketState {
  const BucketListInitialState();
}
class BucketListLoaderState extends BucketState {
  const BucketListLoaderState();
}
class BucketListSuccessState extends BucketState {
  const BucketListSuccessState();
}
class BucketListFailureState extends BucketState {
  const BucketListFailureState();
}
//******************BUCKET-UPDATE*******************************
class BucketUpdateInitialState extends BucketState {
  const BucketUpdateInitialState();
}
class BucketUpdateLoaderState extends BucketState {
  const BucketUpdateLoaderState();
}
class BucketUpdateSuccessState extends BucketState {
  const BucketUpdateSuccessState();
}
class BucketUpdateFailureState extends BucketState {
  const BucketUpdateFailureState();
}
//******************BUCKET-DELETE*******************************
class BucketDeletionInitialState extends BucketState {
  const BucketDeletionInitialState();
}
class BucketDeletionLoaderState extends BucketState {
  const BucketDeletionLoaderState();
}
class BucketDeletionSuccessState extends BucketState {
  const BucketDeletionSuccessState();
}
class BucketDeletionFailureState extends BucketState {
  const BucketDeletionFailureState();
}