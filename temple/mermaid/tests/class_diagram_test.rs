use mermaid::class_diagram::{Association, Attribute, AttributeKind, Class, ClassDiagram};

fn manifest_dir() -> String {
    std::env::var("CARGO_MANIFEST_DIR").unwrap()
}

fn resources_dir() -> String {
    "tests/resources/class_diagram".to_string()
}

fn diagram_code(file_name: &str) -> String {
    let path = format!("{}/{}/{file_name}", manifest_dir(), resources_dir());

    std::fs::read_to_string(path).unwrap()
}

#[test]
fn it_generates_class_diagram_with_classes_and_associations() {
    let class_diagram = ClassDiagram {
        associations: &[Association {
            class_name: "Book",
            associated_class_name: "Author",
            description: Some("Belongs to Author"),
        }],
        classes: &[
            Class {
                name: "Book",
                attributes: &[
                    Attribute {
                        kind: AttributeKind::String,
                        name: "title",
                    },
                    Attribute {
                        kind: AttributeKind::Integer,
                        name: "year",
                    },
                    Attribute {
                        kind: AttributeKind::Boolean,
                        name: "is_new",
                    },
                ],
            },
            Class {
                name: "Author",
                attributes: &[
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
                        kind: AttributeKind::Boolean,
                        name: "is_bestseller",
                    },
                ],
            },
        ],
    };

    assert_eq!(class_diagram.generate(), diagram_code("book_full.mermaid"));
}

#[test]
fn it_generates_class_diagram_with_classes_only() {
    let class_diagram = ClassDiagram {
        associations: &[],
        classes: &[
            Class {
                name: "Book",
                attributes: &[
                    Attribute {
                        kind: AttributeKind::String,
                        name: "title",
                    },
                    Attribute {
                        kind: AttributeKind::Integer,
                        name: "year",
                    },
                    Attribute {
                        kind: AttributeKind::Boolean,
                        name: "is_new",
                    },
                ],
            },
            Class {
                name: "Author",
                attributes: &[
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
                        kind: AttributeKind::Boolean,
                        name: "is_bestseller",
                    },
                ],
            },
        ],
    };

    assert_eq!(
        class_diagram.generate(),
        diagram_code("book_classes.mermaid")
    );
}

#[test]
fn it_generates_class_diagram_with_associations_only() {
    let class_diagram = ClassDiagram {
        associations: &[Association {
            class_name: "Book",
            associated_class_name: "Author",
            description: Some("Belongs to Author"),
        }],
        classes: &[],
    };

    assert_eq!(
        class_diagram.generate(),
        diagram_code("book_associations.mermaid")
    );
}
