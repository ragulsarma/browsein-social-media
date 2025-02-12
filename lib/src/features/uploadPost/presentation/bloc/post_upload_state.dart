part of 'post_upload_cubit.dart';

abstract class PostUploadState extends Equatable {
  const PostUploadState();

  @override
  List<Object?> get props => [];
}

class PostUploadInitial extends PostUploadState {}

class PostUploading extends PostUploadState {}

class PostUploadSuccess extends PostUploadState {}

class PostUploadError extends PostUploadState {
  final String message;
  const PostUploadError(this.message);

  @override
  List<Object?> get props => [message];
}
