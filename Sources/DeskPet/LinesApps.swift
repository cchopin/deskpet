import Foundation

/// Répliques déclenchées par les applications (premier plan, ouverture, fermeture).
extension ScriptedLines {

    static let appBanks: [String: AppBank] = {
        var d = [String: AppBank]()

        d["discord"] = AppBank(
            focus: [
                "Trois serveurs ouverts, zéro message envoyé, respect.",
                "Tu scrolles Discord comme si le TP allait s'écrire seul.",
                "Ce vocal dure depuis quand, exactement ?",
                "Encore en train de lire sans jamais répondre ?",
                "Le salon général n'a pas bougé depuis dix minutes.",
                "Tu réagis avec des émojis au lieu de réviser, classique.",
            ],
            launch: [
                "Discord s'ouvre, la productivité prend une pause.",
                "Voyons combien de pings t'attendent cette fois.",
                "Je parie sur un vocal dans les cinq minutes.",
                "Tiens, quelqu'un a dû te mentionner quelque part.",
                "Ouverture de Discord, adieu la concentration.",
            ],
            quit: [
                "Discord fermé, tes amis survivront sans toi.",
                "Fin du vocal, retour à la vraie vie.",
                "Tu as quitté Discord, j'appelle ça du courage.",
                "Le serveur continuera de vivre sans toi, promis.",
                "Discord se ferme, la concentration peut revenir.",
            ])

        d["spotify"] = AppBank(
            focus: [
                "Cette playlist s'appelle concentration mais tu chantes.",
                "Tu changes de morceau toutes les trente secondes.",
                "Encore ce titre en boucle, je connais les paroles.",
                "La musique est bien, le travail avance moins.",
                "Tu cherches la chanson parfaite depuis dix minutes.",
                "Lo-fi pour bosser, mais tu regardes les pochettes.",
            ],
            launch: [
                "Spotify démarre, ambiance sonore obligatoire pour travailler.",
                "Laisse-moi deviner, playlist focus puis dérive totale.",
                "La bande-son de ta soirée arrive.",
                "Musique lancée, il ne manque que le travail.",
                "Spotify s'ouvre, mes oreilles se préparent.",
            ],
            quit: [
                "Plus de musique, le silence va te déconcentrer aussi.",
                "Spotify fermé, tu fredonnes encore, je t'entends.",
                "Fin de la playlist, début du sérieux ?",
                "Le silence, enfin, je m'entendais plus penser.",
                "Tu coupes la musique, réunion ou sieste ?",
            ])

        d["safari"] = AppBank(
            focus: [
                "Quarante onglets Safari, tu ne les liras jamais tous.",
                "Tu relis le même article depuis tout à l'heure.",
                "Safari rame moins que ta décision de fermer des onglets.",
                "Encore un onglet gardé pour plus tard, bien sûr.",
                "Ce site mérite-t-il vraiment autant de ton temps ?",
                "Navigation privée ou pas, je vois ton écran.",
            ],
            launch: [
                "Safari s'ouvre, restauration de tes cent onglets en cours.",
                "Le navigateur d'Apple, choix sobre et assumé.",
                "Safari démarre, la batterie te dit merci.",
                "Nouvelle session, mêmes vieux onglets jamais lus.",
                "Tu ouvres Safari, recherche sérieuse ou shopping ?",
            ],
            quit: [
                "Safari fermé, tes onglets dorment jusqu'à demain.",
                "Tu as quitté Safari sans trier tes onglets, audacieuse.",
                "Fin de la navigation, retour au concret.",
                "Safari se ferme, le web survivra sans toi.",
                "Adieu les onglets, on parie qu'ils reviennent ?",
            ])

        d["chrome"] = AppBank(
            focus: [
                "Chrome mange ta RAM pendant que tu scrolles.",
                "Chaque onglet Chrome coûte un gigaoctet, tu le sais.",
                "Le ventilateur hurle, merci Chrome.",
                "Ce bruit de soufflerie, c'est Chrome qui digère ta mémoire.",
                "Encore un onglet, ta machine te déteste déjà.",
                "Chrome au premier plan, le Mac chauffe en arrière-plan.",
            ],
            launch: [
                "Chrome démarre, ta RAM retient son souffle.",
                "Tu ouvres Chrome, huit gigas s'évaporent direct.",
                "Chrome se lance, le ventilateur suit dans trois secondes.",
                "Bienvenue dans le navigateur qui dévore tout.",
                "Chrome ouvert, espérons que la machine tienne.",
            ],
            quit: [
                "Chrome fermé, ta RAM respire enfin.",
                "Huit gigas libérés d'un coup, quel luxe.",
                "Le ventilateur ralentit, merci d'avoir fermé Chrome.",
                "Chrome quitté, le Mac te pardonne presque.",
                "Fin de Chrome, la batterie reprend des couleurs.",
            ])

        d["firefox"] = AppBank(
            focus: [
                "Firefox, le choix de la résistance, j'approuve.",
                "Le renard tourne bien, tes onglets aussi.",
                "Toujours fidèle à Firefox, c'est beau la loyauté.",
                "Tu bloques les trackers et tu scrolles tranquille.",
                "Firefox au premier plan, ta vie privée te remercie.",
                "Le panda roux travaille, toi un peu moins.",
            ],
            launch: [
                "Firefox se lance, la team renard est en ligne.",
                "Tu ouvres Firefox, choix de connaisseuse.",
                "Le navigateur libre démarre, respect.",
                "Firefox arrive, les trackers tremblent déjà.",
                "Session Firefox ouverte, navigation en toute dignité.",
            ],
            quit: [
                "Firefox fermé, le renard va se reposer.",
                "Tu quittes Firefox, il gardera tes onglets au chaud.",
                "Fin de session Firefox, la résistance fait une pause.",
                "Le renard rentre au terrier, à demain.",
                "Firefox quitté proprement, comme toujours.",
            ])

        d["visual studio code"] = AppBank(
            focus: [
                "VS Code ouvert depuis une heure, trois lignes écrites.",
                "Tu installes des extensions au lieu de coder.",
                "Ce fichier a plus de TODO que de code.",
                "Encore en train de changer de thème ?",
                "Le curseur clignote, il attend tes idées.",
                "Tu relis ton code comme si c'était celui d'une inconnue.",
            ],
            launch: [
                "VS Code s'ouvre, moment d'inspiration ou de désespoir ?",
                "L'éditeur démarre, les extensions se réveillent une par une.",
                "Tu lances VS Code, le commit du siècle approche.",
                "VS Code arrive, que la session de code commence.",
                "Ouverture de l'éditeur, ferme Discord d'abord peut-être.",
            ],
            quit: [
                "VS Code fermé, j'espère que tout est commité.",
                "Tu quittes l'éditeur, le bug gagnera demain alors.",
                "Fin de la session code, bilan honorable ?",
                "VS Code se ferme, les extensions peuvent souffler.",
                "L'éditeur est fermé, ton cerveau compile encore.",
            ])

        d["xcode"] = AppBank(
            focus: [
                "Xcode indexe encore, va te faire un thé.",
                "La barre de compilation avance moins vite que toi.",
                "Tu regardes la barre de progression comme un feuilleton.",
                "Swift compile encore, ta patience est admirable.",
                "Encore une erreur de signing, courage.",
                "L'indexation d'Xcode finira peut-être avant ce soir.",
            ],
            launch: [
                "Xcode démarre, prévois un goûter pendant l'indexation.",
                "Tu ouvres Xcode, la compilation interminable arrive.",
                "Xcode se lance, huit gigas de bonne volonté.",
                "Le simulateur va encore mettre trois ans, tiens bon.",
                "Xcode ouvert, que la patience soit avec toi.",
            ],
            quit: [
                "Xcode fermé, l'indexation repartira de zéro demain.",
                "Tu quittes Xcode, il a sûrement planté d'abord.",
                "Fin de session Xcode, ton build a survécu ?",
                "Xcode se ferme, ta machine soupire de soulagement.",
                "Xcode quitté, le simulateur peut enfin dormir.",
            ])

        d["terminal"] = AppBank(
            focus: [
                "Le Terminal, enfin un endroit que je respecte.",
                "Tu tapes des commandes comme une pro, ça me plaît.",
                "Un sudo mal placé et on en reparle.",
                "J'adore te regarder grep comme si ta vie en dépendait.",
                "Historique de commandes propre, je suis impressionnée.",
                "Le shell t'obéit mieux que moi, profite.",
            ],
            launch: [
                "Terminal ouvert, mon terrain de jeu préféré.",
                "Tu lances le Terminal, ça devient sérieux.",
                "Une session shell s'ouvre, je m'installe pour regarder.",
                "Le prompt t'attend, impressionne-moi.",
                "Terminal lancé, les vraies choses commencent.",
            ],
            quit: [
                "Terminal fermé, les commandes te manqueront vite.",
                "Tu quittes le shell, mon petit cœur se serre.",
                "Fin de session Terminal, exit code zéro j'espère.",
                "Le prompt s'éteint, reviens vite.",
                "Terminal fermé, retour aux interfaces à boutons.",
            ])

        d["iterm"] = AppBank(
            focus: [
                "iTerm avec un thème stylé, la classe absolue.",
                "Des splits partout, tu frimes un peu là.",
                "Ton terminal a plus de style que mon pixel art.",
                "Transparence et ligatures, tu soignes les détails.",
                "iTerm au premier plan, le travail sérieux avec panache.",
                "Quatre panneaux ouverts, tu n'en regardes qu'un seul.",
            ],
            launch: [
                "iTerm démarre, le terminal mais en mieux habillé.",
                "Tu lances iTerm, préparation d'une session élégante.",
                "iTerm s'ouvre, les splits vont pleuvoir.",
                "Session iTerm lancée, avec le thème qui va bien.",
                "iTerm arrive, le Terminal natif peut aller bouder.",
            ],
            quit: [
                "iTerm fermé, tes splits reposent en paix.",
                "Tu quittes iTerm, fin du show en monospace.",
                "iTerm se ferme, la ligne de commande fait relâche.",
                "Fin de session iTerm, c'était propre.",
                "iTerm quitté, ton bureau perd en style.",
            ])

        d["figma"] = AppBank(
            focus: [
                "Tu alignes ce rectangle au pixel près depuis dix minutes.",
                "Encore un composant dupliqué au lieu d'une variante.",
                "Ce dégradé change de teinte toutes les deux minutes.",
                "Pixel perfect ou rien, je connais ta devise.",
                "Tu zoomes à fond pour un coin arrondi, sérieux.",
                "La maquette est belle, l'implémentation va pleurer.",
            ],
            launch: [
                "Figma s'ouvre, préparez les grilles et les calques.",
                "Tu lances Figma, session pixel perfect en approche.",
                "Figma démarre, les rectangles arrondis vont souffrir.",
                "Figma ouvert, deux heures pour choisir une police ?",
                "Figma se lance, ton sens du détail aussi.",
            ],
            quit: [
                "Figma fermé, la maquette est parfaite ou abandonnée ?",
                "Tu quittes Figma, les pixels sont enfin alignés.",
                "Fin de session Figma, le design peut reposer.",
                "Figma se ferme, tes calques resteront bien nommés.",
                "Design terminé, place au code qui le trahira.",
            ])

        d["slack"] = AppBank(
            focus: [
                "Slack ouvert, les notifications s'empilent joyeusement.",
                "Tu relis ce message avant d'oser répondre.",
                "Encore un fil de discussion qui part en réunion.",
                "Le canal général défile plus vite que tu ne lis.",
                "Tu réponds pouce levé pour éviter d'écrire, maligne.",
                "Trois canaux non lus, le suspense est insoutenable.",
            ],
            launch: [
                "Slack démarre, le travail collectif te réclame.",
                "Tu ouvres Slack, combien de mentions cette fois ?",
                "Slack se lance, les pastilles rouges arrivent.",
                "Ouverture de Slack, la pause est finie on dirait.",
                "Slack arrive, prépare tes réponses diplomatiques.",
            ],
            quit: [
                "Slack fermé, les notifications crieront dans le vide.",
                "Tu quittes Slack, le canal général survivra.",
                "Fin de Slack, personne ne pourra te ping.",
                "Slack se ferme, ta concentration te dit merci.",
                "Slack quitté, les fils de discussion attendront demain.",
            ])

        d["notion"] = AppBank(
            focus: [
                "Cette todo liste a plus d'archives que de tâches faites.",
                "Tu réorganises tes pages au lieu de les remplir.",
                "Encore un nouveau template, l'ancien avait deux jours.",
                "Ta base de données de projets est un projet en soi.",
                "Tu coches une tâche, tu en ajoutes trois.",
                "Notion ouvert, tu ranges tes idées avec amour.",
            ],
            launch: [
                "Notion démarre, la todo t'attend depuis mardi.",
                "Tu ouvres Notion, réorganisation de pages en perspective.",
                "Notion se lance, tes notes espèrent une visite.",
                "Ouverture de Notion, nouvel élan d'organisation détecté.",
                "Notion arrive, la liste jamais finie te salue.",
            ],
            quit: [
                "Notion fermé, la todo restera à moitié cochée.",
                "Tu quittes Notion, les tâches patienteront sagement.",
                "Fin de Notion, l'organisation reprendra une autre fois.",
                "Notion se ferme, tes pages sont bien rangées, bravo.",
                "Notion quitté, la vraie vie n'a pas de base de données.",
            ])

        d["steam"] = AppBank(
            focus: [
                "Steam ouvert, la révision attendra visiblement.",
                "Tu regardes les soldes plus que tu ne joues.",
                "Ta bibliothèque a des jeux jamais lancés, avoue.",
                "Une partie rapide qui dure depuis deux heures.",
                "Tu lis les succès des autres au lieu de jouer.",
                "Le jeu tourne, tes cours prennent la poussière gentiment.",
            ],
            launch: [
                "Steam démarre, la procrastination devient officielle.",
                "Tu lances Steam, une petite partie soi-disant.",
                "Steam s'ouvre, mise à jour de quarante gigas d'abord.",
                "Ouverture de Steam, on se dit à dans trois heures.",
                "Steam arrive, ton backlog de jeux frémit.",
            ],
            quit: [
                "Steam fermé, la partie rapide a duré combien ?",
                "Tu quittes Steam, retour à la réalité scolaire.",
                "Fin de Steam, bravo pour cette pause bien méritée.",
                "Steam se ferme, tes révisions ressuscitent.",
                "Steam quitté, les soldes t'attendront patiemment.",
            ])

        d["mail"] = AppBank(
            focus: [
                "Deux cents non-lus, tu vis dangereusement.",
                "Tu relis ce mail sans jamais y répondre.",
                "Marquer comme non lu, la grande technique d'évitement.",
                "Ta boîte de réception mérite un grand ménage.",
                "Encore une newsletter jamais lue, jamais désabonnée.",
                "Tu tries tes mails par peur d'y répondre.",
            ],
            launch: [
                "Mail s'ouvre, le compteur de non-lus va piquer.",
                "Tu ouvres Mail, courage pour la boîte de réception.",
                "Mail démarre, les newsletters ne t'ont pas oubliée.",
                "Ouverture de Mail, une réponse en retard peut-être ?",
                "Mail se lance, respire un bon coup avant.",
            ],
            quit: [
                "Mail fermé, les non-lus continueront de grossir.",
                "Tu quittes Mail, inbox zéro sera pour demain.",
                "Fin de Mail, les expéditeurs patienteront.",
                "Mail se ferme, ta boîte respire, toi aussi.",
                "Mail quitté, tu as répondu à combien, honnêtement ?",
            ])

        d["zoom"] = AppBank(
            focus: [
                "Ta caméra est coupée, je te comprends.",
                "Tu hoches la tête en regardant autre chose, vue.",
                "Micro coupé, tu peux dire ce que tu penses.",
                "Cette réunion aurait pu être un mail, on est d'accord.",
                "Tu fixes ta propre vignette au lieu d'écouter.",
                "Le partage d'écran arrive, cache tes onglets.",
            ],
            launch: [
                "Zoom démarre, vérifie ton arrière-plan vite.",
                "Tu lances Zoom, teste ton micro avant, pitié.",
                "Zoom s'ouvre, la réunion peut te happer.",
                "Ouverture de Zoom, caméra ou pas caméra ?",
                "Zoom arrive, souris à la webcam.",
            ],
            quit: [
                "Zoom fermé, la réunion est enfin finie.",
                "Tu quittes Zoom, ta caméra peut souffler.",
                "Fin de visio, tu peux reparler normalement.",
                "Zoom se ferme, cette heure ne reviendra jamais.",
                "Zoom quitté, plus personne ne te voit, détends-toi.",
            ])

        d["microsoft teams"] = AppBank(
            focus: [
                "Teams charge encore, prends un livre.",
                "Tu attends que Teams réponde, lui aussi visiblement.",
                "La visio freeze, c'est Teams, pas ta connexion.",
                "Teams au premier plan, la lenteur en majesté.",
                "Tu cherches le bouton micro depuis trente secondes, normal.",
                "Le statut absent te tente, je le vois.",
            ],
            launch: [
                "Teams démarre, compte jusqu'à cent, il arrive.",
                "Tu lances Teams, il sera prêt pour la prochaine réunion.",
                "Teams s'ouvre lentement, comme toujours, avec dignité.",
                "Ouverture de Teams, le chargement est déjà une épreuve.",
                "Teams arrive, ton processeur le sent passer.",
            ],
            quit: [
                "Teams fermé, il redémarrera tout seul, tu verras.",
                "Tu quittes Teams, victoire sur la lenteur.",
                "Fin de Teams, ta machine revit doucement.",
                "Teams se ferme, presque aussi lentement qu'il s'ouvre.",
                "Teams quitté, la visio d'entreprise attendra.",
            ])

        d["whatsapp"] = AppBank(
            focus: [
                "Tu tapes, tu effaces, tu retapes, envoie ce message.",
                "Le groupe famille est encore en feu on dirait.",
                "Tu laisses en vu depuis ce matin, glacial.",
                "Trois messages vocaux de quatre minutes, bon courage.",
                "Tu relis une vieille conversation au lieu de répondre.",
                "WhatsApp ouvert, les potins avancent mieux que les cours.",
            ],
            launch: [
                "WhatsApp s'ouvre, les messages perso prennent le pouvoir.",
                "Tu lances WhatsApp, le groupe famille t'a manqué ?",
                "WhatsApp démarre, réponds au moins au plus ancien.",
                "Ouverture de WhatsApp, pause sociale déclarée.",
                "WhatsApp arrive, dix conversations espèrent une réponse.",
            ],
            quit: [
                "WhatsApp fermé, les messages attendront leur tour.",
                "Tu quittes WhatsApp, le groupe survivra sans toi.",
                "Fin de WhatsApp, retour aux choses sérieuses ?",
                "WhatsApp se ferme, ton pouce te remercie.",
                "WhatsApp quitté, les vocaux de quatre minutes patienteront.",
            ])

        d["telegram"] = AppBank(
            focus: [
                "Encore abonnée à des canaux que tu ne lis pas.",
                "Tu fais défiler Telegram comme un fil sans fin.",
                "Les stickers remplacent les mots, stratégie validée.",
                "Ce canal balance des infos plus vite que tu ne lis.",
                "Telegram ouvert, tes messages secrets sont-ils si secrets ?",
                "Tu épingles des conversations que tu n'ouvres jamais.",
            ],
            launch: [
                "Telegram démarre, les canaux ont accumulé du retard.",
                "Tu lances Telegram, session de rattrapage de messages.",
                "Telegram s'ouvre, les stickers sont prêts.",
                "Ouverture de Telegram, messagerie pour les initiées.",
                "Telegram arrive, deux cents messages non lus t'attendent.",
            ],
            quit: [
                "Telegram fermé, les canaux continueront sans toi.",
                "Tu quittes Telegram, les stickers se reposent.",
                "Fin de Telegram, la veille info fait une pause.",
                "Telegram se ferme, tes conversations restent chiffrées, elles.",
                "Telegram quitté, retour au monde hors ligne.",
            ])

        d["finder"] = AppBank(
            focus: [
                "Ton dossier Téléchargements frôle le chaos total.",
                "Tu ranges des fichiers, moment historique.",
                "Encore un dossier nommé nouveau dossier 2, bravo.",
                "Tu cherches ce fichier que tu as rangé trop bien.",
                "Le bureau est couvert de captures d'écran, comme prévu.",
                "Finder ouvert, l'archéologie de tes fichiers commence.",
            ],
            launch: [
                "Finder s'ouvre, expédition dans tes dossiers.",
                "Tu lances Finder, tu cherches quoi cette fois ?",
                "Finder démarre, grand rangement ou juste un fichier ?",
                "Ouverture de Finder, prudence dans les Téléchargements.",
                "Finder arrive, tes fichiers font semblant d'être rangés.",
            ],
            quit: [
                "Finder fermé, le chaos des dossiers reste intact.",
                "Tu quittes Finder, fichier trouvé ou abandonné ?",
                "Fin de Finder, les Téléchargements gagnent encore.",
                "Finder se ferme, le rangement attendra dimanche.",
                "Finder quitté, tes captures d'écran restent libres.",
            ])

        d["preview"] = AppBank(
            focus: [
                "Ce PDF fait deux cents pages, courage.",
                "Tu surlignes tout, donc rien n'est important.",
                "Page douze depuis vingt minutes, tout va bien ?",
                "Tu zoomes sur le schéma comme s'il allait parler.",
                "Encore un PDF de cours ouvert, jamais fini.",
                "Aperçu affiche, toi tu survoles, je vois tout.",
            ],
            launch: [
                "Aperçu s'ouvre, un PDF de cours j'imagine.",
                "Tu ouvres Aperçu, lecture sérieuse ou diagonale ?",
                "Aperçu démarre, le surlignage jaune se prépare.",
                "Un document s'ouvre, deux cents pages de bonheur ?",
                "Aperçu se lance, bonne lecture, vraiment.",
            ],
            quit: [
                "Aperçu fermé, le PDF a-t-il été lu jusqu'au bout ?",
                "Tu quittes Aperçu, la page huit te reverra.",
                "Fin de lecture, résumé en trois mots ?",
                "Aperçu se ferme, le document retourne dormir.",
                "Aperçu quitté, tes annotations sont sauvées j'espère.",
            ])

        d["vmware"] = AppBank(
            focus: [
                "Ta VM tourne, ton Mac transpire.",
                "Trois VM ouvertes, tu prépares quoi exactement ?",
                "Le snapshot d'avant la bêtise, tu l'as fait ?",
                "Ta machine virtuelle rame, la vraie aussi du coup.",
                "Kali dans VMware, la panoplie complète de l'étudiante.",
                "Tu casses tout dans la VM, c'est fait pour.",
            ],
            launch: [
                "VMware démarre, ton lab virtuel s'éveille.",
                "Tu lances VMware, une VM va souffrir.",
                "VMware s'ouvre, pense au snapshot avant tout.",
                "Ouverture de VMware, huit gigas réquisitionnés.",
                "VMware arrive, le terrain d'entraînement est prêt.",
            ],
            quit: [
                "VMware fermé, les VM dorment sagement.",
                "Tu quittes VMware, le lab est en pause.",
                "Fin de VMware, ta RAM revient à la maison.",
                "VMware se ferme, snapshot sauvegardé j'espère.",
                "VMware quitté, ton Mac redevient une seule machine.",
            ])

        d["virtualbox"] = AppBank(
            focus: [
                "VirtualBox rame un peu, mais il est gratuit.",
                "Ta VM de test fait des siennes on dirait.",
                "Les additions invité, tu les as installées cette fois ?",
                "Ce labo de test tourne mieux que prévu.",
                "Tu bidouilles le réseau de la VM depuis tout à l'heure.",
                "VirtualBox au premier plan, expérimentation en cours.",
            ],
            launch: [
                "VirtualBox démarre, le labo gratuit ouvre ses portes.",
                "Tu lances VirtualBox, quelle VM va trinquer ?",
                "VirtualBox s'ouvre, configuration réseau en perspective.",
                "Ouverture de VirtualBox, les ISO s'alignent.",
                "VirtualBox arrive, le lab de test se réveille.",
            ],
            quit: [
                "VirtualBox fermé, les VM de test hibernent.",
                "Tu quittes VirtualBox, le labo ferme boutique.",
                "Fin de VirtualBox, l'expérience reprendra plus tard.",
                "VirtualBox se ferme, tes ISO restent au chaud.",
                "VirtualBox quitté, la machine hôte respire.",
            ])

        d["wireshark"] = AppBank(
            focus: [
                "Tu filtres du TCP comme une grande, fierté.",
                "Des paquets partout, trouve l'aiguille maintenant.",
                "Ce handshake TCP n'a plus de secret pour toi.",
                "Suivre le flux, la fonction préférée des curieuses.",
                "Tu captures tout le réseau, subtil.",
                "Les paquets défilent, tes yeux aussi.",
            ],
            launch: [
                "Wireshark démarre, les paquets vont parler.",
                "Tu lances Wireshark, le réseau n'a qu'à bien se tenir.",
                "Wireshark s'ouvre, choisis bien ton interface.",
                "Ouverture de Wireshark, capture imminente.",
                "Wireshark arrive, mets un filtre ou tu vas te noyer.",
            ],
            quit: [
                "Wireshark fermé, les paquets voyagent incognito à nouveau.",
                "Tu quittes Wireshark, la capture est dans la boîte ?",
                "Fin de Wireshark, le réseau reprend son intimité.",
                "Wireshark se ferme, ton pcap est sauvé j'espère.",
                "Wireshark quitté, l'analyse continue dans ta tête.",
            ])

        d["burp"] = AppBank(
            focus: [
                "Le proxy intercepte, le site ne se doute de rien.",
                "Tu modifies cette requête avec un sourire en coin.",
                "Le repeater chauffe, la cible fatigue.",
                "Intruder en cours, va boire un verre d'eau.",
                "Tu inspectes chaque requête, rien ne t'échappe.",
                "Forward, forward, drop, j'adore ce rythme.",
            ],
            launch: [
                "Burp démarre, les requêtes vont passer à la douane.",
                "Tu lances Burp, un site va être ausculté.",
                "Burp s'ouvre, configure ton proxy et amuse-toi.",
                "Ouverture de Burp, l'interception peut commencer.",
                "Burp arrive, Java réclame déjà sa mémoire.",
            ],
            quit: [
                "Burp fermé, les requêtes circulent librement à nouveau.",
                "Tu quittes Burp, la cible respire enfin.",
                "Fin de Burp, pense à remettre ton proxy normal.",
                "Burp se ferme, rapport de pentest en vue ?",
                "Burp quitté, Java te rend ta RAM.",
            ])

        return d
    }()

    static func genericAppFocus(_ name: String) -> [String] { [
        "Tu es sur \(name) depuis un bon moment déjà.",
        "\(name) doit être passionnant vu ta concentration.",
        "Toujours sur \(name), je prends racine moi.",
        "\(name) au premier plan, moi au second, vexant.",
        "Alors, il se passe quoi de beau dans \(name) ?",
        "Tu cliques dans \(name) avec une belle détermination.",
        "\(name) a toute ton attention, quelle chance.",
        "Je surveille \(name) du coin de l'œil, on sait jamais.",
        "Encore \(name), tu ne t'en lasses pas.",
        "Tu fais quoi dans \(name), raconte un peu.",
        "Cette fenêtre ne bouge plus depuis un moment, tu dors ?",
        "Tu fixes cet écran avec une intensité suspecte.",
        "Concentration maximale détectée, je n'ose plus bouger.",
        "Je m'ennuie un peu pendant que tu travailles là-dessus.",
        "Ton curseur hésite, ton cerveau négocie.",
    ] }

    static func genericAppLaunch(_ name: String) -> [String] { [
        "Tiens, \(name) entre en scène.",
        "Tu lances \(name), je m'attends à tout.",
        "\(name) démarre, voyons ce que ça donne.",
        "Une nouvelle app, \(name), le suspense est total.",
        "\(name) s'ouvre, j'espère que c'est pour le travail.",
        "Voilà \(name) qui débarque sur le bureau.",
        "\(name) se lance, encore une fenêtre à surveiller.",
        "Ouverture de \(name), je note l'heure.",
        "\(name) arrive, pousse-toi que je regarde.",
        "Tu avais vraiment besoin de \(name) maintenant ?",
        "Encore une app qui s'ouvre, jamais deux sans trois.",
        "Le bureau se remplit, ma tranquillité diminue.",
        "Nouvelle fenêtre détectée, je m'écarte élégamment.",
        "Une app de plus et je demande un loyer.",
        "Ça s'ouvre de partout ici aujourd'hui.",
    ] }

    static func genericAppQuit(_ name: String) -> [String] { [
        "\(name) se ferme, il était temps peut-être.",
        "Tu quittes \(name), lassitude ou mission accomplie ?",
        "Adieu \(name), on ne te retiendra pas.",
        "\(name) fermé, une fenêtre de moins à surveiller.",
        "Fin de \(name), tu passes à quoi maintenant ?",
        "Tu refermes \(name), chapitre terminé.",
        "\(name) s'en va, le bureau s'allège.",
        "Tu en avais fini avec \(name), visiblement.",
        "\(name) quitté, j'espère que tout est sauvegardé.",
        "Plus de \(name), ton Dock respire.",
        "Une app fermée, c'est presque du rangement.",
        "Le bureau se vide, j'ai plus de place pour gambader.",
        "Tu fermes des apps, grand ménage en cours ?",
        "Une fenêtre disparaît, mon champ de vision s'agrandit.",
        "Ça se ferme sec ici, tu prépares un reboot ?",
    ] }
}
