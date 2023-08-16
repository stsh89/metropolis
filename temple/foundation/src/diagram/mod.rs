use crate::model;

pub fn model_class_diagram(model: &model::Model, model_attributes: &[model::Attribute]) -> String {
    mermaid::class_diagram::ClassDiagram {
        classes: vec![mermaid::class_diagram::Class {
            name: &model.name,
            attributes: model_attributes
                .iter()
                .map(|attribute| mermaid::class_diagram::Attribute {
                    kind: match attribute.kind {
                        model::AttributeKind::String => {
                            mermaid::class_diagram::AttributeKind::String
                        }
                        model::AttributeKind::Int64 => {
                            mermaid::class_diagram::AttributeKind::Integer
                        }
                        model::AttributeKind::Bool => mermaid::class_diagram::AttributeKind::Bool,
                    },
                    name: &attribute.name,
                })
                .collect(),
        }],
    }
    .generate()
}
