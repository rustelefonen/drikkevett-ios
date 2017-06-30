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
    
    //Info
    static let infoTitles = ["Trening", "Drikkevettreglene", "Psyken", "Utseende", "Sex", "RUStelefonen"]
    static let infoImages = ["Dumbbell-100", "Rules", "Brain-100", "Lips4", "Sex", "rustelefonenLOGO"]
    
    //Info categories
    static let exerciseTitles = ["Dårligere treningseffekt", "Redusert prestasjonsevne", "Påvirkning av hormoner"]
    static let exerciseImages = ["Dumbbell-100", "Time Trial Biking-100", "Peptide-100"]
    static let exerciseTexts = ["Alkohol kan virke negativt inn på treningsmålet ditt. Hvorfor? Belastningen under trening bryter muskulaturen ned, og hvileperioden etter treningen bruker musklene på å forberede seg på liknende påkjenninger senere («restitusjon»). \nResultatet er at du blir litt sterkere hver gang du trener. Når du drikker alkohol kan dette hemme nydannelse av glykogen og glykosefrigjøring fra leveren, en prosess som er viktig for å oppnå optimal restitusjon. \nHvis du starter med ny trening uten en god restitusjon, vil ikke muskulaturen ha klart å gjenoppbygge seg i mellomtiden. Alkohol kan derfor gi dårligere treningseffekt både på kort og lang sikt. ", "Drikker du alkohol etter trening, tar det lengre tid å erstatte væsketapet. Hvis kroppen ikke klarer å gjenopprette væskebalanse før du trener på nytt, vil det øke risikoen for dehydrering. Væsketap gir redusert prestasjonsevne blant annet grunnet dårligere blodgjennomstrømning til musklene og økt kroppstemperatur.", "Hvis du drikker relativt mye og jevnlig kan produksjonen av mannlig kjønnshormon, testosteron synke. Samtidig kan konsentrasjonen av stresshormonet kortisol øke. Denne kombinasjonen kan over tid medføre nedbrytning av muskelmasse og/eller forhindre at muskelmasse utvikles. Andre stresshormoner kan også øke; et symptom på dette er uregelmessig hjerterytme. "]
    
    static let psycheTitles = ["Sosialt Lim (Lykkepromille)", "Angst og depresjoner", "Reptilhjernen", "Blackout"]
    static let psycheImages = ["Good Quality-100", "Therapy-100", "Brain-100", "Dizzy Person 2-100"]
    static let psycheTexts = ["Det er ikke uvanlig å drikke litt i sosiale sammenhenger, for å slappe mer av og for hyggens skyld; det er ikke uten grunn at alkohol kalles et «sosialt lim». Alkohol er vanlig som sosialt lim. «Lykkepromillen» ligger på omkring 0.6 – 0.8.  Men når promillen overstiger et visst nivå (ca. 0,5) vil tanker og følelser endres og forsterkes, og sosiale ferdigheter avtar. Du risikerer å miste flere hemninger enn du i ettertid vil være komfortabel med.", "Det er ikke uvanlig å drikke litt alkohol for å lette litt på vanskelige følelser som stress eller angst. Om du har angst eller andre psykiske plager, bør du tenke over om du alltid skal bruke alkohol for å lette på disse plagene. Det kan i lengden gjøre at du må ha alkohol for å føle deg bra og for å fungere sosialt. Om du har selvmordstanker i perioder, bør du også være forsiktig med alkohol. Det er større sjanse for at du selvskader deg eller forsøker å ta ditt liv i fylla. Faktisk er det slik at hvert fjerde tilfelle av selvskading blant norsk ungdom er gjort i alkoholrus. ", "Hjernens evne til innlæring og tenkning reduseres ved promille fra 0.4 og oppover. Skal du lære noe eller ønsker å prestere maksimalt i forhold til dine egne kognitive evner, bør du derfor holde deg under denne grensen. Hjernens evne til innlæring er også redusert dagen etter en fyllekule. \n\nNår du er alkoholberuset, svekker du hjernens evne til å ta gode beslutninger. Dette kan gjøre at du blir mindre kritisk til hva du sier og gjør – det går mer på refleks, slik som hos reptiler. Dette kan føre til lite gjennomtenkte replikker og handlinger. Det kan også føre til at din evne til å «ta inn» omgivelsene/forskjellige situasjoner blir dårlige slik at misforståelser lettere oppstår. \n\nDerfor er det ikke uvanlig at folk oftere er involvert i tilfeldig sex, voldshandlinger eller ulykker når de er fulle. Å bli aggressiv eller i overkant dramatisk, er heller ikke uvanlig. ", "Du kan få blackout om du drikker mye alkohol, fra promille fra 1.4 og oppover. Det er større risiko for blackout om du drikker fort, som ved for eksempel shotting. Det som skjer er at overføringen fra korttidsminnet/arbeidsminnet til langtidsminnet svekkes, slik at man ikke husker noe fra hendelsen senere, men der og da er man klar over hva som skjer. Hvor mye tid som «er borte» fra hukommelsen kan variere fra gang til gang, men det er ikke uvanlig at det kan dreie seg om timer. \n\nBlackout kan være farlig, både fordi høy promille er farlig, men også fordi du blir sårbar for ulykker, voldshandlinger og andre farlige situasjoner. Det er dessuten ganske frustrerende og ofte litt flaut og ikke huske hva du har gjort."]
    
    static let drinkSmartRulesTitles = ["1. \nPlanlegg før du skal ut og drikke. Tenk gjennom hvor mye du vil drikke og hva du vil drikke, og forsøk å hold deg til det. Appen du har lastet ned kan hjelpe deg med dette.", "2. \nBegrens inntak av brennevin hvis du drikker det. Dropp shotting. ", "3. \nSpis godt før du drikker og ikke drikk på tom mave. Drikker du på tom mave øker det risikoen for at du skal miste kontrollen."
        , "4. \nTa kontroll over promillen. Drikke et glass vann, juice, brus eller annen alkoholfri drikke mellom hver enhet alkohol du drikker. ", "5. \nBruk erfaringen din. Vi er alle forskjellige og tåler ulike mengder alkohol.", "6. \nHusk at kvinner vanligvis tåler mindre alkohol enn menn.", "7. \nIkke gå alene, allier deg på forhånd med en venn. Kjenner du at du blir så beruset at du vil ha problemer med å ta vare på det selv er det greit å vite at noen holder et øye med deg, evt. følger deg trygt hjem.", "8. \nDet er ingen skam å tåle minst. Ikke la deg bli revet med i konkurransen om å tåle mest. Drikkekonkurranser kan få fatale utfall.", "9. \nVis respekt for rus og rusens virkning. Vold, aggresjon, hemningsløs oppførsel og ulykker skjer ofte i beruset tilstand. ", "10. \nVær rustet til å tåle alkohol. Er du syk, stresset, sover dårlig, eller bruker medisiner e.l. tåler du mindre alkohol, enn når du er frisk og uthvilt. ", "11. \nLytt til erfarne folk. Har du spørsmål om rus kontakt RUStelefonen på tlf 08588, chat med oss eller send oss spørsmål.", "12. \nSett deg et langsiktig mål. Får du ikke til første gang, forsøk igjen."]
    
    static let apperanceTitles = ["Overvekt og ernæring", "Huden din"]
    static let apperanceImages = ["Hamburger-100", "Skin-100"]
    static let apperanceTexts = ["Alkohol inneholder mye energi (kalorier) men få viktige næringsstoffer. I tillegg er det lett å bli fristet til å spise usunn og fet mat når du drikker og dagen etter. Er du ofte på fylla over tid, øker risikoen for overvekt og ernæringsmangler.", "Alkohol er dehydrerende, noe som også påvirker kroppens største organ - huden din. Hvis du drikker mye og ofte kan det gå på bekostning av hudens evne til å ta til seg viktige vitaminer og næringsstoffer. For utseendet ditt vil det bety større risiko for tørr hud, rødming og misfarging av huden. Pløsete hud kan også forårsakes av alkohol, både i ansiktet og på magen. Dessuten inneholder alkohol mye kalorier og karbohydrater, som kan føre til uren hud."]
    
    static let sexTitles = ["Alkohol og sex"]
    static let sexImages = ["Sex"]
    static let sexTexts = ["Alkohol frigjør dopamin og serotonin i hjernen, og dette kan gjøre at du føler deg mindre nervøs og mister litt hemminger - også seksuelt. Serotonin øker også lykkefølelsen, som kan gjøre at du får mer lyst på sex. Dette kan utspille seg i at man kan oppleve å tørre å prøve ut ting man ellers ikke ville gjort/hadde turt.  Men man kan også bli mindre kritisk/likegyldig og ende opp med å ha sex uten egentlig å ville det, og uten å beskytte deg. Gutter kan få problemer med ereksjon og utløsning om han er for full. Jenter kan også få problemer med å få orgasme.\n\n\n- Tenk en gang ekstra på om dette er en person du vil ha sex med \n\n- Tenk over om dette er en person du er trygg på vil forholde seg til dine grenser \n\n- Tenk gjennom om du sårer noen ved å ha sex med denne personen \n\n- Bruk prevensjon som beskytter mot kjønnssykdommer \n\n- Blir du med en person hjem, vær trygg på denne personen, og fortell alltid en venn hvor du skal \n\n- ALDRI gjennomfør seksuelle handlinger på en person som er for full til å si ja eller nei. Det er voldtekt"]
    
    static let rustelefonenTitles = ["Om oss", "Utviklere"]
    static let rustelefonenImages = ["rustelefonenLOGO", "iPhone-100"]
    static let rustelefonenTexts = ["RUStelefonen er en råd-, veiledning- og informasjonstjeneste om rusmiddelproblematikk. Profesjonelle veiledere gir råd og kvalitetssikret informasjon om rusmidler, rusbruk og rett hjelpetiltak i din landsdel.\n\nRUStelefonen er åpen mandag til søndag fra klokken 11.00 til 19.00. (Tirsdag og onsdag 10.00 til 19.00.) Alle som tar kontakt med tjenesten er anonyme! \n\nRUStelefonen er en offentlig, nasjonal opplysningstjeneste om rusmiddelproblematikk, og er ment å være et supplement til det øvrige hjelpeapparatet. \n\nMålsetting\n– Gi fakta om rus og rusmidler.\n– Ha oversikt over behandlingsapparatet i Norge.\n– Gi råd og veiledning gjennom den profesjonelle samtalen.\n\nMålgruppe\n– Ungdom som er i en eksperimenterende fase med utprøving av rusmidler.\n– Pårørende og andre som er bekymret vedrørende rusbruk.\n– Profesjonelle.\n\nRUStelefonen har dessuten som mål å være i forkant av utviklingen av nye trender innenfor rus og rusmidler, og sitter inne med en unik spisskompetanse om rusfeltet.\n\nRUStelefonen finansieres av Helsedirektoratet og driftes av Velferdsetaten i Oslo kommune.", "Utviklingsteamet arbeidet med dette prosjektet som sin bacheloroppgave våren 2016. Alle medlemmene var studenter på Westerdals Oslo ACT. \n\nTeamet bestod av: \nKristoffer Klippenvåg\nJoakim Korsnes\nSimen Fonnes\nLars Petter Kristiansen"]
    
    static let homeChartTexts = ["Dette er andelen kvelder du har ligget over makspromillen din", "Dette er andelen kvelder du har ligget under makspromillen din"]
    
    static let norwegianMonths = ["Januar", "Februar", "Mars", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Desember"]
    
    static let norwegianWeekDays = ["Mandag", "Tirsdag", "Onsdag", "Torsdag", "Fredag", "Lørdag", "Søndag"]
    
    static let greetingArray = ["Hei", "Halla", "Hallo", "Whats up?", "Hallois", "Skjer a?", "Skjer?", "God dag", "Ha en fin dag", "Hallo", "Que pasa?", "Morn", "Åssen går det?", "Står til?", "Läget?"]
    static let quoteArray = ["Visste du at du forbrenner ca. 0,15 promille per time", "Visste du at shotting og rask drikking gjør at kroppen ikke rekker å registere alkoholen før du tilsetter den mer? Da er risikoen for å miste kontroll stor!", "Nyt alkohol med måte, det vil både gjøre din kveld bedre og andres kveld mer hyggelig", "Det er ok å ta en shot med venner, men pass på at du ikke tar en for mye", "Ca 90 % av alkoholen forbrennes i leveren, resten utskilles i utåndingsluften, urinen og svetten", "Evnen til innlæring synker drastisk etter 0.4 i promille", "Alkohol gjør at hjernen blir selektiv slik at du lettere irriterer deg over småting", "Med promille fra 1.4 og oppover kan du få blackout", "Drikker du fort, er risikoen for blackout større", "Drikker du sprit, risikerer du å få for høy promille for fort", "Det beste rådet mot fyllesyke er å ha drikkevett dagen før", "Slutter du å drikke i god tid før du legger deg, minsker sjansen for å bli fyllesyk", "Er promillen høy, kan det være farlig å legge seg på stigende promille", "Er du ofte på fylla, øker risikoen for overvekt og ernæringsmangler.", "Alkohol inneholder mye kalorier og karbohydrater ", "Alkohol kan gi dårligere treningseffekt både på kort og lang sikt.", "Alkohol gir dårligere prestasjonsevne", "Planlegger du på forhånd hvor lite du skal drikke, er det lettere å holde seg til målet", "Spiser du et godt måltid før du begynner å drikke, blir promillen jevnere og litt lettere å kontrollere", "Alkohol er dehydrerende; drikk vann mellom hvert glass alkohol", "Det er ingen skam å tåle minst", "Er du syk, stresset, sover dårlig, eller bruker medisiner e.l. tåler du mindre alkohol, enn når du er frisk og uthvilt", "Alkohol gjør at du fortere mistforstår andre mennesker og situasjoner"]
    
    static let pieChartTexts = ["Dette er andelen kvelder du har ligget over makspromillen din", "Dette er andelen kvelder du har ligget under makspromillen din", "Målet ditt vises i diagrammet til høyre. Fargene illustrerer hvordan det står til med makspromillen din."]
    
    static let guidanceTitles = ["Hjem", "Promillekalkulator", "Planlegg Kvelden", "Dagen Derpå", "Historikk", "Utregning", "Enheter"]
    
    static let guidanceImages = ["hjemSkjermOmrisse", "promilleKalkOmrisse", "iphone omrisse", "dagenderpOmrisse", "historikkOmrisse", "Math-100", "Unis"]
    
    static let guidanceTexts = ["På hjemskjermen din vil du ha muligheten til å se hvordan du ligger an med målene dine, sjekke statistikk over dine kvelder og sette et eventuelt profilbilde", "Promillekalkulatoren gjør at du kan regne ut hvilken promille du har. Du kan også justere antall timer som har gått siden alkoholen ble konsumert, og finne ut hva promillen vil være etter en viss tid. Promillekalkulatoren gir en indikasjon på din promille, og skal ikke brukes som en utregning for når du kan kjøre!", "Denne funksjonen skal hjelpe deg å planlegge kvelden din. Du skal kunne legge inn antall enheter du planlegger å drikke for så å \"drikk\" dem underveis", "Med funksjonen dagen derpå kan du se oversikt over forrige kvelds aktiviteter. Du kan også etterregistrere enheter. Tips-knappen fører deg til tips til dagen derpå.", "Historikken viser en oversikt over alle kveldene du har registrert med applikasjonen. Klikk på en enkelt kveld for mer detaljert data om kvelden din.", "For kvinner:\nAlkohol i gram / (kroppsvekten i kg x 0,60) – (0,15 x timer fra drikkestart) = promille. \nFor menn: \nAlkohol i gram / (kroppsvekten i kg x 0,70) – (0,15 x timer fra drikkestart) = promille.", "Øl: 0,5 l (4,5 % alkohol)\nVin: 1,2 dl (13 % alkohol)\nDrink: 4 cl (40 % alkohol)\nShot: 4 cl (40 % alkohol)"]
}