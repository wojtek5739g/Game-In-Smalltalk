Object subclass: Player [
    | name currentLocation joinedCharacters inventory |

    Player class >> new [
        | P |
        P := super new.
        ^P
    ]

    init: playerName[
        name := playerName.
        joinedCharacters := Set new.
        inventory := Set new.
    ]

    printLines: lines [
        lines do: [ :string | Transcript show: string; cr.]
    ]

    setCurrentLocation: currLoc [
        currentLocation := currLoc
    ]

    joinCharacter: animalName [
        joinedCharacters add: animalName
    ]

    addToInventory: itemName [
        inventory add: itemName 
    ]

    removeFromInventory: itemName [
        inventory remove: itemName
    ]

    getName [
        ^name
    ]

    getCurrentLocation [
        ^currentLocation
    ]

    getJoinedCharacters [
        ^joinedCharacters
    ]

    getInventory [
        ^inventory
    ]

    seeCurrentLocation [
        Transcript show: currentLocation; cr.
    ]

    seeJoinedCharacters [
        self printLines: joinedCharacters.
    ]

    seeInventory [
        (inventory size) = 0 
            ifTrue: [
                self printLines: #('Nie posiadasz zadnych przedmiotow')
            ]
            ifFalse: [
                self printLines: {'Posiadasz nastepujace przedmioty: '}.
                self printLines: inventory.
            ].
    ]

]