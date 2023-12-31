fn main() -> Result<(), Box<dyn std::error::Error>> {
    compile_proto_temple_v1()?;
    compile_proto_gymnasium_v1()?;

    Ok(())
}

fn compile_proto_gymnasium_v1() -> Result<(), Box<dyn std::error::Error>> {
    let files = vec![
        "projects/projects.proto",
        "models/models.proto",
        "attribute_types/attribute_types.proto",
    ];

    let protos: Vec<String> = files
        .iter()
        .map(|file| format!("../../protobuf/proto/gymnasium/v1/{file}"))
        .collect();

    dbg!(&protos);

    tonic_build::configure().compile(&protos, &["../../protobuf"])?;

    Ok(())
}

fn compile_proto_temple_v1() -> Result<(), Box<dyn std::error::Error>> {
    let files = vec!["projects.proto", "attribute_types/attribute_types.proto"];

    let protos: Vec<String> = files
        .iter()
        .map(|file| format!("../../protobuf/proto/temple/v1/{file}"))
        .collect();

    dbg!(&protos);

    tonic_build::configure().compile(&protos, &["../../protobuf"])?;

    Ok(())
}
