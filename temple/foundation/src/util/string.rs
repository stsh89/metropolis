pub fn optional(value: &str) -> Option<String> {
    (!value.is_empty()).then(|| value.to_owned())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_converts_string_to_optional_string() {
        assert_eq!(Some("Barbie".to_string()), optional("Barbie"));

        assert_eq!(None, optional(""));
    }
}
