# Project

## Presenter
```mermaid
classDiagram
    class Project {
        +Text name
        +Text description
        +DateTime create_timestamp
    }
```

## Model
```mermaid
classDiagram
    class Project{
        +Text name
        +Text description
        +DateTime created_at
    }
```

## Entity

```mermaid
erDiagram
    PROJECT {
        uuid id
        varchar name
        varchar description
        datetime inserted_at
    }
```

## Validations

* Name
    * contain any UTF-8 characters including emojies
    * unique within the list of projects
    * can not be empty
    * minimum 1 byte
    * maximum 1000 bytes
* Description
    * can contain any UTF-8 characters including emojies
    * can be empty
    * maximum 10000 bytes

## Use cases
```mermaid
flowchart LR
    U((User))

    U --> A1(Create a new project to design and document)
    U --> A2(Rename a Project)
    U --> A3(Change the description of the Project)
    U --> A4(Archive the Project)
    U --> A5(Remove archived Project)
    U --> A6(List showcased Projects)
    U --> A7(List archived Projects)
    U --> A8(Check Project details)
    U --> A9(Move a Project from the archive to the showcase)
```

Implementation progress:
* [ ] Create a new project to design and document
* [ ] Rename a Project
* [ ] Change the description of the Project
* [ ] Archive the Project
* [ ] Remove archived Project
* [ ] List showcased Projects
* [ ] List archived Projects
* [ ] Check Project details
* [ ] Move a Project from the archive to the showcase
