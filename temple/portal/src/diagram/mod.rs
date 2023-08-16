use foundation::model::{Attribute, Model};

pub fn model_class_diagram(model: &Model, model_attributes: &[Attribute]) -> String {
    mermaid::class_diagram::ClassDiagram {
        classes: vec![mermaid::class_diagram::Class {
            name: &model.name,
            attributes: model_attributes
                .iter()
                .map(|attribute| mermaid::class_diagram::Attribute {
                    kind: match attribute.kind {
                        foundation::model::AttributeKind::String => {
                            mermaid::class_diagram::AttributeKind::String
                        }
                        foundation::model::AttributeKind::Int64 => {
                            mermaid::class_diagram::AttributeKind::Integer
                        }
                        foundation::model::AttributeKind::Bool => {
                            mermaid::class_diagram::AttributeKind::Bool
                        }
                    },
                    name: &attribute.name,
                })
                .collect(),
        }],
    }
    .generate()
}
