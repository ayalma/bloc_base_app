/*
import 'package:bloc_base/bloc_base.dart';
 class  Resource<T> extends BlocState{
  final T data;
  final Object error;
  final Status status;

  Resource(this.data, this.error, this.status);

  factory Resource.success(T data)=> Resource(data, null, Status.Success);
  factory Resource.error(Object error)=> Resource(null, error, Status.Error);
  factory Resource.loading()=> Resource(null, null, Status.Loading);
}*/

enum Status{
  Loading,
  Success,
  Error,
}
