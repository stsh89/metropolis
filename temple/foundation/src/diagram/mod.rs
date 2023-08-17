use crate::model;

pub struct ModelClass<'a> {
    pub model: &'a model::Model,
    pub attributes: &'a [model::Attribute],
    pub associations: &'a [model::Association],
}

pub fn project_class_diagram(project_class: Vec<ModelClass>) -> String {
    let diagram_associations = project_class
        .iter()
        .flat_map(|model_class| {
            model_class
                .associations
                .iter()
                .map(|association| to_diagram_association(model_class.model, association))
                .collect::<Vec<mermaid::class_diagram::Association>>()
        })
        .collect::<Vec<mermaid::class_diagram::Association>>();

    let diagram_class_attributes = project_class
        .iter()
        .map(|model_class| {
            let diagram_class_attributes = model_class
                .attributes
                .iter()
                .map(to_diagram_class_attribute)
                .collect::<Vec<mermaid::class_diagram::Attribute>>();

            (model_class.model.name.as_str(), diagram_class_attributes)
        })
        .collect::<Vec<(&str, Vec<mermaid::class_diagram::Attribute>)>>();

    let diagram_classes = diagram_class_attributes
        .iter()
        .map(|(name, attributes)| mermaid::class_diagram::Class {
            name,
            attributes: attributes.as_slice(),
        })
        .collect::<Vec<mermaid::class_diagram::Class>>();

    mermaid::class_diagram::ClassDiagram {
        associations: diagram_associations.as_slice(),
        classes: diagram_classes.as_slice(),
    }
    .generate()
}

pub fn model_class_diagram(model_class: ModelClass) -> String {
    let ModelClass {
        model,
        attributes,
        associations,
    } = model_class;

    let diagram_associations = associations
        .iter()
        .map(|association| to_diagram_association(model, association))
        .collect::<Vec<mermaid::class_diagram::Association>>();

    let diagram_class_attributes = attributes
        .iter()
        .map(to_diagram_class_attribute)
        .collect::<Vec<mermaid::class_diagram::Attribute>>();

    mermaid::class_diagram::ClassDiagram {
        associations: diagram_associations.as_slice(),
        classes: &[mermaid::class_diagram::Class {
            name: &model.name,
            attributes: diagram_class_attributes.as_slice(),
        }],
    }
    .generate()
}

fn to_diagram_association<'a>(
    model: &'a model::Model,
    association: &'a model::Association,
) -> mermaid::class_diagram::Association<'a> {
    mermaid::class_diagram::Association {
        class_name: &model.name,
        associated_class_name: &association.model.name,
        description: association.description.as_deref(),
    }
}

fn to_diagram_class_attribute(
    attribute: &model::Attribute,
) -> mermaid::class_diagram::Attribute<'_> {
    mermaid::class_diagram::Attribute {
        kind: to_diagram_attribute_kind(&attribute.kind),
        name: &attribute.name,
    }
}

fn to_diagram_attribute_kind(kind: &model::AttributeKind) -> mermaid::class_diagram::AttributeKind {
    match kind {
        model::AttributeKind::String => mermaid::class_diagram::AttributeKind::String,
        model::AttributeKind::Int64 => mermaid::class_diagram::AttributeKind::Integer,
        model::AttributeKind::Bool => mermaid::class_diagram::AttributeKind::Boolean,
    }
}
