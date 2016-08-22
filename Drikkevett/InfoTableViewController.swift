//
//  InfoTableViewController.swift
//  Skall_Meny
//
//  Created by Lars Petter Kristiansen on 19.03.2016.
//  Copyright © 2016 Lars Petter Kristiansen. All rights reserved.
//

import UIKit

class InfoTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let setAppColors = AppColors()
    
    @IBOutlet weak var tableView: UITableView!
    var getTitlesFromColl = ""
    
    var names = [String]()
    var imageArray = [UIImage]()
    var subTitles = [String]()
    var texts = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = setAppColors.mainBackgroundColor()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        // Rename back button
        let backButton = UIBarButtonItem(
            title: "",
            style: UIBarButtonItemStyle.Plain, // Note: .Bordered is deprecated
            target: nil,
            action: nil
        )
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
        
        self.tableView.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.0)
        print("\(getTitlesFromColl)")
        
        // TRENING
        if(getTitlesFromColl == "Trening"){
            self.navigationItem.title = "Trening"
            names = [
                "Dårligere treningseffekt",
                "Redusert prestasjonsevne",
                "Påvirkning av hormoner"
            ]
            // sett bilde i cellene
            imageArray = [
                UIImage(named: "Dumbbell-100")!,
                UIImage(named: "Time Trial Biking-100")!,
                UIImage(named: "Peptide-100")!
            ]
            texts = [
                "Alkohol kan virke negativt inn på treningsmålet ditt. Hvorfor? Belastningen under trening bryter muskulaturen ned, og hvileperioden etter treningen bruker musklene på å forberede seg på liknende påkjenninger senere («restitusjon»). \nResultatet er at du blir litt sterkere hver gang du trener. Når du drikker alkohol kan dette hemme nydannelse av glykogen og glykosefrigjøring fra leveren, en prosess som er viktig for å oppnå optimal restitusjon. \nHvis du starter med ny trening uten en god restitusjon, vil ikke muskulaturen ha klart å gjenoppbygge seg i mellomtiden. Alkohol kan derfor gi dårligere treningseffekt både på kort og lang sikt. ",
                "Drikker du alkohol etter trening, tar det lengre tid å erstatte væsketapet. Hvis kroppen ikke klarer å gjenopprette væskebalanse før du trener på nytt, vil det øke risikoen for dehydrering. Væsketap gir redusert prestasjonsevne blant annet grunnet dårligere blodgjennomstrømning til musklene og økt kroppstemperatur.",
                "Hvis du drikker relativt mye og jevnlig kan produksjonen av mannlig kjønnshormon, testosteron synke. Samtidig kan konsentrasjonen av stresshormonet kortisol øke. Denne kombinasjonen kan over tid medføre nedbrytning av muskelmasse og/eller forhindre at muskelmasse utvikles. Andre stresshormoner kan også øke; et symptom på dette er uregelmessig hjerterytme. "
            ]
        }
        
        // PSYKEN
        if(getTitlesFromColl == "Psyken"){
            self.navigationItem.title = "Psyken"
            names = [
                "Sosialt Lim (Lykkepromille)",
                "Angst og depresjoner",
                "Reptilhjernen",
                "Blackout"
            ]
            imageArray = [
                UIImage(named: "Good Quality-100")!,
                UIImage(named: "Therapy-100")!,
                UIImage(named: "Brain-100")!,
                UIImage(named: "Dizzy Person 2-100")!
            ]
            texts = [
            "Det er ikke uvanlig å drikke litt i sosiale sammenhenger, for å slappe mer av og for hyggens skyld; det er ikke uten grunn at alkohol kalles et «sosialt lim». Alkohol er vanlig som sosialt lim. «Lykkepromillen» ligger på omkring 0.6 – 0.8.  Men når promillen overstiger et visst nivå (ca. 0,5) vil tanker og følelser endres og forsterkes, og sosiale ferdigheter avtar. Du risikerer å miste flere hemninger enn du i ettertid vil være komfortabel med.",
                "Det er ikke uvanlig å drikke litt alkohol for å lette litt på vanskelige følelser som stress eller angst. Om du har angst eller andre psykiske plager, bør du tenke over om du alltid skal bruke alkohol for å lette på disse plagene. Det kan i lengden gjøre at du må ha alkohol for å føle deg bra og for å fungere sosialt. Om du har selvmordstanker i perioder, bør du også være forsiktig med alkohol. Det er større sjanse for at du selvskader deg eller forsøker å ta ditt liv i fylla. Faktisk er det slik at hvert fjerde tilfelle av selvskading blant norsk ungdom er gjort i alkoholrus. ",
                "Hjernens evne til innlæring og tenkning reduseres ved promille fra 0.4 og oppover. Skal du lære noe eller ønsker å prestere maksimalt i forhold til dine egne kognitive evner, bør du derfor holde deg under denne grensen. Hjernens evne til innlæring er også redusert dagen etter en fyllekule. \n\nNår du er alkoholberuset, svekker du hjernens evne til å ta gode beslutninger. Dette kan gjøre at du blir mindre kritisk til hva du sier og gjør – det går mer på refleks, slik som hos reptiler. Dette kan føre til lite gjennomtenkte replikker og handlinger. Det kan også føre til at din evne til å «ta inn» omgivelsene/forskjellige situasjoner blir dårlige slik at misforståelser lettere oppstår. \n\nDerfor er det ikke uvanlig at folk oftere er involvert i tilfeldig sex, voldshandlinger eller ulykker når de er fulle. Å bli aggressiv eller i overkant dramatisk, er heller ikke uvanlig. ",
                "Du kan få blackout om du drikker mye alkohol, fra promille fra 1.4 og oppover. Det er større risiko for blackout om du drikker fort, som ved for eksempel shotting. Det som skjer er at overføringen fra korttidsminnet/arbeidsminnet til langtidsminnet svekkes, slik at man ikke husker noe fra hendelsen senere, men der og da er man klar over hva som skjer. Hvor mye tid som «er borte» fra hukommelsen kan variere fra gang til gang, men det er ikke uvanlig at det kan dreie seg om timer. \n\nBlackout kan være farlig, både fordi høy promille er farlig, men også fordi du blir sårbar for ulykker, voldshandlinger og andre farlige situasjoner. Det er dessuten ganske frustrerende og ofte litt flaut og ikke huske hva du har gjort."
            ]
        }
        
        // DRIKKEVETTREGLENE
        if(getTitlesFromColl == "Drikkevettreglene"){
            self.navigationItem.title = "Drikkevettreglene"
            names = [
                "1. \nPlanlegg før du skal ut og drikke. Tenk gjennom hvor mye du vil drikke og hva du vil drikke, og forsøk å hold deg til det. Appen du har lastet ned kan hjelpe deg med dette."
                , "2. \nBegrens inntak av brennevin hvis du drikker det. Dropp shotting. "
                , "3. \nSpis godt før du drikker og ikke drikk på tom mave. Drikker du på tom mave øker det risikoen for at du skal miste kontrollen."
                , "4. \nTa kontroll over promillen. Drikke et glass vann, juice, brus eller annen alkoholfri drikke mellom hver enhet alkohol du drikker. "
                , "5. \nBruk erfaringen din. Vi er alle forskjellige og tåler ulike mengder alkohol."
                , "6. \nHusk at kvinner vanligvis tåler mindre alkohol enn menn."
                , "7. \nIkke gå alene, allier deg på forhånd med en venn. Kjenner du at du blir så beruset at du vil ha problemer med å ta vare på det selv er det greit å vite at noen holder et øye med deg, evt. følger deg trygt hjem."
                , "8. \nDet er ingen skam å tåle minst. Ikke la deg bli revet med i konkurransen om å tåle mest. Drikkekonkurranser kan få fatale utfall."
                , "9. \nVis respekt for rus og rusens virkning. Vold, aggresjon, hemningsløs oppførsel og ulykker skjer ofte i beruset tilstand. "
                , "10. \nVær rustet til å tåle alkohol. Er du syk, stresset, sover dårlig, eller bruker medisiner e.l. tåler du mindre alkohol, enn når du er frisk og uthvilt. "
                , "11. \nLytt til erfarne folk. Har du spørsmål om rus kontakt RUStelefonen på tlf 08588, chat med oss eller send oss spørsmål."
                , "12. \nSett deg et langsiktig mål. Får du ikke til første gang, forsøk igjen."
            ]
        }
        
        // UTSEENDE
        if(getTitlesFromColl == "Utseende"){
            self.navigationItem.title = "Utseende"
            names = [
                "Overvekt og ernæring",
                "Huden din"
            ]
            imageArray = [
                UIImage(named: "Hamburger-100")!,
                UIImage(named: "Skin-100")!
            ]
            texts = [
                "Alkohol inneholder mye energi (kalorier) men få viktige næringsstoffer. I tillegg er det lett å bli fristet til å spise usunn og fet mat når du drikker og dagen etter. Er du ofte på fylla over tid, øker risikoen for overvekt og ernæringsmangler.",
                "Alkohol er dehydrerende, noe som også påvirker kroppens største organ - huden din. Hvis du drikker mye og ofte kan det gå på bekostning av hudens evne til å ta til seg viktige vitaminer og næringsstoffer. For utseendet ditt vil det bety større risiko for tørr hud, rødming og misfarging av huden. Pløsete hud kan også forårsakes av alkohol, både i ansiktet og på magen. Dessuten inneholder alkohol mye kalorier og karbohydrater, som kan føre til uren hud."
            ]
        }
        
        // RUSTELEFONEN
        if(getTitlesFromColl == "Sex"){
            self.navigationItem.title = "Alkohol og sex"
            names = [
                "Alkohol og sex"
            ]
            imageArray = [
                UIImage(named: "Sex")!
            ]
            texts = [
                "Alkohol frigjør dopamin og serotonin i hjernen, og dette kan gjøre at du føler deg mindre nervøs og mister litt hemminger - også seksuelt. Serotonin øker også lykkefølelsen, som kan gjøre at du får mer lyst på sex. Dette kan utspille seg i at man kan oppleve å tørre å prøve ut ting man ellers ikke ville gjort/hadde turt.  Men man kan også bli mindre kritisk/likegyldig og ende opp med å ha sex uten egentlig å ville det, og uten å beskytte deg. Gutter kan få problemer med ereksjon og utløsning om han er for full. Jenter kan også få problemer med å få orgasme.\n\n\n- Tenk en gang ekstra på om dette er en person du vil ha sex med \n\n- Tenk over om dette er en person du er trygg på vil forholde seg til dine grenser \n\n- Tenk gjennom om du sårer noen ved å ha sex med denne personen \n\n- Bruk prevensjon som beskytter mot kjønnssykdommer \n\n- Blir du med en person hjem, vær trygg på denne personen, og fortell alltid en venn hvor du skal \n\n- ALDRI gjennomfør seksuelle handlinger på en person som er for full til å si ja eller nei. Det er voldtekt"
            ]
        }
        
        // RUSTELEFONEN
        if(getTitlesFromColl == "RUStelefonen"){
            self.navigationItem.title = "RUStelefonen"
            names = [
                "Om oss",
                "Utviklere"
            ]
            imageArray = [
                UIImage(named: "rustelefonenLOGO")!,
                UIImage(named: "iPhone-100")!
            ]
            texts = [
                "RUStelefonen er en råd-, veiledning- og informasjonstjeneste om rusmiddelproblematikk. Profesjonelle veiledere gir råd og kvalitetssikret informasjon om rusmidler, rusbruk og rett hjelpetiltak i din landsdel.\n\nRUStelefonen er åpen mandag til søndag fra klokken 11.00 til 19.00. (Tirsdag og onsdag 10.00 til 19.00.) Alle som tar kontakt med tjenesten er anonyme! \n\nRUStelefonen er en offentlig, nasjonal opplysningstjeneste om rusmiddelproblematikk, og er ment å være et supplement til det øvrige hjelpeapparatet. \n\nMålsetting\n– Gi fakta om rus og rusmidler.\n– Ha oversikt over behandlingsapparatet i Norge.\n– Gi råd og veiledning gjennom den profesjonelle samtalen.\n\nMålgruppe\n– Ungdom som er i en eksperimenterende fase med utprøving av rusmidler.\n– Pårørende og andre som er bekymret vedrørende rusbruk.\n– Profesjonelle.\n\nRUStelefonen har dessuten som mål å være i forkant av utviklingen av nye trender innenfor rus og rusmidler, og sitter inne med en unik spisskompetanse om rusfeltet.\n\nRUStelefonen finansieres av Helsedirektoratet og driftes av Velferdsetaten i Oslo kommune.",
                "Utviklingsteamet arbeidet med dette prosjektet som sin bacheloroppgave våren 2016. Alle medlemmene var studenter på Westerdals Oslo ACT. \n\nTeamet bestod av: \nKristoffer Klippenvåg\nJoakim Korsnes\nSimen Fonnes\nLars Petter Kristiansen"
            ]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("infoCell", forIndexPath: indexPath) as! CustomCell
        
        //cell.photo.image = imageArray[indexPath.row]
        cell.name.text = names[indexPath.row]
        //cell.subTitle.text = subTitles[indexPath.row]
        
        cell.name.textColor = setAppColors.textHeadlinesColors()
        cell.name.font = setAppColors.textHeadlinesFonts(25)
        //cell.subTitle.textColor = setAppColors.textUnderHeadlinesColors()
        //cell.subTitle.font = setAppColors.textUnderHeadlinesFonts(13)
        
        cell.backgroundColor = UIColor.clearColor()
        
        // CELL BACKGROUNDCOLOR ( BRUK INDIVD FARGER VED METODE: .cellBackgroundColors)
        //cell.textLabel?.backgroundColor = setAppColors.mainBackgroundColor()
        cell.textLabel?.backgroundColor = UIColor.clearColor()
        
        // CELL SIDE-DCOLOR ( BRUK INDIVID FARGER VED METODE: .cellSidesColors()
        //cell.contentView.backgroundColor = setAppColors.mainBackgroundColor()
        cell.contentView.backgroundColor = UIColor.clearColor()
        
        // CELL TEXT COLOR WHEN ENTERING VIEW ( NOT HIGHLIGHTED )
        cell.textLabel?.textColor = setAppColors.cellTextColors()
        
        // CELL TEXT SIZE / FONT
        cell.textLabel?.font = setAppColors.cellTextFonts(35)
        
        // CELL TEXT COLOR WHEN HIGHLIGHTED
        cell.textLabel?.highlightedTextColor = setAppColors.cellTextColorsPressed()
        
        // CELL HIGLIGHTED VIEW
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.0)
        cell.selectedBackgroundView = backgroundView
        
        if(getTitlesFromColl == "Drikkevettreglene"){
            cell.name.textColor = setAppColors.textUnderHeadlinesColors()
            cell.name.font = setAppColors.textHeadlinesFonts(14)
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.userInteractionEnabled = false
        }
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("detailSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "detailSegue") {
            let upcoming: InfoDetailViewController = segue.destinationViewController as! InfoDetailViewController
            
            if(getTitlesFromColl == "Drikkevettreglene"){
                print("DO nothing...")
            } else {
                let indexPath = self.tableView.indexPathForSelectedRow!
                
                let setTitle = self.names[indexPath.row]
                let longerText = self.texts[indexPath.row]
                let imageStuff = self.imageArray[indexPath.row]
                
                upcoming.titleOnInf = setTitle
                upcoming.longText = longerText
                upcoming.detailImage = imageStuff
            }
        }
    }
}
