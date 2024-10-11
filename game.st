"The germ of a text adventure game
Marcin Szlenk 2022"

"Game class

Responsibilities:
* print/read outputs/inputs
* handle game loop
* handle 'instructions' and 'halt' commands

Collaborators:
* ..."

Object subclass: Game [
    | isGameOver domPuchatkaZamkniety locations animals items player locationsNames animalsNames itemsNames|

    introductionText := #(
        'Witaj w Stumilowym lesie!'
        ''
        'Budzisz sie jako Krzys w swoim lesnym domku. Dzien zaczyna sie dosc zwyczajnie.'
        ''
        'Jak zwykle rano wstajesz i idziesz na dol pozmywac naczynia po poznej kolacji'
        'z Prosiaczkiem, Sowa, Krolikiem i Puchatkiem, na ktorej ci dwaj ostatni poklocili'
        'sie o lyzke miodu. "Co za urwisy". Mowisz w myslach. W momencie, gdy zasiadasz'
        'do stolu, zeby zrobic sobie jakas kanapke i zaparzyc herbate, slyszysz pukajacego'
        'do drzwi Krolika, krzyczacego wnieboglosy, abys natychmiast otworzyl drzwi.'
        'Cos sie stalo. NIe wiesz, o co moze chodzic, ale masz zle przeczucia.'
        ''
        'Od razu z nim idziesz, zeby zobaczyc co sie stalo z Puchatkiem.'
        ''
    ).

    instructionsText := #(
        'Dostepne komendy to:'
        'n | s | e | w              -- idz w danym kierunku.'
        'wez Przedmiot              -- podnies przedmiot.'
        'upusc Przedmiot            -- upusc przedmiot.'
        'uzyj Przedmiot             -- uzyj przedmiotu.'
        'wyciagnij                  -- sprobuj wyciagnac Puchatka.'
        'rozmawiaj Zwierzak         -- sprawdz, co zwierzak ma do powiedzenia.'
        'rozmawiaj Zwierzak Temat   -- porozmawiaj ze zwierzakiem na wybrany temat.'
        'dolacz Zwierzak            -- zaproponuj postaci dolaczenie do druzyny pomagajacej wyciagnac Puchatka.'
        'rozejrzyj                  -- rozejrzyj sie.'
        'ekwipunek                  -- sprawdz, jakie przedmioty masz przy sobie.'
        'postacie                   -- sprawdz, ktore postacie dolaczyly do druzyny pomagajacej wyciagnac Puchatka.'
        'instrukcje                 -- zobacz instrukcje.'
        'koniec                     -- zakoncz gre i wyjdz.'
        ''
    ).
 
    Game class >> new [
        | g |
        g := super new.
        g init.
        ^g
    ]

    init [
        | hiddenKnowledge |
        isGameOver := false.
        domPuchatkaZamkniety := true.
        locations := Dictionary new.
        animals := Dictionary new.
        items := Dictionary new.

        player := Player new init: 'Krzys'.
        player setCurrentLocation: 'dom_Krzysia'.


        animalsNames := #('Prosiaczek' 'Kangurzyca' 'Krolik' 'Puchatek' 'Burek' 'Sowa' 'Klapouchy' 'Malenstwo').
        locationsNames := #('dom_Prosiaczka' 'dom_Krolika' 'dom_Kangurzycy' 'dom_Sowy' 'na_rozdrozu' 'dom_Klapouchego' 'dom_Puchatka' 'Szesc_Sosen' 'dom_Krzysia').
        itemsNames := #('ogon' 'kosc' 'pusty_balonik' 'sznurek' 'klucz').

        "Dodawanie przedmiotow wraz z ich nazwa, lokalizacja i/lub posiadaczem"
        1 to: itemsNames size do: [:i |
            | item_temp location_temp owner_temp |

            (itemsNames at: i) = 'ogon' ifTrue: [
                location_temp := 'dom_Kangurzycy'.
                ].
            (itemsNames at: i) = 'pusty_balonik' ifTrue: [
                location_temp := 'dom_Krolika'.
                ].
            (itemsNames at: i) = 'sznurek' ifTrue: [
                location_temp := 'dom_Krolika'.
                ].
            (itemsNames at: i) = 'kosc' ifTrue: [
                location_temp := 'na_rozdrozu'.
                ].
            (itemsNames at: i) = 'balonik' ifTrue: [
                location_temp := 'dom_Sowy'.
                ].
            (itemsNames at: i) = 'klucz' ifTrue: [
                location_temp := 'dom_Klapouchego'.
                owner_temp := 'Puchatek'.
                ].

            item_temp := Item new init: (itemsNames at: i); setLocation: location_temp; setOwner: owner_temp.
            items at: (itemsNames at: i) put: item_temp.
        ].

        self printDictionaries: items dictName: 'items'.


        "Dodawanie zwierzakow wraz z ich imieniemn, humorem, miejscem i odpowiedzami"
        1 to: animalsNames size do: [:i |
            | location_temp messages_temp animal_temp |
            messages_temp := Dictionary new.

            (animalsNames at: i) = 'Prosiaczek' ifTrue: [
                location_temp := 'dom_Prosiaczka'.
                messages_temp at: 1 put: #('Milo Cie widziec, Krzysiu' 
                                    'Mam problem z pszczolami nad moim domem'
                                    'Musimy cos z nimi zrobic, tylko jak sie tam dostac.'
                                    'Pamietam jak Puchatek uniosl sie za pomoca balonika. '
                                    'Moze mi tez sie uda - pomyslales.'
                                    );
                        at: 2 put: #('Dziekuje za pomoc, Krzysiu.').
                ].
            (animalsNames at: i) = 'Kangurzyca' ifTrue: [
                location_temp := 'dom_Kangurzycy'.
                messages_temp at: 1 put: #('Dzien dobry, Krzysiu' 
                                    'Czekam na Malenstwo, zeby podac mu obiad.'
                                    'Jesli je zobaczysz, powiesz mu, zeby wrocilo?'
                                    );
                        at: 2 put: #('Czesc Krzysiu!'
                                    'Malenstwo mi mowilo, ze razem sie pobawiliscie.'
                                    'Jest tak zmeczone, ze jak tylko zjadlo, to polozylo sie spac.'
                                    ).
                ].
            (animalsNames at: i) = 'Krolik' ifTrue: [
                location_temp := 'dom_Krolika'.
                messages_temp at: 1 put: #('NATYCHMIAST ZROB COS Z TYM TLUSCIOCHEM, UTKNAL W MOIM DRZEWIE!'
                                        'ZJADL MI MOJE CALE ZAPASY MIODU I TERAZ NIE MOZE SIE PRZECISNAC!'
                                    );
                        at: 2 put: #('Nastepnym razem pilnuj bardziej tego swojego misia.').
                ].
            (animalsNames at: i) = 'Puchatek' ifTrue: [
                location_temp := 'dom_Krolika'.
                messages_temp at: 1 put: #('Ratunku, nie moge sie uwolnic!' 
                                    );
                        at: 2 put: #('Dziekuje, ze mnie uratowales, bede Ci wdzieczny do konca zycia, przyjacielu');
                        at: 3 put: #('Ach pewnie, oto klucz do furtki. Jak ja otworzysz, zostaw go u mnie w domu.');
                        at: 4 put: #('Przeciez ja juz go Tobie dalem. Nie mow, ze go zgubiles!').
                ].
            (animalsNames at: i) = 'Burek' ifTrue: [
                location_temp := 'na_rozdrozu'.
                messages_temp at: 1 put: #('Grrrrrrrrrrrr...'
                                        'Burku, gdzie zgubiles Tosie? Czemu tak warczysz? Burku! - powiedziales do pieska');
                        at: 2 put: #('Hau! Hau!' 
                                    'Dobry piesek - pomyslales.').
                ].
            (animalsNames at: i) = 'Sowa' ifTrue: [
                location_temp := 'dom_Sowy'.
                messages_temp at: 1 put: #('Milo Cie widziec, Krzysiu. Piekny mamy dzis dzien.' 
                                    'Jestem bardzo madra Sowa, wiec jak chcesz sie czego dowiedziec, to pytaj smialo.'
                                    'Moge ci opowiedziec o przedmiotach, przyjaciolach oraz miejsach w Stumilowym Lesie.'
                                    ).
                ].
            (animalsNames at: i) = 'Klapouchy' ifTrue: [
                location_temp := 'dom_Klapouchego'.
                messages_temp at: 1 put: #('Dlaczego... - zastanawia sie pod nosem Klapouchy.' 
                                    'Jak sie masz? - pytasz osiolka.'
                                    'Nie bardzo sie mam - odpowiedzial Klapouchy. - Juz nie pamietam czasow, zebym jakos sie mial.'
                                    'Ale jestem zmeczony... Zgubilem moj ogon.'
                                    'Pomoge go tobie znalezc! - odpowiedziales ochoczo.'
                                    'Na co?... I po co?... - Klapouchy wrocil do rozmyslan.'
                                    );
                        at: 2 put: #('Witaj, przyjacielu.');
                        at: 3 put: #(' ').
                ].
            (animalsNames at: i) = 'Malenstwo' ifTrue: [
                location_temp := 'dom_Puchatka'.
                messages_temp at: 1 put: #('O, Krzysiu! Chcialem sie pobawic z Puchatkiem w chowanego, ale go nie ma.' 
                                    'Moze ty sie ze mna pobawisz? Bardzo, bardzo, bardzo, bardzo prosze!'
                                    'Dobrze, ale szybko. Musisz wracac do domu.'
                                    'Malenstwo ucieszone ucieka, aby sie ukryc. '
                                    'Moze mi tez sie uda - pomyslales.'
                                    );
                        at: 2 put: #('Przechodzac obok ponurego zakatka Klapouchego zauwazasz nietypowa rzecz.'
                                    'Z szalasu z patykow, w ktorym mieszka osiolek, wystaja uszy malego kangurka.'
                                    'Widze cie - krzyknales.'
                                    'Malenstwo podskoczylo ze zdziwienia niszczac budowle z patykow i ucieklo dalej sie chowac.'
                                    'Nie martwcie sie moim domkiem - wzdechnal smutno Klapouchy - juz przyzwyczailem sie do jego odbudowywania.'
                                    );
                        at: 3 put: #('Widzisz Malenstwo probujace otworzyc drzwi do twojego domu'
                                    'Zapomniales, ze zawsze zamykam drzwi jak wychodze? - stwierdzasz ze zdziwieniem.'
                                    'No wiem, ale nie mialem czasu sie schowac. Mozemy ostatni raz?'
                                    'Dobrze. Policze do 10, a ty sie chowaj. Raz, dwa, trzy, cztery...'
                                    'Otwierasz oczy i Malenstwa juz nie ma.'
                                    );
                        at: 4 put: #('Jestes w ostatnim miejscu, jakie zostalo ci do przeszukania, ale Malenstwa nigdzie nie widac.'
                                    'Sowa usmiecha sie do ciebie ze swojego domu, wskazujac skrzydlem w gore.'
                                    'Malenstwo buja sie na galezi nad domkiem Sowy smiejac sie przy tym.'
                                    'Mam cie - mowisz - pora wracac do domu. Zejdz, zanim sobie cos zrobisz.'
                                    'Spokojnie. Tygrysek mnie nauczyl, jak brykac. Ale jestem juz zmeczony. Wracam do domu.');
                        at: 5 put: #('Malenstwo teraz spi, nie bede go budzic.').
                ].
        
            animal_temp := Animal new init: (animalsNames at: i); setLocation: location_temp; setMessages: messages_temp.
            animals at: (animalsNames at: i) put: animal_temp.
        ].

        self printDictionaries: animals dictName: 'animals'.

        "Dodawanie lokacji wraz z ich przedmiotami, ścieżkami i postaciami"
        1 to: locationsNames size do: [:i | 
            | location_temp animals_temp paths_temp items_temp |

            paths_temp := Dictionary new.
            items_temp := Set new.
            animals_temp := Set new.
            (locationsNames at: i) = 'dom_Prosiaczka' ifTrue: [
                paths_temp at: 's' put: ''; at: 'w' put: ''; at: 'n' put: 'Szesc_Sosen'; at: 'e' put: 'dom_Sowy'.
                animals_temp addAll: #('Prosiaczek').
                ].
            (locationsNames at: i) = 'dom_Krolika' ifTrue: [
                paths_temp at: 's' put: 'dom_Sowy'; at: 'w' put: 'Szesc_Sosen'; at: 'n' put: ''; at: 'e' put: 'dom_Krzysia'.
                animals_temp addAll: #('Krolik' 'Puchatek').
                ].
            (locationsNames at: i) = 'dom_Kangurzycy' ifTrue: [
                paths_temp at: 's' put: 'Szesc_Sosen'; at: 'w' put: ''; at: 'n' put: ''; at: 'e' put: ''.
                items_temp add: 'ogon'.
                animals_temp addAll: #('Kangurzyca').
                ].
            (locationsNames at: i) = 'dom_Sowy' ifTrue: [
                paths_temp at: 's' put: ''; at: 'w' put: 'dom_Prosiaczka'; at: 'n' put: 'dom_Krolika'; at: 'e' put: 'dom_Klapouchego'.
                animals_temp addAll: #('Sowa').
                ].
            (locationsNames at: i) = 'na_rozdrozu' ifTrue: [
                paths_temp at: 's' put: 'dom_Klapouchego'; at: 'w' put: ''; at: 'n' put: 'dom_Krzysia'; at: 'e' put: ''.
                animals_temp addAll: #('Burek').
                ].
            (locationsNames at: i) = 'dom_Klapouchego' ifTrue: [
                paths_temp at: 's' put: ''; at: 'w' put: 'dom_Sowy'; at: 'n' put: 'na_rozdrozu'; at: 'e' put: ''.
                animals_temp addAll: #('Klapouchy').
                ].
            (locationsNames at: i) = 'dom_Puchatka' ifTrue: [
                paths_temp at: 's' put: ''; at: 'w' put: ''; at: 'n' put: ''; at: 'e' put: 'Szesc_Sosen'.
                items_temp add: 'pusty_balonik'.
                animals_temp addAll: #('Malenstwo').
                ].
            (locationsNames at: i) = 'Szesc_Sosen' ifTrue: [
                paths_temp at: 's' put: 'dom_Prosiaczka'; at: 'w' put: 'dom_Puchatka'; at: 'n' put: 'dom_Kangurzycy'; at: 'e' put: 'dom_Krolika'.
                items_temp add: 'kosc'.
                ].
            (locationsNames at: i) = 'dom_Krzysia' ifTrue: [
                paths_temp at: 's' put: 'na_rozdrozu'; at: 'w' put: 'dom_Krolika'; at: 'n' put: ''; at: 'e' put: ''.
                items_temp add: 'sznurek'.
                items_temp add: 'talerz'.
                ].

            location_temp := Location new init: (locationsNames at: i); setPaths: paths_temp; setItems: items_temp; setAnimals: animals_temp.
            locations at: (locationsNames at: i) put: location_temp.
        ].

        "dodanie specjalnej wiedzy Sowie"
        hiddenKnowledge := Dictionary new.

        hiddenKnowledge at: 'przedmioty' put: items.
        hiddenKnowledge at: 'przyjaciele' put: animals.
        hiddenKnowledge at: 'miejsca' put: locations.
        (animals at: 'Sowa') setHiddenKnowledge: hiddenKnowledge.

        self printMap.

        self printDescription.
    ]

    noticePlacesToGo [
        ((locations at: (player getCurrentLocation)) getPaths) keysAndValuesDo: [:direction :location |
            location = '' ifFalse: [
                Transcript show: 'Mozesz pojsc w kierunku ', direction printString, ' do ', location printString; cr].
            ]
    ]


    "Print strings from array in separate lines."
    printLines: lines [
        lines do: [ :string | Transcript show: string; cr.]
    ]

    printDictionaries: dict dictName: name [
        Transcript show: 'Wszystkie ', name , ' w grze: '; cr.
        dict keysAndValuesDo: [:key :value |
            Transcript show: key printString, ': ', value printString; cr. 
        ].
        Transcript show: ' '; cr.
    ]

    printMap [
        Transcript show: 'Mapa gry: '; cr.
        locations keysAndValuesDo: [:locationKey :locationValue |
            Transcript show: locationKey printString, ': '; cr. 
                locationValue getPaths keysAndValuesDo: [:key :value | 
                    Transcript show: key printString, ' -> ', value printString; cr.
            ].
        ].
    ]

    printDescription [
        | stringSet |
        Transcript show: ' '; cr.

        self printLines: {'Jestes w: ', player getCurrentLocation}.
        
        self noticePlacesToGo.
        Transcript show: ' '; cr.

        self printLines: #('Sa tu nastepujace przedmioty: ').
        stringSet := (locations at: player getCurrentLocation) getItems.
        self printLines: stringSet.
        Transcript show: ' '; cr.

        self printLines: #('Sa tu nastepujace postacie: ').
        stringSet := (locations at: player getCurrentLocation) getAnimals.
        self printLines: stringSet.
        Transcript show: ' '; cr.
    ]

    printIntroduction [
       self printLines: introductionText.
    ]

    printInstructions [
        self printLines: instructionsText.
    ]

    readCommand [
        Transcript show: '> '.
        ^ FileStream stdin nextLine
    ]

    checkCombine [
        ((player getInventory includes: 'sznurek') and: [(player getInventory) includes: 'pusty_balonik']) 
            ifTrue: [
                | item_temp |
                self printLines: #('Nadmuchales balonik i zwiazales go ze sznurkiem').
                player removeFromInventory: 'sznurek'.
                player removeFromInventory: 'pusty_balonik'.
                player addToInventory: 'balonik'.
                item_temp := Item new init: 'balonik'; setLocation: ' '; setOwner: player.
                items at: 'balonik' put: item_temp.
            ].
        ^self.
    ]
    "Run the game."
    run [
        | cmd isUnknown |

        self printIntroduction.
        self printInstructions.

        "Game loop."
        [isGameOver] whileFalse: [
            
            isUnknown := true.
            cmd := self readCommand.
            cmd := cmd substrings.
            ' ' displayNl.

            " debugowanie "
            cmd first = 'debug' ifTrue: [
                self printLines: cmd.
                cmd size displayNl.
                isUnknown = false
            ].


            (cmd first = 'w' or: [cmd first = 'e' or: [cmd first = 'n' or: [cmd first = 's']]]) ifTrue: [
                | temp |
                cmd size > 1 
                    ifTrue: [
                        self printLines: #('Ta komenda nie przyjmuje żadnych argumentów' '')
                    ].
                    " ifFalse: [
                        self printLines: {(cmd first). ''}
                    ]. "
                temp := ((locations at: player getCurrentLocation) getPaths) at: (cmd first).
                temp = '' 
                    ifTrue: [
                        self printLines: #('Nie mozesz tam przejsc!' '').
                    ]
                    ifFalse: [
                        temp = 'dom_Puchatka' 
                            ifTrue: 
                            [
                                domPuchatkaZamkniety 
                                    ifTrue: [
                                    ((player getInventory) includes: 'klucz') 
                                        ifTrue: [
                                            self printLines: #('Otworzyles furtke do domu Puchatka').
                                            player removeFromInventory: 'klucz'.
                                            domPuchatkaZamkniety := false.
                                            player setCurrentLocation: temp.
                                            self printDescription.
                                        ]
                                        ifFalse: [
                                            player setCurrentLocation: temp.
                                            self printLines: #('Wyglada na to, ze furtka jest zamknieta. Spytam Puchatka o klucz.').
                                        ].  
                                    ]
                                    ifFalse: [
                                        player setCurrentLocation: temp.
                                        self printDescription.
                                    ]
                            ]
                            ifFalse: [
                                player setCurrentLocation: temp.
                                self printDescription.   
                            ].
                    ].
                isUnknown := false
            ].

            cmd first = 'wez' ifTrue: [
                | locObj itemName |
                cmd size = 1
                    ifTrue: [
                        self printLines: #('Ale co takiego chcesz wziac?' '')
                    ]
                    ifFalse: [
                        cmd size = 2
                            ifTrue: [
                                itemName := cmd second. 
                                locObj := locations at: player getCurrentLocation.
                                ((locObj getItems) includes: itemName)
                                    ifTrue: [
                                        self printLines: { 'Podniosles ', itemName}.
                                        locObj deleteItem: itemName.
                                        player getInventory add: itemName.
                                        self checkCombine
                                    ] 
                                    ifFalse: [
                                        self printLines: #('Nie ma tutaj takiego przedmiotu...' ' ')
                                    ].
                            ]
                            ifFalse: [
                                self printLines: #('Komenda nie przyjmuje wiecej niz 1 argument!' ' ')
                            ].
                    ].
                isUnknown := false
            ]. 

            cmd first = 'upusc' ifTrue: [
                | locObj item |
                (player getInventory size < 1) ifTrue: [
                    self printLines: #('Masz pusty ekwipunek' '').
                    isUnknown := false
                ]
                ifFalse: [
                    cmd size = 1
                    ifTrue: [
                        self printLines: #('Ale co takiego chcesz upuscic?' '')
                    ]
                    ifFalse: [
                        cmd size = 2
                            ifTrue: [
                                item := cmd second. 
                                locObj := locations at: player getCurrentLocation.
                                (player getInventory includes: item)
                                    ifTrue: [
                                        self printLines: { 'Upusciles ', item}.
                                        locObj addItem: item.
                                        player getInventory remove: item.
                                    ] 
                                    ifFalse: [
                                        self printLines: #('Nie masz takiego przedmiotu...' '')
                                    ].
                            ]
                            ifFalse: [
                                self printLines: #('Komenda nie przyjmuje wiecej niz 1 argument!' '')
                            ].
                    ].
                    isUnknown := false
                ].
                
                isUnknown := false
            ].

            cmd first = 'uzyj' ifTrue: [
                | item |
                cmd size = 2 
                    ifTrue: [
                        item := cmd second.
                        (player getInventory includes: item) 
                            ifTrue: [
                                (item = 'ogon') 
                                    ifTrue: [
                                        player getCurrentLocation = 'dom_Klapouchego' 
                                            ifTrue: [ 
                                                self printLines: #('Dziekuje za pomoc w przypieciu ogona, Krzysiu.').
                                                player removeFromInventory: 'ogon'.
                                                (animals at: 'Klapouchy') makeHappy.
                                            ]
                                            ifFalse: [
                                                self printLines: #('Nie mozesz uzyc kosci w tym miejscu').
                                            ].
                                    ].
                                (item = 'sznurek') 
                                    ifTrue: [
                                        self printLines: #('Nie mozesz uzyc samego sznurka. Moze go wykorzystasz do czegos innego.').
                                    ].  
                                (item = 'pusty balonik') 
                                    ifTrue: [
                                        self printLines: #('Musze najpierw napompowac balonik i go czyms zwiazac.').
                                    ]. 
                                (item = 'balonik') 
                                    ifTrue: [
                                        player getCurrentLocation = 'dom_Prosiaczka' 
                                            ifTrue: [ 
                                                player removeFromInventory: 'balonik'.
                                                (animals at: 'Prosiaczek') makeHappy.
                                                self printLines: #('Lapiesz za sznurek od balonika i unosisz sie ponad dom Prosiaczka.'
                                                                    'Jestes na wysokosci pszczol. Jedna z nich zadli ciebie w nos.'
                                                                    'Reszta zaatakowala twoj balonik, ktory pekl'
                                                                    'Spadasz na ziemie, a pszczoly radosnie odlatuja w kierunku laki z kwiatami.'
                                                                    'Dziekuje, w koncu moge wyjsc z domu.').
                                            ]
                                            ifFalse: [
                                                self printLines: #('Nie mozesz uzyc balonika w tym miejscu').
                                            ]. 
                                    ].  
                                (item = 'kosc') 
                                    ifTrue: [
                                        (player getCurrentLocation = 'na_rozdrozu') ifTrue: [
                                            self printLines: #('Hau, hau, hau!' 'Burek radosne macha ogonem i lize kosc.').
                                            player removeFromInventory: 'kosc'.
                                            (animals at: 'Burek') makeHappy.
                                        ]
                                        ifFalse: [
                                            self printLines: #('Nie mozesz uzyc tutaj kosci.')
                                        ].    
                                    ].  
                                (item = 'klucz') 
                                    ifTrue: [
                                        self printLines: #('To klucz do furtki Puchatka').
                                    ].                           
                            ]
                            ifFalse: [
                                self printLines: #('Nie posidasz takiego przedmiotu w ekwipunku!' '')
                            ]. 
                    ]
                    ifFalse: [
                        self printLines: #('Komenda przyjmuje dokladnie jeden argument!' '')
                    ].
                isUnknown := false
            ].

            cmd first = 'wyciagnij' ifTrue: [
                cmd size = 2
                    ifTrue: [
                        (player getCurrentLocation = 'dom_Krolika') 
                            ifTrue: [
                                (animals at: 'Puchatek') ifHappy
                                    ifTrue: [
                                        self printLines: #('Puchatek zostal juz uratowany!' '')
                                    ]
                                    ifFalse: [
                                        (player getJoinedCharacters size) < 4 
                                            ifTrue: [
                                                self printLines: #('Musisz zebrac wiecej przyjaciol!' '').
                                            ]
                                            ifFalse: [
                                                self printLines: #('Udalo sie! Uratowaliscie Puchatka!' '').
                                                (animals at: 'Puchatek') makeHappy.
                                                (animals at: 'Krolik') makeHappy.
                                                (animals at: 'Puchatek') setLocation: 'dom_Puchatka'.
                                                (locations at: 'dom_Krolika') deleteAnimal: 'Puchatek'.
                                                (locations at: 'dom_Puchatka') addAnimal: 'Puchatek'.
                                            ].
                                    ].
                            ]
                            ifFalse: [
                                self printLines: #('Nie ma tu Puchatka!' '')
                            ].
                    ]
                    ifFalse: [
                        self printLines: #('Komenda przyjmuje dokladnie jeden argument!' '')
                    ].
                isUnknown := false
            ].

            cmd first = 'rozmawiaj' ifTrue: [
                | animalName |
                cmd size = 2 
                    ifTrue: [
                        animalName := cmd at: 2.
                        (animalsNames includes: animalName) ifTrue: 
                        [
                            ((animals at: animalName) getLocation = (player getCurrentLocation))
                            ifTrue: [
                                | loc |
                                loc := (animals at: 'Malenstwo') getLocation.
                                (animals at: animalName) talkTo.
                                (animalName = 'Malenstwo')
                                    ifTrue: [
                                        (loc = 'dom_Puchatka') 
                                        ifTrue: [
                                            (locations at: 'dom_Klapouchego') addAnimal: 'Malenstwo'.
                                            (locations at: 'dom_Puchatka') deleteAnimal: 'Malenstwo'.
                                        ].
                                        (loc = 'dom_Klapouchego') 
                                        ifTrue: [
                                            (locations at: 'dom_Krzysia') addAnimal: 'Malenstwo'.
                                            (locations at: 'dom_Klapouchego') deleteAnimal: 'Malenstwo'.
                                        ].
                                        (loc = 'dom_Krzysia') 
                                        ifTrue: [
                                            (locations at: 'dom_Sowy') addAnimal: 'Malenstwo'.
                                            (locations at: 'dom_Krzysia') deleteAnimal: 'Malenstwo'.
                                        ].
                                        (loc = 'dom_Sowy') 
                                        ifTrue: [
                                            (locations at: 'dom_Kangurzycy') addAnimal: 'Malenstwo'.
                                            (locations at: 'dom_Sowy') deleteAnimal: 'Malenstwo'.
                                            (animals at: 'Malenstwo') makeHappy.
                                            (animals at: 'Kangurzyca') makeHappy.
                                        ].
                                        (loc = 'dom_Kangurzycy')
                                        ifTrue: [
                                            (locations at: 'dom_Kangurzycy') addAnimal: 'Malenstwo'.
                                        ].
                                        
                                    ].
                            ]
                            ifFalse: [
                                self printLines: #('Nie ma mnie tutaj!' '')
                            ].
                            
                        ]
                        ifFalse: [
                                self printLines: #('Nie ma takiego zwierzaka!' '')
                        ].
                    ]
                    ifFalse: [
                        cmd size = 3
                            ifTrue: [
                                | topic |
                                animalName := cmd at: 2.
                                topic := cmd at: 3.
                                (animalsNames includes: animalName) 
                                ifTrue: 
                                [
                                    ((animals at: animalName) getLocation = player getCurrentLocation) 
                                        ifTrue: [
                                            topic = 'klucz' 
                                                ifTrue: 
                                                [
                                                    animalName = 'Puchatek' 
                                                        ifTrue: 
                                                        [
                                                            
                                                            (((player getInventory) size > 0) and: [((player getInventory) includes: 'klucz') = false])
                                                                ifTrue: [
                                                                    self printLines: #('Ach pewnie. Oto klucz do furtki. Jak ja otworzysz, zostaw go u mnie w domu').
                                                                    player addToInventory: 'klucz'.
                                                                    (items at: 'klucz') setOwner: ' '.
                                                                ]
                                                                ifFalse: [
                                                                    ((items at: 'klucz') getOwner = 'Puchatek') ifTrue:[
                                                                        self printLines: #('Ach pewnie. Oto klucz do furtki. Jak ja otworzysz, zostaw go u mnie w domu').
                                                                        player addToInventory: 'klucz'.
                                                                        (items at: 'klucz') setOwner: ' '.
                                                                    ]
                                                                    ifFalse:[
                                                                        self printLines: #('Przeciez juz go tobie dalem. Nie mow ze go zgubiles.').
                                                                    ].
                                                                    
                                                                ].
                                                        ]
                                                        ifFalse: [
                                                            self printLines: #('Ja nic nie wiem o zadnym kluczu! Zapytaj kogos innego.').
                                                        ].
                                                ]
                                                ifFalse: [
                                                    (animals at: animalName) talkTo: topic.
                                                ].
                                        ]
                                        ifFalse: [
                                            self printLines: #('Nie ma mnie tutaj!' '')
                                        ].
                                ]
                                ifFalse: [
                                    self printLines: #('Nie ma takiego zwierzaka!' '')
                                ].
                                
                            ]
                            ifFalse: [
                                self printLines: #('Błędne użycie komendy' '')
                            ].
                    ].
                isUnknown := false
            ].

            cmd first = 'dolacz' ifTrue: [
                | animalName animalObj response|

                cmd size = 2
                    ifTrue: [
                        animalName := (cmd second).
                        (animalsNames includes: animalName)
                            ifTrue: [
                                (player getJoinedCharacters includes: animalName)
                                    ifTrue: [
                                        self printLines: {animalName, ' juz do Ciebie dolaczyl/a'}
                                    ]
                                    ifFalse: [
                                        animalObj := (animals at: animalName).
                                        response := animalObj askToJoin: player getCurrentLocation.
                                        response ifTrue: [
                                            player getJoinedCharacters add: animalName.
                                        ].
                                    ].    
                            ]
                            ifFalse: [
                                self printLines: #('Nie ma takiej postaci!.' '')
                            ].
                    ]
                    ifFalse: [
                        self printLines: #('Komenda przyjmuje dokladnie jeden argument!' '')
                    ].
                isUnknown := false
            ].

            cmd first = 'rozejrzyj' ifTrue: [
                cmd size > 1
                    ifTrue: [
                        self printLines: #('Ta komenda nie przyjmuje zadnych argumentow' '')
                    ]
                    ifFalse: [
                        self printDescription
                    ].
                isUnknown := false
            ].

            
            cmd first = 'ekwipunek' ifTrue: [
                cmd size > 1 
                    ifTrue: [ 
                        self printLines: #('Ta komenda nie przyjmuje zadnych argumentow' '')
                    ]
                    ifFalse: [
                        player seeInventory.
                    ].
                isUnknown := false
            ].
            
            cmd first = 'postacie' ifTrue: [
                cmd size > 1
                    ifTrue: [
                        self printLines: #('Ta komenda nie przyjmuje zadnych argumentow' '')
                    ]
                    ifFalse: [
                        (player getJoinedCharacters size = 0)
                            ifTrue: [
                                self printLines: #('Nie dolaczyly do Ciebie jeszcze zadne postacie. ')
                            ]
                            ifFalse: [
                                self printLines: #('Postacie, ktore do Ciebie dolaczyly: ').
                                self printLines: player getJoinedCharacters.
                                Transcript show: ''; cr.
                            ].
                    ].
                isUnknown := false
            ].

            cmd first = 'instrukcje' ifTrue: [
                self printInstructions.
                isUnknown := false
            ].

            
            cmd first = 'koniec' ifTrue: [
                cmd size > 1 
                    ifTrue: [ 
                        self printLines: #('Ta komenda nie przyjmuje zadnych argumentow' '')
                    ]
                    ifFalse: [
                        isGameOver := true
                    ].

                    Transcript show: '   _'; cr.
                    Transcript show: ' _( )_'; cr.
                    Transcript show: '(     (o___'; cr.
                    Transcript show: ' |      _ 7'; cr.
                    Transcript show: '  \    (")'; cr.
                    Transcript show: '  /     \ \'; cr.
                    Transcript show: ' |    \ __/'; cr.
                    Transcript show: ' |        |'; cr.
                    Transcript show: ' (       /'; cr.
                    Transcript show: '  \     /'; cr.
                    Transcript show: '   )   /(_'; cr.
                    Transcript show: '   |  (___)'; cr.
                    Transcript show: '    \___)'; cr.

                isUnknown := false
            ].

            
            isUnknown ifTrue: [
                ' ' displayNl.
                ('Nieznana komenda ') displayNl. 
            ]
        ]
    ]
]

Game new run.
