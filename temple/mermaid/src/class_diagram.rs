pub struct ClassDiagram<'a> {
    pub classes: Vec<Class<'a>>,
}

pub struct Class<'a> {
    pub name: &'a str,
    pub attributes: Vec<Attribute<'a>>,
}

pub struct Attribute<'a> {
    pub kind: AttributeKind,
    pub name: &'a str,
}

pub enum AttributeKind {
    String,
    Bool,
    Integer,
}

impl ToString for AttributeKind {
    fn to_string(&self) -> String {
        match self {
            AttributeKind::Bool => "Bool",
            AttributeKind::Integer => "Integer",
            AttributeKind::String => "String",
        }
        .to_string()
    }
}

impl<'a> ClassDiagram<'a> {
    pub fn generate(&self) -> String {
        let classes_string = self
            .classes
            .iter()
            .map(|class| class.generate())
            .collect::<Vec<String>>()
            .join("\n");

        format!(
            r#"
classDiagram
{}
"#,
            classes_string
        )
    }
}

impl<'a> Class<'a> {
    pub fn generate(&self) -> String {
        let attributes_string = self
            .attributes
            .iter()
            .map(|attribute| {
                let Attribute { kind, name } = attribute;

                format!("        +{} {name}", kind.to_string())
            })
            .collect::<Vec<String>>()
            .join("\n");

        format!(
            r#"    class {} {{
{}
    }}"#,
            self.name, attributes_string
        )
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn generates_mermaid_class_diagram() {
        let code = ClassDiagram {
            classes: vec![
                Class {
                    name: "Book",
                    attributes: vec![
                        Attribute {
                            kind: AttributeKind::String,
                            name: "title",
                        },
                        Attribute {
                            kind: AttributeKind::Integer,
                            name: "year",
                        },
                        Attribute {
                            kind: AttributeKind::Bool,
                            name: "is_new",
                        },
                    ],
                },
                Class {
                    name: "Author",
                    attributes: vec![
                        Attribute {
                            kind: AttributeKind::String,
                            name: "first_name",
                        },
                        Attribute {
                            kind: AttributeKind::String,
                            name: "last_name",
                        },
                        Attribute {
                            kind: AttributeKind::Integer,
                            name: "number_of_books",
                        },
                        Attribute {
                            kind: AttributeKind::Bool,
                            name: "is_bestseller",
                        },
                    ],
                },
            ],
        }
        .generate();

        assert_eq!(
            code,
            r#"
classDiagram
    class Book {
        +String title
        +Integer year
        +Bool is_new
    }
    class Author {
        +String first_name
        +String last_name
        +Integer number_of_books
        +Bool is_bestseller
    }
"#
        )
    }
}
