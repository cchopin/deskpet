import Foundation

/// Aiguillage des répliques scriptées de la chèvre — remplace la génération LLM.
///
/// Philosophie : plutôt qu'un modèle local (lent à charger, gourmand en RAM,
/// parfois à côté de la plaque), on pioche dans des listes écrites à la main,
/// classées par situation et teintées par l'humeur du moment. C'est instantané,
/// léger, et les vannes sont calibrées (français, féminin, tutoiement, univers
/// étudiante en cybersécurité + chèvre cyberpunk taquine mais complice).
///
/// Ce fichier ne contient QUE la mécanique (sélecteur, humeurs, aiguillage) ; les
/// banques de répliques vivent dans les `Lines*.swift` pour rester lisibles.
enum ScriptedLines {

    // MARK: - Sélecteur anti-répétition

    /// Garde en mémoire les dernières répliques servies et privilégie du neuf.
    struct Picker {
        private var recent: [String] = []
        private let memory: Int

        init(memory: Int = 80) { self.memory = memory }

        mutating func pick(_ pool: [String]) -> String {
            guard !pool.isEmpty else { return "…" }
            let fresh = pool.filter { !recent.contains($0) }
            let choice = (fresh.isEmpty ? pool : fresh).randomElement()!
            recent.append(choice)
            if recent.count > memory { recent.removeFirst(recent.count - memory) }
            return choice
        }
    }

    // MARK: - Humeur

    /// Humeurs synthétiques exposées par `PetState.humeur`. On les mappe pour
    /// teinter les pools génériques (clic, spontané, retour).
    enum Mood {
        case epuisee, boudeuse, desoeuvree, caline, pechue, tranquille

        init(_ humeur: String) {
            switch humeur {
            case "épuisée":         self = .epuisee
            case "boudeuse":        self = .boudeuse
            case "désœuvrée":       self = .desoeuvree
            case "câline et vive":  self = .caline
            case "pêchue":          self = .pechue
            default:                self = .tranquille
            }
        }
    }

    // MARK: - Moment de la journée

    /// Tranche horaire courante : la chèvre a faim vers midi, baille le soir,
    /// s'étonne qu'on soit debout à 3h du matin.
    enum TimeSlot {
        case nuit, petitMatin, matin, faim, apresMidi, gouter, soiree, fatigue

        init(date: Date = Date(), calendar: Calendar = .current) {
            let c = calendar.dateComponents([.hour, .minute], from: date)
            let m = (c.hour ?? 12) * 60 + (c.minute ?? 0)
            switch m {
            case ..<(5 * 60):         self = .nuit        // 00h00 - 05h00
            case ..<(8 * 60):         self = .petitMatin  // 05h00 - 08h00
            case ..<(11 * 60 + 30):   self = .matin       // 08h00 - 11h30
            case ..<(14 * 60):        self = .faim        // 11h30 - 14h00
            case ..<(16 * 60 + 30):   self = .apresMidi   // 14h00 - 16h30
            case ..<(18 * 60):        self = .gouter      // 16h30 - 18h00
            case ..<(21 * 60):        self = .soiree      // 18h00 - 21h00
            default:                  self = .fatigue     // 21h00 - 00h00
            }
        }

        var lines: [String] {
            switch self {
            case .nuit:       return heureNuit
            case .petitMatin: return heurePetitMatin
            case .matin:      return heureMatin
            case .faim:       return heureFaim
            case .apresMidi:  return heureApresMidi
            case .gouter:     return heureGouter
            case .soiree:     return heureSoiree
            case .fatigue:    return heureFatigue
            }
        }
    }

    // MARK: - Clic sur la chèvre

    /// Pool du clic : on mélange les répliques d'humeur et celles du moment de
    /// la journée, à parts égales — une fois sur deux elle parle de l'heure
    /// qu'il est (faim de midi, coup de mou, veille nocturne).
    static func poke(mood: Mood, piquante: Bool, slot: TimeSlot) -> [String] {
        moodLines(mood, piquante: piquante) + slot.lines
    }

    private static func moodLines(_ mood: Mood, piquante: Bool) -> [String] {
        switch mood {
        case .epuisee:    return pokeEpuisee
        case .boudeuse:   return pokeBoudeuse
        case .desoeuvree: return pokeDesoeuvree
        case .caline:     return pokeCaline
        case .pechue:     return pokePechue
        case .tranquille: return piquante ? pokeTranquillePiquante : pokeTranquilleDouce
        }
    }

    // MARK: - Fichiers apparus sur le bureau

    /// Catégorie déduite d'un fichier/dossier, pour choisir la bonne banque.
    enum FileKind {
        case dossierVide(nom: String)
        case dossier(nom: String, count: Int)
        case archive(nom: String)
        case installeur(nom: String)
        case code(nom: String)
        case document(nom: String)
        case media(nom: String)
        case image(nom: String)
        case application(nom: String)
        case sansExtension(nom: String)
        case autre(nom: String, ext: String)
    }

    static func file(_ kind: FileKind) -> [String] {
        switch kind {
        case let .dossierVide(nom):      return filesDossierVide(nom)
        case let .dossier(nom, count):   return filesDossier(nom, count)
        case let .archive(nom):          return filesArchive(nom)
        case let .installeur(nom):       return filesInstalleur(nom)
        case let .code(nom):             return filesCode(nom)
        case let .document(nom):         return filesDocument(nom)
        case let .media(nom):            return filesMedia(nom)
        case let .image(nom):            return filesImage(nom)
        case let .application(nom):      return filesApplication(nom)
        case let .sansExtension(nom):    return filesSansExtension(nom)
        case let .autre(nom, ext):       return filesAutre(nom, ext)
        }
    }

    // MARK: - Outils lancés / terminés (sécu, dev)

    /// Répliques dédiées aux outils qu'on surveille (voir `ProcessWatcher`).
    /// Une entrée par outil connu, sinon on retombe sur le générique.
    static func tool(_ name: String, started: Bool) -> [String] {
        if started, let specific = toolStart[name] { return specific }
        if !started, let specific = toolEnd[name] { return specific }
        return started ? genericToolStart : genericToolEnd
    }

    // MARK: - Applications (premier plan / ouverture / fermeture)

    enum AppEvent { case focus, launch, quit }

    /// Trois banques par application reconnue.
    struct AppBank {
        let focus: [String]
        let launch: [String]
        let quit: [String]
    }

    /// macOS ne rapporte pas toujours le nom auquel on s'attend : VS Code
    /// s'annonce « Code », et un système en français localise les apps Apple.
    /// On renvoie ces noms-là vers la banque correspondante.
    private static let appAliases: [String: String] = [
        "code": "visual studio code",
        "aperçu": "preview",
        "windows app": "remote desktop",
    ]

    /// Applications grand public + applications de travail + alias, en une table.
    private static let allAppBanks: [String: AppBank] = {
        var d = appBanks.merging(appBanksWork) { general, _ in general }
        for (alias, canonique) in appAliases {
            if let bank = d[canonique] { d[alias] = bank }
        }
        return d
    }()

    static func app(_ name: String, event: AppEvent) -> [String] {
        let key = name.lowercased()
        // Clé la PLUS LONGUE qui matche : « microsoft teams » l'emporte sur
        // « teams », et le résultat ne dépend pas de l'ordre du dictionnaire.
        let bank = allAppBanks
            .filter { key.contains($0.key) }
            .max { $0.key.count < $1.key.count }?
            .value
        if let bank {
            switch event {
            case .focus:  return bank.focus
            case .launch: return bank.launch
            case .quit:   return bank.quit
            }
        }
        switch event {
        case .focus:  return genericAppFocus(name)
        case .launch: return genericAppLaunch(name)
        case .quit:   return genericAppQuit(name)
        }
    }
}
