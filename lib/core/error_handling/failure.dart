abstract class Failure {
  final String message;

  const Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure(
    super.message,
  ); // Pass null or a default message here
}
