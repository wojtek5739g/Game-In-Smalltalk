Object subclass: Item [
    | name atLocation owner |

    Item class >> new [
        | it |
        it := super new.
        ^it
    ]

    init: itemName[
        name := itemName.
        atLocation := ' '.
        owner := ' '.
    ]

    setLocation: itLoc [
        atLocation := itLoc
    ]

    setOwner: itOwn [
        owner := itOwn
    ]

    getLocation [
        ^atLocation
    ]

    getOwner [
        ^owner
    ]

]