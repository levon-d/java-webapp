package ucl.ac.uk.exceptions;
public class ExistingColumnNameException extends Exception {
    public ExistingColumnNameException(String errorMessage) {
        super(errorMessage);
    }
}
