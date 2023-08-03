fn main() -> Result<(), Box<dyn std::error::Error>> {
    compile_proto_gymnasium()?;
    compile_proto_temple()?;

    Ok(())
}

fn compile_proto_gymnasium() -> Result<(), Box<dyn std::error::Error>> {
    let files = vec!["dimensions.proto", "dimensions/project.proto"];

    let protos: Vec<String> = files
        .iter()
        .map(|file| format!("../protobuf/proto/gymnasium/v1/{file}"))
        .collect();

    dbg!(&protos);

    tonic_build::configure().compile(&protos, &["../protobuf"])?;

    Ok(())
}

fn compile_proto_temple() -> Result<(), Box<dyn std::error::Error>> {
    let files = vec!["projects.proto", "temple.proto"];

    let protos: Vec<String> = files
        .iter()
        .map(|file| format!("../protobuf/proto/temple/v1/{file}"))
        .collect();

    tonic_build::configure().compile(&protos, &["../protobuf"])?;

    Ok(())
}
