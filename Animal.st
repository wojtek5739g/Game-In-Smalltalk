Object subclass: Animal [
    | name isHappy atLocation messages hiddenKnowledge|

    Animal class >> new [
        | A |
        A := super new.
        ^A
    ]

    init: aniName[
        name := aniName.
        isHappy := false.
        messages := Dictionary new.
        hiddenKnowledge := Dictionary new.
    ]
    
    printLines: lines [
        lines do: [ :string | Transcript show: string; cr.]
    ]

    printDictionaries: dict [
        dict keysAndValuesDo: [:key :value |
            value = '' ifFalse:[
                Transcript show: key printString, ': ', value printString; cr. 
            ].
        ].
        Transcript show: ' '; cr.
    ]

    printMap: locations [
        locations keysAndValuesDo: [:locationKey :locationValue |
            Transcript show: locationKey printString, ': '; cr. 
                locationValue getPaths keysAndValuesDo: [:key :value | 
                    Transcript show: key printString, ' -> ', value printString; cr.
            ].
        ].
    ]

    setLocation: aniLocation[
        atLocation := aniLocation
    ]

    setMessages: aniMessages[
        messages := aniMessages
    ]

    setHiddenKnowledge: aniHiddenKnowledge[
        hiddenKnowledge := aniHiddenKnowledge
    ]

    makeHappy [
        isHappy := true.
        self printLines: {name, ': teraz jestem szczesliwy/a!'}.
    ]

    getName [
        ^name
    ]

    ifHappy [
        ^isHappy
    ]

    getLocation [
        ^atLocation
    ]

    getMessages [
        ^messages
    ]

    getMessage: index [
        ^(messages at: index)
    ] 

    talkTo [
        | mess |
        name = 'Malenstwo' ifTrue: [
            atLocation = 'dom_Puchatka' ifTrue: [
                mess := self getMessage: 1.
                self setLocation: 'dom_Klapouchego'.
                self printLines:  mess.
                ^self.
            ].
            atLocation = 'dom_Klapouchego' ifTrue: [
                mess := self getMessage: 2.
                self setLocation: 'dom_Krzysia'.
                self printLines:  mess.
                ^self.
            ].
            atLocation = 'dom_Krzysia' ifTrue: [
                mess := self getMessage: 3.
                self setLocation: 'dom_Sowy'.
                self printLines:  mess.
                ^self.
            ].
            atLocation = 'dom_Sowy' ifTrue: [
                mess := self getMessage: 4.
                self setLocation: 'dom_Kangurzycy'.
                self printLines:  mess.
                ^self.
            ].
            atLocation = 'dom_Kangurzycy' ifTrue: [
                mess := self getMessage: 5.
                self printLines:  mess.
                ^self.
            ].
            
            ^self.
        ].
        isHappy ifTrue: [
            mess := self getMessage: 2.
            self printLines: mess.    
        ]
        ifFalse: [
            mess := self getMessage: 1.
            self printLines: mess.
        ].
    ]

    talkTo: topic [
        name = 'Sowa' ifTrue: [
            | items friends places |
            items := hiddenKnowledge at: 'przedmioty'.
            friends := hiddenKnowledge at: 'przyjaciele'.
            places := hiddenKnowledge at: 'miejsca'.

            ((items keys) includes: topic) ifTrue: [
                | place |
                place := ((items at: topic) getLocation).
                self printLines: {topic, ' jest w: ', place}.
                ^self.
            ].
            ((friends keys) includes: topic) ifTrue: [
                | place |
                place := ((friends at: topic) getLocation).
                self printLines: {topic, ' jest w: ', place}.
                ^self.
            ].
            ((places keys) includes: topic) ifTrue: [
                self printLines: {'Do ', topic, ' mozesz dostac sie z: '}.
                self printDictionaries: (places at: topic) getPaths.
                ^self.
            ].
            topic = 'przedmioty' ifTrue: [
                self printLines: #('Widzialem takie przedmioty w Stumilowym lesie: ').
                self printDictionaries: items.
                ^self.
            ].
            topic = 'przyjaciele' ifTrue: [
                self printLines: #('W okolicy mieszkaja: ').
                self printDictionaries: friends.
                ^self.
            ].
            topic = 'miejsca' ifTrue: [
                self printLines: #('W Stumilowym Lesie mozesz odwiedzic te miejsca: ').
                self printLines: places keys.
                ^self.
            ].
            self printLines: #('Hmmm, nic mi na ten temat nie wiadomo').
        ]
        ifFalse: [
            self printLines: #('Jesli chcesz porozmawiac na jakis temat, to lepiej zapytaj Pana Sowe' 
                                'Jesli ktokolwiek wie cokolwiek o czymkolwiek, to tylko Sowa.').
            self printLines: {'Albo nie jestem ', name, '. A przeciez jestem.'}.
        ].
    ]

    askToJoin: playerLoc [
        atLocation = playerLoc 
            ifTrue: [
                isHappy = true 
                        ifTrue: [
                                self printLines: {name, ' zgodzil sie do Ciebie dolaczyc!'}.
                                ^true
                            ]
                        ifFalse: [
                                self printLines: #('Jestem zbyt smutny/a, aby do Ciebie dolaczyc!')
                            ].
            ]
            ifFalse: [
                self printLines: #('Mnie tu nie ma! Krzysiu, poszukaj, gdzie indziej gluptasku!' '')
            ].
        ^false
    ]
]