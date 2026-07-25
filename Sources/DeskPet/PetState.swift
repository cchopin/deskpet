import Foundation

/// « L'âme » de la chèvre : l'état persistant qui dérive avec le temps et les
/// événements. C'est CET objet qu'on synchronisera entre Macs via iCloud.
/// Sérialisé en JSON. L'humeur et les traits qu'il expose teintent le choix des
/// répliques scriptées (voir `ScriptedLines`).
struct PetState: Codable {

    // MARK: Jauges court terme (0...1)

    /// Baisse la nuit et avec l'activité, remonte au repos. Faible → répliques
    /// fatiguées, elle dort plus.
    var energie: Double = 0.8
    /// Monte quand on s'occupe d'elle (clics, présence), baisse si on l'ignore.
    var affection: Double = 0.5
    /// Monte quand il ne se passe rien, retombe à chaque interaction.
    var ennui: Double = 0.2

    // MARK: Traits long terme (-1...1, dérive lente sur des jours)

    /// + si on la charrie / l'ignore souvent. Colore le ton (mordant vs doux).
    var sarcasme: Double = 0.3
    /// + si on s'occupe d'elle régulièrement.
    var tendresse: Double = 0.3

    // MARK: Compteurs & mémoire

    var naissance: Date = Date()      // pour l'âge et le stade de croissance
    var derniereVue: Date = Date()    // dernière INTERACTION (pour les absences)
    var derniereDerive: Date = Date() // dernière application de la dérive temporelle
    var totalClics: Int = 0
    var journal: [Souvenir] = []      // faits marquants récents (capé)

    /// Un fait marquant réinjecté plus tard dans le prompt pour donner de la
    /// continuité (« tu te souviens, hier tu galérais sur du Python »).
    struct Souvenir: Codable {
        var date: Date
        var texte: String
    }

    // MARK: - Dérivés

    /// Stades de croissance selon l'âge (donne une raison de revenir).
    enum Stade: String { case chevreau, jeune, adulte }
    var stade: Stade {
        let jours = Date().timeIntervalSince(naissance) / 86_400
        switch jours {
        case ..<2:  return .chevreau
        case ..<7:  return .jeune
        default:    return .adulte
        }
    }

    /// Humeur synthétique déduite des jauges — sert à teinter le prompt.
    var humeur: String {
        if energie < 0.25 { return "épuisée" }
        if affection < 0.25 { return "boudeuse" }
        if ennui > 0.7 { return "désœuvrée" }
        if affection > 0.7 && energie > 0.5 { return "câline et vive" }
        if ennui < 0.3 && energie > 0.6 { return "pêchue" }
        return "tranquille"
    }

    /// Durée depuis la dernière fois qu'on l'a « vue » active.
    var absence: TimeInterval { Date().timeIntervalSince(derniereVue) }

    // MARK: - Évolution dans le temps

    /// Applique la dérive due au temps écoulé depuis `derniereVue` : la nuit
    /// fatigue, l'absence use l'affection et gonfle l'ennui. À appeler au
    /// lancement et périodiquement.
    mutating func avancerDansLeTemps(maintenant: Date = Date(),
                                     heure: Int = Calendar.current.component(.hour, from: Date())) {
        let dt = maintenant.timeIntervalSince(derniereDerive)
        guard dt > 0 else { return }
        // On plafonne pour éviter des swings extrêmes après une longue absence.
        let heures = min(dt / 3600, 10)

        // Nuit (22h-7h) : l'énergie descend ; journée : elle remonte doucement.
        let nuit = (heure >= 22 || heure < 7)
        energie += (nuit ? -0.06 : 0.03) * heures
        // Le temps qui passe sans interaction : affection s'érode, ennui grimpe.
        affection -= 0.02 * heures
        ennui += 0.05 * heures

        derniereDerive = maintenant
        clampAll()
    }

    /// Réaction à un événement d'interaction (clic, présence, etc.).
    mutating func encaisser(_ event: Evenement) {
        switch event {
        case .clic:
            totalClics += 1
            affection += 0.05; ennui -= 0.15; tendresse += 0.004
        case .presence:
            ennui -= 0.05; affection += 0.01
        case .vuErreurCode:
            ennui -= 0.1; sarcasme += 0.006
        case .ignoreeLongtemps:
            affection -= 0.08; sarcasme += 0.01; ennui += 0.1
        }
        derniereVue = Date()
        clampAll()
    }

    enum Evenement { case clic, presence, vuErreurCode, ignoreeLongtemps }

    /// Ajoute un souvenir, en gardant le journal borné (les N plus récents).
    mutating func noter(_ texte: String, max: Int = 12) {
        journal.append(Souvenir(date: Date(), texte: texte))
        if journal.count > max { journal.removeFirst(journal.count - max) }
    }

    private mutating func clampAll() {
        energie = min(1, max(0, energie))
        affection = min(1, max(0, affection))
        ennui = min(1, max(0, ennui))
        sarcasme = min(1, max(-1, sarcasme))
        tendresse = min(1, max(-1, tendresse))
    }
}

/// Persistance JSON de `PetState`. Local pour l'instant ; le passage à iCloud
/// (M4) se fera en changeant `fileURL` vers le dossier Mobile Documents.
struct PetStateStore {
    let fileURL: URL

    /// Emplacement de l'état. On privilégie le dossier iCloud Drive pour
    /// synchroniser « l'âme » entre les Macs (M4) ; repli local sinon. On dépose
    /// le fichier directement dans Mobile Documents/CloudDocs — pas de CloudKit,
    /// pas d'entitlement : iCloud réplique tout seul.
    static func defaultURL() -> URL {
        let fm = FileManager.default
        let localFile = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
            .appendingPathComponent("DeskPet/state.json")

        let iCloudRoot = fm.homeDirectoryForCurrentUser
            .appendingPathComponent("Library/Mobile Documents/com~apple~CloudDocs", isDirectory: true)
        guard fm.fileExists(atPath: iCloudRoot.path) else {
            try? fm.createDirectory(at: localFile.deletingLastPathComponent(),
                                    withIntermediateDirectories: true)
            return localFile
        }

        let dir = iCloudRoot.appendingPathComponent("DeskPet", isDirectory: true)
        try? fm.createDirectory(at: dir, withIntermediateDirectories: true)
        let target = dir.appendingPathComponent("state.json")

        // Première bascule vers iCloud : on migre l'état local existant pour ne
        // pas repartir de zéro.
        if !fm.fileExists(atPath: target.path), fm.fileExists(atPath: localFile.path) {
            try? fm.copyItem(at: localFile, to: target)
        }
        return target
    }

    func load() -> PetState {
        let dec = JSONDecoder()
        dec.dateDecodingStrategy = .iso8601      // doit matcher l'encodeur ci-dessous
        guard let data = try? Data(contentsOf: fileURL),
              let state = try? dec.decode(PetState.self, from: data)
        else { return PetState() }
        return state
    }

    func save(_ state: PetState) {
        let enc = JSONEncoder()
        enc.outputFormatting = [.prettyPrinted]
        enc.dateEncodingStrategy = .iso8601
        if let data = try? enc.encode(state) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }
}
