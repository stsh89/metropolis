//! This module is responsible for the simple validation of the data.
//! Once it has grown, you should consider moving it to a separate crate.

/// Wrapper around found validation errors.
///
/// An example of using the validator would be as follows:
///
///```ignore
/// fn main() {
///     let validation_errors = Validator::new()
///         .validate_required("name", "")
///         .validate_max_length("name", "Captain America", 10)
///         .validate();
///
///     // Proceed with the check for validation errors.
/// }
///
/// ```
pub struct Validator {
    validation_errors: Vec<ValidationError>,
}

/// Error that was found during the validation process.
#[derive(Clone, Debug, PartialEq)]
pub struct ValidationError {
    /// The name of the field that was validated.
    pub field_name: String,

    /// The type of the error.
    pub kind: ValidationErrorKind,
}

/// List of all available validation error types.
#[derive(Clone, Debug, PartialEq)]
pub enum ValidationErrorKind {
    /// Field is required and can't be empty.
    Required,

    /// The field exceeds maximum bytes.
    MaxLength(usize),
}

impl Validator {
    /// Initializes the validation process.
    pub fn new() -> Self {
        Self {
            validation_errors: vec![],
        }
    }

    /// Returns a list of all validation errors.
    pub fn validate(self) -> Vec<ValidationError> {
        self.validation_errors
    }

    /// Validate string field against maximum number of bytes allowed.
    pub fn validate_max_length(
        mut self,
        field_name: &str,
        value: &str,
        length: usize,
    ) -> Validator {
        if value.len() <= length {
            return self;
        };

        self.validation_errors.push(ValidationError {
            field_name: field_name.to_string(),
            kind: ValidationErrorKind::MaxLength(length),
        });

        self
    }

    /// Check that a string is non-empty.
    pub fn validate_required(mut self, field_name: &str, value: &str) -> Validator {
        if !value.is_empty() {
            return self;
        };

        self.validation_errors.push(ValidationError {
            field_name: field_name.to_string(),
            kind: ValidationErrorKind::Required,
        });

        self
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_returns_empty_list_when_all_validation_pass() {
        let validation_errors = Validator::new()
            .validate_required("name", "a")
            .validate_max_length("name", "Captain", 10)
            .validate();

        assert_eq!(validation_errors, []);
    }

    #[test]
    fn it_validates_required_str() {
        let validation_errors = Validator::new().validate_required("name", "").validate();

        let expected_validation_error = ValidationError {
            field_name: "name".to_string(),
            kind: ValidationErrorKind::Required,
        };

        assert_eq!(validation_errors, [expected_validation_error]);
    }

    #[test]
    fn it_validates_max_length() {
        let validation_errors = Validator::new()
            .validate_max_length("name", "Captain America", 10)
            .validate();

        let expected_validation_error = ValidationError {
            field_name: "name".to_string(),
            kind: ValidationErrorKind::MaxLength(10),
        };

        assert_eq!(validation_errors, [expected_validation_error]);
    }

    #[test]
    fn it_returns_all_validation_errors() {
        let validation_errors = Validator::new()
            .validate_required("name", "")
            .validate_max_length("name", "Captain America", 10)
            .validate();

        let expected_required_error = ValidationError {
            field_name: "name".to_string(),
            kind: ValidationErrorKind::Required,
        };

        let expected_max_length_error = ValidationError {
            field_name: "name".to_string(),
            kind: ValidationErrorKind::MaxLength(10),
        };

        assert_eq!(
            validation_errors,
            [expected_required_error, expected_max_length_error]
        );
    }
}
