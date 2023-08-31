pub struct ClassDiagram<'a> {
    pub classes: &'a [Class<'a>],
    pub associations: &'a [Association<'a>],
}

pub struct Class<'a> {
    pub name: &'a str,
    pub attributes: &'a [Attribute<'a>],
}

pub struct Attribute<'a> {
    pub kind: &'a str,
    pub name: &'a str,
}

pub struct Association<'a> {
    pub class_name: &'a str,
    pub associated_class_name: &'a str,
    pub description: Option<&'a str>,
}

impl<'a> ClassDiagram<'a> {
    pub fn generate(&self) -> String {
        let ClassDiagram {
            classes,
            associations,
        } = self;

        let code = "classDiagram".to_string();

        let code = if classes.is_empty() {
            code
        } else {
            format!("{code}\n{}\n", self.classes_diagram_code())
        };

        if associations.is_empty() {
            code
        } else {
            format!("{code}\n{}\n", self.associations_diagram_code())
        }
    }

    fn classes_diagram_code(&self) -> String {
        self.classes
            .iter()
            .map(|class| class.generate())
            .collect::<Vec<String>>()
            .join("\n")
    }

    fn associations_diagram_code(&self) -> String {
        self.associations
            .iter()
            .map(|association| association.generate())
            .collect::<Vec<String>>()
            .join("\n")
    }
}

impl<'a> Class<'a> {
    fn generate(&self) -> String {
        let attributes_string = self
            .attributes
            .iter()
            .map(|attribute| {
                let Attribute { kind, name } = attribute;

                format!("        +{kind} {name}")
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

impl<'a> Association<'a> {
    fn generate(&self) -> String {
        let Association {
            class_name,
            associated_class_name,
            description,
        } = self;

        let code = format!("    {class_name} --> {associated_class_name}");

        let Some(description) = description else  {
            return code;
        };

        format!("{code} : {description}")
    }
}
