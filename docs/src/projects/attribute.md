# ModelAttribute

## Model
```mermaid
classDiagram
    class Attribute{
        +String description
        +String name
        +String kind
    }
```

## Record

```mermaid
erDiagram
    Attribute {
        uuid id
        uuid model_id
        varchar description
        varchar kind
        varchar name
        timestamp inserted_at
        timestamp updated_at
    }
```

## Use cases
```mermaid
flowchart LR
    U((User))

    U --> A1(Add attribute to Model)
    U --> A2(Delete the attribute)
```
