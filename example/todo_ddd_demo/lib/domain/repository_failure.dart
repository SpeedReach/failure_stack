

sealed class RepositoryFailure{
  const RepositoryFailure();
}

class UnExpectedFailure extends RepositoryFailure{
  final Object? error;
  const UnExpectedFailure(this.error);
}

class ConnectionFailure extends RepositoryFailure {
  const ConnectionFailure();
  @override
  String toString() {
    return "ConnectionFailure: Could not connect to server, please check your internet environment.";
  }
}

class UnAuthorizeFailure extends RepositoryFailure{
  const UnAuthorizeFailure();
  @override
  String toString() {
    return "UnAuthorizeFailure: You do not have permission for this action.";
  }
}

class ServerFailure extends RepositoryFailure{

  const ServerFailure();

  @override
  String toString() {
    return "ServerFailure: Some error occurred while processing your request. Please contact admin.";
  }
}

class IllegalActionFailure extends RepositoryFailure{

  final String message;

  const IllegalActionFailure(this.message);

  @override
  String toString() {
    return "IllegalActionFailure: $message";
  }

}

class RequestCanceledFailure extends RepositoryFailure{
  const RequestCanceledFailure();
}