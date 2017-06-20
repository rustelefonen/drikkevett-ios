//
//  ResourceList.swift
//  Drikkevett
//
//  Created by Simen Fonnes on 27.07.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

struct ResourceList {
    static let genders = ["Mann", "Kvinne", "Annet"]
    static let counties = ["Akershus", "Aust-Agder", "Buskerud", "Finnmark", "Hedmark", "Hordaland", "Møre og Romsdal", "Nord-Trøndelag", "Nordland", "Oppland", "Oslo", "Rogaland", "Sogn og Fjordane", "Sør-Trøndelag", "Telemark", "Troms", "Vest-Agder", "Vestfold", "Østfold"]
    
    static let privacyMessage = "For å regne ut promille mest mulig nøyaktig, ber appen deg om å oppgi kjønn, alder og vekt. Ønsker du å opprette profilbilde behøver appen tilgang på kamera og galleri. Du kan velge å ikke gi appen tilgang til dette. All informasjon som lagres i appen krypteres på din telefon og vil ikke sendes videre. Dette gjelder alle versjoner i iOS og versjoner fra og med 5.0 (lollipop) i Android. Kildekoden til appen ligger åpen på Github under brukeren rustelefonen: https://github.com/rustelefonen."
    
    static let introBacInfos = ["Legg inn en langsiktig makspromille du ønsker å holde deg under frem til en ønsket dato. \n\nMakspromillen tilsvarer et nivå av promille du ikke vil overstige i løpet av EN kveld.", "En promille der de fleste vil fremstå som normale.", "En promille der de fleste vil fremstå som normale.\n\nDu kan føle velbehag, bli pratsom og bli mer avslappet.", "Denne promillen tilsvarer det man kaller lykkepromille!\n\nDu føler velbehag, blir mer pratsom og har redusert hemning.", "Balansen vil bli svekket.", "Talen blir snøvlete og kontrollen på bevegelser forverres.", "Man blir trøtt sløv og kan bli kvalm.", "Hukommelsen sliter og man kan bli bevisstløs."]
}
