Object subclass: Location [
    | name paths animals items|

    Location class >> new [
        | l |
        l := super new.
        ^l
    ]

    init: locName [
        name := locName.
        items := Set new.
        paths := Dictionary new.
        animals := Set new.
    ]

    printLines: lines [
        lines do: [ :string | Transcript show: string; cr.]
    ]

    setPaths: locPaths [
        paths := locPaths
    ]

    setAnimals: locAnimals [
        animals := locAnimals
    ]

    addAnimal: locAnimal [
        animals add: locAnimal
    ]

    deleteAnimal: locAnimal [
        animals remove: locAnimal
    ]

    setItems: locItems [
        items := locItems
    ]

    deleteItem: locItem [
        items remove: locItem
    ]

    addItem: locItem [
        items add: locItem
    ]
    
    getName [
        ^name
    ]

    getPaths [
        ^paths
    ]

    getAnimals [
        ^animals
    ]

    getItems [
        ^items
    ]
]
